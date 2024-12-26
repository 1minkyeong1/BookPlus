package com.bookplus.goods.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.bookplus.goods.vo.GoodsVO;

@Repository("goodsDAO")
public class GoodsDAOImpl implements GoodsDAO{
	@Autowired
	private SqlSession sqlSession;

	@Override
	public List<GoodsVO> selectAllGoods(Map<String, Object> params) throws Exception {
	    return sqlSession.selectList("mapper.goods.selectAllGoods", params);
	}


//주제 : Ajax 이용해 입력한 검색어 관련  데이터 자동으로 표시하기
	//<input>에 검색 키워드를 입력하기 위해 키보드의 키를 눌렀다가 떼면 ~
	//입력된 키워드가 포함된 도서상품 책제목을 조회해서 가져옵니다.
	@Override
	public List<String> selectKeywordSearch(String keyword) throws DataAccessException {
	   List<String> list=(ArrayList)sqlSession.selectList("mapper.goods.selectKeywordSearch",keyword);
	   return list;
	}
	
	@Override
	public ArrayList selectGoodsBySearchWord(String searchWord) throws DataAccessException{
		ArrayList list=(ArrayList)sqlSession.selectList("mapper.goods.selectGoodsBySearchWord",searchWord);
		 return list;
	}
	
	//상품 아이디로 상세페이지 화면에 보여질  도서상품 하나의 정보를 조회 !!!
	@Override
	public GoodsVO selectGoodsDetail(String goods_id) throws DataAccessException{
		
		GoodsVO goodsVO=(GoodsVO)sqlSession.selectOne("mapper.goods.selectGoodsDetail",goods_id);
		return goodsVO;
	}
	
	//상품 아이디로 상세피이지 화면에 보여질 도서상품 하나의 이미지 정보 여러개를 조회!!!
	@Override
	public List<GoodsVO> selectGoodsDetailImage(String goods_id) throws DataAccessException{
		
		List<GoodsVO> imageList=(ArrayList)sqlSession.selectList("mapper.goods.selectGoodsDetailImage",goods_id);
		
		return imageList;
	}

	@Override
    public int insertGoods(GoodsVO goodsVO) throws DataAccessException {
        return sqlSession.insert("mapper.goods.insertGoods", goodsVO);
    }

    @Override
    public int updateGoods(GoodsVO goodsVO) throws DataAccessException {
        return sqlSession.update("mapper.goods.updateGoods", goodsVO);
    }

    @Override
    public GoodsVO selectGoodsByISBN(String goods_isbn) throws DataAccessException {
        return sqlSession.selectOne("mapper.goods.selectGoodsByISBN", goods_isbn);
    }
    
}
