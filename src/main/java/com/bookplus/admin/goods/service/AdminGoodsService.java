package com.bookplus.admin.goods.service;

import java.util.List;
import java.util.Map;

import com.bookplus.goods.vo.GoodsVO;
import com.bookplus.order.vo.OrderVO;

public interface AdminGoodsService {
	public String addNewGoods(Map newGoodsMap) throws Exception;
	public List<GoodsVO> listNewGoods(Map condMap) throws Exception;
	public Map goodsDetail(String goods_isbn) throws Exception;
	public List<GoodsVO> goodsImageFile(String goods_isbn) throws Exception;
	public void modifyGoodsInfo(Map goodsMap) throws Exception;
	public void modifyGoodsImage(List<GoodsVO> imageFileList) throws Exception;
	public List<OrderVO> listOrderGoods(Map condMap) throws Exception;
	public void modifyOrderGoods(Map orderMap) throws Exception;
	public void removeGoodsImage(String goods_isbn) throws Exception; 
	public void addNewGoodsImage(List<GoodsVO> imageFileList) throws Exception;
}
