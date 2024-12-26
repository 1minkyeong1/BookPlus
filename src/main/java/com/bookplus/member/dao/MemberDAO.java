package com.bookplus.member.dao;

import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.bookplus.API.vo.APILoginVO;
import com.bookplus.member.vo.MemberVO;

public interface MemberDAO {

	public MemberVO login(Map<String, String> loginMap) throws DataAccessException;

	public void insertNewMember(MemberVO memberVO) throws DataAccessException;
	
	public String selectOverlappedID(String id) throws DataAccessException;
	MemberVO selectAPIUser(String apiId, String platform) throws DataAccessException;
	void insertKakaoUser(APILoginVO kakaoUser) throws DataAccessException;
	
	public String selectMemID(MemberVO memberVO) throws DataAccessException;

	public MemberVO checkMemInfo(Map<String, String> checkMem) throws DataAccessException;

	public int removeMember(String mem_id)throws DataAccessException;

	public int updatePass(String mem_id, String user_psw_confirm)throws DataAccessException;
	
}
