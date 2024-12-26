package com.bookplus.goods.service;

import java.sql.Date;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.bookplus.goods.dao.GoodsDAO;
import com.bookplus.goods.vo.GoodsVO;

@Service("goodsService")
@Transactional(propagation = Propagation.REQUIRED)
public class GoodsServiceImpl implements GoodsService {

	private static final String API_URL = "http://www.aladin.co.kr/ttb/api/ItemList.aspx";
	private static final String API_KEY = "ttbsmilesna171505001"; // 알라딘 API 키 입력
	private static final int MAX_RESULTS = 50; // 한 번에 가져올 수 있는 최대 결과 수

	@Autowired
	private GoodsDAO goodsDAO;

	@Override
	public List<GoodsVO> fetchBookDetails() throws Exception {

		System.out.println("goods service fetchbookdetails start");
		List<GoodsVO> goodsList = new ArrayList<>();
		String[] queryTypes = { "itemnewall", "bestseller", "blogbest" }; // API 타입
		int maxPages = 1; // 최대 페이지 수
		int maxResults = 50; // 페이지당 최대 결과 수

		try {
			RestTemplate restTemplate = new RestTemplate();
			for (int i = 0; i < queryTypes.length; i++) { // queryTypes 순회
				String queryType = queryTypes[i];

				for (int j = 1; j <= maxPages; j++) { // 페이지 순회
					// API URL 동적 생성
					// 카테고리 날씨 >> 51210, 28465, 8435
					String requestUrl = String.format(
							"http://www.aladin.co.kr/ttb/api/ItemList.aspx?ttbkey=%s&querytype=%s&searchtarget=book&start=%d&maxresults=%d&cover=big&categoryid=28465&output=xml&inputencoding=utf-8&version=20131101",
							API_KEY, queryType, j, maxResults);
					System.out.println(requestUrl);
					// API 호출 및 응답 처리
					String response = restTemplate.getForObject(requestUrl, String.class);
					DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
					DocumentBuilder builder = factory.newDocumentBuilder();
					Document doc = builder.parse(new java.io.ByteArrayInputStream(response.getBytes("UTF-8")));

					NodeList itemList = doc.getElementsByTagName("item");

					// 파싱된 정보 확인
					if (itemList.getLength() == 0) {
						break; // 더 이상 데이터가 없으면 루프 종료
					}

					Random random = new Random();

					// 현재 날짜
					LocalDate currentDate = LocalDate.now();

					// 3일 뒤의 날짜
					LocalDate deliveryDate = currentDate.plusDays(3);

					java.util.Date utilDate = Date.from(deliveryDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
					java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());

					for (int k = 0; k < itemList.getLength(); k++) {

						Element item = (Element) itemList.item(k);

						GoodsVO goods = new GoodsVO();
						double goodsPrice = (double) parseToInt(getTagValue("priceStandard", item));
						double goodsSalesPrice = (double) parseToInt(getTagValue("priceSales", item));
						double SalesPrice = (1 - (goodsSalesPrice / goodsPrice)) * 100;

						// Math.round를 사용하여 소숫점 아래 2자리로 반올림
						double roundedSalesPrice = Math.round(SalesPrice * 100.0) / 100.0;

						System.out.println(goodsPrice);
						System.out.println(goodsSalesPrice);
						System.out.println(SalesPrice);
						System.out.println(roundedSalesPrice);

						goods.setGoods_title(getTagValue("title", item));
						goods.setGoods_writer(getTagValue("author", item));
						goods.setGoods_published_date(
								java.sql.Date.valueOf(java.time.LocalDate.parse(getTagValue("pubDate", item),
										java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd"))));
						goods.setGoods_isbn(getTagValue("isbn13", item));
						goods.setGoods_price((int) goodsPrice);
						goods.setGoods_total_page(random.nextInt(401) + 100); // 100 ~ 500 사이의 랜덤값
						goods.setGoods_delivery_price(3000); // 배송료 3000원 고정
						goods.setGoods_delivery_date(sqlDate); // 배송기간 3일 고정
						goods.setGoods_sales_price((int) roundedSalesPrice);
						goods.setGoods_fileName(getTagValue("cover", item));
						goods.setGoods_sort(getTagValue("categoryName", item));
						goods.setGoods_publisher(getTagValue("publisher", item));

						System.out.println(goods.toString());
						goodsList.add(goods);
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return goodsList;
	}

	@Override
	public boolean updateDatabase(List<GoodsVO> fetchBookDetails) throws Exception {
		boolean result = true;
		try {
			for (GoodsVO goods : fetchBookDetails) {
				// ISBN으로 기존 데이터 조회
				GoodsVO existingBook = goodsDAO.selectGoodsByISBN(goods.getGoods_isbn());
				if (existingBook != null) {
					// 존재하면 업데이트
					int updateResult = goodsDAO.updateGoods(goods);
					if (updateResult != 1) {
						System.err.println("Update 실패: " + goods.getGoods_isbn());
						result = false; // 실패 처리
					}
				} else {
					// 존재하지 않으면 삽입
					int insertResult = goodsDAO.insertGoods(goods);
					if (insertResult != 1) {
						System.err.println("Insert 실패: " + goods.getGoods_isbn());
						result = false; // 실패 처리
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			result = false; // 예외 발생 시 실패
		}
		return result; // 최종 성공 여부 반환
	}

	private String getTagValue(String tag, Element element) {
		NodeList nodeList = element.getElementsByTagName(tag);
		if (nodeList != null && nodeList.getLength() > 0) {
			Node node = nodeList.item(0);
			if (node != null && node.getFirstChild() != null) {
				return node.getFirstChild().getNodeValue();
			}
		}
		return null;
	}

	private int parseToInt(String value) {
		try {
			return (value == null || value.isEmpty()) ? 0 : Integer.parseInt(value);
		} catch (NumberFormatException e) {
			return 0;
		}
	}

	@Override
	public List<GoodsVO> getAllGoods(String category, int limit, int offset) throws Exception {
	    // DAO에 전달할 파라미터 구성
	    Map<String, Object> params = new HashMap<>();
	    params.put("category", category); // 카테고리 추가
	    params.put("limit", limit);
	    params.put("offset", offset);
	    System.out.println(params);
	    return goodsDAO.selectAllGoods(params);
	}


	// 상품아이디를 매개변수로 전달 받아 도서상품정보 + 도서이미지정보를 GoodsDAOImpl의 메소드로 조회 명령 하는 메소드
	public Map goodsDetail(String goods_id) throws Exception {

		Map goodsMap = new HashMap();

		GoodsVO goodsVO = goodsDAO.selectGoodsDetail(goods_id); // 도서 상품 조회

		goodsMap.put("goodsVO", goodsVO);

//		List<ImageFileVO> imageList =goodsDAO.selectGoodsDetailImage(_goods_id); //도서상품의 이미지 정보 조회 
//		
//		goodsMap.put("imageList", imageList);

		return goodsMap;
	}

//주제 : Ajax 이용해 입력한 검색어 관련  데이터 자동으로 표시하기	
	// <input>에 검색 키워드를 입력하기 위해 키보드의 키를 눌렀다가 떼면 ~
	// 입력된 키워드가 포함된 도서상품 책제목을 조회해서 가져옵니다.
	public List<String> keywordSearch(String keyword) throws Exception {

		List<String> list = goodsDAO.selectKeywordSearch(keyword);
		return list;
	}

	public List<GoodsVO> searchGoods(String searchWord) throws Exception {
		List goodsList = goodsDAO.selectGoodsBySearchWord(searchWord);
		return goodsList;
	}
}
