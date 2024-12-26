<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>오늘 날씨에 대한 추천 책</title>
<style>
    #weather-container {
        font-family: Arial, sans-serif;
        background-color: rgb(244, 245, 206); /* 기본 배경 (2번 색상) */
        color: rgb(41, 47, 52); /* 텍스트 색상 (3번 색상) */
        padding: 20px;
        margin: 0 auto;
        max-width: 600px;
        border: 1px solid rgb(200, 200, 200);
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }

    #weather-container h1 {
        color: rgb(41, 47, 52); /* 제목 색상 (3번 색상) */
        font-size: 1.8rem;
        margin-bottom: 20px;
        text-align: center;
    }

    #weather-container button {
        display: block;
        width: 100%;
        background-color: rgb(84, 84, 84); /* 버튼 색상 (1번 색상) */
        color: #fff;
        font-size: 1rem;
        padding: 10px 20px;
        margin: 0 auto;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }

    #weather-container button:hover {
        background-color: rgb(66, 66, 66); /* 버튼 호버 색상 (1번 색상 약간 어둡게) */
    }

    #weather-container #result-container {
        margin-top: 20px;
        padding: 10px;
        background-color: #fff;
        border: 1px solid rgb(200, 200, 200);
        border-radius: 5px;
        text-align: center;
        color: rgb(244, 67, 54); /* 경고 메시지 색상 (붉은색 유지) */
        font-weight: bold;
    }

    #weather-container #bookList {
        margin-top: 20px;
        padding: 10px;
        background-color: #fff;
        border: 1px solid rgb(200, 200, 200);
        border-radius: 5px;
    }

    #weather-container ul {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    #weather-container ul li {
        background-color: rgb(244, 245, 206); /* 리스트 배경 (2번 색상) */
        margin: 5px 0;
        padding: 10px;
        border-radius: 3px;
        border: 1px solid rgb(84, 84, 84); /* 리스트 경계 (1번 색상) */
        transition: background-color 0.3s ease;
    }

    #weather-container ul li:hover {
        background-color: rgb(226, 228, 192); /* 리스트 호버 배경 (2번 색상 약간 어둡게) */
        cursor: pointer;
    }
</style>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const resultContainer = document.getElementById("result-container");
        const bookListDiv = document.getElementById("bookList");

        // 현재 시간 정보 가져오기
        const now = new Date();
        const year = now.getFullYear();
        const month = String(now.getMonth() + 1).padStart(2, '0');
        const date = String(now.getDate()).padStart(2, '0');
        let hours = now.getHours();
        const minutes = now.getMinutes();

        // baseDate와 baseTime 생성
        let baseDate = parseInt(year + month + date); // 정수 값으로 생성
        let adjustedHours = hours;

        if (minutes <= 10) {
            adjustedHours -= 1;
            if (adjustedHours < 0) {
                const previousDate = new Date(now);
                previousDate.setDate(previousDate.getDate() - 1);
                const prevYear = previousDate.getFullYear();
                const prevMonth = String(previousDate.getMonth() + 1).padStart(2, '0');
                const prevDate = String(previousDate.getDate()).padStart(2, '0');
                baseDate = parseInt(prevYear + prevMonth + prevDate); // 정수 값으로 재계산
                adjustedHours = 23;
            }
        }

        const baseTime = parseInt(String(adjustedHours).padStart(2, '0') + "00"); // 정수 값으로 생성

        // JSON 요청 데이터
        const requestData = {
            type: "getUltraSrtFcst", // API 유형
            dataType: "JSON",
            baseDate: baseDate, // 정수 형태의 날짜
            baseTime: baseTime, // 정수 형태의 시간
            nx: 60, // X 좌표
            ny: 127 // Y 좌표
        };

        // AJAX 요청
        fetch("recommendBooks", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(requestData)
        })
        .then(function(response) {
            return response.json();
        })
        .then(function(data) {
        	resultContainer.innerHTML = ""; // 기존 내용을 초기화

            if (data.error) {
                resultContainer.innerHTML = "<p>" + data.error + "</p>";
            } else if (data.message) {
                resultContainer.innerHTML = "<p>" + data.message + "</p>";
            } else if (data.books) {
                let booksHtml = "";
                data.books.forEach(function(book) {
                    booksHtml += "<li>" + book + "</li>";
                });
                resultContainer.innerHTML = "<ul>" + booksHtml + "</ul>";
            }
        })
        .catch(function(error) {
            resultContainer.innerHTML = "<p>데이터 요청 중 문제가 발생했습니다. 잠시 후 다시 시도하세요.</p>";
        });
    });
</script>
</head>
<body>
	<div id="weather-container">
		<h1>오늘 날씨와 꼭 맞는 책 추천</h1>
		<div id="result-container" style="margin-top: 20px;"></div>
	</div>
</body>
</html>
