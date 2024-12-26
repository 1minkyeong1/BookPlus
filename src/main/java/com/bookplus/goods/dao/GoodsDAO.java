package com.bookplus.goods.dao;

import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.bookplus.goods.vo.GoodsVO;

public interface GoodsDAO {
	public List<String> selectKeywordSearch(String keyword) throws DataAccessException;
	public GoodsVO selectGoodsDetail(String goods_id) throws DataAccessException;
	public List<GoodsVO> selectGoodsDetailImage(String goods_id) throws DataAccessException;
	public List<GoodsVO> selectGoodsBySearchWord(String searchWord) throws DataAccessException;
	GoodsVO selectGoodsByISBN(String isbn); // ISBN으로 책 조회
    int updateGoods(GoodsVO goodsVO); // 책 정보 업데이트
    int insertGoods(GoodsVO goodsVO); // 새 책 정보 삽입	
	public List<GoodsVO> selectAllGoods(Map<String, Object> params) throws Exception;
}
