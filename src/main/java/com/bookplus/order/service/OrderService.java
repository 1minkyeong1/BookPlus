package com.bookplus.order.service;

import java.util.List;
import java.util.Map;

import com.bookplus.order.vo.OrderVO;
import com.bookplus.order.vo.PaymentVO;

public interface OrderService {
	public List<OrderVO> listMyOrderGoods(OrderVO orderVO) throws Exception;
	public void addNewOrder(List<OrderVO> myOrderList) throws Exception;
	public OrderVO findMyOrder(String order_id) throws Exception;
    boolean processOrderAndPayment(Map<String, Object> requestData);

	
}
