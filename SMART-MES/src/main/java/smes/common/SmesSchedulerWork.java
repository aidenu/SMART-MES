package smes.common;

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


public class SmesSchedulerWork 
{
	
	Logger logger = Logger.getLogger("egovframework");
	
	@Resource(name="SmesCommonDAO")
	private SmesCommonDAOImpl SmesCommonDAO;
	
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
			List<HashMap> resultSummary = SmesCommonDAO.nosessioncommonDataProc("setEqpDailySummary", hp);
			
			if(resultSummary == null || resultSummary.size() <= 0) 
			{
				logger.error("[/scheduler/DailyDataSummary] DailySummaryData DB Insert Fail :: " + resultSummary.get(0).get("ACTION_RESULT"));
				return;
			}
			
			logger.debug("================   /scheduler/DailyDataSummary] DailyDataSummary DB Insert End  ===============================");
			
		} catch(Exception e) {
			logger.error("[/scheduler/DailyDataInsert] Exception :: " + e.toString());
		}
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
			List<HashMap> resultLocate = SmesCommonDAO.nosessioncommonDataProc("getEqpLogLocate");
			
			if(resultLocate != null && resultLocate.size() > 0)
			{
				fileLocate = resultLocate.get(0).get("FILE_LOCATE").toString();
			}
			
			List<HashMap> resultLog = SmesCommonDAO.nosessioncommonDataProc("getEqpLogDay");
			
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
			List<HashMap> resultLocate = SmesCommonDAO.nosessioncommonDataProc("getEqpLogLocate");
			
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
				
				List<HashMap> resultLast = SmesCommonDAO.nosessioncommonDataProc("getLastData");
				
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
								
								List<HashMap> resultInsert = SmesCommonDAO.nosessioncommonDataProc("setEqpDailyData", hp);
								
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