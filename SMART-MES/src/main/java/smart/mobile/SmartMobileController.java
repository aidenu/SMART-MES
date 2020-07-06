package smart.mobile;

import java.io.File;
import java.io.RandomAccessFile;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import smart.common.SmartCommonDAOImpl;
import smart.common.SmartGcmSender;
import egovframework.com.cmm.LoginVO;
import egovframework.let.uat.uia.service.EgovLoginService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;

@Controller
public class SmartMobileController {
	
Logger logger = Logger.getLogger("egovframework");
	
	/** EgovLoginService */
	@Resource(name = "loginService")
	private EgovLoginService loginService;
	
	@Resource(name="smartCommonDAO")
	private SmartCommonDAOImpl SmartCommonDAO;
	
	@Resource(name="messageSource")
	MessageSource messageSource ;
	
	@Resource(name="smartGcmSender")
	private SmartGcmSender SmartGcmSender;
	
	
	
	@RequestMapping(value = "/mobile/login_check.do")
	public String getSmartMobileLoginCheckPage(
			@ModelAttribute("loginVO") LoginVO loginVO, HttpServletResponse response,
            HttpServletRequest request,
            ModelMap model
			) throws Exception {
		
		String result = "FALSE";
		
		if(loginVO.getId() != null) 
		{
		    LoginVO resultVO = loginService.actionLogin(loginVO);
		
	        if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) 
	        {
	        	result = "TRUE";
	        	
	        	HashMap<String,String> hp = new HashMap<String,String>();
		    	
				hp.put("userid",resultVO.getId());
				
				List<HashMap> resultRole = SmartCommonDAO.nosessioncommonDataProc("getMobileUserRole",hp);
				
				if(resultRole != null && resultRole.size()>0)
				{
					result = "TRUE|" + (String)resultRole.get(0).get("AUTHOR_CODE");
				}
				else
				{
					result = "TRUE|NO ROLE";
				}
	        }
    	}

		model.addAttribute("result", result);

        return "mobile/login_check";
		
	}
	
	
	
	@RequestMapping(value = "/mobile/appkey_regist.do")
	public String getSmartMobileAppkeyRegistPage(
			@RequestParam(value="userid", required=false) String userid,
			@RequestParam(value="appkey", required=false) String appkey,
			@RequestParam(value="ostype", required=false) String ostype,
            ModelMap model
			) throws Exception {
		
		String resultStr = "FALSE";
		
		try{
    		
			if(userid != null && !"".equals(userid))
			{
		    	HashMap<String,String> hp = new HashMap<String,String>();
		    	
				hp.put("userid",userid);
				hp.put("appkey",appkey);
				hp.put("ostype",ostype);
	
				List<HashMap> result = SmartCommonDAO.nosessioncommonDataProc("setMobileAppkeyRegist",hp);
	
				if(result != null && result.size()>0)
				{
					resultStr = (String)result.get(0).get("ACTION_RESULT");
					
					if("OK".equals(resultStr))
					{
						resultStr = "TRUE";
					}
					else
					{
						resultStr = "FALSE";
					}
				}
				else
				{
					resultStr = "FALSE";
				}
			}
			else
			{
				resultStr = "FALSE";
			}

			model.addAttribute("result",resultStr);
			
    	}
    	catch(Exception e){
    		logger.error("[/mobile/appkey_regist.do] Exception :: " + e.toString());
    	}
    	
        return "mobile/appkey_regist";
		
	}
	
	
	
	@RequestMapping(value = "/mobile/appkey_delete.do")
	public String getSmartMobileAppkeyDeletePage(
			@RequestParam(value="userid", required=false) String userid,
			@RequestParam(value="appkey", required=false) String appkey,
            ModelMap model
			) throws Exception {
		
		String resultStr = "FALSE";
		
		try{
    		
			if(userid != null && !"".equals(userid))
			{
		    	HashMap<String,String> hp = new HashMap<String,String>();
		    	
				hp.put("userid",userid);
				hp.put("appkey",appkey);
	
				List<HashMap> result = SmartCommonDAO.nosessioncommonDataProc("setMobileAppkeyDelete",hp);
	
				if(result != null && result.size()>0)
				{
					resultStr = (String)result.get(0).get("ACTION_RESULT");
					
					if("OK".equals(resultStr))
					{
						resultStr = "TRUE";
					}
					else
					{
						resultStr = "FALSE";
					}
				}
				else
				{
					resultStr = "FALSE";
				}
			}
			else
			{
				resultStr = "FALSE";
			}

			model.addAttribute("result",resultStr);
			
    	}
    	catch(Exception e){
    		logger.error("[/mobile/appkey_delete.do] Exception :: " + e.toString());
    	}
    	
        return "mobile/appkey_delete";
		
	}
	
		
	
	
	@RequestMapping(value = "/mobile/alarm_list.do")
    public String getSmartMobileAlarmListPage(
    		@RequestParam(value="userid", required=false) String userid,
    		ModelMap model
    		)throws Exception {

		//System.out.println("userid::"+userid);
		
		try{
			
			HashMap<String,String> hp = new HashMap<String,String>();
			
			hp.put("userid", userid);
			hp.put("pageno", "0");
			
			List<HashMap> result = SmartCommonDAO.nosessioncommonDataProc("getMobileAlarmList",hp);
			
			model.addAttribute("alarmlist", result);
			model.addAttribute("userid", userid);
		}
		catch(Exception e){
			logger.error("[/mobile/alarm_list.do] Exception :: " + e.toString());
		}
		
		return "mobile/alarm_list";
    }
	
	
	@RequestMapping(value = "/mobile/alarm_list_hidden.do")
    public String getSmartMobileAlarmHiddenListPage(
    		@RequestParam(value="userid", required=false) String userid,
    		@RequestParam(value="pageno", required=false) String pageno,
    		ModelMap model
    		)throws Exception {

		//System.out.println("userid::"+userid);
		
		try{
			
			HashMap<String,String> hp = new HashMap<String,String>();
			
			hp.put("userid", userid);
			hp.put("pageno", pageno);
			
			List<HashMap> result = SmartCommonDAO.nosessioncommonDataProc("getMobileAlarmList",hp);
			
			model.addAttribute("alarmlist", result);
			model.addAttribute("userid", userid);
			model.addAttribute("pageno", pageno);
		}
		catch(Exception e){
			logger.error("[/mobile/alarm_list_hidden.do] Exception :: " + e.toString());
		}
		
		return "mobile/alarm_list_hidden";
    }
		
	
	
	
	@RequestMapping(value = "/mobile/alarm_confirm.do")
    public String getSmartMobileAlarmCongirmPage(
    		@RequestParam(value="userid", required=false) String userid,
    		@RequestParam(value="arrayid", required=false) String arrayid,
    		ModelMap model
    		)throws Exception {

		
		try{
			
			HashMap<String,String> hp = new HashMap<String,String>();
			
			hp.put("userid", userid);
			hp.put("arrayid", arrayid);
			
			List<HashMap> result = SmartCommonDAO.nosessioncommonDataProc("setMobileAlarmData",hp);
			
			if(result != null && result.size()>0)
			{
				model.addAttribute("actionresult",(String)result.get(0).get("ACTION_RESULT"));
			}
		}
		catch(Exception e){
			logger.error("[/mobile/alarm_confirm.do] Exception :: " + e.toString());
		}
		
		return "mobile/alarm_confirm";
    }
	
	
	//설비상태 데이터 조회
	@RequestMapping(value = "/mobile/model_eqp_status.do")
	public String model_eqp_status(
		@RequestParam(value="userid", required=false) String userid,
		ModelMap model
		) throws Exception {
	
		try{
		
			Calendar calendar1 = new GregorianCalendar();

			HashMap<String,String> hp = new HashMap<String,String>();
			
			String fileLocate = "";
			List<HashMap> resultLocate = SmartCommonDAO.nosessioncommonDataProc("getEqpLogLocate");
			if(resultLocate != null && resultLocate.size() > 0)
			{
				fileLocate = resultLocate.get(0).get("FILE_LOCATE").toString();
			}
			
			List<HashMap> result = SmartCommonDAO.nosessioncommonDataProc("getEqpStatus");
			model.addAttribute("result", result);
			
			List<HashMap> resultStatus = new ArrayList();
			HashMap<String,String> status = null;;
			
			
			if(result != null && result.size() > 0)
			{
				for(int i=0; i<result.size(); i++)
				{
					int cnt = 0;
					boolean completeflag = false;
					
					status = new HashMap<String,String>();
					
					String macaddress = "";
					String eqpname = "";
					String eqppart = "";
					String username = "";
					
					
					if(result.get(i).get("EQP_NAME") != null)
						eqpname = result.get(i).get("EQP_NAME").toString();
					if(result.get(i).get("EQP_PART") != null)
						eqppart = result.get(i).get("EQP_PART").toString();
					if(result.get(i).get("USER_NM") != null)
						username = result.get(i).get("USER_NM").toString();
					if(result.get(i).get("MACADDRESS") != null)
						macaddress = result.get(i).get("MACADDRESS").toString();
					else
					{
						status.put("EQP_PART", eqppart);
						status.put("EQP_NAME", eqpname);
						status.put("WHITE_STATUS", "OFF");
						status.put("WHITE_VALUE", "0");
						status.put("ACTIVE_FLAG", "DEAD");
						status.put("USER_NAME", username);
						resultStatus.add(status);
					}
					
					calendar1.add(Calendar.DATE, cnt);
		    		SimpleDateFormat sdf = new SimpleDateFormat("yyyy_MM_dd");
		    		String readDate = sdf.format(calendar1.getTime());
		    		
		    		File dir = new File(fileLocate);
		    		File[] fileList = dir.listFiles();
		    		
		    		for(int j=(fileList.length-1); j>-1; j--)
		    		{
		    			File file = fileList[j];
			    		if(file.isFile() && file.toString().indexOf(".csv")>-1)
			    		{
			    			//파일의 뒤에서부터 읽기 위해 RandomAccessFile 사용
							RandomAccessFile csvfile = new RandomAccessFile(file,"r");
							long fileLength = csvfile.length();	//파일 총 문자 수
							long pos = fileLength-1;	//제일 마지막 line
							String line = "";
							String activeflag = "";
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
									if(macaddress.equals(temp[1]))
									{
										//WDTMonitoring
										if("0".equals(temp[9]))
										{
											activeflag = "DEAD";
										}
										else
										{
											activeflag = "ACTIVE";
										}
										
										if(!"0".equals(temp[3]))
										{
											//RED
											status.put("EQP_PART", eqppart);
											status.put("EQP_NAME", eqpname);
											status.put("RED_STATUS", "ON");
											status.put("RED_VALUE", temp[3]);
											status.put("ACTIVE_FLAG", activeflag);
											status.put("USER_NAME", username);
										}
										else
										{
											//RED
											status.put("EQP_PART", eqppart);
											status.put("EQP_NAME", eqpname);
											status.put("RED_STATUS", "OFF");
											status.put("RED_VALUE", temp[3]);
											status.put("ACTIVE_FLAG", activeflag);
											status.put("USER_NAME", username);
										}
										if(!"0".equals(temp[4]))
										{
											//AMBER
											status.put("EQP_PART", eqppart);
											status.put("EQP_NAME", eqpname);
											status.put("AMBER_STATUS", "ON");
											status.put("AMBER_VALUE", temp[4]);
											status.put("ACTIVE_FLAG", activeflag);
											status.put("USER_NAME", username);
										}
										else
										{
											//AMBER
											status.put("EQP_PART", eqppart);
											status.put("EQP_NAME", eqpname);
											status.put("AMBER_STATUS", "OFF");
											status.put("AMBER_STATUS", temp[3]);
											status.put("ACTIVE_FLAG", activeflag);
											status.put("USER_NAME", username);
										}
										if(!"0".equals(temp[5]))
										{
											//GREEN
											status.put("EQP_PART", eqppart);
											status.put("EQP_NAME", eqpname);
											status.put("GREEN_STATUS", "ON");
											status.put("GREEN_VALUE", temp[5]);
											status.put("ACTIVE_FLAG", activeflag);
											status.put("USER_NAME", username);
										}
										else
										{
											//GREEN
											status.put("EQP_PART", eqppart);
											status.put("EQP_NAME", eqpname);
											status.put("GREEN_STATUS", "OFF");
											status.put("GREEN_VALUE", temp[5]);
											status.put("ACTIVE_FLAG", activeflag);
											status.put("USER_NAME", username);
										}
										if(!"0".equals(temp[6]))
										{
											//BLUE
											status.put("EQP_PART", eqppart);
											status.put("EQP_NAME", eqpname);
											status.put("BLUE_STATUS", "ON");
											status.put("BLUE_VALUE", temp[6]);
											status.put("ACTIVE_FLAG", activeflag);
											status.put("USER_NAME", username);
										}
										else
										{
											//BLUE
											status.put("EQP_PART", eqppart);
											status.put("EQP_NAME", eqpname);
											status.put("BLUE_STATUS", "OFF");
											status.put("BLUE_VALUE", temp[6]);
											status.put("ACTIVE_FLAG", activeflag);
											status.put("USER_NAME", username);
										}
										if(!"0".equals(temp[7]))
										{
											//WHITE
											status.put("EQP_PART", eqppart);
											status.put("EQP_NAME", eqpname);
											status.put("WHITE_STATUS", "ON");
											status.put("WHITE_VALUE", temp[7]);
											status.put("ACTIVE_FLAG", activeflag);
											status.put("USER_NAME", username);
										}
										else
										{
											//WHITE
											status.put("EQP_PART", eqppart);
											status.put("EQP_NAME", eqpname);
											status.put("WHITE_STATUS", "OFF");
											status.put("WHITE_VALUE", temp[7]);
											status.put("ACTIVE_FLAG", activeflag);
											status.put("USER_NAME", username);
										}
										
										resultStatus.add(status);
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
				}	//for 종료
			}
			model.addAttribute("resultStatus", resultStatus);
		                 
		}
		catch(Exception e){
			System.out.println("[/mobile/model_eqp_status.do] Exception :: " + e.toString());
			e.printStackTrace();
		}
		
		return "mobile/model_eqp_status";
	
	}
	
}
