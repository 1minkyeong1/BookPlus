package com.bookplus.admin.goods.dao;

import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.bookplus.goods.vo.GoodsVO;
import com.bookplus.order.vo.OrderVO;

public interface AdminGoodsDAO {
	public String insertNewGoods(Map newGoodsMap) throws DataAccessException;
	public List<GoodsVO> selectNewGoodsList(Map condMap) throws DataAccessException;
	public GoodsVO selectGoodsDetail(String goods_isbn) throws DataAccessException;
	public List<GoodsVO> selectGoodsImageFileList(String goods_isbn) throws DataAccessException;
	public void insertGoodsImageFile(List<GoodsVO> fileList)  throws DataAccessException;
	public void updateGoodsInfo(Map goodsMap) throws DataAccessException;
	public void updateGoodsImage(List<GoodsVO> imageFileList) throws DataAccessException;
	public void deleteGoodsImage(String goods_isbn) throws DataAccessException;
	public List<OrderVO> selectOrderGoodsList(Map condMap) throws DataAccessException;
	public void updateOrderGoods(Map orderMap) throws DataAccessException;
}
