package com.bookplus.admin.goods.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map; 

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.bookplus.admin.goods.dao.AdminGoodsDAO;
import com.bookplus.goods.vo.GoodsVO;
import com.bookplus.order.vo.OrderVO;

@Service("adminGoodsService")
@Transactional(propagation=Propagation.REQUIRED)
public class AdminGoodsServiceImpl implements AdminGoodsService {

	@Autowired
	private AdminGoodsDAO adminGoodsDAO;
	
	@Override
	public String addNewGoods(Map newGoodsMap) throws Exception {
		// 새 도서 상품정보를 테이블에 INSERT하고 새로운 goods_isbn 반환 가정
		String goods_isbn = (String)adminGoodsDAO.insertNewGoods(newGoodsMap);

		// 변경 전: ArrayList<ImageFileVO> imageFileList = (ArrayList)newGoodsMap.get("imageFileList");
		// 변경 후: imageFileList → List<GoodsVO>로 받음
		List<GoodsVO> imageFileList = (List<GoodsVO>)newGoodsMap.get("imageFileList");

		// 각 이미지 정보에 상품 ISBN을 설정
		for(GoodsVO goodsVO : imageFileList) {
			goodsVO.setGoods_isbn(goods_isbn);
		}

		// 이미지 정보를 이미지 테이블에 INSERT
		adminGoodsDAO.insertGoodsImageFile(imageFileList);

		return goods_isbn; 
	}

	@Override

	public List<GoodsVO> listNewGoods(Map condMap) throws Exception{
		return adminGoodsDAO.selectNewGoodsList(condMap);
	}

	// 상품 수정을 위해 도서 상품 정보와 도서 이미지 정보를 조회하여 먼저 보여주기 위함
	@Override
	public Map goodsDetail(String goods_isbn) throws Exception {
		Map goodsMap = new HashMap();

		// 도서상품 정보 조회
		GoodsVO goodsVO = adminGoodsDAO.selectGoodsDetail(goods_isbn);

		// 도서 이미지정보 조회
		List<GoodsVO> imageFileList = adminGoodsDAO.selectGoodsImageFileList(goods_isbn);

		goodsMap.put("goods", goodsVO);
		goodsMap.put("imageFileList", imageFileList);

		return goodsMap;
	}
	
	@Override
	public List<GoodsVO> goodsImageFile(String goods_isbn) throws Exception {
		List<GoodsVO> imageList = adminGoodsDAO.selectGoodsImageFileList(goods_isbn);
		return imageList;
	}

	// 수정 반영하기 누르면 호출되는 메소드
	@Override
	public void modifyGoodsInfo(Map goodsMap) throws Exception {
		adminGoodsDAO.updateGoodsInfo(goodsMap);
	}

	@Override
	public void modifyGoodsImage(List<GoodsVO> imageFileList) throws Exception {
		adminGoodsDAO.updateGoodsImage(imageFileList); 
	}

	@Override
	public List<OrderVO> listOrderGoods(Map condMap) throws Exception {
		return adminGoodsDAO.selectOrderGoodsList(condMap);
	}

	@Override
	public void modifyOrderGoods(Map orderMap) throws Exception {
		adminGoodsDAO.updateOrderGoods(orderMap);
	}

	@Override
	public void removeGoodsImage(String goods_isbn) throws Exception {
		// 기존 코드: adminGoodsDAO.deleteGoodsImage(image_id);
		// 이미지 식별자를 image_id -> goods_isbn으로 변경하였으므로 DAO에서도 이 부분 수정 필요.
		adminGoodsDAO.deleteGoodsImage(goods_isbn);
	}

	@Override
	public void addNewGoodsImage(List<GoodsVO> imageFileList) throws Exception {
		adminGoodsDAO.insertGoodsImageFile(imageFileList);
	}
	
}
