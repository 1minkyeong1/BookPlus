package com.bookplus.API.controller;

import com.bookplus.API.service.APIService;
import com.bookplus.API.vo.APIweatherVO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/API/weather")
public class APIController {

	@Autowired
	private APIService APIService;

	@RequestMapping("/weather")
	public String showWeatherInputPage() {
		return "weather/weather";
	}

	@RequestMapping("/recommendBooks")
	@ResponseBody
	public Map<String, Object> recommendBooks(@RequestBody APIweatherVO APIweatherVO, Model model) {
		// WeatherRequest는 요청 데이터를 매핑할 VO 클래스입니다.
		String type = APIweatherVO.getType();
		String dataType = APIweatherVO.getDataType();
		int baseDate = APIweatherVO.getBaseDate();
		int baseTime = APIweatherVO.getBaseTime();
		int nx = APIweatherVO.getNx();
		int ny = APIweatherVO.getNy();
		
		// 확인
		System.out.println(type);
		System.out.println(dataType);
		System.out.println(baseDate);
		System.out.println(baseTime);
		System.out.println(nx + ", " + ny);
		
		Map<String, Object> response = new HashMap<>();

	    try {
	        // 서비스에서 책 리스트 가져오기
	        List<String> recommendedBooks = APIService.getRecommendBooks(
	            APIweatherVO.getType(),
	            APIweatherVO.getDataType(),
	            APIweatherVO.getBaseDate(),
	            APIweatherVO.getBaseTime(),
	            APIweatherVO.getNx(),
	            APIweatherVO.getNy()
	        );

	        if (recommendedBooks.isEmpty()) {
	            response.put("message", "추천 책이 없습니다!");
	        } else {
	            response.put("books", recommendedBooks);
	        }
	    } catch (Exception e) {
	        response.put("error", "서버 처리 중 문제가 발생했습니다.");
	        e.printStackTrace();
	    }

	    return response;
	}
}
