package com.bookplus.goods.service;

import java.util.List;
import java.util.Map;

import com.bookplus.goods.vo.GoodsVO;

public interface GoodsService {

	// 상품 상세정보 조회: _goods_isbn을 인자로 받아 상세정보를 Map으로 반환
	public Map goodsDetail(String _goods_isbn) throws Exception;
	
	//키워드로 상품을 검색하는 메서드로, keyword를 인자로 받아 List<String> 형태로 반환합니다.
	public List<String> keywordSearch(String keyword) throws Exception;

	// 검색어로 상품 검색
	public List<GoodsVO> searchGoods(String searchWord) throws Exception;

	// API를 통해 상품 정보 가져오기
	public List<GoodsVO> fetchBookDetails() throws Exception;

	// DB 업데이트
	public boolean updateDatabase(List<GoodsVO> fetchBookDetails) throws Exception;

	public List<GoodsVO> getAllGoods(String category, int limit, int offset) throws Exception;
}
