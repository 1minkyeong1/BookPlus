package com.bookplus.member.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bookplus.API.vo.APILoginVO;
import com.bookplus.member.vo.MemberVO;

public interface MemberService {

	String handleLogin(String platform, HttpServletRequest request);
	public MemberVO login(Map<String, String>  loginMap) throws Exception;
	public MemberVO addMember(MemberVO memberVO) throws Exception;
	public String overlapped(String id) throws Exception;	
//	String handleKakaoLogin(String code, HttpServletRequest request);
	public String searchId(MemberVO memberVO) throws Exception;
	public MemberVO checkMemInfo(Map<String, String> checkMem) throws Exception;
	public int removeMember(String mem_id)throws Exception;
	public int updatePass(String mem_id, String user_psw_confirm)throws Exception;

	String processLogin(String platform, HttpServletRequest request);
	MemberVO checkAPIUser(String apiId, String platform);

}
