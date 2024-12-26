package com.bookplus.admin.goods.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.bookplus.goods.vo.GoodsVO;
import com.bookplus.order.vo.OrderVO;

@Repository("adminGoodsDAO")
public class AdminGoodsDAOImpl implements AdminGoodsDAO {
	@Autowired
	private SqlSession sqlSession;

	// 새 도서상품 INSERT 후 goods_isbn 반환 가정
	@Override
	public String insertNewGoods(Map newGoodsMap) throws DataAccessException {
		// mapper에서 INSERT 시키고, newGoodsMap에 goods_isbn을 파라미터로 전달하고,
		// INSERT 후 SELECT KEY 등을 통해 goods_isbn을 생성했다고 가정
		// 여기서는 DB나 mapper 환경에 따라 적절히 수정 필요
		sqlSession.insert("mapper.admin.goods.insertNewGoods", newGoodsMap);
		return (String)newGoodsMap.get("goods_isbn"); 
	}

	@Override
	public void insertGoodsImageFile(List<GoodsVO> fileList)  throws DataAccessException {
		for(GoodsVO goodsVO : fileList){
			// 상품 이미지 정보를 테이블에 추가 
			sqlSession.insert("mapper.admin.goods.insertGoodsImageFile", goodsVO);
		}
	}

	@Override
	public List<GoodsVO> selectNewGoodsList(Map condMap) throws DataAccessException {
		List<GoodsVO> goodsList = sqlSession.selectList("mapper.admin.goods.selectNewGoodsList", condMap);
		return goodsList;
	}

	@Override
	public GoodsVO selectGoodsDetail(String goods_isbn) throws DataAccessException {
		GoodsVO goodsBean = sqlSession.selectOne("mapper.admin.goods.selectGoodsDetail", goods_isbn);
		return goodsBean;
	}

	@Override
	public List<GoodsVO> selectGoodsImageFileList(String goods_isbn) throws DataAccessException {
		List<GoodsVO> imageList = sqlSession.selectList("mapper.admin.goods.selectGoodsImageFileList", goods_isbn);
		return imageList;
	}

	@Override
	public void updateGoodsInfo(Map goodsMap) throws DataAccessException {
		sqlSession.update("mapper.admin.goods.updateGoodsInfo", goodsMap);
	}

	@Override
	public void deleteGoodsImage(String goods_isbn) throws DataAccessException {
		// ISBN을 사용해 해당 상품의 이미지 삭제
		sqlSession.delete("mapper.admin.goods.deleteGoodsImage", goods_isbn);
	}

	@Override
	public List<OrderVO> selectOrderGoodsList(Map condMap) throws DataAccessException {
		List<OrderVO> orderGoodsList = sqlSession.selectList("mapper.admin.goods.selectOrderGoodsList", condMap);
		return orderGoodsList;
	}

	@Override
	public void updateOrderGoods(Map orderMap) throws DataAccessException {
		sqlSession.update("mapper.admin.goods.updateOrderGoods", orderMap);
	}

	@Override
	public void updateGoodsImage(List<GoodsVO> imageFileList) throws DataAccessException {
		for(GoodsVO goodsVO : imageFileList){
			sqlSession.update("mapper.admin.goods.updateGoodsImage", goodsVO);	
		}
	}
}
