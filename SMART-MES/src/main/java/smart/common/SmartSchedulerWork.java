package smart.common;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.RandomAccessFile;
import java.io.StringWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.commons.collections.comparators.ComparatorChain;
import org.apache.log4j.Logger;
import org.springframework.scheduling.annotation.Scheduled;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import egovframework.rte.fdl.property.EgovPropertyService;


public class SmartSchedulerWork 
{
	
	Logger logger = Logger.getLogger("egovframework");
	
	@Resource(name="smartCommonDAO")
	private SmartCommonDAOImpl SmartCommonDAO;
	
	@Resource(name="smartGcmSender")
	private SmartGcmSender SmartGcmSender;
	
	@Resource(name = "propertiesService")
    protected EgovPropertyService propertyService;
    
	
	/**
	 * cron gap : 10min
	 * 내용 : 설비 상태가 중지 or error 상태가 지속될 경우에 alarm 데이터 insert를 하고 mobile push 실행
	 */
//	@Scheduled(cron="0 */10 * * * *")
	public void EqpErrorCheck()
	{
		RandomAccessFile csvfile = null;
    	File file = null;
		try {
			HashMap<String,String> hp = new HashMap<String,String>();
			
			String fileLocate = "";
			List<HashMap> resultLocate = SmartCommonDAO.nosessioncommonDataProc("getEqpLogLocate");
			if(resultLocate != null && resultLocate.size() > 0)
			{
				fileLocate = resultLocate.get(0).get("FILE_LOCATE").toString();
			}
			List<HashMap> result = SmartCommonDAO.nosessioncommonDataProc("getEqpStatus");
			if(result != null && result.size() > 0)
			{
				for(int i=0; i<result.size(); i++)
				{
					boolean completeflag = false;
					String macaddress = "";
					String eqpname = "";
					String eqppart = "";
					String username = "";
					
					if(result.get(i).get("EQP_NAME") != null)
						eqpname = result.get(i).get("EQP_NAME").toString();
					if(result.get(i).get("EQP_PART") != null)
						eqppart = result.get(i).get("EQP_PART").toString();
					if(result.get(i).get("USER_ID") != null)
						username = result.get(i).get("USER_ID").toString();
					if(result.get(i).get("MACADDRESS") != null)
						macaddress = result.get(i).get("MACADDRESS").toString();
					
					File dir = new File(fileLocate);
		    		File[] fileList = dir.listFiles();
		    		for(int j=(fileList.length-1); j>-1; j--)
		    		{
		    			file = fileList[j];
			    		if(file.isFile() && file.toString().indexOf(".csv")>-1)
			    		{
			    			//파일의 뒤에서부터 읽기 위해 RandomAccessFile 사용
							csvfile = new RandomAccessFile(file,"r");
							long fileLength = csvfile.length();	//파일 총 문자 수
							long pos = fileLength-1;	//제일 마지막 line
							String line = "";
							String eventTime = "";
							String Appkey = "";
							String PushMsg = "";
							String gcmresult = "";
							
							String[] temp = null;
							while(true)
							{
								//파일의 지정된 위치로 이동 (최초에는 제일 마지막 line)
								csvfile.seek(pos);
								//RandomAccessFile은 문자 하나씩 체크를 하므로 줄넘김이 나오면 해당 라인 확인 
								if(csvfile.readByte() == '\n' && csvfile.readLine() != null)
								{
									
									csvfile.seek(pos+1);
									line = csvfile.readLine();
									temp = line.split(",");
									eventTime = temp[0];
									if(macaddress.equals(temp[1]))
									{
										//WDTMonitoring
										if("0".equals(temp[9]))
										{
											logger.error("=============== Stop Equipment : [" +  eventTime + "] " + eqpname + " ==================");
											//알림 method
											//동일한 이벤트 알림 내역이 있는지 확인한다.
											//알림 내역 유/무 FLAG:ALREADY/NOT
											hp = new HashMap<String,String>();
											hp.put("eventtime", eventTime);
											hp.put("eqpname", eqpname);
											List<HashMap> resultevent = SmartCommonDAO.nosessioncommonDataProc("getEventHist", hp);
											
											if(resultevent != null && resultevent.size()>0)
											{
												if("NOT".equals(resultevent.get(0).get("FLAG").toString()))
												{
													PushMsg = "[" + eventTime + "]" + eqpname + " 장비의 전원이 꺼졌습니다.";
													
													//알림 보내기
													hp = new HashMap<String,String>();
													hp.put("eventtime", eventTime);
													hp.put("eqpname", eqpname);
													hp.put("userid", username);
													hp.put("gubun", "설비");
													hp.put("alarmmsg", PushMsg);
													List<HashMap> resultAlarm = SmartCommonDAO.nosessioncommonDataProc("setEqpStatusAlarm",hp);
													
													//모바일 PUSH method
													/*
													hp = new HashMap<String,String>();
													hp.put("userid", username);
													List<HashMap> resultAppkey = SmartCommonDAO.nosessioncommonDataProc("getMobileAppkeyUser",hp);
													if(resultAppkey != null && resultAppkey.size()>0)
													{
														Appkey = resultAppkey.get(0).get("APPKEY").toString();
														gcmresult = SmartGcmSender.gcmSender(Appkey, PushMsg, 1);
													}
													*/
												}
											}
										}
										
										if(!"0".equals(temp[3]))
										{
											logger.error("=============== Error Equipment : [" +  eventTime + "] " + eqpname + " ==================");
											//RED
											//알림 method
											hp = new HashMap<String,String>();
											hp.put("eventtime", eventTime);
											hp.put("eqpname", eqpname);
											List<HashMap> resultevent = SmartCommonDAO.nosessioncommonDataProc("getEventHist", hp);
											
											if(resultevent != null && resultevent.size()>0)
											{
												if("NOT".equals(resultevent.get(0).get("FLAG").toString()))
												{
													PushMsg = "[" + eventTime + "]" + eqpname + " 장비의 오류가 발생하였습니다.";
													
													//알림 보내기
													hp = new HashMap<String,String>();
													hp.put("eventtime", eventTime);
													hp.put("eqpname", eqpname);
													hp.put("userid", username);
													hp.put("gubun", "설비");
													hp.put("alarmmsg", PushMsg);
													List<HashMap> resultAlarm = SmartCommonDAO.nosessioncommonDataProc("setEqpStatusAlarm",hp);
													
													//모바일 PUSH method
													/*
													hp = new HashMap<String,String>();
													hp.put("userid", username);
													List<HashMap> resultAppkey = SmartCommonDAO.nosessioncommonDataProc("getMobileAppkeyUser",hp);
													System.out.println(resultAppkey);
													if(resultAppkey != null && resultAppkey.size()>0)
													{
														for(int k=0 ; k<resultAppkey.size() ; k++)
														{
															Appkey = resultAppkey.get(0).get("APPKEY").toString();
															gcmresult = SmartGcmSender.gcmSender(Appkey, PushMsg, 1);
														}
													}
													*/
												}
											}
										}
										completeflag = true;
										break;
									}
								}
								if(pos == 0)
									break;
								pos--;
							}	//while 종료
							if(completeflag)
								break;
			    		}	//isFile if 종료
		    		}	//file for 종료
		    		if(csvfile != null)
						csvfile.close();
				}	//for 종료
			}
			
			
		} catch(Exception e) {
			logger.error("[/scheduler/EqpErrorCheck] Exception :: " + e.toString());
			logger.error("[/scheduler/EqpErrorCheck] Exception :: " + getPrintStackTrace(e));
			try {
				if(csvfile != null) {
					csvfile.close();
				}
			} catch(Exception e2) {
				logger.error("[/scheduler/EqpErrorCheck.do] Exception2 :: " + e2.toString());
			}
		} finally {
			try {
				if(csvfile != null) {
					csvfile.close();
				}
			} catch(Exception e) {
				logger.error("[/scheduler/EqpErrorCheck.do] Exception3 :: " + e.toString());
			}
		}
	}
    
//	@Scheduled(cron="0 0 1 * * ?")//매일 새벽 1시에 실행
	public void DailyDataInsert()
	{
		//전날 데이터 DB에 수집
		BufferedReader br = null;
		InputStreamReader isr = null;
		FileInputStream fis = null;
		try 
		{
			String fileLocate = "";
			String yesterday = "";
			String yesterdayData = "";
			String fileName = "";
			String temp = "";
			String[] arrData = null;
			
			String eventDate = "";
			String macAddr = "";
			String redFlag = "";
			String amberFlag = "";
			String greenFlag = "";
			String blueFlag = "";
			String whiteFlag = "";
			String buzzerFlag = "";
			String wdtFlag = "";
			
			HashMap<String,String> hp = new HashMap<String,String>();
			
			//어제 날짜 구하기
			Calendar calendar = new GregorianCalendar();
			calendar.add(Calendar.DATE, -1);
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy_MM_dd");
			SimpleDateFormat sdfData = new SimpleDateFormat("yyyy-MM-dd");
			yesterday = sdf.format(calendar.getTime());
			yesterdayData = sdfData.format(calendar.getTime());
			
			logger.debug("================   /scheduler/DailyDataInsert] DailyData DB Insert Start :: " + yesterday + " ===============================");
			
			//기준정보관리에서 파일경로 가져오기
			List<HashMap> resultLocate = SmartCommonDAO.nosessioncommonDataProc("getEqpLogLocate");
			
			if(resultLocate != null && resultLocate.size() > 0) 
			{
				fileLocate = resultLocate.get(0).get("FILE_LOCATE").toString();
			}
			
			//파일명 셋팅
			fileName = "patlog_auto"+yesterday+".csv";
			
			File file = new File(fileLocate+"\\"+fileName);
			
			fis= new FileInputStream(file);
			isr = new InputStreamReader(fis);
			br = new BufferedReader(isr);
			
			while( (temp = br.readLine()) != null) 
			{
				if(temp.indexOf("DataTime") == -1) 
				{
					arrData = temp.split(",");
					//파일에 전날 이전 파일의 마지막 로그가 찍히는 경우가 있어 당일 데이터만 Valid
					logger.debug("arrData[0] : " + arrData[0]);
					if(arrData[0].indexOf(yesterdayData) > -1)
					{
						if(arrData[0].indexOf(":") == 12)
						{
							eventDate = arrData[0].substring(0, 11) + "0" + arrData[0].substring(arrData[0].indexOf(":")-1);
						}
						else
						{
							eventDate = arrData[0];
						}
						
						macAddr = arrData[1];
						redFlag = arrData[3];
						amberFlag = arrData[4];
						greenFlag = arrData[5];
						blueFlag = arrData[6];
						whiteFlag = arrData[7];
						buzzerFlag = arrData[8];
						wdtFlag = arrData[9];
						
						hp = new HashMap<String,String>();
						hp.put("event_date", eventDate);
						hp.put("mac_addr", macAddr);
						hp.put("red_flag", redFlag);
						hp.put("amber_flag", amberFlag);
						hp.put("green_flag", greenFlag);
						hp.put("blue_flag", blueFlag);
						hp.put("white_flag", whiteFlag);
						hp.put("buzzer_flag", buzzerFlag);
						hp.put("wdt_flag", wdtFlag);
						
						List<HashMap> resultInsert = SmartCommonDAO.nosessioncommonDataProc("setEqpDailyData", hp);
						
						if(resultInsert == null || resultInsert.size() <= 0) 
						{
							logger.error("[/scheduler/DailyDataInsert] DailyData DB Insert Fail :: " + resultInsert.get(0).get("ACTION_RESULT"));
							return;
						}
					}
				}
			}
			
			if(br != null)	br.close();
			if(isr != null)	isr.close();
			if(fis != null)	fis.close();
		} 
		catch (Exception e) 
		{
			logger.error("[/scheduler/DailyDataInsert] Exception1 :: " + e.toString());
			logger.error("[/scheduler/DailyDataInsert] Exception1 :: " + getPrintStackTrace(e));
			
			try
			{
				if(br != null)	br.close();
				if(isr != null)	isr.close();
				if(fis != null)	fis.close();
			}
			catch(Exception ee)
			{
				logger.error("[/scheduler/DailyDataInsert] Exception2 :: " + ee.toString());
				logger.error("[/scheduler/DailyDataInsert] Exception2 :: " + getPrintStackTrace(ee));
			}
		} 
		finally 
		{
			try
			{
				if(br != null)	br.close();
				if(isr != null)	isr.close();
				if(fis != null)	fis.close();
			}
			catch(Exception e)
			{
				logger.error("[/scheduler/DailyDataInsert] Exception3 :: " + e.toString());
				logger.error("[/scheduler/DailyDataInsert] Exception3 :: " + getPrintStackTrace(e));
			}
		}
		
		logger.debug("================   /scheduler/DailyDataInsert] DailyData DB Insert End  ===============================");
		
	}
	
	
	
//	@Scheduled(cron="0 45 1 * * ?")//매일 새벽 1시 45분에 실행
	public void DailyDataSummary()
	{
		BufferedReader br = null;
		InputStreamReader isr = null;
		FileInputStream fis = null;
		List<DailyData> dailyData = new ArrayList<DailyData>();
		
		try
		{
			String fileLocate = "";
			String yesterday = "";
			String yesterdayData = "";
			String fileName = "";
			String temp = "";
			String[] arrData = null;
			
			String eventDate = "";
			String macAddr = "";
			String redFlag = "";
			String amberFlag = "";
			String greenFlag = "";
			String blueFlag = "";
			String whiteFlag = "";
			String buzzerFlag = "";
			String wdtFlag = "";
			
			HashMap<String,String> hp = new HashMap<String,String>();
			
			//어제 날짜 구하기
			Calendar calendar = new GregorianCalendar();
			calendar.add(Calendar.DATE, -1);
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy_MM_dd");
			SimpleDateFormat sdfData = new SimpleDateFormat("yyyy-MM-dd");
			yesterday = sdf.format(calendar.getTime());	//yyyy_MM_dd 타입(파일명에 쓰임)
			yesterdayData = sdfData.format(calendar.getTime()); //yyyy-MM-dd 타입(파일 내용중 일자 valid에 쓰임)
			
			logger.debug("================   /scheduler/DailyDataSummary] DailyDataSummary DB Insert Start :: " + yesterday + " ===============================");
			
			//기준정보관리에서 파일경로 가져오기
			List<HashMap> resultLocate = SmartCommonDAO.nosessioncommonDataProc("getEqpLogLocate");
			
			if(resultLocate != null && resultLocate.size() > 0)
			{
				fileLocate = resultLocate.get(0).get("FILE_LOCATE").toString();
			}
			//System.out.println("fileLocate::"+fileLocate);
			
			//파일명 셋팅
			fileName = "patlog_auto"+yesterday+".csv";
			File file = new File(fileLocate+"\\"+fileName);

			
			//정렬을 위해 파일을 읽어 List에 담기
			fis= new FileInputStream(file);
			isr = new InputStreamReader(fis);
			br = new BufferedReader(isr);
			
			
			while( (temp = br.readLine()) != null) 
			{
				if(temp.indexOf("Date/Time") == -1) 
				{
					arrData = temp.split(",");
					//파일에 전날 이전 파일의 마지막 로그가 찍히는 경우가 있어 당일 데이터만 Valid
					if(arrData[0].indexOf(yesterdayData) > -1)
					{
						//ex) yyyy-MM-dd 1:23:45 -> yyyy-MM-dd 01:23:45 변경
						if(arrData[0].indexOf(":") == 12)
						{
							eventDate = arrData[0].substring(0, 11) + "0" + arrData[0].substring(arrData[0].indexOf(":")-1);
						}
						else
						{	
							eventDate = arrData[0];
						}
						
						macAddr = arrData[1];
						redFlag = arrData[3];
						amberFlag = arrData[4];
						greenFlag = arrData[5];
						blueFlag = arrData[6];
						whiteFlag = arrData[7];
						buzzerFlag = arrData[8];
						wdtFlag = arrData[9];
//						System.out.println(eventDate + ", " + macAddr + ", " + redFlag + ", " + amberFlag + ", " + greenFlag + ", " + blueFlag + ", " + whiteFlag + ", " + buzzerFlag + ", " + wdtFlag);
						dailyData.add(new DailyData(eventDate, macAddr, redFlag, amberFlag, greenFlag, blueFlag, whiteFlag, buzzerFlag, wdtFlag));
					}
				}
			}
			
			
			
			//MacAddress, EventTime 으로 sorting
			ComparatorChain chain = new ComparatorChain();
			chain.addComparator(comparatorMacAddress);
			chain.addComparator(comparatorEventTime);
			Collections.sort(dailyData, chain);
			
			
			//기준정보관리에 등록된 설비의 MacAddress 가져오기
			List<HashMap> resultEqp = SmartCommonDAO.nosessioncommonDataProc("getEqpList");
			
			//기준정보관리에서 RUNNING 상태 기준 가져오기
			hp = new HashMap<String,String>();
			hp.put("active_flag", "RUNNING");
			List<HashMap> resultRunningFlag = SmartCommonDAO.nosessioncommonDataProc("getEqpRunningFlag", hp);
			
			//기준정보관리에서 ERROR 상태 기준 가져오기
			hp = new HashMap<String,String>();
			hp.put("active_flag", "ERROR");
			List<HashMap> resultErrorFlag = SmartCommonDAO.nosessioncommonDataProc("getEqpRunningFlag", hp);
			
			
			//기준정보관리에 등록된 설비 MacAddress 별로 데이터 수집
			//기준정보관리에 등록한 설비만 데이터를 수집한다.
			for(int i=0; i<resultEqp.size(); i++) 
			{
				String tempMacAddr = "";
				//해당 설비에 UserName 만 등록되어있는 경우 macAddress는 null로 표기되어 오류날 수 있음.
				if(resultEqp.get(i).get("MACADDRESS") == null)
					break;
				else
					tempMacAddr = resultEqp.get(i).get("MACADDRESS").toString();
				
				long runningTime = 0;	//누적되는 running time
				boolean runningFlag = false;	//running 상태 flag
				boolean errorFlag = false;		//error 상태 flag
				String lastErrorTime = "";		//최종 ERROR 발생 시각
				
				//해당 MacAddress의 최종 상태 가져오기(데이터 수집날짜 이전)
				hp = new HashMap<String,String>();
				hp.put("macAddress", tempMacAddr);
				List<HashMap> resultLastStatus = SmartCommonDAO.nosessioncommonDataProc("getEqpLastStatus", hp);
				
				
				//최종상태 기준으로 최초 RUNNING 상태 체크
				if(resultLastStatus != null && resultLastStatus.size() > 0) 
				{
					runningTime = 0;
					
					//최종상태가 기준정보관리의 RUNNING FLAG를 포함하면 runningFlag 를 true로 설정
					for(int j=0; j<resultRunningFlag.size(); j++) 
					{
						if(resultLastStatus.get(0).get("STATUS").toString().indexOf(resultRunningFlag.get(j).get("RUNNING_FLAG").toString()) > -1)
						{
							runningFlag = true;
							break;
						}
					}
					
					//최종상태가 기준정보관리의 ERROR FLAG를 포함하면 errorFlag 를 true로 설정하고,
					//EQP_ERROR_HIST에서 해당 MAC ADDRESS의 error 발생 시각을 가져온다.
					for(int j=0; j<resultErrorFlag.size(); j++) 
					{
						if(resultLastStatus.get(0).get("STATUS").toString().indexOf(resultErrorFlag.get(j).get("RUNNING_FLAG").toString()) > -1)
						{
							errorFlag = true;
							lastErrorTime = resultLastStatus.get(0).get("EVENT_TIME").toString();
							
							break;
						}
					}
				} 
				else 
				{
					runningFlag = false;
					errorFlag = false;
				}
				
				
				//최종상태 초기시간 00시00분00초로 설정
				SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd");
				calendar = new GregorianCalendar();
				calendar.add(Calendar.DATE, -1);
				String asisEventTime = sdf2.format(calendar.getTime()) + " 00:00:00";
				
				
				SimpleDateFormat sdf3 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				
				//SORTING 된 데이터 돌면서 RUNNING TIME 계산
				for(int j=0; j<dailyData.size(); j++) 
				{
//					System.out.println(dailyData.get(j).getEventTime() + " || " + dailyData.get(j).getMacAddress() + " || " + dailyData.get(j).getRedFlag() + " || " + dailyData.get(j).getAmberFlag() + " || " + dailyData.get(j).getGreenFlag() + " || " + dailyData.get(j).getBlueFlag() + " || " + dailyData.get(j).getWhiteFlag() );
					if(tempMacAddr.equals(dailyData.get(j).getMacAddress())) 
					{
						//현재상태가 RUNNING일 경우
						//기준정보관리의 RUNNING FLAG 값이 1or2 -> 0 으로 변경 될 때 시간을 누적한다.
						if(runningFlag) 
						{
							//기준정보관리의 RUNNING FLAG와 dailyData의 해당 FLAG(색정보)의 값을 chkFlag 에 더해준다.
							int chkFlag = 0;
							
							for(int k=0; k<resultRunningFlag.size(); k++) 
							{
								if(resultRunningFlag.get(k).get("RUNNING_FLAG").toString().indexOf("RED") > -1)
									chkFlag += Integer.parseInt(dailyData.get(j).getRedFlag());
								if(resultRunningFlag.get(k).get("RUNNING_FLAG").toString().indexOf("AMBER") > -1)
									chkFlag += Integer.parseInt(dailyData.get(j).getAmberFlag());
								if(resultRunningFlag.get(k).get("RUNNING_FLAG").toString().indexOf("GREEN") > -1)
									chkFlag += Integer.parseInt(dailyData.get(j).getGreenFlag());
								if(resultRunningFlag.get(k).get("RUNNING_FLAG").toString().indexOf("BLUE") > -1)
									chkFlag += Integer.parseInt(dailyData.get(j).getBlueFlag());
								if(resultRunningFlag.get(k).get("RUNNING_FLAG").toString().indexOf("WHITE") > -1)
									chkFlag += Integer.parseInt(dailyData.get(j).getWhiteFlag());
							}
							
							//chkFlag 값이 0 이면 현재 기준정보관리의 RUNNING FLAG 에 해당되는 상태가 없음 
							//기준정보관리의 RUNNING FLAG값이 전부 0(불이 꺼짐)일 경우에 누적시간을 구한다.
							if(chkFlag == 0) 
							{
								Date asisTime = sdf3.parse(asisEventTime);
								Date tobeTime = sdf3.parse(dailyData.get(j).getEventTime());
								
								//설비가동이력 등록 
								hp = new HashMap<String,String>();
								hp.put("macAddress", tempMacAddr);
								hp.put("startTime", sdf3.format(asisTime));
								hp.put("endTime", sdf3.format(tobeTime));
								hp.put("runningTime", String.valueOf((tobeTime.getTime() - asisTime.getTime())/1000));
								
								List<HashMap> resultRunningHist = SmartCommonDAO.nosessioncommonDataProc("setEqpRunningHist", hp);
								
								if(resultRunningHist != null || resultRunningHist.size() > 0) 
								{
									if((resultRunningHist.get(0).get("ACTION_RESULT").toString()).indexOf("ERROR") > 0)
									{
										logger.error("[/scheduler/DailyDataSummary] EqpRunningHist DB INSERT Fail :: " + resultRunningHist.get(0).get("ACTION_RESULT"));
										return;
									}
								}
								else
								{
									logger.error("[/scheduler/DailyDataSummary] EqpRunningHist DB INSERT Fail :: NO RETURN");
									return;
								}
								
								runningTime += (tobeTime.getTime() - asisTime.getTime())/1000;
								runningFlag = false;
								asisEventTime = dailyData.get(j).getEventTime();
							}
						}
						else 
						{
							//현재상태가 NOT RUNNING일 경우
							//기준정보관리의 RUNNING FLAG 값이 0 -> 1or2 으로 변경 될 때 runningFlag 값과 이벤트 발생 시간을 변경해준다
							//누적시간은 구하지 않는다.
							int chkFlag = 0;
							
							for(int k=0; k<resultRunningFlag.size(); k++) 
							{
								if(resultRunningFlag.get(k).get("RUNNING_FLAG").toString().indexOf("RED") > -1)
									chkFlag += Integer.parseInt(dailyData.get(j).getRedFlag());
								if(resultRunningFlag.get(k).get("RUNNING_FLAG").toString().indexOf("AMBER") > -1)
									chkFlag += Integer.parseInt(dailyData.get(j).getAmberFlag());
								if(resultRunningFlag.get(k).get("RUNNING_FLAG").toString().indexOf("GREEN") > -1)
									chkFlag += Integer.parseInt(dailyData.get(j).getGreenFlag());
								if(resultRunningFlag.get(k).get("RUNNING_FLAG").toString().indexOf("BLUE") > -1)
									chkFlag += Integer.parseInt(dailyData.get(j).getBlueFlag());
								if(resultRunningFlag.get(k).get("RUNNING_FLAG").toString().indexOf("WHITE") > -1)
									chkFlag += Integer.parseInt(dailyData.get(j).getWhiteFlag());
							}
							
							if(chkFlag > 0) 
							{
								runningFlag = true;
								asisEventTime = dailyData.get(j).getEventTime();
							}
						}
						
						//ERROR 발생 기록 수집
						//현재 상태가 ERROR 일 경우
						if(errorFlag) 
						{
							//기준정보관리의 ERROR FLAG와 dailyData의 해당 FLAG(색정보)의 값을 chkFlag 에 더해준다.
							int chkFlag = 0;
							
							for(int k=0; k<resultErrorFlag.size(); k++) 
							{
								if(resultErrorFlag.get(k).get("RUNNING_FLAG").toString().indexOf("RED") > -1)
									chkFlag += Integer.parseInt(dailyData.get(j).getRedFlag());
								if(resultErrorFlag.get(k).get("RUNNING_FLAG").toString().indexOf("AMBER") > -1)
									chkFlag += Integer.parseInt(dailyData.get(j).getAmberFlag());
								if(resultErrorFlag.get(k).get("RUNNING_FLAG").toString().indexOf("GREEN") > -1)
									chkFlag += Integer.parseInt(dailyData.get(j).getGreenFlag());
								if(resultErrorFlag.get(k).get("RUNNING_FLAG").toString().indexOf("BLUE") > -1)
									chkFlag += Integer.parseInt(dailyData.get(j).getBlueFlag());
								if(resultErrorFlag.get(k).get("RUNNING_FLAG").toString().indexOf("WHITE") > -1)
									chkFlag += Integer.parseInt(dailyData.get(j).getWhiteFlag());
							}
							
							//chkFlag 값이 0 이면 현재 기준정보관리의 ERROR FLAG 에 해당되는 상태가 아님
							//ERROR가 조치되면 EQP_ERROR_HIST테이블에 END_TIME, ELAP_TIME을 UPDATE한다.
							if(chkFlag == 0) 
							{
								//getEqpLastErrorTime() 에서 데이터가 없는 경우는 00시00분00초 기준으로 한다
								if("".equals(lastErrorTime))
								{
									lastErrorTime = yesterdayData + " 00:00:00";
								}
								
								Date asisTime = sdf3.parse(lastErrorTime);		//최종 ERROR 발생 시각
								Date tobeTime = sdf3.parse(dailyData.get(j).getEventTime());	//ERROR 조치 시각
								long elapTime = (tobeTime.getTime() - asisTime.getTime())/1000;	//ERROR 조치 경과시간
								
								hp = new HashMap<String,String>();
								hp.put("macAddress", tempMacAddr);
								hp.put("startTime", lastErrorTime);
								hp.put("endTime", dailyData.get(j).getEventTime());
								hp.put("elapTime", Long.toString(elapTime));
								hp.put("gubun", "END");
								
								List<HashMap> resultErrorHist = SmartCommonDAO.nosessioncommonDataProc("setEqpErrorHist", hp);
								
								if(resultErrorHist == null || resultErrorHist.size() <= 0) 
								{
									logger.error("[/scheduler/DailyDataSummary] EqpErrorHist DB Update Fail :: " + resultErrorHist.get(0).get("ACTION_RESULT"));
									return;
								}
								
								errorFlag = false;
								lastErrorTime = dailyData.get(j).getEventTime();
							}
						}
						else
						{
							int chkFlag = 0;
							
							for(int k=0; k<resultErrorFlag.size(); k++) 
							{
								if(resultErrorFlag.get(k).get("RUNNING_FLAG").toString().indexOf("RED") > -1)
									chkFlag += Integer.parseInt(dailyData.get(j).getRedFlag());
								if(resultErrorFlag.get(k).get("RUNNING_FLAG").toString().indexOf("AMBER") > -1)
									chkFlag += Integer.parseInt(dailyData.get(j).getAmberFlag());
								if(resultErrorFlag.get(k).get("RUNNING_FLAG").toString().indexOf("GREEN") > -1)
									chkFlag += Integer.parseInt(dailyData.get(j).getGreenFlag());
								if(resultErrorFlag.get(k).get("RUNNING_FLAG").toString().indexOf("BLUE") > -1)
									chkFlag += Integer.parseInt(dailyData.get(j).getBlueFlag());
								if(resultErrorFlag.get(k).get("RUNNING_FLAG").toString().indexOf("WHITE") > -1)
									chkFlag += Integer.parseInt(dailyData.get(j).getWhiteFlag());
							}
							
							if(chkFlag > 0) 
							{
								hp = new HashMap<String,String>();
								hp.put("macAddress", tempMacAddr);
								hp.put("startTime", dailyData.get(j).getEventTime());
								hp.put("endTime", "");
								hp.put("elapTime", "");
								hp.put("gubun", "START");
								
								List<HashMap> resultErrorHist = SmartCommonDAO.nosessioncommonDataProc("setEqpErrorHist", hp);
								
								if(resultErrorHist == null || resultErrorHist.size() <= 0) 
								{
									logger.error("[/scheduler/DailyDataSummary] EqpErrorHist DB INSERT Fail :: " + resultErrorHist.get(0).get("ACTION_RESULT"));
									return;
								}
								
								errorFlag = true;
								lastErrorTime = dailyData.get(j).getEventTime();
							}
						}
					}
					
					//해당 일의 최종 상태가 RUNNING 일 경우 다음날 00:00:00 까지 누적시간을 더한다.
					if(j == dailyData.size()-1 && runningFlag) 
					{
						calendar = new GregorianCalendar();
						Date asisTime = sdf3.parse(asisEventTime);
						Date tobeTime = sdf3.parse(sdf2.format(calendar.getTime()) + " 00:00:00");
						runningTime += (tobeTime.getTime() - asisTime.getTime())/1000;
					}
				}
				
				hp = new HashMap<String,String>();
				hp.put("macAddress", tempMacAddr);
				hp.put("runningTime", Long.toString(runningTime));
				hp.put("runningFlag", "RUNNING");
				
				List<HashMap> resultSummary = SmartCommonDAO.nosessioncommonDataProc("setEqpDailySummary", hp);
				
				if(resultSummary == null || resultSummary.size() <= 0) 
				{
					logger.error("[/scheduler/DailyDataSummary] DailySummaryData DB Insert Fail :: " + resultSummary.get(0).get("ACTION_RESULT"));
					return;
				}
			}
			
			if(br != null)	br.close();
			if(isr != null)	isr.close();
			if(fis != null)	fis.close();
		}
		catch(Exception e)
		{
			logger.error("[/scheduler/DailyDataSummary] Exception1 :: " + e.toString());
			logger.error("[/scheduler/DailyDataSummary] Exception1 :: " + getPrintStackTrace(e));
			
			try
			{
				if(br != null)	br.close();
				if(isr != null)	isr.close();
				if(fis != null)	fis.close();
			}
			catch(Exception ee)
			{
				logger.error("[/scheduler/DailyDataSummary] Exception2 :: " + ee.toString());
				logger.error("[/scheduler/DailyDataSummary] Exception2 :: " + getPrintStackTrace(ee));
			}
		}
		finally
		{
			try
			{
				if(br != null)	br.close();
				if(isr != null)	isr.close();
				if(fis != null)	fis.close();
			}
			catch(Exception e)
			{
				logger.error("[/scheduler/DailyDataSummary] Exception3 :: " + e.toString());
				logger.error("[/scheduler/DailyDataSummary] Exception3 :: " + getPrintStackTrace(e));
			}
		}
		
		logger.debug("================   /scheduler/DailyDataSummary] DailyDataSummary DB Insert End  ===============================");
		
	}
	
	
	
//	@Scheduled(cron="0 10 2 * * ?")//매일 새벽 2시 10분에 실행
	public void DeleteLogFile() throws IOException
	{
		StringBuffer output = new StringBuffer();
        Process process = null;
        BufferedReader bufferReader = null;
        Runtime runtime = Runtime.getRuntime();
        
		try
		{
			String fileLocate = "";
			String saveInterval = "";
			HashMap<String,String> hp = new HashMap<String,String>();
			
			//기준정보관리에서 파일경로 가져오기
			List<HashMap> resultLocate = SmartCommonDAO.nosessioncommonDataProc("getEqpLogLocate");
			
			if(resultLocate != null && resultLocate.size() > 0)
			{
				fileLocate = resultLocate.get(0).get("FILE_LOCATE").toString();
			}
			
			List<HashMap> resultLog = SmartCommonDAO.nosessioncommonDataProc("getEqpLogDay");
			
			if(resultLog != null && resultLog.size() > 0)
			{
				saveInterval = resultLog.get(0).get("LOG_FILE_SAVE_DAY").toString();
	
				if(!"0".equals(saveInterval))
				{
					logger.debug("================   /scheduler/DeleteLogFile] DeleteLogFile Start  ===============================");
					
					String commandStr = "forfiles /p " + fileLocate + " /m *.* /d -" + saveInterval + " /c \"cmd /c del @file\"";
					
					process = runtime.exec(commandStr);
					
					bufferReader = new BufferedReader(new InputStreamReader(process.getInputStream()));
					
		            String msg = null;
		            
		            while((msg=bufferReader.readLine()) != null) 
		            {
		                logger.debug("[/scheduler/DeleteLogFile] DeleteLogFile] : " + msg + System.getProperty("line.separator"));
		            }
		            
		            logger.debug("================   /scheduler/DeleteLogFile] DeleteLogFile End  ===============================");
				}
			}
			
			if(bufferReader != null)
			{
				bufferReader.close();
			}
            
		}
		catch(Exception e)
		{
			logger.error("[/scheduler/DeleteLogFile] Exception1 :: " + e.toString());
		}
		
		if(bufferReader != null)
		{
			bufferReader.close();
		}
	}
	
	
//  @Scheduled(cron="0 0/1 * * * *")//1분 마다 실행
	public void SpaceSodicXmlParsing() throws Exception {
		
		DocumentBuilderFactory factory= DocumentBuilderFactory.newInstance();
		DocumentBuilder builder = factory.newDocumentBuilder();
		BufferedReader in = null;
	      
		try{
			
//			URL obj = new URL("http://localhost:5000/current"); 
			URL obj = new URL("http://localhost:8090/smes/device.xml");
			HttpURLConnection con = (HttpURLConnection)obj.openConnection();

			con.setDoOutput(true);
			con.setRequestMethod("GET");

			in = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
			String line;
			String resultLine = "";

			while((line = in.readLine()) != null)
			{
				resultLine += line;
			}
			
			String arraystr = "";
			
			ArrayList tagList = new ArrayList();
			tagList.add("Execution");
			tagList.add("Program");
			tagList.add("PathPosition");
			tagList.add("MachineLength");
			
			ArrayList nameList = new ArrayList();
			nameList.add("execution");
			nameList.add("program");
			nameList.add("path_pos");
			nameList.add("total_length");
			
			
			//기준정보관리에서 파일경로 가져오기
			
			Document doc = builder.parse(new ByteArrayInputStream(resultLine.getBytes()));
			doc.getDocumentElement().normalize();
			
//			System.out.println("Root element : "+doc.getDocumentElement().getNodeName());
			NodeList list = doc.getElementsByTagName("DeviceStream");
//			System.out.println("-----------------------");
			
			
			for(int i=0; i<list.getLength(); i++) {
				Node node = list.item(i);
				
				if(node.getNodeType() == Node.ELEMENT_NODE) {
					Element element = (Element)node;
					
					 //DeviceStream Tag 에서 설비이름 가져오기
					String eqpName = element.getAttributes().getNamedItem("name").getNodeValue();
					arraystr += eqpName + "♬";
//					System.out.println("EQP NAME :: " + eqpName);

					for(int j=0; j<tagList.size(); j++) {
						
						
						NodeList subNodeList = element.getElementsByTagName(tagList.get(j).toString());
						for(int k = 0; k<subNodeList.getLength(); k++) {
							Element subElement = (Element)subNodeList.item(k);
							String name = subElement.getAttributes().getNamedItem("name").getNodeValue();
							if(nameList.get(j).toString().equals(name)) {
								arraystr += getTagValue(tagList.get(j).toString(), element) + "♬";
//								System.out.println(getTagValue(tagList.get(j).toString(), element));
							}
						}	//for subNodeList
						
					}	//for tagList 
					
				}	//node.getNodeType() == Node.ELEMENT_NODE
				arraystr = arraystr.substring(0, arraystr.length()-1) + "♩"; 
				
//				System.out.println("===================");
				
			}	//for Streams NodeList
			
			
			arraystr = arraystr.substring(0, arraystr.length()-1);
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("arraystr", arraystr);
			
			List<HashMap> resultInsert = SmartCommonDAO.nosessioncommonDataProc("setSodicEqpData", hp);
			if(resultInsert != null && resultInsert.size() > 0) {
				if(resultInsert.get(0).get("ACTION_RESULT").toString().indexOf("ERROR") > -1) {
					logger.error("[/scheduler/SpaceSodicXmlParsing] DB Insert Fail :: " + resultInsert.get(0).get("ACTION_RESULT"));
					return;
				}
				if(resultInsert.get(0).get("ERROR_EQP") != null) {
					String errorEqp = resultInsert.get(0).get("ERROR_EQP").toString();
//					errorEqp = errorEqp.replaceAll("TIGER2", "AL600G");
//					errorEqp = errorEqp.replaceAll("TIGER", "AL600G");
//					errorEqp = errorEqp.replaceAll("LION2", "AL60L");
//					errorEqp = errorEqp.replaceAll("LION", "AL60G");
					SimpleDateFormat sdf = new SimpleDateFormat ( "yyyy-MM-dd HH:mm:ss");
					Date time = new Date();
					String eventTime = sdf.format(time);
					String PushMsg = "[" + eventTime + "]" + errorEqp + " 장비에 에러가 발생하였습니다.";
					String Appkey = "";
					
					//모바일 앱  Push
					/*
					hp = new HashMap<String,String>();
					hp.put("gubun", "ROLE_USER_SYSOP");
					List<HashMap> resultAppKey = SmartCommonDAO.nosessioncommonDataProc("getMobileAppkey",hp);
					
					if(resultAppKey != null && resultAppKey.size()>0)
					{
						for(int m=0 ; m<resultAppKey.size() ; m++)
						{
							Appkey = resultAppKey.get(m).get("APPKEY").toString();
							String gcmresult = SmartGcmSender.gcmSender(Appkey, PushMsg, 0);
						}
					}
					else
					{
						logger.debug("[/scheduler/SpaceSodicXmlParsing.do] ROLE_USER_SYSOP Mobile Push Appkey not found!! ");
					}
					*/
				}
			}
			
		} catch(Exception e) {
			e.printStackTrace();
			logger.error("[/scheduler/SpaceSodicXmlParsing] Exception :: " + e.toString());
		}
		
	}
	
	
//	@Scheduled(cron="0 30 2 * * ?")//매일 새벽 2시30분에 실행
	public void SpaceSodicDataSummary() throws Exception {
		//매일 전일 데이터를 가동시간, 대기시간, 에러시간별로 나누어 취합한다.
		try {
			
			List<HashMap> result = SmartCommonDAO.nosessioncommonDataProc("setSodicEqpDataSummary");
			if(result != null && result.size() > 0) {
				if(result.get(0).get("ACTION_RESULT").toString().indexOf("ERROR") > -1) {
					logger.error("[/scheduler/SpaceSodicDataSummary] DB Insert Fail :: " + result.get(0).get("ACTION_RESULT"));
					return;
				}
			}
			
		} catch(Exception e) {
			logger.error("[/scheduler/SpaceSodicDataSummary] Exception :: " + e.toString());
		}
		
	}
	
//	@Scheduled(cron="0 0/1 * * * *")//1분 마다 실행
	public void SpacePxDataUpdate() throws Exception {
		
		RandomAccessFile datFile = null;
		
		try{
			
			logger.debug("[/scheduler/SpacePxDataUpdate] Update Start---------------------------------------->");
			
			HashMap<String,String> hp = new HashMap<String,String>();
			String fileLocate = "";
			
			List<HashMap> resultLocate = SmartCommonDAO.nosessioncommonDataProc("getPxFileLocate");
			
			if(resultLocate != null && resultLocate.size() > 0)
			{
				fileLocate = resultLocate.get(0).get("FILE_LOCATE").toString();
			}
			
			List<HashMap> result = SmartCommonDAO.nosessioncommonDataProc("getPxEqpInfo");
			
			HashMap<String,String> status = null;
			
			File pxFile = null;
			
			long fileLength = 0;	//파일 총 문자 수
			long pos = 0;	//제일 마지막 line
			String line = "";
			String[] arrStr;
			
			SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy_MM_dd");//파일명은 _로 구분
			SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd");//날짜 입력시에는 -로 구분
			SimpleDateFormat sdf3 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Calendar calendar = Calendar.getInstance();
			String today1 = sdf1.format(calendar.getTime());
			String today2 = sdf2.format(calendar.getTime());
			StringBuffer sb = new StringBuffer();
			
			if(result != null && result.size() > 0)
			{
				for(int i=0; i<result.size(); i++)
				{
					
					//금일 해당설비의 마지막 데이터 입력 시간
					hp = new HashMap<String,String>();
					hp.put("eqpname", result.get(i).get("FOLDER_NAME").toString());
					List<HashMap> resultLast = SmartCommonDAO.nosessioncommonDataProc("getPxEqpLastTime", hp);
					String pxEqpLastTime = "";
					if(resultLast != null && resultLast.size() > 0) {
						if(resultLast.get(0).get("LAST_TIME") == null) {
							pxEqpLastTime = today2 + " 00:00:00";
						} else {
							pxEqpLastTime = resultLast.get(0).get("LAST_TIME").toString();
						}
					} else {
						pxEqpLastTime = today2 + " 00:00:00";
					}
					
					pxFile = new File(fileLocate +"\\" + result.get(i).get("FOLDER_NAME") + "\\" + today1 + ".dat");
					
					if(pxFile != null && pxFile.length()>0)
					{
						datFile = new RandomAccessFile(pxFile,"r");
						
						fileLength = datFile.length();	//파일 총 문자 수
						pos = fileLength-1;	//제일 마지막 line
						
						while(true)
						{
							
							datFile.seek(pos);
							//RandomAccessFile은 문자 하나씩 체크를 하므로 줄넘김이 나오면 해당 라인 확인 
							if(datFile.readByte() == '\n' && datFile.readLine() != null)
							{
								datFile.seek(pos+1);
								line = datFile.readLine();
								arrStr = line.split("\t");

								//Data는 3번째 line 부터 시작
								if(line.indexOf("Flag") > -1)
									break;
								
								Date lastTime = sdf3.parse(pxEqpLastTime);
								Date lineTime = sdf3.parse(today2 + " " + arrStr[6]);
								if(lineTime.getTime() >= lastTime.getTime()) {
									sb.append(result.get(i).get("FOLDER_NAME") + "♬" + arrStr[0] + "♬" + arrStr[2] + "♬" + today2 + " " + arrStr[5] + "♬" + today2 + " " + arrStr[6] + "♩");
								} else {
									break;
								}
								
							}
							
							pos--;
						}
						datFile.close();
					}
				}
			}
			
			if(sb != null && sb.length()>0)
			{
				hp = new HashMap<String,String>();
				hp.put("eqpdata", sb.toString().substring(0, sb.toString().length()-1));
				
				List<HashMap>  resultEqp =  SmartCommonDAO.nosessioncommonDataProc("setPxEqpSave",hp);
				
	    		if(resultEqp != null && resultEqp.size()>0)
	    		{
	    			logger.debug("[/scheduler/SpacePxDataUpdate] Result :: " + resultEqp.get(0).get("ACTION_RESULT"));
				}
			}
		
		} catch(Exception e) {
			e.printStackTrace();
			logger.error("[/scheduler/SpacePxDataUpdate] Exception :: " + e.toString());
		}
		
		if(datFile != null)
		{
			datFile.close();
		}
		
	}
	
	
	@Scheduled(cron="0 30 2 * * ?")//매일 새벽 2시30분에 실행
//	@Scheduled(cron="0 0/1 * * * *")//1분 마다 실행
	public void SpacePxDataSummary() throws Exception {
		//매일 전일 데이터를 가동시간, 대기시간, 에러시간별로 나누어 취합한다.
		try {
			
			List<HashMap> result = SmartCommonDAO.nosessioncommonDataProc("setPxEqpDataSummary");
			if(result != null && result.size() > 0) {
				if(result.get(0).get("ACTION_RESULT").toString().indexOf("ERROR") > -1) {
					logger.error("[/scheduler/SpacePxDataSummary] DB Insert Fail :: " + result.get(0).get("ACTION_RESULT"));
					return;
				}
			}
			
		} catch(Exception e) {
			logger.error("[/scheduler/SpacePxDataSummary] Exception :: " + e.toString());
		}
		
	}
	
	
	
	private static String getTagValue(String tag, Element element) {
		NodeList list =  element.getElementsByTagName(tag).item(0).getChildNodes();
		Node nValue = (Node) list.item(0);
		if(nValue == null) {
			return "";
		} else {
			return nValue.getNodeValue();
		}
	}
	
	
	public static Comparator<DailyData> comparatorEventTime = new Comparator<DailyData>(){
		@Override
		public int compare(DailyData d1, DailyData d2) {
			return d1.getEventTime().compareToIgnoreCase(d2.getEventTime());
		}
	};
	
	public static Comparator<DailyData> comparatorMacAddress = new Comparator<DailyData>() {
		@Override
		public int compare(DailyData d1, DailyData d2) {
			return d1.getMacAddress().compareToIgnoreCase(d2.getMacAddress());
		}
	};
	
	public static String getPrintStackTrace(Exception e) {
		StringWriter errors = new StringWriter();
		e.printStackTrace(new PrintWriter(errors));
		
		return errors.toString();
	}
	
}