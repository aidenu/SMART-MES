package space.common;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URLDecoder;
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

import org.apache.commons.collections.comparators.ComparatorChain;
import org.apache.log4j.Logger;
import org.springframework.scheduling.annotation.Scheduled;

import egovframework.rte.fdl.property.EgovPropertyService;


public class SpaceSchedulerWork 
{
	
	Logger logger = Logger.getLogger("egovframework");
	
	@Resource(name="spaceCommonDAO")
	private SpaceCommonDAOImpl spaceCommonDAO;
	
	@Resource(name = "propertiesService")
    protected EgovPropertyService propertyService;
    
	
	
	
	@Scheduled(cron="0 45 1 * * ?")//매일 새벽 1시 45분에 실행
//  @Scheduled(cron="*/30 * * * * *")//30초 마다 실행
	public void DailyDataSummary()
	{
		String yesterday = "";
		
		try {
			//어제 날짜 구하기
			Calendar calendar = new GregorianCalendar();
			calendar.add(Calendar.DATE, -1);
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			yesterday = sdf.format(calendar.getTime());
			
			logger.debug("================   /scheduler/DailyDataSummary] DailyDataSummary DB Insert Start :: " + yesterday + " ===============================");
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("searchDate", yesterday);
			List<HashMap> resultSummary = spaceCommonDAO.nosessioncommonDataProc("setEqpDailySummary", hp);
			
			if(resultSummary == null || resultSummary.size() <= 0) 
			{
				logger.error("[/scheduler/DailyDataSummary] DailySummaryData DB Insert Fail :: " + resultSummary.get(0).get("ACTION_RESULT"));
				return;
			}
			
			logger.debug("================   /scheduler/DailyDataSummary] DailyDataSummary DB Insert End  ===============================");
			
		} catch(Exception e) {
			logger.error("[/scheduler/DailyDataInsert] Exception :: " + e.toString());
		}
	
		
		
		/*
		BufferedReader br = null;
		InputStreamReader isr = null;
		FileInputStream fis = null;
		List<DailyData> dailyData = new ArrayList<DailyData>();
		
		try
		{
			String fileLocate = "";
			String yesterday = "";
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
			yesterday = sdf.format(calendar.getTime());
			
			logger.debug("================   /scheduler/DailyDataSummary] DailyDataSummary DB Insert Start :: " + yesterday + " ===============================");
			
			//기준정보관리에서 파일경로 가져오기
			List<HashMap> resultLocate = spaceCommonDAO.nosessioncommonDataProc("getEqpLogLocate");
			
			if(resultLocate != null && resultLocate.size() > 0)
			{
				fileLocate = resultLocate.get(0).get("FILE_LOCATE").toString();
			}
			
			
			//파일명 셋팅
			fileName = "patlog_auto"+yesterday+".csv";
			File file = new File(fileLocate+"\\"+fileName);

			
			//정렬을 위해 파일을 읽어 List에 담기
			fis= new FileInputStream(file);
			isr = new InputStreamReader(fis);
			br = new BufferedReader(isr);
			
			while( (temp = br.readLine()) != null) 
			{
				if(temp.indexOf("DataTime") == -1) 
				{
					arrData = temp.split(",");
					
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
					
					dailyData.add(new DailyData(eventDate, macAddr, redFlag, amberFlag, greenFlag, blueFlag, whiteFlag, buzzerFlag, wdtFlag));
				}
			}
			
			
			//MacAddress, EventTime 으로 sorting
			ComparatorChain chain = new ComparatorChain();
			chain.addComparator(comparatorMacAddress);
			chain.addComparator(comparatorEventTime);
			Collections.sort(dailyData, chain);
			
			
			//기준정보관리에 등록된 설비의 MacAddress 가져오기
			List<HashMap> resultEqp = spaceCommonDAO.nosessioncommonDataProc("getEqpList");
			
			//기준정보관리에서 RUNNING 상태 기준 가져오기
			hp = new HashMap<String,String>();
			hp.put("active_flag", "RUNNING");
			
			List<HashMap> resultRunningFlag = spaceCommonDAO.nosessioncommonDataProc("getEqpRunningFlag", hp);
			
			//기준정보관리에서 ERROR 상태 기준 가져오기
			hp = new HashMap<String,String>();
			hp.put("active_flag", "ERROR");
			
			List<HashMap> resultErrorFlag = spaceCommonDAO.nosessioncommonDataProc("getEqpRunningFlag", hp);
			
			
			//기준정보관리에 등록된 설비 MacAddress 별로 데이터 수집
			//기준정보관리에 등록한 설비만 데이터를 수집한다.
			for(int i=0; i<resultEqp.size(); i++) 
			{
				String tempMacAddr = resultEqp.get(i).get("MACADDRESS").toString();
				
				long runningTime = 0;	//누적되는 running time
				boolean runningFlag = false;	//running 상태 flag
				boolean errorFlag = false;		//error 상태 flag
				String lastErrorTime = "";		//최종 ERROR 발생 시각
				
				//해당 MacAddress의 최종 상태 가져오기(데이터 수집날짜 이전)
				hp = new HashMap<String,String>();
				hp.put("macAddress", tempMacAddr);
				List<HashMap> resultLastStatus = spaceCommonDAO.nosessioncommonDataProc("getEqpLastStatus", hp);
				
				
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
								
								if("00255CFFFEBABE6C".equals(tempMacAddr)) {
									System.out.println("runningFlag : " + runningFlag + " || " + asisEventTime + " || " + dailyData.get(j).getEventTime() + " GAB : " + ((tobeTime.getTime() - asisTime.getTime())/1000));
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
									lastErrorTime = asisEventTime;
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
								
								List<HashMap> resultErrorHist = spaceCommonDAO.nosessioncommonDataProc("setEqpErrorHist", hp);
								
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
								
								List<HashMap> resultErrorHist = spaceCommonDAO.nosessioncommonDataProc("setEqpErrorHist", hp);
								
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
				
				List<HashMap> resultSummary = spaceCommonDAO.nosessioncommonDataProc("setEqpDailySummary", hp);
				
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
			
			try
			{
				if(br != null)	br.close();
				if(isr != null)	isr.close();
				if(fis != null)	fis.close();
			}
			catch(Exception ee)
			{
				logger.error("[/scheduler/DailyDataInsert] Exception2 :: " + ee.toString());
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
			}
		}
		
		logger.debug("================   /scheduler/DailyDataSummary] DailyDataSummary DB Insert End  ===============================");
		*/
	}
	
	
	
	@Scheduled(cron="0 15 2 * * ?")//매일 새벽 2시 10분에 실행
//  @Scheduled(cron="*/30 * * * * *")//30초 마다 실행
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
			List<HashMap> resultLocate = spaceCommonDAO.nosessioncommonDataProc("getEqpLogLocate");
			
			if(resultLocate != null && resultLocate.size() > 0)
			{
				fileLocate = resultLocate.get(0).get("FILE_LOCATE").toString();
			}
			
			List<HashMap> resultLog = spaceCommonDAO.nosessioncommonDataProc("getEqpLogDay");
			
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
	
	
	
	//10분 마다 설비 작동 이력을 DB에 넣어 준다
	@Scheduled(cron="0 0/10 * * * ?")//매 10분 마다 실행
    //@Scheduled(cron="*/30 * * * * *")//30초 마다 실행
	public void WorkDataInsert()
	{
		//10분 마다 데이터 DB에 수집
		BufferedReader br = null;
		InputStreamReader isr = null;
		FileInputStream fis = null;
		File file = null;
		
		try 
		{
			Calendar calendar = new GregorianCalendar();
			//calendar.add(Calendar.DATE, -1);
			
			long event_time_long = 0l;
			long today_time_long = 0l;
			long last_time_long = 0l;
			
			String fileLocate = "";
			String today = "";
			String today_time = "";
			String last_time = "";
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
			
			String today_cnt = "";
			
			HashMap<String,String> hp = new HashMap<String,String>();
			
			//오늘 날짜 구하기
			SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy_MM_dd");
			SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd kk:mm:ss");
			today = sdf1.format(calendar.getTime());
			today_time = sdf2.format(calendar.getTime());
			
			logger.debug("================   /scheduler/DailyWorkDataInsert] DailyWorkData DB Insert Start :: " + today_time + " ===============================");
			
			//기준정보관리에서 파일경로 가져오기
			List<HashMap> resultLocate = spaceCommonDAO.nosessioncommonDataProc("getEqpLogLocate");
			
			if(resultLocate != null && resultLocate.size() > 0) 
			{
				fileLocate = resultLocate.get(0).get("FILE_LOCATE").toString();
			}
			
			//파일명 셋팅
			fileName = "patlog_auto"+today+".csv";
			
			file = new File(fileLocate+"\\"+fileName);
			
			
			if(file != null)//오늘 날짜 파일이 있으면
			{
				//오늘 날짜 파일이 있으면 DB에서 오늘 날짜 데이터가 있는지 확인하여 데이터가 있으면 10분전 데이터부터 현재시간(10분단위)까지 넣고
				//데이터가 없으면 첫줄 부터 현재시간(10분단위)까지 넣는다
				
				List<HashMap> resultLast = spaceCommonDAO.nosessioncommonDataProc("getLastData");
				
				if(resultLast != null && resultLast.size() > 0) 
				{
					fis= new FileInputStream(file);
					isr = new InputStreamReader(fis);
					br = new BufferedReader(isr);
					
					last_time = resultLast.get(0).get("LAST_EVENT_TIME").toString();
					today_cnt = resultLast.get(0).get("CNT").toString();
					
					int cnt = 0;
					
					while( (temp = br.readLine()) != null)
					{
						if(cnt > 0) //첫번째 줄은 제외
						{
							arrData = temp.split(",");
							
							if(arrData[0].indexOf(":") == 12)
							{
								eventDate = arrData[0].substring(0, 11) + "0" + arrData[0].substring(arrData[0].indexOf(":")-1);
							}
							else
							{
								eventDate = arrData[0];
							}
							
							event_time_long = Long.parseLong(eventDate.replaceAll("-","").replaceAll(" ","").replaceAll(":",""));
							last_time_long = Long.parseLong(last_time.replaceAll("-","").replaceAll(" ","").replaceAll(":",""));
							
							//오늘 들어온 데이터가 하나도 없으면 처음부터 다 넣어 주고
							//오늘 들어온 데이터가 이미 있으면 마지막 데이터 시간 이후 값만 넣어 준다
							if("0".equals(today_cnt) || event_time_long>last_time_long)
							{
								macAddr = arrData[1];
								redFlag = arrData[3];
								amberFlag = arrData[4];
								greenFlag = arrData[5];
								blueFlag = arrData[6];
								whiteFlag = arrData[7];
								buzzerFlag = arrData[8];
								wdtFlag = arrData[9];
								
								hp = new HashMap<String,String>();
								hp.put("insert_date", today_time);
								hp.put("event_date", eventDate);
								hp.put("mac_addr", macAddr);
								hp.put("red_flag", redFlag);
								hp.put("amber_flag", amberFlag);
								hp.put("green_flag", greenFlag);
								hp.put("blue_flag", blueFlag);
								hp.put("white_flag", whiteFlag);
								hp.put("buzzer_flag", buzzerFlag);
								hp.put("wdt_flag", wdtFlag);
								
								List<HashMap> resultInsert = spaceCommonDAO.nosessioncommonDataProc("setEqpDailyData", hp);
								
								if(resultInsert == null || resultInsert.size() <= 0) 
								{
									logger.error("[/scheduler/DailyWorkDataInsert] DailyWorkData1 DB Insert Fail :: " + resultInsert.get(0).get("ACTION_RESULT"));
									return;
								}
							}
						}

						cnt ++;
						
					}
					
					
					if(br != null)	br.close();
					if(isr != null)	isr.close();
					if(fis != null)	fis.close();
				}
			}
		} 
		catch (Exception e) 
		{
			logger.error("[/scheduler/DailyWorkDataInsert] Exception1 :: " + e.toString());
			
			try
			{
				if(br != null)	br.close();
				if(isr != null)	isr.close();
				if(fis != null)	fis.close();
			}
			catch(Exception ee)
			{
				logger.error("[/scheduler/DailyWorkDataInsert] Exception2 :: " + ee.toString());
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
				logger.error("[/scheduler/DailyWorkDataInsert] Exception3 :: " + e.toString());
			}
		}
		
		logger.debug("================   /scheduler/DailyWorkDataInsert] DailyWorkData DB Insert End  ===============================");
		
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
	
}