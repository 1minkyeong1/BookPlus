<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Simple Map</title>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script src="https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=3yUCZPlQLSXrUVYnaBC07pB2LIkjQD43OUfAR85i"></script>

<style>
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        background-color: #f4f4f9;
        height: 100vh;
    }

    #map_wrap {
        width: 80%;
        max-width: 800px;
        margin: 20px auto;
        border: 1px solid #ddd;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        border-radius: 8px;
        overflow: hidden;
        background-color: #fff;
    }

    #map_div {
        width: 100%;
        height: 400px;
    }

    input[type="text"] {
        width: calc(100% - 120px);
        max-width: 600px;
        padding: 10px;
        margin: 10px 5px;
        border: 1px solid #ccc;
        border-radius: 4px;
        box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.1);
    }

    button {
        padding: 10px 15px;
        border: none;
        border-radius: 4px;
        background-color: #4CAF50;
        color: #fff;
        font-size: 14px;
        cursor: pointer;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    button:hover {
        background-color: #45a049;
    }

    #selectedPlace {
        width: calc(100% - 40px);
        max-width: 600px;
        padding: 10px;
        margin: 10px auto;
        border: 1px solid #ddd;
        border-radius: 4px;
        background-color: #f9f9f9;
    }

    label {
        font-weight: bold;
        margin: 10px 0 5px;
        display: block;
    }
</style>

<script type="text/javascript">
    var map;
    var totalMarkerArr = [];

    // Tmap API 초기화 함수 - 현위치를 받아 지도에 표시
    function initTmap() {
        navigator.geolocation.getCurrentPosition(
            function (position) {
                var userLat = position.coords.latitude; // 현재 위도
                var userLng = position.coords.longitude; // 현재 경도

                // Tmap 지도 생성
                map = new Tmapv2.Map("map_div", {
                    center: new Tmapv2.LatLng(userLat, userLng),
                    width: "100%",
                    height: "400px",
                    zoom: 18,
                    zoomControl: true,
                    scrollwheel: true
                });

                // 현재 위치에 마커 추가
                var marker_s = new Tmapv2.Marker({
                    position: new Tmapv2.LatLng(userLat, userLng),
                    icon: "https://maps.google.com/mapfiles/ms/icons/green-dot.png",
                    iconSize: new Tmapv2.Size(24, 38),
                    map: map
                });

                // 지도 중심을 현재 위치로 설정
                map.setCenter(new Tmapv2.LatLng(userLat, userLng));

                // 검색 버튼에 현재 위치 데이터 저장
                $("#searchButton").data("lat", userLat);
                $("#searchButton").data("lng", userLng);
            },
            function (error) {
                console.error("위치를 가져올 수 없습니다", error);
                alert("위치를 가져오지 못했습니다. 위치 서비스를 활성화해주세요.");
            }
        );
    }

    // 카카오 API를 이용하여 주소 검색
    function searchAddress() {
        var query = $("#keyword").val(); // 검색 키워드
        var userLat = $("#searchButton").data("lat"); // 현재 위도
        var userLng = $("#searchButton").data("lng"); // 현재 경도

        if (!query) {
            alert("검색어를 입력하세요!");
            return;
        }

        if (!userLat || !userLng) {
            alert("위치를 가져오지 못했습니다. 위치 서비스를 확인하세요.");
            return;
        }

        $.ajax({
            method: "GET",
            url: "https://dapi.kakao.com/v2/local/search/keyword.json",
            headers: {
                Authorization: "KakaoAK c0560692570618117086f9a23465fb75" // REST API 키
            },
            data: {
                query: query,
                x: userLng, // 현위치 경도
                y: userLat, // 현위치 위도
                radius: 20000 // 검색 반경 (단위: 미터)
            },
            success: function (response) {
                // 검색 결과 필터링 및 데이터 저장
                var filteredResults = response.documents.map(function (item) {
                    return {
                        place_name: item.place_name, // 장소 이름
                        place_url: item.place_url, // 장소 URL
                        road_address_name: item.road_address_name, // 도로명 주소
                        x: item.x, // 경도
                        y: item.y // 위도
                    };
                });

                displaySearchResults(filteredResults); // 검색 결과 지도에 표시
            },
            error: function (error) {
                console.error("카카오 API 요청 실패", error);
                alert("주소 검색에 실패했습니다.");
            }
        });
    }

    // 검색 결과를 지도에 표시하는 함수
    function displaySearchResults(results) {
        // 기존 마커 제거
        totalMarkerArr.forEach(function (marker) {
            marker.setMap(null);
        });
        totalMarkerArr = [];

        results.forEach(function (result) {
            // 검색 결과 마커 추가
            var marker = new Tmapv2.Marker({
                position: new Tmapv2.LatLng(result.y, result.x), // 위도, 경도
                icon: "https://cdn-icons-png.flaticon.com/512/684/684908.png",
                iconSize: new Tmapv2.Size(24, 38),
                map: map
            });

            totalMarkerArr.push(marker);

            // 마커 클릭 시 장소 정보 표시 및 지도 중심 이동
            marker.addListener("click", function () {
                $("#selectedPlace").val(result.place_name + " (" + result.road_address_name + ")");
                selectedPlaceData = result;
                map.setCenter(new Tmapv2.LatLng(result.y, result.x));
            });
        });

        // 검색 결과가 없을 경우
        if (results.length === 0) {
            alert("검색 결과가 없습니다.");
        } else {
            // 첫 번째 검색 결과로 지도 중심 이동
            map.setCenter(new Tmapv2.LatLng(results[0].y, results[0].x));
        }
    }

    // 팝업 닫기 및 선택한 장소 정보 전달
    function closePopup() {
        if (selectedPlaceData && window.opener) {
            window.opener.document.getElementById("selectedPlaceInput").value =
                selectedPlaceData.place_name + " (" + selectedPlaceData.road_address_name + ")";
            window.opener.setPlaceData(
                selectedPlaceData.place_name,
                selectedPlaceData.road_address_name,
                selectedPlaceData.place_url,
                selectedPlaceData.x,
                selectedPlaceData.y
            );
        }
        window.close();
    }
</script>
</head>
<body onload="initTmap();">

    <div id="map_wrap" class="map_wrap3">
        <div id="map_div"></div>
    </div>

    <input type="text" id="keyword" placeholder="주소나 장소를 입력하세요">
    <button id="searchButton" onclick="searchAddress()">검색</button>

    <label for="selectedPlace">선택된 장소:</label>
    <input type="text" id="selectedPlace" readonly>

    <button onclick="closePopup()">확인 후 닫기</button>
</body>
</html>
