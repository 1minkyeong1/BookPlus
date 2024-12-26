package com.bookplus.admin.member.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.bookplus.admin.member.dao.AdminMemberDAO;
import com.bookplus.member.vo.MemberVO;

@Service("adminMemberService")
@Transactional(propagation=Propagation.REQUIRED)
public class AdminMemberServiceImpl implements AdminMemberService {
    @Autowired
    private AdminMemberDAO adminMemberDAO;
    
    @Override
    public ArrayList<MemberVO> listMember(HashMap condMap) throws Exception {
        return adminMemberDAO.listMember(condMap);
    }

	public MemberVO memberDetail(String member_id) throws Exception{
		 return adminMemberDAO.memberDetail(member_id);
	}
	
	public void  modifyMemberInfo(HashMap memberMap) throws Exception{
		 adminMemberDAO.modifyMemberInfo(memberMap);
	}


}
