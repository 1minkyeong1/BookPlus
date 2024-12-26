<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>simpleMap</title>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script src="https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=3yUCZPlQLSXrUVYnaBC07pB2LIkjQD43OUfAR85i"></script>
<script type="text/javascript">
    var map;
    var marker_s, marker_e;
    var totalMarkerArr = [];
    var drawInfoArr = [];
    var resultdrawArr = [];

    function initTmap() {
        // 1. 지도 띄우기
        map = new Tmapv2.Map("map_div", {
            center: new Tmapv2.LatLng(35.151564, 129.059674),
            width: "100%",
            height: "400px",
            zoom: 17,
            zoomControl: true,
            scrollwheel: true
        });

        // 2. 현위치를 받아와 경로 탐색
        navigator.geolocation.getCurrentPosition(
            function (position) {
                var userLat = position.coords.latitude; // 사용자 위도
                var userLng = position.coords.longitude; // 사용자 경도

                // 사용자 현위치 마커 추가
                marker_s = new Tmapv2.Marker({
                    position: new Tmapv2.LatLng(userLat, userLng), // 현재 위치
                    icon: "https://maps.google.com/mapfiles/ms/icons/green-dot.png",
                    iconSize: new Tmapv2.Size(24, 38),
                    map: map
                });

                // 도착지 좌표 (예: 고정값) 35.151564, 129.059674
                var destLat = 35.151564; // 도착지 위도
                var destLng = 129.059674; // 도착지 경도

                // 도착지 마커 추가
                marker_e = new Tmapv2.Marker({
                    position: new Tmapv2.LatLng(destLat, destLng),
                    icon: "https://maps.google.com/mapfiles/ms/icons/blue-dot.png",
                    iconSize: new Tmapv2.Size(24, 38),
                    map: map
                });

                // [수정된 부분] 지도 중심과 범위 설정
                var bounds = new Tmapv2.LatLngBounds(); // LatLngBounds 객체 생성
                bounds.extend(new Tmapv2.LatLng(userLat, userLng)); // 현위치 추가
                bounds.extend(new Tmapv2.LatLng(destLat, destLng)); // 도착지 추가
                map.fitBounds(bounds); // 지도를 두 좌표가 포함되도록 설정

                // 경로 탐색
                findRoute(userLat, userLng, destLat, destLng);
            },
            function (error) {
                console.error("현위치를 가져올 수 없습니다.", error);
                alert("현위치를 가져오는 데 실패했습니다. 위치 서비스를 활성화하세요.");
            }
        );
    }

    // 경로 탐색 함수
    function findRoute(startLat, startLng, endLat, endLng) {
        var headers = {
            appKey: "3yUCZPlQLSXrUVYnaBC07pB2LIkjQD43OUfAR85i"
        };

        // T-map 경로 탐색 API 호출
        $.ajax({
            method: "POST",
            headers: headers,
            url: "https://apis.openapi.sk.com/tmap/routes/pedestrian?version=1&format=json",
            data: {
                startX: startLng,
                startY: startLat,
                endX: endLng,
                endY: endLat,
                reqCoordType: "WGS84GEO",
                resCoordType: "EPSG3857",
                startName: "현위치",
                endName: "도착지"
            },
            success: function (response) {
                var resultData = response.features;

                //결과 출력
                var tDistance = "총 거리 : "
                    + ((resultData[0].properties.totalDistance) / 1000).toFixed(1) + "km,";
                var tTime = " 총 시간 : "
                    + ((resultData[0].properties.totalTime) / 60).toFixed(0) + "분";

                $("#result").text(tDistance + tTime);

                //기존 그려진 라인 & 마커가 있다면 초기화
                if (resultdrawArr.length > 0) {
                    for (var i in resultdrawArr) {
                        resultdrawArr[i].setMap(null);
                    }
                    resultdrawArr = [];
                }

                drawInfoArr = [];

                for (var i in resultData) { //for문 [S]
                    var geometry = resultData[i].geometry;

                    if (geometry.type === "LineString") {
                        for (var j in geometry.coordinates) {
                            var latlng = new Tmapv2.Point(geometry.coordinates[j][0], geometry.coordinates[j][1]);
                            var convertPoint = new Tmapv2.Projection.convertEPSG3857ToWGS84GEO(latlng);
                            var convertChange = new Tmapv2.LatLng(convertPoint._lat, convertPoint._lng);
                            drawInfoArr.push(convertChange);
                        }
                    }
                }
                drawLine(drawInfoArr);
            },
            error: function (request, status, error) {
                console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
            }
        });
    }

    function drawLine(arrPoint) {
        var polyline_ = new Tmapv2.Polyline({
            path: arrPoint,
            strokeColor: "#DD0000",
            strokeWeight: 6,
            map: map
        });
        resultdrawArr.push(polyline_);
    }
</script>
</head>
<body onload="initTmap();">

    <div id="map_wrap" class="map_wrap3">
        <div id="map_div"></div>
    </div>
    <p id="result"></p>
    <br />
</body>
</html>
