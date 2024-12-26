package com.bookplus.order.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bookplus.order.dao.PaymentDAO;
import com.bookplus.order.vo.PaymentVO;

@Service("paymentService")  // 스프링 빈으로 등록
public class PaymentServiceImpl {
	
	@Autowired
    private PaymentDAO paymentDAO;

	public PaymentVO findPaymentByOrderId(String orderId) throws Exception {
        return paymentDAO.selectPaymentByOrderId(orderId);
    }
	
}
