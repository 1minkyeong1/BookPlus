package com.bookplus.member.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.bookplus.API.vo.APILoginVO;
import com.bookplus.common.base.BaseController;
import com.bookplus.member.service.MemberService;
import com.bookplus.member.vo.MemberVO;

@Controller("memberController")
@RequestMapping(value = "/member")
public class MemberControllerImpl extends BaseController implements MemberController {
	@Autowired
	private MemberService memberService;
	@Autowired
	private MemberVO memberVO;

	// loginForm.jsp화면에서 아이디 비밀번호를 입력하고 로그인 버튼을 눌러 로그인요청을 했을때.. 호출되는 메소드
	// /member/login.do
	@Override
	@RequestMapping(value = "/login.do", method = RequestMethod.POST)
	// 입력한 아이디와 비밀번호를 Map에 저장후 전달 받습니다.
	public ModelAndView login(@RequestParam Map<String, String> loginMap, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();

		// 로그인 요청을 위해 입력한 아이디와 비밀번호가 DB에 저장되어 있는지 확인을 위해
		// 입력한 아이디와 비밀번호로 회원을 조회 해옴
		// 조회가 되면 로그인 처리 하고 조회가 되지 않으면 로그인 처리 하면 안됨
		memberVO = memberService.login(loginMap);

		// 조회가 되고!! 조회한 회원의 아이디가 존재하면?
		if (memberVO != null && memberVO.getMember_id() != null) {

			// 조회한 회원 정보를 가져와 isLogOn 속성을 true로 설정하고
			// memberInfo속성으로 조회된 회원 정보를 session에 저장합니다.
			HttpSession session = request.getSession();
			session.setAttribute("isLogOn", true);
			session.setAttribute("memberInfo", memberVO);

			// 상품 주문 과정에서 로그인 했으면 로그인 후 다시 주문 화면으로 진행하고 그외에 는 메인페이지를 표시합니다.
			String action = (String) session.getAttribute("action");

			if (action != null && action.equals("/order/orderEachGoods.do")) {
				mav.setViewName("forward:" + action);
			} else {
				mav.setViewName("redirect:/main/main.do");
			}

			// 로그인 요청시 입력한 아이디와 비밀번호로 회원 조회가 되지 않으면?(입력한 아이디와 비밀번호가 DB에 저장되어 있지 않으면?)
		} else {
			String message = "아이디나 비밀번호가 틀립니다. 다시 로그인해주세요";
			mav.addObject("message", message);
			mav.setViewName("/member/loginForm");
		}
		return mav;
	}

	// header.jsp페이지에서 로그아웃 <a>를 눌러서 로그아웃 요청 주소 /member/logout.do을 받았을때..
	@Override
	@RequestMapping(value = "/logout.do", method = RequestMethod.GET)
	public ModelAndView logout(HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();

		HttpSession session = request.getSession();

		session.setAttribute("isLogOn", false); // 로그아웃 시키는 false값 저장

		session.removeAttribute("memberInfo");// 로그인 요청시 입력한 아이디 비번을 이용해서 조회 했던 회원정보(MemberVO객체)를 삭제 !
		// 세션 초기화
		session.invalidate(); // 세션 전체 삭제 -> 로그아웃했을때 퀵메뉴에서 로그인하기전 퀵메뉴상태로 돌아감

		mav.setViewName("redirect:/main/main.do");// ViewInterCeptor클래스 ->
													// MainController의 main메소드 ->
													// 그 후 tiles_main.xml 파일에 작성한 <definition name=/main/main ...> 태그 ->
													// WEB-INF/views/main/main.jsp 를 중앙에 보여준다.
		// 참고. 이때 session영역을 이용하여 미로그인 된 화면을 보여 준다.
		return mav;
	}

	// 회원 가입 요청을 받았을떄...
	@Override
	@RequestMapping(value = "/addMember.do", method = RequestMethod.POST)
	// 회원가입시 입력한 회원 정보를 MemberVO 객체의 각변수에 저장후 전달 받음
	public ResponseEntity addMember(@ModelAttribute("memberVO") MemberVO _memberVO, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();

		// KakaoVO 데이터 수동 설정
		String id = request.getParameter("apiId");
		String socialProvider = request.getParameter("socialProvider");

		System.out.println(id);
		System.out.println(socialProvider);

		if (id != null && socialProvider != null) {
			APILoginVO apiLoginVO = new APILoginVO();
			apiLoginVO.setId(id);
			apiLoginVO.setSocialProvider(socialProvider);
			_memberVO.setAPILoginVO(apiLoginVO);
		}
		
		//회원가입처리
		String message = null;
		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type", "text/html; charset=utf-8"); // 저장해서 보여줄 값도 아래에 작성 보여줄 수 있음.
		try {
			MemberVO memberVO = memberService.addMember(_memberVO);// 새 회원 정보를 DB에 추가~

			if (memberVO != null && memberVO.getMember_id() != null) {
				// 세션에 로그인 정보 저장
				HttpSession session = request.getSession(true);
				session.setAttribute("isLogOn", true);
				session.setAttribute("memberInfo", memberVO);

				// 성공 메시지
				message = "<script>";
				message += " alert('회원가입 및 로그인이 성공했습니다. 메인 페이지로 이동합니다.');";
				message += " location.href='" + request.getContextPath() + "/main/main.do';";
				message += " </script>";
			} else {
				throw new Exception("로그인 처리 실패");
			}

		} catch (Exception e) {
			message = "<script>";
			message += " alert('회원가입에 실패 했습니다.');";
			message += " location.href='" + request.getContextPath() + "/member/memberForm.do';";
			message += " </script>";
			e.printStackTrace();
		}

		return new ResponseEntity<>(message, responseHeaders, HttpStatus.OK);
	}

	// memberForm.jsp페이지에서 회원가입시 입력한 아이디가 DB에 존재 하는지 유무 요청 주소 /member/overlapped.do을
	// 받았을때...
	// ResponseEntity 객체형태로 반환 (좀 더 자세한 정보를 담아서 반환) HttpStatus.OK (OK는 200을
	// 반환?성공응답메세지 위에주석확인.)
	@Override
	@RequestMapping(value = "/overlapped.do", method = RequestMethod.POST)
	public ResponseEntity overlapped(@RequestParam("id") String id, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ResponseEntity resEntity = null;

		String result = memberService.overlapped(id);

		resEntity = new ResponseEntity(result, HttpStatus.OK);

		return resEntity;
	}

	// ==========
	// API 로그인 했을 경우 호출되는 콜백 함수, OAuth 인증 과정에서 콜백 URL로 호출
	@Override
	@RequestMapping(value = "/{platform}/callback", method = RequestMethod.GET)
	public void apiCallback(@PathVariable String platform, HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		try {
			String redirectUrl = memberService.handleLogin(platform, request);
			response.sendRedirect(redirectUrl);

		} catch (Exception e) {
			response.getWriter().write(platform + " 로그인 실패: " + e.getMessage());
		}
	}

	// ==========
	// apiCallback에서 Access Token을 받은 후, 사용자 정보를 가져와 로그인 또는 회원가입 처리를 수행
	@Override
	@RequestMapping(value = "/{platform}/login", method = RequestMethod.GET)
	public ModelAndView apiLogin(@PathVariable String platform, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();

		try {
			String redirectUrl = memberService.processLogin(platform, request);

			if (redirectUrl.startsWith("redirect:")) {
				mav.setViewName(redirectUrl); // 리다이렉트 처리
			} else {
				mav.setViewName(redirectUrl); // Forward 처리
			}
			return mav;
		} catch (Exception e) {
			response.getWriter().write("사용자 정보 처리 실패: " + e.getMessage());
			return null;
		}
	}

}
