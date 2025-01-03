package com.bookplus.board.controller;

import java.math.BigDecimal;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.security.authentication.encoding.ShaPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bookplus.board.service.BoardService;
import com.bookplus.board.vo.Board;
import com.bookplus.member.vo.MemberVO;

@Controller
public class BoardController{

	@Autowired
	BoardService boardService;
	
	
	//게시글 리스트 조회
	@RequestMapping(value = "/board/boardList.do")
	public String boardList(@RequestParam Map<String, Object> paramMap, Model model,
			                HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		//조회 하려는 페이지
		int startPage = (paramMap.get("startPage")!=null?Integer.parseInt(paramMap.get("startPage").toString()):1);
		//한페이지에 보여줄 리스트 수
		int visiblePages = (paramMap.get("visiblePages")!=null?Integer.parseInt(paramMap.get("visiblePages").toString()):10);
		//일단 전체 건수를 가져온다.
		int totalCnt = boardService.getContentCnt(paramMap);


		//아래 1,2는 실제 개발에서는 class로 빼준다. (여기서는 이해를 위해 직접 적음)
		//1.하단 페이지 네비게이션에서 보여줄 리스트 수를 구한다.
		BigDecimal decimal1 = new BigDecimal(totalCnt);
		BigDecimal decimal2 = new BigDecimal(visiblePages);
		BigDecimal totalPage = decimal1.divide(decimal2, 0, BigDecimal.ROUND_UP);

		int startLimitPage = 0;
		//2.mysql limit 범위를 구하기 위해 계산
		if(startPage==1){
			startLimitPage = 0;
		}else{
			startLimitPage = (startPage-1)*visiblePages;
		}

		paramMap.put("start", startLimitPage);

		//MYSQL
		paramMap.put("end", visiblePages);

		//ORACLE
		//paramMap.put("end", startLimitPage+visiblePages);
		//jsp 에서 보여줄 정보 추출
		model.addAttribute("startPage", startPage+"");//현재 페이지      
		model.addAttribute("totalCnt", totalCnt);//전체 게시물수
		model.addAttribute("totalPage", totalPage);//페이지 네비게이션에 보여줄 리스트 수
		model.addAttribute("boardList", boardService.getContentList(paramMap));//검색
		
		System.out.println("조회된 개수 : "  +  boardService.getContentList(paramMap).size());
	    
		//  /board/boardList 뷰 주소 얻기
		String viewName=(String)request.getAttribute("viewName");  

		return viewName;

	}

	//게시글 상세 보기
	@RequestMapping(value = "/board/view.do")
	public String boardView(@RequestParam Map<String, Object> paramMap, Model model,
							HttpServletRequest request, HttpServletResponse response) throws Exception {

		model.addAttribute("replyList", boardService.getReplyList(paramMap));
		model.addAttribute("boardView", boardService.getContentView(paramMap));
		
		//로그인 시 저장된 session 정보
		 HttpSession session = request.getSession();
		 MemberVO membervo = (MemberVO) session.getAttribute("memberInfo");
		 
	    // 작성자 이름 전달
	    if (membervo != null) {
	        model.addAttribute("userName", membervo.getMember_name()); // 사용자 이름
	    }
		
		//  /board/view 뷰 주소 얻기
		String viewName=(String)request.getAttribute("viewName"); 
			
		System.out.println("ViewNameInterceptor에서 생성된 viewName: " + viewName);

		if (viewName == null || viewName.isEmpty()) {
	        viewName = "/board/boardView"; // 기본값 설정
	    }
		
		return viewName;

	}

	//게시글 등록 및 수정
	@RequestMapping(value = "/board/edit.do")
	public String boardEdit(HttpServletRequest request, 
							@RequestParam Map<String, Object> paramMap, 
							Model model) {

		 HttpSession session = request.getSession();
		 MemberVO membervo = (MemberVO) session.getAttribute("memberInfo");
		 
	    // 작성자 이름 전달
	    if (membervo != null) {
	        model.addAttribute("userId", membervo.getMember_id()); // 사용자 이름
	        model.addAttribute("userName", membervo.getMember_name()); // 사용자 이름
	    }
		 
		
		//Referer 검사
		String Referer = request.getHeader("referer");

		if(Referer!=null){//URL로 직접 접근 불가
			if(paramMap.get("id") != null){ //게시글 수정
				if(Referer.indexOf("/board/view.do")>-1){
					System.out.println( boardService.getContentView(paramMap).toString());
					//정보를 가져온다.
					model.addAttribute("boardView", boardService.getContentView(paramMap));
					return "/board/edit";
				}else{
					return "redirect:/board/boardList.do";
				}
			}else{ //게시글 등록
				if(Referer.indexOf("/board/boardList.do")>-1){
					return "/board/edit";
				}else{
					return "redirect:/board/boardList.do";
				}
			}
		}else{
			return "redirect:/board/boardList.do";
		}

	}

	//AJAX 호출 (게시글 등록, 수정)
	@RequestMapping(value="/board/save", method=RequestMethod.POST, produces = "application/json")
	@ResponseBody
	public Object boardSave(@RequestParam Map<String, Object> paramMap) {

		//리턴값
		Map<String, Object> retVal = new HashMap<String, Object>();

		//패스워드 암호화
//		BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
//		String password = encoder.encode(paramMap.get("password").toString());
//		paramMap.put("password", password);
		System.out.println(paramMap);

		// 작성자 이름 (member_name) 가져오기
	    String userId = (String) paramMap.get("userId");
	    System.out.println(userId);

	    // writer를 member_id로 설정
	    paramMap.put("writer", userId);

		
		//정보입력
		int result = boardService.regContent(paramMap);

		if(result>0){
			retVal.put("code", "OK");
			retVal.put("message", "등록에 성공 하였습니다.");
		}else{
			retVal.put("code", "FAIL");
			retVal.put("message", "등록에 실패 하였습니다.");
		}

		return retVal;

	}
	
	@RequestMapping("map/map")
    public String showMapPage() {
        return "map/map"; // Tiles definition 이름
    }

	//AJAX 호출 (게시글 삭제)
	@RequestMapping(value="/board/del", method=RequestMethod.POST)
	@ResponseBody
	public Object boardDel(@RequestParam Map<String, Object> paramMap) {

		//리턴값
		Map<String, Object> retVal = new HashMap<String, Object>();

		//패스워드 암호화
//		BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
//		String password = encoder.encode(paramMap.get("password").toString());
//		paramMap.put("password", password);

		//정보입력
		int result = boardService.delBoard(paramMap);

		if(result>0){
			retVal.put("code", "OK");
		}else{
			retVal.put("code", "FAIL");
			retVal.put("message", "패스워드를 확인해주세요.");
		}

		return retVal;

	}

	//AJAX 호출 (게시글 패스워드 확인)
	@RequestMapping(value="/board/check", method= {RequestMethod.POST})
	@ResponseBody
	public Object boardCheck(@RequestParam Map<String, Object> paramMap) {

		//리턴값
		Map<String, Object> retVal = new HashMap<String, Object>();

		//패스워드 암호화
//		BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
//		String password = encoder.encode(paramMap.get("password").toString());
//		paramMap.put("password", password);

		//정보입력
		int result = boardService.getBoardCheck(paramMap);

		if(result>0){
			retVal.put("code", "OK");
		}else{
			retVal.put("code", "FAIL");
			retVal.put("message", "패스워드를 확인해주세요.");
		}

		return retVal;

	}

	//AJAX 호출 (댓글 등록)
	@RequestMapping(value="/board/reply/save", method=RequestMethod.POST, produces = "application/json")
	@ResponseBody
	public Object boardReplySave(@RequestParam Map<String, Object> paramMap, HttpSession session) {

		//리턴값
		Map<String, Object> retVal = new HashMap<String, Object>();

		//패스워드 암호화
//		ShaPasswordEncoder encoder = new ShaPasswordEncoder(256);
//		String password = encoder.encodePassword(paramMap.get("reply_password").toString(), null);
//		paramMap.put("reply_password", password);

		// 세션에서 로그인한 사용자 정보 가져오기
	    MemberVO member = (MemberVO) session.getAttribute("memberInfo");
	    if (member == null) {
	        retVal.put("code", "FAIL");
	        retVal.put("message", "로그인 정보가 필요합니다.");
	        return retVal;
	    }

	    // reply_writer에 로그인한 사용자의 ID 설정
	    paramMap.put("reply_writer", member.getMember_id());
		
		//정보입력
		int result = boardService.regReply(paramMap);

		if(result>0){
			retVal.put("code", "OK");
			retVal.put("reply_id", paramMap.get("reply_id"));
			retVal.put("parent_id", paramMap.get("parent_id"));
			retVal.put("message", "등록에 성공 하였습니다.");
		}else{
			retVal.put("code", "FAIL");
			retVal.put("message", "등록에 실패 하였습니다.");
		}

		return retVal;

	}

	//AJAX 호출 (댓글 삭제)
	@RequestMapping(value="/board/reply/del", method=RequestMethod.POST)
	@ResponseBody
	public Object boardReplyDel(@RequestParam Map<String, Object> paramMap) {

		//리턴값
		Map<String, Object> retVal = new HashMap<String, Object>();

		//패스워드 암호화
//		BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
//		String password = encoder.encode(paramMap.get("password").toString());
//		paramMap.put("password", password);

		//정보입력
		int result = boardService.delReply(paramMap);

		if(result>0){
			retVal.put("code", "OK");
			retVal.put("message", "삭제에 성공했습니다.");
		}else{
			retVal.put("code", "FAIL");
			retVal.put("message", "삭제에 실패했습니다. 패스워드를 확인해주세요.");
		}

		return retVal;

	}

	//AJAX 호출 (댓글 패스워드 확인)
	@RequestMapping(value="/board/reply/check", method=RequestMethod.POST)
	@ResponseBody
	public Object boardReplyCheck(@RequestParam Map<String, Object> paramMap) {

		//리턴값
		Map<String, Object> retVal = new HashMap<String, Object>();

		//패스워드 암호화
//		BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
//		String password = encoder.encode(paramMap.get("password").toString());
//		paramMap.put("password", password);

		//정보입력
		boolean check = boardService.checkReply(paramMap);

		if(check){
			retVal.put("code", "OK");
			retVal.put("reply_id", paramMap.get("reply_id"));
		}else{
			retVal.put("code", "FAIL");
			retVal.put("message", "패스워드를 확인해 주세요.");
		}

		return retVal;

	}

	//AJAX 호출 (댓글 수정)
	@RequestMapping(value="/board/reply/update", method=RequestMethod.POST)
	@ResponseBody
	public Object boardReplyUpdate(@RequestParam Map<String, Object> paramMap) {

		//리턴값
		Map<String, Object> retVal = new HashMap<String, Object>();

		//패스워드 암호화
//		BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
//		String password = encoder.encode(paramMap.get("password").toString());
//		paramMap.put("password", password);

		System.out.println(paramMap);

		//정보입력
		boolean check = boardService.updateReply(paramMap);

		if(check){
			retVal.put("code", "OK");
			retVal.put("reply_id", paramMap.get("reply_id"));
			retVal.put("message", "수정에 성공 하였습니다.");
		}else{
			retVal.put("code", "FAIL");
			retVal.put("message", "수정에 실패 하였습니다.");
		}

		return retVal;

	}
}
