package com.bookplus.goods.vo;

import java.sql.Date;
import java.util.ArrayList;

public class GoodsVO {
	private String goods_id;
	private String goods_title;
	private String goods_writer;
	private Date    goods_published_date;
	private String goods_isbn;
	private int    goods_price;
	private int    goods_sales_price;
	private String goods_fileName;
	private String goods_sort;
	private String goods_publisher;
	private int    goods_total_page;
	private int goods_delivery_price;
	private Date goods_delivery_date;
	private String goods_status;
	private Date   goods_credate;

	/*String goods_title;
	String goods_author;
	Date goods_pubDate;
	String goods_isbn;
	int goods_priceStandard;
	int goods_priceSales;
	String goods_cover;
	String goods_categoryName;
	String goods_publisher;*/

	@Override
	public String toString() {
	    return "GoodsVO {" +
	            "goods_id=" + goods_id +
	            ", goods_title='" + goods_title + '\'' +
	            ", goods_writer='" + goods_writer + '\'' +
	            ", goods_price=" + goods_price +
	            ", goods_publisher='" + goods_publisher + '\'' +
	            ", goods_sort='" + goods_sort + '\'' +
	            ", goods_sales_price=" + goods_sales_price +
	            ", goods_published_date=" + goods_published_date +
	            ", goods_total_page=" + goods_total_page +
	            ", goods_isbn='" + goods_isbn + '\'' +
	            ", goods_delivery_price='" + goods_delivery_price + '\'' +
	            ", goods_delivery_date=" + goods_delivery_date +
	            ", goods_fileName='" + goods_fileName + '\'' +
	            ", goods_status='" + goods_status + '\'' +
	            ", goods_credate=" + goods_credate +
	            '}';
	}

	
	public GoodsVO() {
	}

	public String getGoods_id() {
		return goods_id;
	}

	public void setGoods_id(String goods_id) {
		this.goods_id = goods_id;
	}

	public String getGoods_title() {
		return goods_title;
	}

	public void setGoods_title(String goods_title) {
		this.goods_title = goods_title;
	}

	public String getGoods_writer() {
		return goods_writer;
	}

	public void setGoods_writer(String goods_writer) {
		this.goods_writer = goods_writer;
	}

	public int getGoods_price() {
		return goods_price;
	}

	public void setGoods_price(int goods_price) {
		this.goods_price = goods_price;
	}

	public String getGoods_publisher() {
		return goods_publisher;
	}
	
	public void setGoods_publisher(String goods_publisher) {
		this.goods_publisher = goods_publisher;
	}

	public String getGoods_sort() {
		return goods_sort;
	}

	public void setGoods_sort(String goods_sort) {
		this.goods_sort = goods_sort;
	}
	public int getGoods_sales_price() {
		return goods_sales_price;
	}

	public void setGoods_sales_price(int goods_sales_price) {
		this.goods_sales_price = goods_sales_price;
	}

	public int getGoods_total_page() {
		return goods_total_page;
	}

	public void setGoods_total_page(int goods_total_page) {
		this.goods_total_page = goods_total_page;
	}

	public String getGoods_isbn() {
		return goods_isbn;
	}

	public void setGoods_isbn(String goods_isbn) {
		this.goods_isbn = goods_isbn;
	}

//	public String getGoods_delivery_price() {
//		return goods_delivery_price;
//	}
//
//	public void setGoods_delivery_price(String goods_delivery_price) {


	public int getGoods_delivery_price() {
		return goods_delivery_price;
	}



	public void setGoods_delivery_price(int goods_delivery_price) {
		this.goods_delivery_price = goods_delivery_price;
	}


	public Date getGoods_published_date() {
		return goods_published_date;
	}

	public void setGoods_published_date(Date goods_published_date) {
		this.goods_published_date = goods_published_date;
	}

	public Date getGoods_delivery_date() {
		return goods_delivery_date;
	}

	public void setGoods_delivery_date(Date goods_delivery_date) {
		this.goods_delivery_date = goods_delivery_date;
	}

	public String getGoods_fileName() {
		return goods_fileName;
	}

	public void setGoods_fileName(String goods_fileName) {
		this.goods_fileName = goods_fileName;
	}

	public String getGoods_status() {
		return goods_status;
	}

	public void setGoods_status(String goods_status) {
		this.goods_status = goods_status;
	}

	public Date getGoods_credate() {
		return goods_credate;
	}

	public void setGoods_credate(Date goods_credate) {
		this.goods_credate = goods_credate;
	}

}
