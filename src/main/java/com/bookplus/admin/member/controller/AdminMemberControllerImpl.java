package com.bookplus.admin.member.controller;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.bookplus.admin.member.service.AdminMemberService;
import com.bookplus.common.base.BaseController;
import com.bookplus.member.vo.MemberVO;

@Controller("adminMemberController")
@RequestMapping(value="/admin/member")
public class AdminMemberControllerImpl extends BaseController  implements AdminMemberController{
	@Autowired
	private AdminMemberService adminMemberService;
	
	@RequestMapping(value="/adminMemberMain.do" ,method={RequestMethod.POST,RequestMethod.GET})
	public ModelAndView adminGoodsMain(@RequestParam Map<String, String> dateMap,
			                           HttpServletRequest request, HttpServletResponse response)  throws Exception{
		
		HttpSession session=request.getSession();

		session.setAttribute("side_menu", "admin_mode"); 
		
		String viewName=(String)request.getAttribute("viewName");
		ModelAndView mav = new ModelAndView(viewName);

		String fixedSearchPeriod = dateMap.get("fixedSearchPeriod");
		String section = dateMap.get("section");
		String pageNum = dateMap.get("pageNum");
		String beginDate=null,endDate=null;
		
		String [] tempDate=calcSearchPeriod(fixedSearchPeriod).split(",");
		beginDate=tempDate[0];
		endDate=tempDate[1];
		dateMap.put("beginDate", beginDate);
		dateMap.put("endDate", endDate);
		
		HashMap<String,Object> condMap=new HashMap<String,Object>();
		if(section== null) {
			section = "1";
		}
		if(pageNum== null) {
			pageNum = "1";
		}
		// String을 Integer로 변환
		int sectionInt = Integer.parseInt(section);
		int pageNumInt = Integer.parseInt(pageNum);
		
		int pageSection = (sectionInt - 1) * 100 + (pageNumInt - 1) * 10;
		
		condMap.put("pageSection", pageSection);
		condMap.put("beginDate",beginDate);
		condMap.put("endDate", endDate);
		ArrayList<MemberVO> member_list=adminMemberService.listMember(condMap);
		mav.addObject("member_list", member_list);
		
		String beginDate1[]=beginDate.split("-");
		String endDate2[]=endDate.split("-");
		mav.addObject("beginYear",beginDate1[0]);
		mav.addObject("beginMonth",beginDate1[1]);
		mav.addObject("beginDay",beginDate1[2]);
		mav.addObject("endYear",endDate2[0]);
		mav.addObject("endMonth",endDate2[1]);
		mav.addObject("endDay",endDate2[2]);
		
		mav.addObject("section", section);
		mav.addObject("pageNum", pageNum);
		return mav;
		
	}
	@RequestMapping(value="/memberDetail.do" ,method={RequestMethod.POST,RequestMethod.GET})
	public ModelAndView memberDetail(HttpServletRequest request, HttpServletResponse response)  throws Exception{
		String viewName=(String)request.getAttribute("viewName");
		ModelAndView mav = new ModelAndView(viewName);
		String member_id=request.getParameter("member_id");
		MemberVO member_info=adminMemberService.memberDetail(member_id);
		mav.addObject("member_info",member_info);
		return mav;
	}
	
	@RequestMapping(value="/modifyMemberInfo.do" ,method={RequestMethod.POST,RequestMethod.GET})
	public void modifyMemberInfo(HttpServletRequest request, HttpServletResponse response)  throws Exception{
		HashMap<String,String> memberMap=new HashMap<String,String>();
		String val[]=null;
		PrintWriter pw=response.getWriter();
		String member_id=request.getParameter("member_id");
		String mod_type=request.getParameter("mod_type");
		String value =request.getParameter("value");
		
		System.out.println("Received member_id: " + member_id);
        System.out.println("Received mod_type: " + mod_type);
        System.out.println("Received value: " + value);

		

        // 비밀번호 처리
        if (mod_type.equals("member_pw")) {
            memberMap.put("member_pw", value);
        }
        // 성별 처리
        else if (mod_type.equals("member_gender")) {
            memberMap.put("member_gender", value);
        }
        // 생년월일 처리
        else if (mod_type.equals("member_birth")) {
            val = value.split(",");
            memberMap.put("member_birth_y", val[0]);
            memberMap.put("member_birth_m", val[1]);
            memberMap.put("member_birth_d", val[2]);
            memberMap.put("member_birth_gn", val[3]);
        }
        // 휴대폰 번호 처리
        else if (mod_type.equals("hp")) {
            val = value.split(",");
            memberMap.put("hp1", val[0]);
            memberMap.put("hp2", val[1]);
            memberMap.put("hp3", val[2]);
			memberMap.put("smssts_yn", val[3]);
        }
        // 이메일 처리
        else if (mod_type.equals("email")) {
            val = value.split(",");
            memberMap.put("email1", val[0]);
            memberMap.put("email2", val[1]);
			memberMap.put("emailsts_yn", val[2]);
        }
        // 주소 처리
        else if (mod_type.equals("address")) {
            val = value.split(",");
            memberMap.put("zipcode", val[0]);
            memberMap.put("roadAddress", val[1]);
            memberMap.put("jibunAddress", val[2]);
            memberMap.put("namujiAddress", val[3]);
        }

        // 회원 ID는 모든 요청에 포함
        memberMap.put("member_id", member_id);

        // 서비스 호출
        adminMemberService.modifyMemberInfo(memberMap);

        // 성공 메시지 반환
        pw.print("mod_success");
        pw.close();
    }
	
	@RequestMapping(value="/deleteMember.do" ,method={RequestMethod.POST})
	public ModelAndView deleteMember(HttpServletRequest request, HttpServletResponse response)  throws Exception {
		ModelAndView mav = new ModelAndView();
		HashMap<String,String> memberMap=new HashMap<String,String>();
		String member_id=request.getParameter("member_id");
		String del_yn=request.getParameter("del_yn");
		memberMap.put("del_yn", del_yn);
		memberMap.put("member_id", member_id);
		
		adminMemberService.modifyMemberInfo(memberMap);
		mav.setViewName("redirect:/admin/member/adminMemberMain.do");
		return mav;
		
	}
	@RequestMapping(value="/deleteInfo.do" ,method={RequestMethod.POST})
	public ModelAndView deleteInfo(HttpServletRequest request, HttpServletResponse response)  throws Exception {
		ModelAndView mav = new ModelAndView();
		HashMap<String,String> memberMap=new HashMap<String,String>();
		String member_id=request.getParameter("member_id");
		String del_yn=request.getParameter("del_yn");
		System.out.println(member_id);
		System.out.println(del_yn);
		memberMap.put("del_yn", del_yn);
		memberMap.put("member_id", member_id);
		
		adminMemberService.modifyMemberInfo(memberMap);
		mav.setViewName("redirect:/member/logout.do");
		return mav;
		
	}
		

	
}
