<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<!--카카오 도서 실시간 검색 api를 이용한 기능 추가   -->

	<div class="search" style="text-align: center; margin: 20px;">
		<h1
			style="font-size: 24px; color: #444; margin-bottom: 20px; border-bottom: 1px solid #ccc; padding-bottom: 10px;">
			도서 현황 <span style="color: #FF5733;">실시간 빠른 검색</span>
		</h1>
		<div
			style="display: flex; justify-content: center; align-items: center; gap: 10px; margin-top: 20px;">
			<input type="text" id="searchQuery" placeholder="실시간 도서정보 확인가능"
				style="width: 60%; padding: 10px; font-size: 16px; border: 2px solid #ccc; border-radius: 5px; box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);">

			<button id="searchButton"
				style="padding: 10px 20px; font-size: 16px; background-color: #FF5733; color: white; border: none; border-radius: 5px; cursor: pointer; box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);">
				검색</button>
		</div>
	</div>

	<p id="result"
		style="display: flex; flex-wrap: wrap; gap: 10px; justify-content: flex-start; padding: 10px;">
	</p>
	<!-- 페이징 네비게이션 영역 -->
	<div id="pagination" style="text-align: center; margin-top: 20px;"></div>

	<div style="text-align: center; margin-top: 20px;"></div>
	<script src="https://code.jquery.com/jquery-3.7.1.js"
		integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
		crossorigin="anonymous">
	</script>

	<script>
    var currentPage = 1; //카카오 도서 검색 api에서 받아온 데이터들 중에서 그 api의 데이터들의 1페이지부터 받아온다.
    var itemsPerPage = 8; //한 페이지에 표시할 데이터 수
    var totalData = []; //전체 검색 데이터를 저장

    //검색 버튼 클릭 이벤트
    $("#searchButton").on("click", function () {
        var query = $("#searchQuery").val(); //검색어를 입력하는 공간

        //검색어가 비어 있는지 확인하는 조건문을 넣어서 입력하게끔 설정
        if (!query) {
            alert("검색어를 입력해주세요.");
            return;
        }
		//AJAX를 이용해 해당 페이지에서 그 데이터들을 바로 보이게 하자
        $.ajax({
            method: "GET", //데이터 가져오기때문에 get방식
            url: "https://dapi.kakao.com/v3/search/book?target=title", //사용한 api주소
            data: { query: query, size: 50 }, // 한 번에 50개의 데이터 가져오기 -> 카카오 도서 api는 50개가 최대 
            headers: { Authorization: "KakaoAK 3ce47450eb78c196dbc94c071c4d5168" } //REST API의 키값
        })
        .done(function (msg) {
            totalData = msg.documents; //검색 결과 데이터를 전역 변수에 저장
            currentPage = 1; //현재 페이지 초기화를 한다
            $("#result").empty(); //기존 결과 초기화를 한다
            if (totalData.length === 0) {
                //검색 결과가 없을 때 메시지 표시
                $("#result").html("<div style='text-align:center; font-size:16px; color:gray;'>검색결과가 없습니다.</div>");
                $("#pagination").empty(); //페이징도 제거
                return; //종료
            }
            renderPage(); //첫 페이지 데이터 렌더링
            renderPagination(); //페이지 번호 렌더링
        })
        .fail(function () {
            alert("API 요청 중 오류가 발생했습니다.");
        });
    });

    //페이지 번호 클릭 이벤트
    $(document).on("click", ".page-link", function () {
        currentPage = $(this).data("page"); // 클릭한 페이지 번호 가져오기
        renderPage(); //해당 페이지 데이터 렌더링
        renderPagination(); //페이지 번호 강조 업데이트
    });

    //현재 페이지 데이터를 렌더링
    function renderPage() {
        var start = (currentPage - 1) * itemsPerPage; //시작 인덱스 계산
        var end = Math.min(start + itemsPerPage, totalData.length); //끝 인덱스 계산

        $("#result").empty(); // 기존 데이터 초기화 진행
        for (var i = start; i < end; i++) { //반복문을 이용해 데이터들을 모두 불러온다.
            var book = totalData[i];
            var card = $("<div></div>").css({
                "width": "20%",
                "box-shadow": "0px 4px 6px rgba(0,0,0,0.1)",
                "border-radius": "8px",
                "padding": "10px",
                "text-align": "center",
                "background-color": "#fff",
              	"cursor": "pointer", //해당 div영역에 커서를 올리면 상호작용이 가능하다는것을 알리기위해 삽입
                "position": "relative",
                "margin-bottom": "20px"
            });

           //책의 제목 
            card.append("<strong style='font-size:14px;'>" + book.title + "</strong><br>"); 
           
           //책의 썸네일 
            if (book.thumbnail) {
                card.append("<img src='" + book.thumbnail + "' alt='책 표지' style='width:100px; margin-top: 10px; margin-bottom: 10px;'><br>");
            } else { //없다면 회색정사각형안에 이미지없음 이라는 텍스트가 나오게 설정
                card.append("<span style='display:block; width:100px; height:100px; margin-top:10px; background-color:#f0f0f0; line-height:100px; text-align:center; border:1px solid #ddd;'>이미지 없음</span><br>");
            }
            
         	//책의 저자
            card.append("<span style='font-size:12px; color:gray;'>저자: " + (book.authors && book.authors.length > 0 ? book.authors : "정보 없음") + "</span><br>");

            //책의 번역 -> 있다면 데이터를 불러들이고 null값이라면 다음 데이터들을 불러들인다.
            if (book.translators && book.translators.length > 0) {
                card.append("<span style='font-size:12px; color:gray;'>번역: " + book.translators + "</span><br>");
            }
            
            //책의 출판사
			card.append("<span style='font-size:12px; color:gray;'>출판사: " + (book.publisher || "정보 없음") + "</span><br>");

        	//책의 출판날짜에서 날짜만 추출
            const formattedDate = book.datetime.split("T")[0]; 
            card.append("<span style='font-size:12px; color:gray;'>출판날짜: " + formattedDate + "</span><br>");
            
            //책의 정상판매가
            card.append("<span style='font-size:12px; color:gray;'>정상판매가: " + book.price + "원</span><br>");
           
            //책의 할인가
            if (book.sale_price === -1) { //만약 할인값이 없다는 뜻인 -1을 불러들이게 된다면 해당 책의 정상판매가를 표기하도록 설정
                card.append("<span style='font-size:12px; color:gray;'>할인판매가: "+ book.price + "원</span><br>");
            } else {
                card.append("<span style='font-size:12px; color:gray;'>할인판매가: " + book.sale_price + "원</span><br>");
            }
            
         	//판매 여부 표시
            if (book.status) { //정상판매,품절,절판 등
                card.append("<span style='font-size:12px; color:gray;'>판매여부: " + book.status + "</span><br>");
            } else {
                card.append("<span style='font-size:12px; color:gray;'>판매여부: 미정</span><br>");
            }
         	
            //숨겨진 컨텐츠 영역 추가
            var contentDiv = $("<div></div>").css({
                "display": "none",
                "margin-top": "10px",
                "font-size": "12px",
                "color": "#333",
                "border-top": "1px solid #ccc",
                "padding-top": "10px"
            }).text(book.contents || "책 소개가 없습니다."); //만약 contents가 있다면 그 데이터들을 가져오고 없다면 "책 소개가 없습니다."

            //토글 아이콘 추가
            var toggleIcon = $("<span class='toggle-icon' style='font-size: 12px; cursor: pointer;'>[상세보기]</span>");
            card.append(toggleIcon); //생성한 toggleIcon을 책 정보 카드(card)에 추가
            card.append(contentDiv); //기본적으로 숨겨져 있으며, "상세보기" 버튼을 클릭할 때 표시/숨김 상태가 전환

            card.on("click", function () {
                var contentElement = $(this).find("div"); //숨겨진 콘텐츠 영역 선택
                var iconElement = $(this).find(".toggle-icon");
                if (contentElement.css("display") === "none") {
                    contentElement.slideDown(); //컨텐츠 표시
                    iconElement.text("[접기]"); //아이콘 변경
                } else {
                    contentElement.slideUp(); //컨텐츠 숨김
                    iconElement.text("[상세보기]"); //아이콘 변경
                }
            });

            $("#result").append(card); //카드 추가
        }
    }

 //페이지 네비게이션 렌더링 코드
    function renderPagination() {
        var totalPages = Math.ceil(totalData.length / itemsPerPage); //전체 페이지 수 계산 또한 올림(Math.ceil)을 사용하여 마지막 페이지를 포함함
        var paginationHtml = ""; //페이지 네비게이션에 표시될 HTML 문자열을 동적으로 생성하기 위해 초기화된 변수

        //"이전" 버튼 추가
        if (currentPage > 1) {
            paginationHtml += "<button class='page-link prev' style='margin: 0 5px; cursor: pointer;' data-page='" + (currentPage - 1) + "'>이전</button>";
        } else {
            paginationHtml += "<button class='page-link prev' style='margin: 0 5px; color: gray;' disabled>이전</button>";
        }

        //페이지 번호 추가
        for (var i = 1; i <= totalPages; i++) {
            if (i === currentPage) {
                paginationHtml += "<button class='page-link' style='margin: 0 5px; font-weight: bold; color: red;' data-page='" + i + "'>" + i + "</button>";
            } else {
                paginationHtml += "<button class='page-link' style='margin: 0 5px; cursor: pointer;' data-page='" + i + "'>" + i + "</button>";
            }
        }

        //"다음" 버튼 추가
        if (currentPage < totalPages) {
            paginationHtml += "<button class='page-link next' style='margin: 0 5px; cursor: pointer;' data-page='" + (currentPage + 1) + "'>다음</button>";
        } else {
            paginationHtml += "<button class='page-link next' style='margin: 0 5px; color: gray;' disabled>다음</button>";
        }

        $("#pagination").html(paginationHtml); //페이지 번호 및 버튼 추가
    }

    //페이지 번호 및 "이전/다음" 버튼 클릭 이벤트
    $(document).on("click", ".page-link", function () {
    	
    	var newPage = $(this).data("page"); //클릭한 버튼의 페이지 번호 가져오기
        if (newPage && newPage >= 1 && newPage <= Math.ceil(totalData.length / itemsPerPage)) {
            currentPage = newPage; //현재 페이지 업데이트
            renderPage(); //해당 페이지 데이터 렌더링
            renderPagination(); //페이지 번호 및 버튼 강조 업데이트
        }
    });


</script>
</body>
</html>