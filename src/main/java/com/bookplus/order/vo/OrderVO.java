package com.bookplus.order.vo;

import org.springframework.stereotype.Repository;

@Repository
public class OrderVO {
    private int orderSeqNum;        	// 주문 상품 일련번호
    private long orderId;             	// 주문 번호
    private String orderMemberId;       // 주문자 아이디
    private String orderMemberName;     // 주문자 아이디
    private String goodsId;           	// 상품 번호
    private String goodsTitle;     		// 상품 이름
    private int orderGoodsQty;     		// 주문 수량
    private String receiverName;   		// 수령인 이름
    private String receiverHp1;    		// 수령인 전화번호 앞자리
    private String receiverHp2;    		// 수령인 전화번호 중간자리
    private String receiverHp3;    		// 수령인 전화번호 뒷자리
    private String deliveryAddress;		// 배송지 주소
    private String deliveryMessage;		// 배송 메시지
    private String deliveryMethod; 		// 배송 방법
    private String deliveryState;
	private int totalPrice;        		// 총 결제 금액
    private String payMethod;      		// 결제 방식
    private String paymentStatus;  		// 결제 상태
    private String orderDate;      		// 주문 일자 (문자열로 처리)


	// Getters and Setters
    
    
    
    public String getDeliveryMethod() {
		return deliveryMethod;
	}

	public String getDeliveryState() {
		return deliveryState;
	}

	public void setDeliveryState(String deliveryState) {
		this.deliveryState = deliveryState;
	}

	public void setDeliveryMethod(String deliveryMethod) {
		this.deliveryMethod = deliveryMethod;
	}
	
    public int getOrderSeqNum() {
        return orderSeqNum;
    }

    public void setOrderSeqNum(int orderSeqNum) {
        this.orderSeqNum = orderSeqNum;
    }

    public long getOrderId() {
        return orderId;
    }

    public void setOrderId(long orderId) {
        this.orderId = orderId;
    }

    public String getOrderMemberId() {
		return orderMemberId;
	}

	public void setOrderMemberId(String orderMemberId) {
		this.orderMemberId = orderMemberId;
	}

	public String getOrderMemberName() {
		return orderMemberName;
	}

	public void setOrderMemberName(String orderMemberName) {
		this.orderMemberName = orderMemberName;
	}

	public String getGoodsId() {
        return goodsId;
    }

    public void setGoodsId(String goodsId) {
        this.goodsId = goodsId;
    }

    public String getGoodsTitle() {
        return goodsTitle;
    }

    public void setGoodsTitle(String goodsTitle) {
        this.goodsTitle = goodsTitle;
    }

    public int getOrderGoodsQty() {
        return orderGoodsQty;
    }

    public void setOrderGoodsQty(int orderGoodsQty) {
        this.orderGoodsQty = orderGoodsQty;
    }

    public String getReceiverName() {
        return receiverName;
    }

    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
    }

    public String getReceiverHp1() {
        return receiverHp1;
    }

    public void setReceiverHp1(String receiverHp1) {
        this.receiverHp1 = receiverHp1;
    }

    public String getReceiverHp2() {
        return receiverHp2;
    }

    public void setReceiverHp2(String receiverHp2) {
        this.receiverHp2 = receiverHp2;
    }

    public String getReceiverHp3() {
        return receiverHp3;
    }

    public void setReceiverHp3(String receiverHp3) {
        this.receiverHp3 = receiverHp3;
    }

    public String getDeliveryAddress() {
        return deliveryAddress;
    }

    public void setDeliveryAddress(String deliveryAddress) {
        this.deliveryAddress = deliveryAddress;
    }

    public String getDeliveryMessage() {
        return deliveryMessage;
    }

    public void setDeliveryMessage(String deliveryMessage) {
        this.deliveryMessage = deliveryMessage;
    }

    public int getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(int totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getPayMethod() {
        return payMethod;
    }

    public void setPayMethod(String payMethod) {
        this.payMethod = payMethod;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(String orderDate) {
        this.orderDate = orderDate;
    }
    
    
    @Override
    public String toString() {
        return "OrderVO{" +
                "orderSeqNum=" + orderSeqNum +
                ", orderId=" + orderId +
                ", orderMemberId='" + orderMemberId + '\'' +
                ", orderMemberName='" + orderMemberName + '\'' +
                ", goodsId='" + goodsId + '\'' +
                ", goodsTitle='" + goodsTitle + '\'' +
                ", orderGoodsQty=" + orderGoodsQty +
                ", receiverName='" + receiverName + '\'' +
                ", receiverHp1='" + receiverHp1 + '\'' +
                ", receiverHp2='" + receiverHp2 + '\'' +
                ", receiverHp3='" + receiverHp3 + '\'' +
                ", deliveryAddress='" + deliveryAddress + '\'' +
                ", deliveryMessage='" + deliveryMessage + '\'' +
                ", totalPrice=" + totalPrice +
                ", payMethod='" + payMethod + '\'' +
                ", paymentStatus='" + paymentStatus + '\'' +
                ", orderDate='" + orderDate + '\'' +
                '}';
    }
    
}
