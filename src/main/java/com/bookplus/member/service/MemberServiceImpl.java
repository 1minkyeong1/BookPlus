package com.bookplus.member.service;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import com.bookplus.member.dao.MemberDAO;
import com.bookplus.member.vo.MemberVO;
import com.google.gson.Gson;
import com.google.gson.JsonObject;


@Service("memberService")
@Transactional(propagation=Propagation.REQUIRED)
public class MemberServiceImpl implements MemberService {

	@Autowired
	private MemberDAO memberDAO;
	
	private static final Map<String, String> API_CONFIG = Map.of(
        "kakao_token_url", "https://kauth.kakao.com/oauth/token",
        "kakao_user_info_url", "https://kapi.kakao.com/v2/user/me",
        "kakao_client_id", "279e4cf54e1d0711b4748cd1ffb04c56",
        "kakao_redirect_uri", "http://localhost:8090/BookPlus/member/kakao/callback",
        "naver_token_url", "https://nid.naver.com/oauth2.0/token",
        "naver_user_info_url", "https://openapi.naver.com/v1/nid/me",
        "naver_client_id", "JyvgOzKzRCnvAIRqpVXo",
        "naver_client_secret", "I9xmN7Uqi3",
        "naver_redirect_uri", "http://localhost:8090/BookPlus/member/naver/callback"
	);
	
	//==========
	// 아이디, 패스워드를 사용하여 로그인을 진행하기 위해 DAO 호출
	@Override
	public MemberVO login(Map<String, String> loginMap) throws Exception{
		return memberDAO.login(loginMap);
	}
	
	//==========
	// 회원 가입을 진행하고, 성공시 로그인을 진행하기 위해 DAO 호출
	@Override
	public MemberVO addMember(MemberVO memberVO) throws Exception{
		memberDAO.insertNewMember(memberVO);
		// 회원 가입 후 로그인 처리
        Map<String, String> loginMap = new HashMap<>();
        loginMap.put("member_id", memberVO.getMember_id());
        loginMap.put("member_pw", memberVO.getMember_pw());

        return memberDAO.login(loginMap); // 로그인 처리
	}
	
	//==========
	//
	@Override
	public String overlapped(String id) throws Exception{
		return memberDAO.selectOverlappedID(id);
	}
	
	//==========
	// 기존 사용자에 대한 로그인을 처리하기 위해 handleKakaoLogin에서 호출되는 함수
	private void setupSession(HttpServletRequest request, MemberVO memberVO) {
	    HttpSession session = request.getSession();
	    session.setAttribute("isLogOn", true);
	    session.setAttribute("memberInfo", memberVO);
	}

	//==========
	// 플랫폼으로부터 반환된 인증 코드를 처리하여 Access Token을 요청하고 세션에 저장하는 역할
	@Override
    public String handleLogin(String platform, HttpServletRequest request) {
		
		// OAuth 인증 과정에서 플랫폼에서 반환된 인증 코드와 상태 값을 요청에서 가져옴
        String code = request.getParameter("code"); //사용자가 정상적으로 인증했음을 나타내는 고유 코드
        String state = request.getParameter("state"); //CSRF(교차 사이트 요청 위조)를 방지하기 위한 값

        // Access Token 요청에 필요한 파라미터를 Map으로 구성
        Map<String, String> params = new HashMap<>();
        params.put("grant_type", "authorization_code");
        params.put("code", code);
        params.put("state", state);
        params.put("client_id", API_CONFIG.get(platform + "_client_id"));
        
        // 네이버 API의 경우 추가적으로 클라이언트 Secret을 파라미터에 포함
        if ("naver".equals(platform)) {
            params.put("client_secret", API_CONFIG.get("naver_client_secret"));
        }
        params.put("redirect_uri", API_CONFIG.get(platform + "_redirect_uri"));

        // Access Token 요청 URL 설정 및 요청 수행
        String tokenUrl = API_CONFIG.get(platform + "_token_url");
        String accessToken = fetchAccessToken(tokenUrl, params);

        // Access Token을 세션에 저장하여 이후 사용자 정보 요청 시 활용
        request.getSession().setAttribute("accessToken", accessToken);
        return request.getContextPath() + "/member/" + platform + "/login";
    }

	//==========
	// Access Token을 사용하여 사용자 정보를 가져오고, 해당 정보를 처리하여 로그인 또는 회원가입 준비를 수행
    @Override
    public String processLogin(String platform, HttpServletRequest request) {
        String accessToken = (String) request.getSession().getAttribute("accessToken");
        if (accessToken == null) {
            throw new RuntimeException("Access Token이 존재하지 않습니다.");
        }

        String userInfoUrl = API_CONFIG.get(platform + "_user_info_url");
        Map<String, Object> userProfile = fetchUserInfo(userInfoUrl, accessToken, platform);
        System.out.println("siuuuuu" + userProfile);
        
        if (userProfile == null) {
            throw new RuntimeException(platform + " 사용자 정보 요청 실패");
        } else {
        	String id = null;
        	if(platform.equals("kakao")) {
        		id = userProfile.get("id").toString();
        	} else {
        		// userProfile에서 "response" 키의 값을 Map으로 가져오기
        		Map<String, Object> response = (Map<String, Object>) userProfile.get("response");

        		// response에서 "id" 키의 값을 안전하게 추출
        		id = response != null ? response.getOrDefault("id", "").toString() : "";

        	}
        	MemberVO memberVO = checkAPIUser(id, platform);
        	if (memberVO != null) {
                // 기존 사용자: 로그인 처리
                setupSession(request, memberVO);
                return "redirect:/main/main.do";
            } else {
		        Map<String, Object> responseMap = extractUserProfile(platform, userProfile);
		
		        prepareSignupRequest(responseMap, request);
		        
		        return "/member/memberForm";
            }
        }
    }

    //==========
    //Access Token을 요청하기 위해 호출되는 메소드(POST 요청)
    public String fetchAccessToken(String tokenUrl, Map<String, String> params) {

        RestTemplate restTemplate = new RestTemplate();// Spring의 HTTP 요청 클라이언트로, API 서버와의 통신을 담당
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        
        // params는 일반 Map<String, String> 형태의 요청 파라미터를 MultiValueMap 형식으로 변환.
        MultiValueMap<String, String> multiParams = new LinkedMultiValueMap<>();
        params.forEach(multiParams::add);

        HttpEntity<MultiValueMap<String, String>> requestEntity = new HttpEntity<>(multiParams, headers);
        try {
        	//응답 본문을 JSON 문자열로 가져와 Gson 라이브러리를 사용하여 JSON 객체로 파싱
            ResponseEntity<String> response = restTemplate.exchange(tokenUrl, HttpMethod.POST, requestEntity, String.class);
            
            JsonObject jsonResponse = new Gson().fromJson(response.getBody(), JsonObject.class);
            
            return jsonResponse.get("access_token").getAsString();// JSON 객체에서 access_token 키의 값을 추출하여 반환
        } catch (Exception e) {
            throw new RuntimeException("Access Token 요청 실패", e);
        }
    }

    //==========
    //
    public Map<String, Object> fetchUserInfo(String userInfoUrl, String accessToken, String platform) {
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + accessToken);

        HttpEntity<Void> requestEntity = new HttpEntity<>(headers);
        try {
        	ResponseEntity<String> response = restTemplate.exchange(userInfoUrl, HttpMethod.GET, requestEntity, String.class);
        	
            Map<String, Object> userProfile = new Gson().fromJson(response.getBody(), Map.class);
            System.out.println(userProfile);
            
            if("kakao".equals(platform)) {
            	// id 값을 Long으로 변환하여 다시 저장 (필요한 경우)
	                Double idDouble = (Double) userProfile.get("id");
	                userProfile.put("id", idDouble.longValue());
            }
            
            
            return userProfile;
            
        } catch (Exception e) {
            throw new RuntimeException("사용자 정보 요청 실패", e);
        }
    }

    private Map<String, Object> extractUserProfile(String platform, Map<String, Object> userProfile) {
    	if ("kakao".equals(platform)) {
            Map<String, Object> kakaoAccount = (Map<String, Object>) userProfile.get("kakao_account");
            System.out.println(kakaoAccount);
            return Map.of(
                "id", userProfile.get("id").toString(),
                "name", kakaoAccount.getOrDefault("name", "").toString(),
                "email", kakaoAccount.getOrDefault("email", "").toString(),
                "gender", kakaoAccount.getOrDefault("gender", "").toString(),
                "birthday", kakaoAccount.getOrDefault("birthday", "").toString(),
                "birthyear", kakaoAccount.getOrDefault("birthyear", "").toString(),
                "phoneNumber", kakaoAccount.getOrDefault("phone_number", "").toString(),
                "socialProvider", "kakao"
            );
        
        } else if ("naver".equals(platform)) {
            Map<String, Object> naverAccount = (Map<String, Object>) userProfile.get("response");
            System.out.println(naverAccount);
            return Map.of(
                "id", naverAccount.getOrDefault("id", "").toString(),
                "email", naverAccount.getOrDefault("email", "").toString(),
                "name", naverAccount.getOrDefault("name", "").toString(),
                "gender", naverAccount.getOrDefault("gender", "").toString(),
                "phoneNumber", naverAccount.getOrDefault("mobile", "").toString(),
                "birthday", naverAccount.getOrDefault("birthday", "").toString(),
                "birthyear", naverAccount.getOrDefault("birthyear", "").toString(),
                "socialProvider","naver"
            );
        }

        throw new RuntimeException("지원하지 않는 플랫폼: " + platform);
    }

    private void prepareSignupRequest(Map<String, Object> userProfile, HttpServletRequest request) {
    	String accountEmail = userProfile.get("email").toString();
        String email1 = "";
        String email2 = "";
        if (accountEmail != null && accountEmail.contains("@")) {
            String[] emailParts = accountEmail.split("@");
            email1 = emailParts[0];
            email2 = emailParts[1];
        }
        
        String phoneNumber = userProfile.get("phoneNumber").toString();
        if(phoneNumber.contains("+82 ")) { // 카카오
        	phoneNumber = phoneNumber.replace("+82 ", "0");
        } 
        String phone1 = "";
        String phone2 = "";
        String phone3 = "";
        if (phoneNumber != null && phoneNumber.contains("-")) {
            String[] phoneParts = phoneNumber.split("-");
            phone1 = phoneParts[0];
            phone2 = phoneParts[1];
            phone3 = phoneParts[2];
        }
        
        String accountGender = userProfile.get("gender").toString();
        if(accountGender == "F" ||  accountGender == "female") {
        	accountGender = "102";
        }else {
        	accountGender = "101";
        }
        
        String accountBirthDay = userProfile.get("birthday").toString();
        if(accountBirthDay.contains("-")) {
        	accountBirthDay = accountBirthDay.replace("-", "");
        }
        System.out.println(accountBirthDay);

        request.setAttribute("id", userProfile.get("id"));
        request.setAttribute("name", userProfile.get("name"));
        request.setAttribute("email1", email1);
        request.setAttribute("email2", email2);
        request.setAttribute("gender", accountGender);
        request.setAttribute("birthday", accountBirthDay);
        request.setAttribute("birthyear", userProfile.get("birthyear"));
        request.setAttribute("phone1", phone1);
        request.setAttribute("phone2", phone2);
        request.setAttribute("phone3", phone3);        
        request.setAttribute("socialProvider", userProfile.get("socialProvider"));
    }
	
	//==========
	// 카카오 API사용하여 로그인한 회원의 id 값을 사용하여 조회하기 위해 DAO 호출하는 함수
	@Override
	public MemberVO checkAPIUser(String apiId, String platform) {
	    // DAO 호출: ID로 사용자 존재 여부 확인
	    return memberDAO.selectAPIUser(apiId, platform);
	}
	
	
	@Override
	public String searchId(MemberVO memberVO) throws Exception{
		return memberDAO.selectMemID(memberVO);
	}
	
	@Override
	public MemberVO checkMemInfo(Map<String, String> checkMem) throws Exception {
		return memberDAO.checkMemInfo(checkMem);
	}

	@Override
	public int removeMember(String mem_id) throws Exception{
		return memberDAO.removeMember(mem_id);
	}

	@Override
	public int updatePass(String mem_id, String user_psw_confirm) throws Exception {
		return memberDAO.updatePass(mem_id,user_psw_confirm);	
	}
}
