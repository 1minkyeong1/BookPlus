package com.bookplus.mypage.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestParam;

import com.bookplus.member.vo.MemberVO;
import com.bookplus.mypage.dao.MyPageDAO;
import com.bookplus.mypage.vo.MyPageVO;
import com.bookplus.order.dao.PaymentDAO;
import com.bookplus.order.vo.OrderVO;

@Service("myPageService")
@Transactional(propagation=Propagation.REQUIRED)
public class MyPageServiceImpl  implements MyPageService{
	@Autowired
	private MyPageDAO myPageDAO;
	@Autowired
	private PaymentDAO paymentDAO;

	//로그인한 회원 ID를 이용해 주문한 상품을 조회 합니다. 
	public List<OrderVO> listMyOrderGoods(String member_id) throws Exception{
		return myPageDAO.selectMyOrderGoodsList(member_id);
	}
	
	public List findMyOrderInfo(String order_id) throws Exception{
		return myPageDAO.selectMyOrderInfo(order_id);
	}
	
	public List<OrderVO> listMyOrderHistory(Map dateMap) throws Exception{
		return myPageDAO.selectMyOrderHistoryList(dateMap);
	}
	
	public MemberVO  modifyMyInfo(Map memberMap) throws Exception{
		 String member_id=(String)memberMap.get("member_id");
		 myPageDAO.updateMyInfo(memberMap);
		 return myPageDAO.selectMyDetailInfo(member_id);
	}
	
	//주문취소 버튼을 눌러  t_shopping_order테이블에 저장된 
    //주문번호에 해당 하는  주문상태열의 값을  주문취소(cancel_order)로 수정! 	
	public void cancelOrder(String order_id) throws Exception{
		myPageDAO.updateMyOrderCancel(order_id);
	}
	
	
	public MemberVO myDetailInfo(String member_id) throws Exception{
		return myPageDAO.selectMyDetailInfo(member_id);
	}
	
	//==========
	// 주문 삭제
	@Override
	public void deleteOrder(String order_id) throws Exception {
		paymentDAO.deleteMyOrder(order_id);
		myPageDAO.deleteMyOrder(order_id);
	}
}






