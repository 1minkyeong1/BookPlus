package com.bookplus.order.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.annotation.Propagation;
import com.bookplus.order.dao.OrderDAO;
import com.bookplus.order.dao.PaymentDAO;
import com.bookplus.order.vo.OrderVO;
import com.bookplus.order.vo.PaymentVO;


@Service("orderService")
@Transactional(propagation=Propagation.REQUIRED)
public class OrderServiceImpl implements OrderService {
	@Autowired
	private OrderDAO orderDAO;
	
	@Autowired
	private PaymentDAO paymentDAO;
	
	public List<OrderVO> listMyOrderGoods(OrderVO orderVO) throws Exception{
		List<OrderVO> orderGoodsList;
		orderGoodsList=orderDAO.listMyOrderGoods(orderVO);
		return orderGoodsList;
	}
	//주문정보가 저장되어 있는 ArrayList배열을 매개변수로 전달 받아 
	//DB의 주문 테이블에 추가 명령 하는 메소드! 그리고 장바구니테이블에 담긴 도서상품을 주문한 경우 해당 상품을 구매후 장바구니 테이블에서 삭제 합니다. 
	public void addNewOrder(List<OrderVO> myOrderList) throws Exception{
		
		//주문상품목록을 주문테이블에 추가합니다.
		orderDAO.insertNewOrder(myOrderList);
		
		//장바구니테이블에 상품을 추가하고 주문 했을 경우  주문한 상품을 삭제 합니다. 
		orderDAO.removeGoodsFromCart(myOrderList);
	}	
	
	public OrderVO findMyOrder(String order_id) throws Exception{
		return orderDAO.findMyOrder(order_id);
	}

	@Transactional
	@Override
	public boolean processOrderAndPayment(Map<String, Object> requestData) {
	    try {
	        // 주문 정보 공통 데이터 생성
	        String orderId = requestData.get("order_id").toString();
	        String orderMemberId = (String) requestData.get("order_member_id");
	        String orderMemberName = (String) requestData.get("order_member_name");
	        String receiverName = (String) requestData.get("receiver_name");
	        String receiverHp1 = (String) requestData.get("receiver_hp1");
	        String receiverHp2 = (String) requestData.get("receiver_hp2");
	        String receiverHp3 = (String) requestData.get("receiver_hp3");
	        String deliveryAddress = (String) requestData.get("delivery_address");
	        String deliveryMessage = (String) requestData.get("delivery_message");
	        int amount = Integer.parseInt(requestData.get("amount").toString());
	        String payMethod = (String) requestData.get("pay_method");
	        String paymentStatus = (String) requestData.get("status");
	        String impUid = (String) requestData.get("imp_uid");

	        // goods_list 처리
	        List<Map<String, Object>> goodsList = (List<Map<String, Object>>) requestData.get("goods_list");

	        for (Map<String, Object> goodsData : goodsList) {
	            // 개별 책 정보
	            String goodsId = goodsData.get("goods_id").toString();
	            String goodsTitle = goodsData.get("goods_title").toString();
	            int orderGoodsQty = Integer.parseInt(goodsData.get("order_goods_qty").toString());
	            int totalPrice = Integer.parseInt(goodsData.get("total_price").toString());

	            // 주문 정보 생성
	            OrderVO orderVO = new OrderVO();
	            orderVO.setOrderId(Long.parseLong(orderId));
	            orderVO.setOrderMemberId(orderMemberId);
	            orderVO.setOrderMemberName(orderMemberName);
	            orderVO.setGoodsId(goodsId);
	            orderVO.setGoodsTitle(goodsTitle);
	            orderVO.setOrderGoodsQty(orderGoodsQty);
	            orderVO.setReceiverName(receiverName);
	            orderVO.setReceiverHp1(receiverHp1);
	            orderVO.setReceiverHp2(receiverHp2);
	            orderVO.setReceiverHp3(receiverHp3);
	            orderVO.setDeliveryAddress(deliveryAddress);
	            orderVO.setDeliveryMessage(deliveryMessage);
	            orderVO.setTotalPrice(totalPrice);
	            orderVO.setPayMethod(payMethod);
	            orderVO.setPaymentStatus(paymentStatus);

	            // 주문 정보 저장
	            orderDAO.insertOrder(orderVO);
	        }

	        // 결제 정보 생성
	        PaymentVO paymentVO = new PaymentVO();
	        paymentVO.setImpUid(impUid);
	        paymentVO.setMerchantUid(orderId);
	        paymentVO.setAmount(amount);
	        paymentVO.setPayMethod(payMethod);
	        paymentVO.setPaymentStatus(paymentStatus);
	        paymentVO.setOrderId(Long.parseLong(orderId));

	        // 결제 정보 저장
	        paymentDAO.insertPayment(paymentVO);

	        return true;
	    } catch (Exception e) {
	        e.printStackTrace();
	        throw new RuntimeException("주문 및 결제 처리 중 오류 발생: " + e.getMessage());
	    }
	}

	
}
