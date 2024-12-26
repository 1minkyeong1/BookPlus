package com.bookplus.mypage.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.bookplus.common.base.BaseController;
import com.bookplus.goods.service.GoodsService;
import com.bookplus.goods.vo.GoodsVO;
import com.bookplus.member.vo.MemberVO;
import com.bookplus.mypage.service.MyPageService;
import com.bookplus.order.service.PaymentServiceImpl;
import com.bookplus.order.vo.OrderVO;
import com.bookplus.order.vo.PaymentVO;

// 화면상단에 마이페이지 누르면  요청하는 주소
// http://localhost:8090/bookplus/mypage/myPageMain.do
// 최근 주문 내역과 계좌 내역 표시 하는 화면 요청!

@Controller("myPageController")
@RequestMapping(value = "/mypage")
public class MyPageControllerImpl extends BaseController implements MyPageController {
	@Autowired
	private MyPageService myPageService;
	
	@Autowired
	private GoodsService goodsService;

	@Autowired
	private PaymentServiceImpl paymentService;
	
	@Autowired
	private MemberVO memberVO;

	// 마이페이지 최초 화면을 요청합니다.
	@Override
	@RequestMapping(value="/myPageMain.do" ,method = RequestMethod.GET)
								   //주문 취소시 결과 메세지를 매개변수로 받습니다. 
	public ModelAndView myPageMain(@RequestParam(required = false,value="message")  String message,
			   HttpServletRequest request, HttpServletResponse response)  throws Exception {
		
		HttpSession session=request.getSession(true);
		
		//마이페이지 왼쪽 화면 메뉴를 보여주기 위해 조건값 저장 
		session.setAttribute("side_menu", "my_page"); 
		
	//  /mypage/myPageMain
		String viewName=(String)request.getAttribute("viewName");
		ModelAndView mav = new ModelAndView(viewName);

		// 로그인한 상품 구매자의 정보를 session에서 얻는다.
		memberVO = (MemberVO) session.getAttribute("memberInfo");
		System.out.println("로그인 값 가져오기 전!: " + memberVO.getMember_id());
		String member_id = memberVO.getMember_id();

		// 로그인한 회원 ID를 이용해 주문한 상품을 조회 합니다.
		List<OrderVO> myOrderList = myPageService.listMyOrderGoods(member_id);

		// 주문 취소시 결과 메세지를 JSP로 전달하기 위해 저장
		mav.addObject("message", message);
		// 주문한 상품목록(DB에서 조회한 상품목록)을 JSP로 전달 하기 위해 저장
		mav.addObject("myOrderList", myOrderList);

		return mav;
	}
	//==========
	//주문 후 주문 내역을 조회하기 위해 호출하는 함
	@Override
	@RequestMapping(value="/myOrderDetail.do" ,method = RequestMethod.POST)
	public ModelAndView myOrderDetail(@RequestParam("order_id")  String order_id,HttpServletRequest request, HttpServletResponse response)  throws Exception {
		
		String viewName=(String)request.getAttribute("viewName");
		ModelAndView mav = new ModelAndView(viewName);
		
		HttpSession session=request.getSession(true);
		MemberVO orderer=(MemberVO)session.getAttribute("memberInfo");
		

		List<OrderVO> myOrderList=myPageService.findMyOrderInfo(order_id);
		
	    List<Map<String, Object>> goodsList = new ArrayList<>();
		// 로그로 출력
		for (OrderVO order : myOrderList) {
		    System.out.println(order.toString());
		    String goodsIds = order.getGoodsId(); // goodsId 필드 값 (콤마로 구분된 문자열)
	        String[] goodsIdArray = goodsIds.split(","); // 콤마를 기준으로 분리
	        
	        for (String goodsId : goodsIdArray) {
	            Map<String, Object> goodsMap = goodsService.goodsDetail(goodsId.trim()); // 각 goods_id로 책 정보 조회
	            if (goodsMap != null && !goodsMap.isEmpty()) {
	                goodsList.add(goodsMap); // 리스트에 추가
	            }
	            System.out.println(goodsMap);
	        }
		}
		// 결제 정보 조회
	    PaymentVO paymentInfo = paymentService.findPaymentByOrderId(order_id);

	    // ModelAndView에 데이터 추가
	    mav.addObject("paymentInfo", paymentInfo);
	    mav.addObject("orderer", orderer);
	    mav.addObject("myOrderList", myOrderList);
	    mav.addObject("goodsList", goodsList); // 조회한 책 정보 리스트 추가

	    return mav;
	}

	@Override
	@RequestMapping(value = "/listMyOrderHistory.do", method = RequestMethod.GET)
	public ModelAndView listMyOrderHistory(@RequestParam Map<String, String> dateMap, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String viewName = (String) request.getAttribute("viewName");
		ModelAndView mav = new ModelAndView(viewName);
		HttpSession session = request.getSession(true);
		memberVO = (MemberVO) session.getAttribute("memberInfo");
		String member_id = memberVO.getMember_id();

		String fixedSearchPeriod = dateMap.get("fixedSearchPeriod");
		String beginDate = null, endDate = null;

		String[] tempDate = calcSearchPeriod(fixedSearchPeriod).split(",");
		beginDate = tempDate[0];
		endDate = tempDate[1];
		dateMap.put("beginDate", beginDate);
		dateMap.put("endDate", endDate);
		dateMap.put("member_id", member_id);
		List<OrderVO> myOrderHistList = myPageService.listMyOrderHistory(dateMap);

		String beginDate1[] = beginDate.split("-"); // �˻����ڸ� ��,��,�Ϸ� �и��ؼ� ȭ�鿡 �����մϴ�.
		String endDate1[] = endDate.split("-");
		mav.addObject("beginYear", beginDate1[0]);
		mav.addObject("beginMonth", beginDate1[1]);
		mav.addObject("beginDay", beginDate1[2]);
		mav.addObject("endYear", endDate1[0]);
		mav.addObject("endMonth", endDate1[1]);
		mav.addObject("endDay", endDate1[2]);
		mav.addObject("myOrderHistList", myOrderHistList);
		return mav;
	}

	//==========
	// 주문 취소 버튼을 눌러 주문 취소 요청이 들어오면 주문한 상품들의 주문번호를 매개변수로 받아서
	// 주문번호에 대한 상품정보들을 DB에서 삭제!
	@Override
	@RequestMapping(value = "/cancelMyOrder.do", method = RequestMethod.POST)
	public ModelAndView cancelMyOrder(@RequestParam("order_id") String order_id, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		// 주문취소 버튼을 눌러 t_shopping_order테이블에 저장된
		// 주문번호에 해당 하는 주문상태열의 값을 주문취소(cancel_order)로 수정!
		myPageService.cancelOrder(order_id);

		mav.addObject("message", "cancel_order");
		mav.setViewName("redirect:/mypage/myPageMain.do");
		return mav;
	}
	
	@Override
	@RequestMapping(value = "/deleteMyOrder.do", method = RequestMethod.POST)
	public ModelAndView deleteMyOrder(@RequestParam("order_id") String order_id, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		myPageService.deleteOrder(order_id);
		
		mav.addObject("message", "delete_order");
		mav.setViewName("redirect:/mypage/myPageMain.do");
		return mav;

	}

	
	
	// side.jsp페이지 화면에서 회원정보관리 <a>태그를 클릭하면 호출되는 메소드
	@Override
	@RequestMapping(value = "/myInfoModify.do", method = RequestMethod.GET)
	public ModelAndView myDetailInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String viewName = (String) request.getAttribute("viewName"); // /mypage//myInfoModify
		ModelAndView mav = new ModelAndView(viewName);
		return mav;
	}

	@Override
	@RequestMapping(value = "/myInfoModify.do", method = RequestMethod.POST)
	public ResponseEntity modifyMyInfo(@RequestParam("attribute") String attribute, @RequestParam("value") String value,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		Map<String, String> memberMap = new HashMap<String, String>();
		String val[] = null;
		HttpSession session = request.getSession();
		memberVO = (MemberVO) session.getAttribute("memberInfo");
		String member_id = memberVO.getMember_id();
		if (attribute.equals("member_birth")) {
			val = value.split(",");
			memberMap.put("member_birth_y", val[0]);
			memberMap.put("member_birth_m", val[1]);
			memberMap.put("member_birth_d", val[2]);
			memberMap.put("member_birth_gn", val[3]);
		} else if (attribute.equals("tel")) {
			val = value.split(",");
			memberMap.put("tel1", val[0]);
			memberMap.put("tel2", val[1]);
			memberMap.put("tel3", val[2]);
		} else if (attribute.equals("hp")) {
			val = value.split(",");
			memberMap.put("hp1", val[0]);
			memberMap.put("hp2", val[1]);
			memberMap.put("hp3", val[2]);
			memberMap.put("smssts_yn", val[3]);
		} else if (attribute.equals("email")) {
			val = value.split(",");
			memberMap.put("email1", val[0]);
			memberMap.put("email2", val[1]);
			memberMap.put("emailsts_yn", val[2]);
		} else if (attribute.equals("address")) {
			val = value.split(",");
			memberMap.put("zipcode", val[0]);
			memberMap.put("roadAddress", val[1]);
			memberMap.put("jibunAddress", val[2]);
			memberMap.put("namujiAddress", val[3]);
		} else {
			memberMap.put(attribute, value);
		}

		memberMap.put("member_id", member_id);

		memberVO = (MemberVO) myPageService.modifyMyInfo(memberMap);
		session.removeAttribute("memberInfo");
		session.setAttribute("memberInfo", memberVO);

		String message = null;
		ResponseEntity resEntity = null;
		HttpHeaders responseHeaders = new HttpHeaders();
		message = "mod_success";
		resEntity = new ResponseEntity(message, responseHeaders, HttpStatus.OK);
		return resEntity;
	}

}
