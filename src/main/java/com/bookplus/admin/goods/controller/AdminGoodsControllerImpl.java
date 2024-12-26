package com.bookplus.admin.goods.controller;

import java.io.File;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map; 

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils; 
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity; 
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod; 
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.bookplus.admin.goods.service.AdminGoodsService;
import com.bookplus.common.base.BaseController;
import com.bookplus.goods.vo.GoodsVO;
import com.bookplus.member.vo.MemberVO;


@Controller("adminGoodsController")
@RequestMapping(value="/admin/goods")
public class AdminGoodsControllerImpl extends BaseController implements AdminGoodsController {
	
	private static final String CURR_IMAGE_REPO_PATH = "C:\\shopping\\file_repo";
	
	@Autowired
	private AdminGoodsService adminGoodsService;
	
	@Override
	@RequestMapping(value="/adminGoodsMain.do" ,method={RequestMethod.POST,RequestMethod.GET})
	public ModelAndView adminGoodsMain(@RequestParam Map<String, String> dateMap,
			                           HttpServletRequest request, HttpServletResponse response)  throws Exception {
	
		String viewName=(String)request.getAttribute("viewName");
		ModelAndView mav = new ModelAndView(viewName);   //    /admin/goods/adminGoodsMain
		
		String fixedSearchPeriod = dateMap.get("fixedSearchPeriod");
		String section = dateMap.get("section");
		String pageNum = dateMap.get("pageNum");
		
		String [] tempDate=calcSearchPeriod(fixedSearchPeriod).split(",");
		String beginDate=tempDate[0];
		String endDate=tempDate[1];
		dateMap.put("beginDate", beginDate);
		dateMap.put("endDate", endDate);
		
		Map<String,Object> condMap=new HashMap<String,Object>();
		
		if(section== null) {
			section = "1";
		}
		if(pageNum== null) {
			pageNum = "1";
		}
		// String을 Integer로 변환
		int sectionInt = Integer.parseInt(section);
		int pageNumInt = Integer.parseInt(pageNum);
		
		int pageSection = (sectionInt - 1) * 100 + (pageNumInt - 1) * 10;

		condMap.put("beginDate",beginDate);
		condMap.put("endDate", endDate);
		condMap.put("pageSection", pageSection);
		
		List<GoodsVO> newGoodsList=adminGoodsService.listNewGoods(condMap);
		mav.addObject("newGoodsList", newGoodsList);
		
		String beginDate1[]=beginDate.split("-");
		String endDate2[]=endDate.split("-");
		mav.addObject("beginYear",beginDate1[0]);
		mav.addObject("beginMonth",beginDate1[1]);
		mav.addObject("beginDay",beginDate1[2]);
		mav.addObject("endYear",endDate2[0]);
		mav.addObject("endMonth",endDate2[1]);
		mav.addObject("endDay",endDate2[2]);
		
		mav.addObject("section", section);
		mav.addObject("pageNum", pageNum);
		return mav;	
	}
	

	@Override
	@RequestMapping(value="/addNewGoods.do" ,method={RequestMethod.POST})
	public ResponseEntity addNewGoods(MultipartHttpServletRequest multipartRequest, 
									  HttpServletRequest request, HttpServletResponse response) throws Exception {
		multipartRequest.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=UTF-8");
		
		Map newGoodsMap = new HashMap();
		Enumeration enu=multipartRequest.getParameterNames();
		
		while(enu.hasMoreElements()){
			String name=(String)enu.nextElement();
			String value=multipartRequest.getParameter(name);
			newGoodsMap.put(name,value);
		}
		
		HttpSession session = multipartRequest.getSession();
		MemberVO memberVO = (MemberVO) session.getAttribute("memberInfo");
		String reg_id = memberVO.getMember_id();
		
		// 이미지 업로드 : GoodsVO 리스트
		List<GoodsVO> imageFileList =upload(multipartRequest, request);
		if(imageFileList!= null && imageFileList.size()!=0) {
			for(GoodsVO goodsVO : imageFileList) {
				// reg_id 설정
				// goods_isbn은 insert 후 DB에서 받는 것이므로 여기서는 아직 설정 불가
				// 필요하다면 insert 후 반환받은 isbn으로 재처리
			}
			newGoodsMap.put("imageFileList", imageFileList);
		}
		
		String message = null;
		ResponseEntity resEntity = null;
		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type", "text/html; charset=utf-8");
		try {
			// goods_isbn 반환 가정
			String goods_isbn = adminGoodsService.addNewGoods(newGoodsMap);
			
			// 이미지 실제 이동
			if(imageFileList!=null && imageFileList.size()!=0) {
				for(GoodsVO goodsVO:imageFileList) {
					String imageFileName = goodsVO.getGoods_fileName();
					File srcFile = new File(CURR_IMAGE_REPO_PATH+"\\temp\\"+imageFileName);
					File destDir = new File(CURR_IMAGE_REPO_PATH+"\\"+goods_isbn);
					FileUtils.moveFileToDirectory(srcFile, destDir,true);
				}
			}
			message= "<script>";
			message += " alert('새 상품 추가 성공.');";
			message +=" location.href='"+multipartRequest.getContextPath()+"/admin/goods/addNewGoodsForm.do';";
			message +=("</script>");
		}catch(Exception e) {
			if(imageFileList!=null && imageFileList.size()!=0) {
				for(GoodsVO goodsVO:imageFileList) {
					String imageFileName = goodsVO.getGoods_fileName();
					File srcFile = new File(CURR_IMAGE_REPO_PATH+"\\temp\\"+imageFileName);
					srcFile.delete();
				}
			}
			message= "<script>";
			message += " alert('오류가 발생했습니다. 다시 시도해 주세요');";
			message +=" location.href='"+multipartRequest.getContextPath()+"/admin/goods/addNewGoodsForm.do';";
			message +=("</script>");
			e.printStackTrace();
		}
		resEntity =new ResponseEntity(message, responseHeaders, HttpStatus.OK);
		return resEntity;
	}
	
	
	@RequestMapping(value="/modifyGoodsForm.do" ,method={RequestMethod.GET,RequestMethod.POST})
	public ModelAndView modifyGoodsForm(@RequestParam("goods_isbn") String goods_isbn,
			                            HttpServletRequest request, HttpServletResponse response) throws Exception {
		String viewName=(String)request.getAttribute("viewName"); 
		ModelAndView mav = new ModelAndView(viewName);
		
		Map goodsMap=adminGoodsService.goodsDetail(goods_isbn);
		mav.addObject("goodsMap",goodsMap);
		
		return mav;
	}
	
	@Override
	@RequestMapping(value="/modifyGoodsInfo.do" ,method={RequestMethod.POST})
	public ResponseEntity modifyGoodsInfo(@RequestParam("goods_isbn") String goods_isbn,
										  @RequestParam("attribute") String attribute,
										  @RequestParam("value") String value,
										  HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		Map<String,String> goodsMap=new HashMap<String,String>();
		goodsMap.put("goods_isbn", goods_isbn); 
		goodsMap.put(attribute, value);
		
		adminGoodsService.modifyGoodsInfo(goodsMap);
		
		String message  = "mod_success";
		HttpHeaders responseHeaders = new HttpHeaders();
		ResponseEntity resEntity =new ResponseEntity(message, responseHeaders, HttpStatus.OK);
		return resEntity;
	}

	@Override
	@RequestMapping(value="/modifyGoodsImageInfo.do" ,method={RequestMethod.POST})
	public void modifyGoodsImageInfo(MultipartHttpServletRequest multipartRequest,
			 						HttpServletRequest request, HttpServletResponse response)  throws Exception {
		multipartRequest.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");

		Map goodsMap = new HashMap();
		Enumeration enu=multipartRequest.getParameterNames();
		while(enu.hasMoreElements()){
			String name=(String)enu.nextElement();
			String value=multipartRequest.getParameter(name);
			goodsMap.put(name,value);
		}
		
		HttpSession session = multipartRequest.getSession();
		MemberVO memberVO = (MemberVO) session.getAttribute("memberInfo");
		String reg_id = memberVO.getMember_id();
		
		List<GoodsVO> imageFileList=null;
		String goods_isbn = (String)goodsMap.get("goods_isbn");
		try {
			imageFileList =upload(multipartRequest, request);
			if(imageFileList!= null && imageFileList.size()!=0) {
				for(GoodsVO goodsVO : imageFileList) {
					goodsVO.setGoods_isbn(goods_isbn);
					// reg_id 필요시 goodsVO에 reg_id 관련 필드 추가
				}
				
			    adminGoodsService.modifyGoodsImage(imageFileList);
				for(GoodsVO goodsVO : imageFileList) {
					String imageFileName = goodsVO.getGoods_fileName();
					File srcFile = new File(CURR_IMAGE_REPO_PATH+"\\temp\\"+imageFileName);
					File destDir = new File(CURR_IMAGE_REPO_PATH+"\\"+goods_isbn);
					FileUtils.moveFileToDirectory(srcFile, destDir,true);
				}
			}
		}catch(Exception e) {
			if(imageFileList!=null && imageFileList.size()!=0) {
				for(GoodsVO goodsVO : imageFileList) {
					String imageFileName = goodsVO.getGoods_fileName();
					File srcFile = new File(CURR_IMAGE_REPO_PATH+"\\temp\\"+imageFileName);
					srcFile.delete();
				}
			}
			e.printStackTrace();
		}
	}
	

	@Override
	@RequestMapping(value="/addNewGoodsImage.do" ,method={RequestMethod.POST})
	public void addNewGoodsImage(MultipartHttpServletRequest multipartRequest, 
			 					HttpServletRequest request, HttpServletResponse response) throws Exception {
		multipartRequest.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");

		Map goodsMap = new HashMap();
		Enumeration enu=multipartRequest.getParameterNames();
		while(enu.hasMoreElements()){
			String name=(String)enu.nextElement();
			String value=multipartRequest.getParameter(name);
			goodsMap.put(name,value);
		}
		
		HttpSession session = multipartRequest.getSession();
		MemberVO memberVO = (MemberVO) session.getAttribute("memberInfo");
		String reg_id = memberVO.getMember_id();
		
		List<GoodsVO> imageFileList=null;
		String goods_isbn=(String)goodsMap.get("goods_isbn");
		try {
			imageFileList =upload(multipartRequest, request);
			if(imageFileList!= null && imageFileList.size()!=0) {
				for(GoodsVO goodsVO : imageFileList) {
					goodsVO.setGoods_isbn(goods_isbn);
					// reg_id 필요하다면 GoodsVO에 관련 필드 추가 후 set
				}
				
			    adminGoodsService.addNewGoodsImage(imageFileList);
				for(GoodsVO goodsVO : imageFileList) {
					String imageFileName = goodsVO.getGoods_fileName();
					File srcFile = new File(CURR_IMAGE_REPO_PATH+"\\temp\\"+imageFileName);
					File destDir = new File(CURR_IMAGE_REPO_PATH+"\\"+goods_isbn);
					FileUtils.moveFileToDirectory(srcFile, destDir,true);
				}
			}
		}catch(Exception e) {
			if(imageFileList!=null && imageFileList.size()!=0) {
				for(GoodsVO goodsVO : imageFileList) {
					String imageFileName = goodsVO.getGoods_fileName();
					File srcFile = new File(CURR_IMAGE_REPO_PATH+"\\temp\\"+imageFileName);
					srcFile.delete();
				}
			}
			e.printStackTrace();
		}
	}

	@Override
	@RequestMapping(value="/removeGoodsImage.do" ,method={RequestMethod.POST})
	public void removeGoodsImage(@RequestParam("goods_isbn") String goods_isbn,
			                     @RequestParam("imageFileName") String imageFileName,
			                     HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		adminGoodsService.removeGoodsImage(goods_isbn);
		try{
			File srcFile = new File(CURR_IMAGE_REPO_PATH+"\\"+goods_isbn+"\\"+imageFileName);
			srcFile.delete();
		}catch(Exception e) {
			e.printStackTrace();
		}
	}

}
