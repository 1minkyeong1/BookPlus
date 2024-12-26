package com.bookplus.order.controller;

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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.bookplus.common.base.BaseController;
import com.bookplus.goods.service.GoodsService;
import com.bookplus.goods.vo.GoodsVO;
import com.bookplus.member.vo.MemberVO;
import com.bookplus.order.service.OrderService;
import com.bookplus.order.vo.OrderVO;

//   /order/orderAllCartGoods.do

//   /order/orderEachGoods.do
@Controller("orderController")
@RequestMapping(value="/order")
public class OrderControllerImpl extends BaseController implements OrderController {
	@Autowired
	private OrderService orderService;
	@Autowired
	private OrderVO orderVO;
	@Autowired
	private GoodsService goodsService;
	
	
	//goodsDetail.jsp페이지에서 구매하기 버튼을 눌러 주문요청한 주소   /order/orderEachGoods.do
	@RequestMapping(value="/orderEachGoods.do" ,method = RequestMethod.POST)
	public ModelAndView orderEachGoods(@RequestParam("goodsId") String goods_id, 
									   @RequestParam("orderGoodsQty") String orderGoodsQty, 
			                           HttpServletRequest request, 
			                           HttpServletResponse response)  throws Exception{
		
		request.setCharacterEncoding("utf-8");
		HttpSession session=request.getSession();
		
		Boolean isLogOn=(Boolean)session.getAttribute("isLogOn"); //true 또는 false를 반환 받음.  true -> 로그인함
																  //                         false -> 미로그인 
	
		//로그인을 하지 않았다면 먼저 로그인 후 주문을 처리하도록 주문 정보와 주문 페이지 요청 URL을 session에 저장합니다. 
		if(isLogOn==null || isLogOn==false){
			return new ModelAndView("redirect:/member/loginForm.do");
			
		}
		
		//향후  tiles_order.xml파일에서 중앙화면의 주소가 결정됨 
		String viewName=(String)request.getAttribute("viewName"); //  /order/orderEachGoods
		ModelAndView mav = new ModelAndView(viewName);
		

		//도서 상품 정보를 조회한후  Map으로 반환 받습니다. 
		Map goodsMap=goodsService.goodsDetail(goods_id); //상품 아이디 전달!
		System.out.println(goodsMap);
		
		
		List<GoodsVO> myOrderList=new ArrayList<>();
	    List<Integer> orderQtyList = new ArrayList<>(); // 추가: 주문 수량 리스트

		
	    // goodsMap에서 GoodsVO 객체를 가져옴
	    GoodsVO goodsVO = (GoodsVO) goodsMap.get("goodsVO");
	    myOrderList.add(goodsVO);
	    
	    orderQtyList.add(Integer.parseInt(orderGoodsQty));
	    
		mav.addObject("myOrderList", myOrderList);
		mav.addObject("orderQtyList", orderQtyList);  //상품 수량 저장
		

		//로그인 요청 당시 ~ 입력한 아이디, 비밀번호를 이용해 회원정보를 조회한 정보가 저장된 MemeberVO객체는 session에 저장되어 있었으므로
		//로그인 했다면~~  MemberVO객체를 꺼내 온다.
		MemberVO memberInfo=(MemberVO)session.getAttribute("memberInfo");
		//주문 상품 정보와  주문자 정보를 저장 후 창으로 전달합니다. 
		mav.addObject("memberInfo", memberInfo); //로그인한 주문자 정보
		return mav;
	}
	
	// myCartList.jsp화면(장바구니 목록 화면)에서  주문할 상품을 체크박스를 클릭해 선택하고  
	//각 상품의 주문 수량을 입력하여 주문하기 버튼을 클릭하여  
	//배송지 정보와 결제 정보를 최종 입력후  최종결제 요청을 하는 중앙화면을 요청하는 주소!
	//  /order/orderAllCartGoods.do 요청 주소를 받으면 호출되는 메소드 
	@RequestMapping(value = "/orderAllCartGoods.do", method = RequestMethod.POST)
	public ModelAndView orderAllCartGoods(
	        @RequestParam("cart_goods_qty2") String[] cart_goods_qty,
	        HttpServletRequest request, HttpServletResponse response) throws Exception {

	    String viewName = (String) request.getAttribute("viewName"); // /order/orderAllCartGoods
	    ModelAndView mav = new ModelAndView(viewName);

	    // 세션에서 장바구니 정보 가져오기
	    HttpSession session = request.getSession();
	    Map<String, Object> cartMap = (Map<String, Object>) session.getAttribute("cartMap");
	    List<GoodsVO> myGoodsList = (List<GoodsVO>) cartMap.get("myGoodsList");

	    // 주문할 상품 정보를 저장할 리스트
	    List<GoodsVO> myOrderList = new ArrayList<>();
	    List<Integer> orderQtyList = new ArrayList<>(); // 추가: 주문 수량 리스트


	    // 세션에서 로그인한 사용자 정보 가져오기
	    MemberVO memberInfo = (MemberVO) session.getAttribute("memberInfo");

	    // 체크된 상품 수량 배열 반복
	    for (String cartGoods : cart_goods_qty) {
	        System.out.println(cartGoods);
	        // 상품 번호와 주문 수량 분리
	        String[] cart_goods = cartGoods.split(":");
	        System.out.println();
	        String goodsIdFromRequest = cart_goods[0];
	        int orderQty = Integer.parseInt(cart_goods[1]);
	        

	        // myGoodsList에서 해당 상품 검색
	        for (GoodsVO goodsVO : myGoodsList) {
	            if (goodsVO.getGoods_id().equals(goodsIdFromRequest)) {
	                myOrderList.add(goodsVO);
	                orderQtyList.add(orderQty);     // 해당 상품의 수량 추가

	                break; // 해당 상품 처리 완료 시 반복 종료
	            }
	        }
	    }

	    // 선택한 주문 항목을 세션에 저장
	    mav.addObject("myOrderList", myOrderList);
	    mav.addObject("memberInfo", memberInfo);   
	    mav.addObject("orderQtyList", orderQtyList); // 수량 리스트 추가


	    return mav;
	}

	
	//팝업창에서 최종결제하기 버튼을 눌렀을때 
	// 최종 결제하기 버튼을 눌러  최종 결제 요청한 주소  /order/payToOrderGoods.do
//	@RequestMapping(value="/payToOrderGoods.do" ,method = RequestMethod.POST)
//										//주문창(goodsDetail.jsp)에서 입력한 상품 수령자 정보와 배송지 정보를 Map에 바로 저장후 매개변수로 받습니다.
//	public ModelAndView payToOrderGoods(@RequestParam Map<String, String> receiverMap,
//			                            HttpServletRequest request, HttpServletResponse response)  throws Exception{
//		
//		
//		String viewName=(String)request.getAttribute("viewName");  // /order/payToOrderGoods
//		ModelAndView mav = new ModelAndView(viewName);
//		
//		HttpSession session=request.getSession();
//		MemberVO memberVO=(MemberVO)session.getAttribute("orderer");
//		String member_id=memberVO.getMember_id();
//		String orderer_name=memberVO.getMember_name();
//		String orderer_hp = memberVO.getHp1()+"-"+memberVO.getHp2()+"-"+memberVO.getHp3();
//		
//		List<OrderVO> myOrderList=(List<OrderVO>)session.getAttribute("myOrderList");
//		
//		//주문창에서 입력한 수령자 정보와 배송지 정보를 주문 상품 정보 목록과 합칩니다. 
//		for(int i=0; i<myOrderList.size();i++){
//			OrderVO orderVO=(OrderVO)myOrderList.get(i);
//			orderVO.setMember_id(member_id);
//			orderVO.setOrderer_name(orderer_name);
//			orderVO.setReceiver_name(receiverMap.get("receiver_name"));
//			
//			orderVO.setReceiver_hp1(receiverMap.get("receiver_hp1"));
//			orderVO.setReceiver_hp2(receiverMap.get("receiver_hp2"));
//			orderVO.setReceiver_hp3(receiverMap.get("receiver_hp3"));
//			
//			orderVO.setDelivery_address(receiverMap.get("delivery_address"));
//			orderVO.setDelivery_message(receiverMap.get("delivery_message"));
//			orderVO.setDelivery_method(receiverMap.get("delivery_method"));
//			orderVO.setGift_wrapping(receiverMap.get("gift_wrapping"));
//			orderVO.setPay_method(receiverMap.get("pay_method"));
//			orderVO.setCard_com_name(receiverMap.get("card_com_name"));
//			orderVO.setCard_pay_month(receiverMap.get("card_pay_month"));
//			orderVO.setPay_orderer_hp_num(receiverMap.get("pay_orderer_hp_num"));	
//			orderVO.setOrderer_hp(orderer_hp);	
//			myOrderList.set(i, orderVO);
//		}//end for
//		
//		//주문 정보를 DB에 추가 합니다. 
//	    orderService.addNewOrder(myOrderList);
//	    
//	    //주문 완료  결과창에 주문자 정보를 표시할수 있도록 저장후 전달 하게 합니다. 
//		mav.addObject("myOrderInfo",receiverMap);
//		
//		//주문 완료 결과창에  주문 상품목록을 표시할수 있도록 저장후 전달 하게 합니다. 
//		mav.addObject("myOrderList", myOrderList);
//		
//		return mav;
//	}
//	

	//==========
	// KG이니시스 결제 이후 Ajax 요청되면
	@RequestMapping(value="/paySuccess" ,method = RequestMethod.POST)
	@ResponseBody
    public ResponseEntity<Map<String, Object>> handlePaymentSuccess(@RequestBody Map<String, Object> requestData) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // OrderService에서 결제 검증, 주문 및 결제 데이터 저장까지 처리
            boolean isProcessed = orderService.processOrderAndPayment(requestData);

            if (isProcessed) {
            	response.put("order_id", requestData.get("order_id").toString());
                response.put("success", true);
                response.put("message", "결제가 성공적으로 처리되었습니다.");
                System.out.println(response);
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "결제 검증에 실패했습니다.");
                return ResponseEntity.badRequest().body(response);
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "결제 처리 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
}
