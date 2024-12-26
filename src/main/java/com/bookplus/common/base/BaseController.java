package com.bookplus.common.base;

import java.io.File;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.bookplus.goods.vo.GoodsVO;

public abstract class BaseController  {
	
	// 기존 ImageFileVO → GoodsVO 사용, 이미지명(goods_cover)만 저장
	protected List<GoodsVO> upload(MultipartHttpServletRequest multipartRequest, HttpServletRequest request) throws Exception {
	    String path = request.getSession().getServletContext().getRealPath("/resources/image/shopping/file_repo");
		List<GoodsVO> fileList = new ArrayList<GoodsVO>();
		Iterator<String> fileNames = multipartRequest.getFileNames();
		
		while(fileNames.hasNext()){
			GoodsVO goodsVO = new GoodsVO();  // ImageFileVO 대신 GoodsVO 사용
			String fileName = fileNames.next();
			
			MultipartFile mFile = multipartRequest.getFile(fileName);
			String originalFileName = mFile.getOriginalFilename();
			
			// GoodsVO에 이미지 파일명만 저장
			goodsVO.setGoods_fileName(originalFileName);
			fileList.add(goodsVO);
			
			File file = new File(path + "/" + fileName);
			if (mFile.getSize() != 0) { 
			    if (!file.exists()) {
			        if (file.getParentFile().mkdirs()) {
			            file.createNewFile();
			        }
			    }
			    // temp 폴더에 실제 파일 저장
			    mFile.transferTo(new File(path + "/" + "temp" + "/" + originalFileName));
			}
		}
		return fileList;
	}
	
	private void deleteFile(String fileName, HttpServletRequest request) {
	    String path = request.getSession().getServletContext().getRealPath("/resources/image/shopping/file_repo");
	    File file = new File(path + "/" + fileName);
		try{
			file.delete();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value="/*.do" ,method={RequestMethod.POST,RequestMethod.GET})
	protected  ModelAndView viewForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String viewName=(String)request.getAttribute("viewName");
		System.out.println("BaseController : viewForm메소드 내부에서 처리  : " +  viewName);
		ModelAndView mav = new ModelAndView(viewName);
		return mav;
	}
	
	
	protected String calcSearchPeriod(String fixedSearchPeriod){
		String beginDate=null;
		String endDate=null;
		String endYear=null;
		String endMonth=null;
		String endDay=null;
		String beginYear=null;
		String beginMonth=null;
		String beginDay=null;
		DecimalFormat df = new DecimalFormat("00");
		Calendar cal=Calendar.getInstance();
		
		endYear   = Integer.toString(cal.get(Calendar.YEAR));
		endMonth  = df.format(cal.get(Calendar.MONTH) + 1);
		endDay   = df.format(cal.get(Calendar.DATE));
		endDate = endYear +"-"+ endMonth +"-"+endDay;
		
		if(fixedSearchPeriod == null) {
			cal.add(cal.MONTH,-4);
		}else if(fixedSearchPeriod.equals("one_week")) {
			cal.add(Calendar.DAY_OF_YEAR, -7);
		}else if(fixedSearchPeriod.equals("two_week")) {
			cal.add(Calendar.DAY_OF_YEAR, -14);
		}else if(fixedSearchPeriod.equals("one_month")) {
			cal.add(cal.MONTH,-1);
		}else if(fixedSearchPeriod.equals("two_month")) {
			cal.add(cal.MONTH,-2);
		}else if(fixedSearchPeriod.equals("three_month")) {
			cal.add(cal.MONTH,-3);
		}else if(fixedSearchPeriod.equals("four_month")) {
			cal.add(cal.MONTH,-4);
		}
		
		beginYear   = Integer.toString(cal.get(Calendar.YEAR));
		beginMonth  = df.format(cal.get(Calendar.MONTH) + 1);
		beginDay   = df.format(cal.get(Calendar.DATE));
		beginDate = beginYear +"-"+ beginMonth +"-"+beginDay;
		
		return beginDate+","+endDate;
	}
}
