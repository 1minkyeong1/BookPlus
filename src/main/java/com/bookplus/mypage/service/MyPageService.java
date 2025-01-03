package com.bookplus.mypage.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.bookplus.member.vo.MemberVO;
import com.bookplus.order.vo.OrderVO;

public interface MyPageService{
	public List<OrderVO> listMyOrderGoods(String member_id) throws Exception;
	public List findMyOrderInfo(String order_id) throws Exception;
	public List<OrderVO> listMyOrderHistory(Map dateMap) throws Exception;
	public MemberVO  modifyMyInfo(Map memberMap) throws Exception;
	public void cancelOrder(String order_id) throws Exception;
	public MemberVO myDetailInfo(String member_id) throws Exception;
	public void deleteOrder(String order_id) throws Exception;

}
