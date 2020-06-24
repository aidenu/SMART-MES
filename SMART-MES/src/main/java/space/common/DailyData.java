package space.common;

public class DailyData {
	
	private String eventTime;
	private String macAddress;
	private String redFlag;
	private String amberFlag;
	private String greenFlag;
	private String blueFlag;
	private String whiteFlag;
	private String buzzerFlag;
	private String wdtFlag;
	
	public DailyData(String eventTime, String macAddress, String redFlag, String amberFlag, String greenFlag, String blueFlag, String whiteFlag, String buzzerFlag, String wdtFlag) {
		this.eventTime = eventTime;
		this.macAddress = macAddress;
		this.redFlag = redFlag;
		this.amberFlag = amberFlag;
		this.greenFlag = greenFlag;
		this.blueFlag = blueFlag;
		this.whiteFlag = whiteFlag;
		this.buzzerFlag = buzzerFlag;
		this.wdtFlag = wdtFlag;
	}

	public String getEventTime() {
		return eventTime;
	}

	public void setEventTime(String eventTime) {
		this.eventTime = eventTime;
	}

	public String getMacAddress() {
		return macAddress;
	}

	public void setMacAddress(String macAddress) {
		this.macAddress = macAddress;
	}

	public String getRedFlag() {
		return redFlag;
	}

	public void setRedFlag(String redFlag) {
		this.redFlag = redFlag;
	}

	public String getAmberFlag() {
		return amberFlag;
	}

	public void setAmberFlag(String amberFlag) {
		this.amberFlag = amberFlag;
	}

	public String getGreenFlag() {
		return greenFlag;
	}

	public void setGreenFlag(String greenFlag) {
		this.greenFlag = greenFlag;
	}

	public String getBlueFlag() {
		return blueFlag;
	}

	public void setBlueFlag(String blueFlag) {
		this.blueFlag = blueFlag;
	}

	public String getWhiteFlag() {
		return whiteFlag;
	}

	public void setWhiteFlag(String whiteFlag) {
		this.whiteFlag = whiteFlag;
	}

	public String getBuzzerFlag() {
		return buzzerFlag;
	}

	public void setBuzzerFlag(String buzzerFlag) {
		this.buzzerFlag = buzzerFlag;
	}

	public String getWdtFlag() {
		return wdtFlag;
	}

	public void setWdtFlag(String wdtFlag) {
		this.wdtFlag = wdtFlag;
	}
	
	
}
