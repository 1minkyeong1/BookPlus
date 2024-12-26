package com.bookplus.API.service;

import com.bookplus.API.DAO.APIDAO;
import com.bookplus.API.vo.APIweatherVO;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.List;

@Service
public class APIServiceImpl implements APIService {

    @Autowired
    private APIDAO APIDAO;

    @Override
    public List<String> getRecommendBooks(String type, String dataType, int baseDate, int baseTime, int nx, int ny) {
        // 1. 날씨 데이터 가져오기
        APIweatherVO weather = getWeatherData(type, dataType, baseDate, baseTime, nx, ny);

        // 2. 날씨 데이터에서 태그 생성
        String goods_title = mapWeatherToTag(weather.getSKY(), weather.getPTY());
        System.out.println(goods_title);
        // 3. DAO를 통해 책 조회
        return APIDAO.getBooksByTag(goods_title);
    }

    private APIweatherVO getWeatherData(String type, String dataType, int baseDate, int baseTime, int nx, int ny) {
        String url = String.format(
    		"https://apihub.kma.go.kr/api/typ02/openApi/VilageFcstInfoService_2.0/%s?authKey=%s&numOfRows=%s&pageNo=%s&dataType=%s&base_date=%s&base_time=%s&nx=%d&ny=%d",
            type,
            "Ke2_jY0YQoetv42NGIKHDQ",
            "1000",
            "1",
            dataType,
            baseDate,
            baseTime,
            nx,
            ny
        );
        
        // 디버깅용 로그 추가
        System.out.println("Generated API URL: " + url);
        System.out.println("type: " + type);
        System.out.println("dataType: " + dataType);
        System.out.println("baseDate: " + baseDate);
        System.out.println("baseTime: " + baseTime);
        System.out.println("nx: " + nx);
        System.out.println("ny: " + ny);

        RestTemplate restTemplate = new RestTemplate();
        try {
            ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);

            if (response.getStatusCode().is2xxSuccessful()) {
                String responseBody = response.getBody();
                ObjectMapper objectMapper = new ObjectMapper();
                JsonNode rootNode = objectMapper.readTree(responseBody);

                JsonNode itemsNode = rootNode.path("response").path("body").path("items").path("item");

                int sky = 1; // 기본값: 맑음
                int pty = 0; // 기본값: 강수 없음

                for (JsonNode item : itemsNode) {
                    String category = item.path("category").asText();
                    int obsrValue = item.path("fcstValue").asInt();

                    if ("SKY".equals(category)) {
                        sky = obsrValue;
                    } else if ("PTY".equals(category)) {
                        pty = obsrValue;
                    }

                    // SKY와 PTY 값을 모두 찾으면 루프 종료
                    if (sky != 1 || pty != 0) {
                        break;
                    }
                }

                APIweatherVO weather = new APIweatherVO();
                weather.setBaseDate(baseDate);
                weather.setBaseTime(baseTime);
                weather.setNx(nx);
                weather.setNy(ny);
                weather.setCategory("Weather Summary");
                weather.setSKY(sky);
                weather.setPTY(pty);
                return weather;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 기본값 반환
        APIweatherVO defaultWeather = new APIweatherVO();
        defaultWeather.setCategory("Weather Summary");
        defaultWeather.setSKY(1); // 기본값: 맑음
        defaultWeather.setPTY(0); // 기본값: 강수 없음
        return defaultWeather;
    }

    private String mapWeatherToTag(int sky, int pty) {
        // 강수 형태 우선 고려
        switch (pty) {
            case 1: return "비";
            case 2: return "비/눈";
            case 3: return "눈";
            case 5: return "빗방울";
            case 6: return "빗방울/눈날림";
            case 7: return "눈날림";
        }

        // 강수 형태가 없을 경우 하늘 상태를 고려
        switch (sky) {
            case 1: return "맑음";
            case 3: return "구름 많음";
            case 4: return "흐림";
            default: return "맑음";
        }
    }
}
