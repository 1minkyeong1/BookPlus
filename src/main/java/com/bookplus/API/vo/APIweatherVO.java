package com.bookplus.API.vo;

import com.fasterxml.jackson.annotation.JsonProperty;

public class APIweatherVO {

	@JsonProperty("type")
    private String type; // 요청 조회 종류
	@JsonProperty("dataType")
    private String dataType; // 요청 정보 유형
	@JsonProperty("baseDate")
    private int baseDate; // 발표일자
	@JsonProperty("baseTime")
    private int baseTime; // 발표시각
    private String category; // 자료구분코드
    private String obsrValue; // 실황 값
    private int fcstDate; // 예보일자
    private int fcstTime; // 예보시각
    private int fcstValue; // 예보 값
    @JsonProperty("nx")
    private int nx; // 예보지점 X 좌표
    @JsonProperty("ny")
    private int ny; // 예보지점 Y 좌표
    private int numOfRows; // 한 페이지 결과 수
    private int pageNo; // 페이지 번호
    private int totalCount; // 데이터 총 개수
    private int resultCode; // 응답 메시지 코드
    private String resultMsg; // 응답 메시지 내용

    // 단기예보 필드
    private int POP; // 강수확률
    private int PTY; // 강수형태
    private int PCP; // 1시간 강수량
    private int REH; // 습도
    private int SNO; // 1시간 신적설
    private int SKY; // 하늘상태
    private int TMP; // 1시간 기온
    private int TMN; // 일 최저기온
    
    public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getDataType() {
		return dataType;
	}

	public void setDataType(String dataType) {
		this.dataType = dataType;
	}

	public int getBaseDate() {
		return baseDate;
	}

	public void setBaseDate(int baseDate) {
		this.baseDate = baseDate;
	}

	public int getBaseTime() {
		return baseTime;
	}

	public void setBaseTime(int baseTime) {
		this.baseTime = baseTime;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getObsrValue() {
		return obsrValue;
	}

	public void setObsrValue(String obsrValue) {
		this.obsrValue = obsrValue;
	}

	public int getFcstDate() {
		return fcstDate;
	}

	public void setFcstDate(int fcstDate) {
		this.fcstDate = fcstDate;
	}

	public int getFcstTime() {
		return fcstTime;
	}

	public void setFcstTime(int fcstTime) {
		this.fcstTime = fcstTime;
	}

	public int getFcstValue() {
		return fcstValue;
	}

	public void setFcstValue(int fcstValue) {
		this.fcstValue = fcstValue;
	}

	public int getNx() {
		return nx;
	}

	public void setNx(int nx) {
		this.nx = nx;
	}

	public int getNy() {
		return ny;
	}

	public void setNy(int ny) {
		this.ny = ny;
	}

	public int getNumOfRows() {
		return numOfRows;
	}

	public void setNumOfRows(int numOfRows) {
		this.numOfRows = numOfRows;
	}

	public int getPageNo() {
		return pageNo;
	}

	public void setPageNo(int pageNo) {
		this.pageNo = pageNo;
	}

	public int getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}

	public int getResultCode() {
		return resultCode;
	}

	public void setResultCode(int resultCode) {
		this.resultCode = resultCode;
	}

	public String getResultMsg() {
		return resultMsg;
	}

	public void setResultMsg(String resultMsg) {
		this.resultMsg = resultMsg;
	}

	private int TMX; // 일 최고기온
    private int UUU; // 풍속(동서성분)
    private int VVV; // 풍속(남북성분)
    private int WAV; // 파고
    private int VEC; // 풍향
    private int WSD; // 풍속

    // 초단기실황 필드
    private int T1H; // 기온
    private int RN1; // 1시간 강수량

    // 초단기예보 필드
    private int LGT; // 낙뢰

    // Getter and Setter Methods

    public int getPOP() {
        return POP;
    }

    public void setPOP(int POP) {
        this.POP = POP;
    }

    public int getPTY() {
        return PTY;
    }

    public void setPTY(int PTY) {
        this.PTY = PTY;
    }

    public int getPCP() {
        return PCP;
    }

    public void setPCP(int PCP) {
        this.PCP = PCP;
    }

    public int getREH() {
        return REH;
    }

    public void setREH(int REH) {
        this.REH = REH;
    }

    public int getSNO() {
        return SNO;
    }

    public void setSNO(int SNO) {
        this.SNO = SNO;
    }

    public int getSKY() {
        return SKY;
    }

    public void setSKY(int SKY) {
        this.SKY = SKY;
    }

    public int getTMP() {
        return TMP;
    }

    public void setTMP(int TMP) {
        this.TMP = TMP;
    }

    public int getTMN() {
        return TMN;
    }

    public void setTMN(int TMN) {
        this.TMN = TMN;
    }

    public int getTMX() {
        return TMX;
    }

    public void setTMX(int TMX) {
        this.TMX = TMX;
    }

    public int getUUU() {
        return UUU;
    }

    public void setUUU(int UUU) {
        this.UUU = UUU;
    }

    public int getVVV() {
        return VVV;
    }

    public void setVVV(int VVV) {
        this.VVV = VVV;
    }

    public int getWAV() {
        return WAV;
    }

    public void setWAV(int WAV) {
        this.WAV = WAV;
    }

    public int getVEC() {
        return VEC;
    }

    public void setVEC(int VEC) {
        this.VEC = VEC;
    }

    public int getWSD() {
        return WSD;
    }

    public void setWSD(int WSD) {
        this.WSD = WSD;
    }

    public int getT1H() {
        return T1H;
    }

    public void setT1H(int T1H) {
        this.T1H = T1H;
    }

    public int getRN1() {
        return RN1;
    }

    public void setRN1(int RN1) {
        this.RN1 = RN1;
    }

    public int getLGT() {
        return LGT;
    }

    public void setLGT(int LGT) {
        this.LGT = LGT;
    }

    @Override
    public String toString() {
        return "APIweatherVO{" +
                "type='" + type + '\'' +
                ", dataType='" + dataType + '\'' +
                ", baseDate=" + baseDate +
                ", baseTime=" + baseTime +
                ", category='" + category + '\'' +
                ", obsrValue='" + obsrValue + '\'' +
                ", fcstDate='" + fcstDate + '\'' +
                ", fcstTime='" + fcstTime + '\'' +
                ", fcstValue='" + fcstValue + '\'' +
                ", nx=" + nx +
                ", ny=" + ny +
                ", numOfRows=" + numOfRows +
                ", pageNo=" + pageNo +
                ", totalCount=" + totalCount +
                ", resultCode='" + resultCode + '\'' +
                ", resultMsg='" + resultMsg + '\'' +
                ", POP='" + POP + '\'' +
                ", PTY='" + PTY + '\'' +
                ", PCP='" + PCP + '\'' +
                ", REH='" + REH + '\'' +
                ", SNO='" + SNO + '\'' +
                ", SKY='" + SKY + '\'' +
                ", TMP='" + TMP + '\'' +
                ", TMN='" + TMN + '\'' +
                ", TMX='" + TMX + '\'' +
                ", UUU='" + UUU + '\'' +
                ", VVV='" + VVV + '\'' +
                ", WAV='" + WAV + '\'' +
                ", VEC='" + VEC + '\'' +
                ", WSD='" + WSD + '\'' +
                ", T1H='" + T1H + '\'' +
                ", RN1='" + RN1 + '\'' +
                ", LGT='" + LGT + '\'' +
                '}';
    }
}
