package com.bookplus.main;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.bookplus.common.base.BaseController;
import com.bookplus.goods.service.GoodsService;
import com.bookplus.goods.vo.GoodsVO;

//@Controller("mainController"): 해당 클래스를 컨트롤러로 지정하며, 빈의 이름을 "mainController"로 설정한다.
//@EnableAspectJAutoProxy: AOP를 사용하기 위한 어노테이션으로, 이를 설정하면 자동으로 AOP 프록시를 생성하여 적용한다.
@Controller("mainController")
@EnableAspectJAutoProxy
public class MainController extends BaseController {
	
	//GoodsServiceImpl.java파일에 작성 해 놓은 
	//public class GoodsServiceImpl implements GoodsService {} 의
	//<bean>을 자동 주입 합니다.
	@Autowired
	private GoodsService goodsService;

	// http://localhost:8090/bookShop01/main/main.do 입력하여 메인화면 요청시
	// 메인화면 중앙에 보여줄 베스트셀러, 신간, 스테디 셀러를 조회한후  Map에 저장하여  JSP로 전달합니다.
	@RequestMapping(value= "/main/main.do" ,method={RequestMethod.POST,RequestMethod.GET})
	public ModelAndView main( @RequestParam(value = "page", required = false, defaultValue = "1") int page,
							  @RequestParam(value = "category", required = false) String category, // category 파라미터 추가
							  Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		//세션영역에 side_menu속성값 user를 저장 해 놓으면
		//첫 메인 화면 main.jsp의 왼쪾사이드메뉴 모습은 비로그인된 상태로 접속한 사이드 왼쪾메뉴를 나타내기 위해 쓰입니다.
		//참고. 그밖에 세연영역에 저장되는 값 확인을 위해 common폴더에 만들어져 있는 side.jsp를 열어 확인 해보세요
		HttpSession session = request.getSession();
		session.setAttribute("side_menu", "user");
		
		int limit = 12;  // 페이지당 15개
	    int offset = (page - 1) * limit; // 시작 위치
	    System.out.println(category);
	    // category를 그대로 Service로 전달
	    List<GoodsVO> goodsList = goodsService.getAllGoods(category, limit, offset);

	    model.addAttribute("goodsList", goodsList);
	    model.addAttribute("currentPage", page);
	    model.addAttribute("selectedCategory", category); // 선택된 카테고리 전달
	    session.setAttribute("goodsList", goodsList);
	    
	 // View 설정
	    ModelAndView mav = new ModelAndView();
	    String viewName = (String) request.getAttribute("viewName");
	    mav.setViewName(viewName);
	    mav.addObject("goodsList", goodsList);
	    mav.addObject("currentPage", page);
	    mav.addObject("selectedCategory", category); // View로 선택된 카테고리 전달

	    return mav;
	}

	@RequestMapping(value = "/map/directions.do" , method = RequestMethod.GET)
	public String showDirections(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String viewName=(String)request.getAttribute("viewName");
		
		return viewName;
	}
}
