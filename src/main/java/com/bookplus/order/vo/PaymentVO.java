package com.bookplus.order.vo;

public class PaymentVO {
    private String impUid;         // 아임포트 고유 ID
    private String merchantUid;    // 상점 주문 고유 번호
    private int amount;            // 결제 금액
    private String payMethod;      // 결제 방식
    private String paymentStatus;  // 결제 상태
    private long orderId;           // 주문 번호 (외래 키)

    // Getters and Setters
    public String getImpUid() {
        return impUid;
    }

    public void setImpUid(String impUid) {
        this.impUid = impUid;
    }

    public String getMerchantUid() {
        return merchantUid;
    }

    public void setMerchantUid(String merchantUid) {
        this.merchantUid = merchantUid;
    }

    public int getAmount() {
        return amount;
    }

    public void setAmount(int amount) {
        this.amount = amount;
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

    public long getOrderId() {
        return orderId;
    }

    public void setOrderId(long orderId) {
        this.orderId = orderId;
    }
}
