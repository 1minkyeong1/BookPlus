
package com.bookplus.goods.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.bookplus.common.base.BaseController;
import com.bookplus.goods.service.GoodsService;
import com.bookplus.goods.vo.GoodsVO;

import net.sf.json.JSONObject;

@Controller("goodsController")
@RequestMapping(value="/goods") 
public class GoodsControllerImpl extends BaseController   implements GoodsController {
	
	@Autowired
	private GoodsService goodsService;
	
	
	//   /goods/goodsDetail.do?goods_id=${item.goods_id }"
	@RequestMapping(value="/goodsDetail.do" ,method = RequestMethod.GET)
									//main.jsp에서 상품 클릭시 전달한 상품번호(상품아이디) 얻기 
	public ModelAndView goodsDetail(@RequestParam("goods_id") String goods_id, 
			                       HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		 // /goods/goodsDetail   웹브라우저에 보여줄 뷰의  주소 는 
		//  ViewIntercepter클래스에서 생성하여 request에 저장했었음!!
		String viewName=(String)request.getAttribute("viewName"); 
		
		//빠른메뉴에 표시 될 최근 본 상품 목록 정보가 session메모리영역에 있는지 없는지 판단하기 위해 session영역 얻기
		HttpSession session=request.getSession();
		
		//도서 상품 정보를 조회한후  Map으로 반환 받습니다. 
		Map goodsMap=goodsService.goodsDetail(goods_id); //상품 아이디 전달!
		System.out.println(goodsMap);
		
		ModelAndView mav = new ModelAndView(viewName); //   /goods/goodsDetail  저장
		mav.addObject("goodsMap", goodsMap);  //조회된 도서 상품 정보 저장 
		
		
		GoodsVO goodsVO=(GoodsVO)goodsMap.get("goodsVO");
		
		System.out.println("goodsDetail----기존에 본 상품아이디:" +goodsVO.getGoods_id() );
		System.out.println("goodsDetail----추가로 본 상품아이디:" +goods_id );
		
		//상품 상페페이지에서 조회한 상품 정보를 빠른메뉴(퀵메뉴)에 표시하기 위해 !!! 
		//메소드 호출시!  조회된 도서상품 번호, 조회한 도서상품 정보!GoodsVO객체, 세션을  전달합니다.
		addGoodsInQuick(goods_id,goodsVO,session); 
		
		System.out.println("-----"+session.getAttribute("quickGoodsListNum"));
		
		return mav;
	}
	
	//session에 또한 최근 본 상품정보가 저장된(퀵메뉴에 보여질 상품정보가 저장된) ArrayList배열이 저장되어 있지 않으면?
	// 상품상세페이지 요청시 본 상품정보(두번쨰 매개변수 GoodsVO goodsVO로 받는 상품정보)를 ArrayList배열 생성후
	// 추가시킵니다.
	private void addGoodsInQuick(String goods_id, GoodsVO goodsVO, HttpSession session) {

		boolean already_existed = false;

		List<GoodsVO> quickGoodsList;

		// 세션에 저장된 최근 본 상품 목록을 가져 옵니다.
		quickGoodsList = (ArrayList<GoodsVO>) session.getAttribute("quickGoodsList");

		// 최근 본 상품이 있는 경우
		if (quickGoodsList != null) {
			// 최근 본 상품목록이 네개 미만인 경우
			if (quickGoodsList.size() < 4) {

				for (int i = 0; i < quickGoodsList.size(); i++) {

					GoodsVO _goodsBean = (GoodsVO) quickGoodsList.get(i);
					
					if (goods_id != null && goods_id.equals(String.valueOf(_goodsBean.getGoods_id()))) {
				        System.out.println("이미 존재하는 상품입니다.");
				        already_existed = true;
				        break;
				    }
				}

				// already_existed변수값이 false이면 상품 정보를 목록에 저장합니다.
				if (already_existed == false) {
					quickGoodsList.add(goodsVO);
				}
			}

			
			
		} else {
			// 최근 본 상품 목록이 없으면 생성하여 상품정보를 저장합니다.
			quickGoodsList = new ArrayList<GoodsVO>();
			quickGoodsList.add(goodsVO);

		}
		// 최근 본 상품 목록을 세션에 저장합니다.
		session.setAttribute("quickGoodsList", quickGoodsList);
		// 최근 본 상품목록에 저장된 상품 개수를 세션에 저장합니다.
		session.setAttribute("quickGoodsListNum", quickGoodsList.size());
	}

	@RequestMapping(value = "/keywordSearch.do", method = RequestMethod.GET, produces = "application/json; charset=utf8")
	// JSON데이터를 웹브라우저로 출력합니다. //검색할 키워드를 가져 옵니다.
	public @ResponseBody String keywordSearch(@RequestParam("keyword") String keyword, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		response.setContentType("text/html;charset=utf-8");
		response.setCharacterEncoding("utf-8");
		// System.out.println(keyword);
		if (keyword == null || keyword.equals("")) {
			return null;
		}
		keyword = keyword.toUpperCase();

		// <input>에 검색 키워드를 입력하기 위해 키보드의 키를 눌렀다가 떼면 ~
		// 입력된 키워드가 포함된 도서상품 책제목을 조회해서 가져옵니다.
		List<String> keywordList = goodsService.keywordSearch(keyword);

		// JSONObject객체 -> { } 객체 를 생성
		JSONObject jsonObject = new JSONObject();
		// { "keyword": keywordList }
		jsonObject.put("keyword", keywordList);

		// "{ 'keyword': keywordList }"
		String jsonInfo = jsonObject.toString();

		System.out.println(jsonInfo);

		return jsonInfo;
	}

	// 검색버튼 누르면 !~ http://localhost:8090/bookplus/goods/searchGoods.do 입력한 검색어 단어가
	// 포함된 도서상품 검색
	@RequestMapping(value = "/searchGoods.do", method = RequestMethod.GET)
	public ModelAndView searchGoods(@RequestParam("searchWord") String searchWord, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		String viewName = (String) request.getAttribute("viewName"); // /goods/searchGoods

		List<GoodsVO> goodsList = goodsService.searchGoods(searchWord); // 자바 EE 디자인 패턴

		ModelAndView mav = new ModelAndView(viewName); // /goods/searchGoods

		mav.addObject("goodsList", goodsList);

		return mav;

	}

	@RequestMapping(value = "/updateDatabase", method = RequestMethod.POST)
    public ResponseEntity<Map<String, Object>> updateDatabase() {
		System.out.println("goods controller updatebase start");
        Map<String, Object> response = new HashMap();
        try {
            // DB 갱신 로직 실행
        	List<GoodsVO> fetchBookDetails = goodsService.fetchBookDetails();
    		System.out.println("goods controller updatebase info fetch start");
            boolean isUpdated = goodsService.updateDatabase(fetchBookDetails);
    		System.out.println("goods controller updatebase info fetch end");
            
            if(isUpdated) {
                response.put("updated", isUpdated);
                response.put("message", "DB 갱신 성공");
                return ResponseEntity.ok(response);
            } else {
                response.put("updated", isUpdated);
                response.put("message", "DB 갱신 실패");
                return ResponseEntity.ok(response);
            }
        } catch (Exception e) {
            response.put("updated", false);
            response.put("message", "DB 갱신 중 오류 발생");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
}
