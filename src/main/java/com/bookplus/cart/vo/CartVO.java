package com.bookplus.cart.vo;

import org.springframework.stereotype.Component;

//장바구니에 저장할 상품하나의 정보들을 저장할 변수가 있는 클래스 
@Component("cartVO")
public class CartVO {
	private int cart_id;
	private String goods_id;
	private String member_id;
	private int cart_goods_qty;
	private String creDate;
	
	@Override
	public String toString() {
	    return "CartVO [cart_id=" + cart_id + 
	           ", goods_id=" + goods_id + 
	           ", member_id=" + member_id + 
	           ", cart_goods_qty=" + cart_goods_qty + 
	           ", creDate=" + creDate + "]";
	}
	
	public int getCart_id() {
		return cart_id;
	}
	public void setCart_id(int cart_id) {
		this.cart_id = cart_id;
	}
	
	
	public String getGoods_id() {
		return goods_id;
	}
	public void setGoods_id(String goods_id) {
		this.goods_id = goods_id;
	}
	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
	
	
	public int getCart_goods_qty() {
		return cart_goods_qty;
	}
	public void setCart_goods_qty(int cart_goods_qty) {
		this.cart_goods_qty = cart_goods_qty;
	}
	public String getCreDate() {
		return creDate;
	}
	public void setCreDate(String creDate) {
		this.creDate = creDate;
	}
	
	
	

}
