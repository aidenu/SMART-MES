package smart.common;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.LoginVO;
import egovframework.let.uss.umt.service.EgovUserManageService;
import egovframework.let.uss.umt.service.UserManageVO;
import egovframework.let.utl.sim.service.EgovFileScrty;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;

@Controller
public class SmartCommonController {

	Logger logger = Logger.getLogger("egovframework");
	
	@Resource(name="smartCommonDAO")
	private SmartCommonDAOImpl SmartCommonDAO;
		
	@Resource(name="messageSource")
	MessageSource messageSource ;
		
	@Resource(name = "propertiesService")
    protected EgovPropertyService propertyService;
		
	@Resource(name = "egovFileIdGnrService")
    private EgovIdGnrService idgenService;
	
	@Resource(name="smartGcmSender")
	private SmartGcmSender smartGcmSender; 
	
	/** userManageService */
    @Resource(name = "userManageService")
    private EgovUserManageService userManageService;
	
	
	@RequestMapping(value = "/smart/common/SmartDashBoard.do")
	public String SmartDashBoard(
			ModelMap model) throws Exception {
		
		try {
			
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			
			model.addAttribute("userid", loginVO.getId());
			model.addAttribute("username", loginVO.getName());
			model.addAttribute("useremail", loginVO.getEmail());
			
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			List<HashMap> resultAlarm = SmartCommonDAO.commonDataProc("getAlarmList", hp);
			model.addAttribute("resultAlarm", resultAlarm);			
			
		} catch(Exception e) {
			logger.error("[/smart/common/SmartDashBoard.do] Exception :: " + e.toString());
		}
		
		return "smart/common/SmartDashBoard";
	}
	
	
	@RequestMapping(value="/smart/common/SmartDashBoardModelStatus.do")
	@ResponseBody
	public List<HashMap> SmartDashBoardModelStatus(
			@RequestParam(value="gubun", required=false) String gubun,
			ModelMap model) throws Exception {
		
		List<HashMap> result = null;
		
		try {
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("startDate", "");
			hp.put("endDate", "");
			hp.put("gubun", gubun);
			
			result = SmartCommonDAO.nosessioncommonDataProc("getModelStatusData", hp);
			model.addAttribute("result", result);
			
		} catch(Exception e) {
			logger.error("[/smart/common/SmartDashBoardModelStatus.do] Exception :: " + e.toString());
		}
		
		return result;
	}
	
	
	@RequestMapping(value="/smart/common/SmartDashBoardModelSummary.do")
	@ResponseBody
	public List<HashMap> SmartDashBoardModelSummary(ModelMap model) throws Exception {
		
		List<HashMap> result = null;
		
		try {
			
			result = SmartCommonDAO.nosessioncommonDataProc("getModelSummaryStatus");
			model.addAttribute("result", result);
			
		} catch(Exception e) {
			logger.error("[/smart/common/SmartDashBoardModelSummary.do] Exception :: " + e.toString());
		}
		
		return result;
	}
	
	@RequestMapping(value="/smart/common/SmartDashBoardSodicStatus.do")
	@ResponseBody
	public List<HashMap> SmartDashBoardSodicStatus(ModelMap model) throws Exception {
		
		List<HashMap> result = null;
		
		try {
			
			result = SmartCommonDAO.commonDataProc("getSodicEqpData");
			model.addAttribute("result", result);
			
		} catch(Exception e) {
			logger.error("[/smart/common/SmartDashBoardSodicStatus.do] Exception :: " + e.toString());
		}
		
		return result;
	}
	
	
	@RequestMapping(value="/smart/common/SmartDashBoardPxStatus.do")
	@ResponseBody
	public List<HashMap> SmartDashBoardPxStatus(ModelMap model) throws Exception {
		
		
		List<HashMap> result = null;
		
		try {
			
			String fileLocate = "";
			
			List<HashMap> resultLocate = SmartCommonDAO.commonDataProc("getPxFileLocate");
			
			if(resultLocate != null && resultLocate.size() > 0)
			{
				fileLocate = resultLocate.get(0).get("FILE_LOCATE").toString();
				model.addAttribute("fileLocate", fileLocate);
			}
			
			result = SmartCommonDAO.commonDataProc("getPxEqpInfo");
			
			HashMap<String,String> status = null;
			
			File pxFile = null;
			BufferedReader filereader;
			String line = "";
			
			if(result != null && result.size() > 0)
			{
				for(int i=0; i<result.size(); i++)
				{
					String os = System.getProperty("os.name").toLowerCase();
					if (os.contains("mac")) { 
						pxFile = new File(fileLocate +"/" + result.get(i).get("FOLDER_NAME") + "/STATUS.dat");
					} else { 
						pxFile = new File(fileLocate +"\\" + result.get(i).get("FOLDER_NAME") + "\\STATUS.dat");
					}
					
					
					if(pxFile.exists())
					{
						filereader = new BufferedReader(new FileReader(pxFile));
						
						//첫번째 줄의 데이터만 출력
						while((line = filereader.readLine()) != null)
						{
							String[] lineData = line.split("\\t");
//							System.out.println(result.get(i).get("FOLDER_NAME") +"::"+ line);
							result.get(i).put("EQP_FLAG", lineData[0]);
							result.get(i).put("EQP_STATUS", lineData[1]);
							break;
						}
						
						filereader.close();
					}
				}
			}
			
		} catch(Exception e) {
			logger.error("[/smart/common/SmartDashBoardPxStatus.do] Exception :: " + e.toString());
		}
		
		return result;
	}
	
	
	@RequestMapping(value="/smart/common/SmartDashBoardPxTimeline.do")
	@ResponseBody
	public List<HashMap> SmartDashBoardPxTimeline(ModelMap model) throws Exception {
		
		List<HashMap> result = null;
		
		try {
			
			result = SmartCommonDAO.commonDataProc("getPxEqpDailyTimeline");

		} catch(Exception e) {
			logger.error("[/smart/common/SmartDashBoardPxTimeline.do] Exception :: " + e.toString());
		}
		
		return result;
	}
	
	
	@RequestMapping(value = "/smart/common/SmartBasicData.do")
	public String SmartBasicData(ModelMap model) throws Exception {
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
    	if(!isAuthenticated) {
    		model.addAttribute("sessionmessage", "session expire");
    		return "uat/uia/EgovLoginUsr";
    	}
    	try {
    		
    		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        	HashMap<String,String> hp = new HashMap<String,String>();
        	//Alarm List, userid/username/email
        	hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			List<HashMap> resultAlarm = SmartCommonDAO.commonDataProc("getAlarmList", hp);
			model.addAttribute("resultAlarm", resultAlarm);	
        	model.addAttribute("userid", loginVO.getId());
			model.addAttribute("username", loginVO.getName());
			model.addAttribute("useremail", loginVO.getEmail());
			
			hp = new HashMap<String,String>();
    		hp.put("userid", loginVO.getId());
    		
    		List<HashMap> result = SmartCommonDAO.commonDataProc("selectUserRoleData",hp);
        	model.addAttribute("result", result.get(0).get("AUTHOR_CODE"));
        	
			
			
			
    	} catch(Exception e) {
    		logger.error("[/smart/common/SmartBasicData.do] Exception :: " + e.toString());
    	}
    	return "smart/common/SmartBasicData";
	}
	
	
	
	@RequestMapping(value = "/smart/common/SmartBasicDataList.do")
	public String SmartBasicDataList(
			@RequestParam(value="actionlevel", required=false) String actionlevel,
    		@RequestParam(value="parentid", required=false) String parentid,
    		ModelMap model) throws Exception {
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
    	if(!isAuthenticated) {
    		model.addAttribute("sessionmessage", "session expire");
    		return "uat/uia/EgovLoginUsr";
    	}
		
    	try{
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("actionlevel", actionlevel);
			hp.put("parentid", parentid);
			    	
	    	List<HashMap> result = SmartCommonDAO.commonDataProc("selectBasicDataList",hp);
			
	    	model.addAttribute("actiontype", "select");
	    	model.addAttribute("actionlevel", actionlevel);
			model.addAttribute("basicdatalist", result);
    	}
    	catch(Exception e){
			logger.error("[/smart/common/SmartBasicDataList.do] Exception :: " + e.toString());
		}
				    	
		return "smart/common/SmartBasicDataList";
	}
	
	
	
	@RequestMapping(value = "/smart/common/SmartBasicDataAction.do")
	public String SmartBasicDataAction(
			@RequestParam(value="actiontype", required=false) String actiontype,
    		@RequestParam(value="actionlevel", required=false) String actionlevel,
    		@RequestParam(value="parentid", required=false) String parentid,
    		@RequestParam(value="childid", required=false) String childid,
    		@RequestParam(value="childvalue", required=false) String childvalue,
    		ModelMap model) throws Exception {
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
    	if(!isAuthenticated) {
    		model.addAttribute("sessionmessage", "session expire");
    		return "uat/uia/EgovLoginUsr";
    	}
    	
    	try{
	    	LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
	    	
	    	HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			hp.put("actiontype", actiontype);
			hp.put("actionlevel", actionlevel);
			hp.put("parentid", parentid);
			hp.put("childid", childid);
			hp.put("childvalue", childvalue);
	    	
	    	List<HashMap> result = SmartCommonDAO.commonDataProc("updateBasicDataList",hp);
	    	model.addAttribute("actionlevel", actionlevel);
	    	model.addAttribute("parentid", parentid);
			model.addAttribute("result", result.get(0).get("out_data"));
    	}
    	catch(Exception e){
			logger.error("[/smart/common/SmartBasicDataAction.do] Exception :: " + e.toString());
		}
    	
		return "smart/common/SmartBasicDataResult";
	}
	
	
	@RequestMapping(value="/smart/common/SmartAlarmList.do")
	public String SmartAlarmList(
			ModelMap model) throws Exception {
		
		try {
			
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        	HashMap<String,String> hp = new HashMap<String,String>();
        	//Alarm List
        	hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			List<HashMap> resultAlarm = SmartCommonDAO.commonDataProc("getAlarmList", hp);
			model.addAttribute("resultAlarm", resultAlarm);	
			
		} catch(Exception e) {
			logger.error("[/smart/common/SmartAlarmList.do] Exception :: " + e.toString());
		}
		return "smart/common/SmartAlarmList";
	}
	
	//알림 확인 처리
	@RequestMapping(value = "/smart/common/SmartAlarmSave.do")
	public String SmartAlarmSave(
			@RequestParam(value="arrayid", required=false) String arrayid,
			ModelMap model) throws Exception {
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
    	if(!isAuthenticated) {
    		model.addAttribute("sessionmessage", "session expire");
    		return "uat/uia/EgovLoginUsr";
    	}
    	
    	try{
    		
    		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
	    	
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			hp.put("arrayid", arrayid);
			
			List<HashMap>  resultPart  =  SmartCommonDAO.commonDataProc("setAlarmSave",hp);
			
    		model.addAttribute("actionresult", resultPart.get(0).get("ACTION_RESULT").toString());
    		
    	}
    	catch(Exception e){
			logger.error("[/smart/common/SmartAlarmSave.do] Exception :: " + e.toString());
		}
    	
		return "smart/common/SmartAlarmSave";
	}
	
	
	@RequestMapping(value="/smart/common/SmartChangePassword.do")
	@ResponseBody
	public String SmartChangePassword(
			@RequestParam(value="currentPassword", required=false) String currentPassword,
			@RequestParam(value="newPassword", required=false) String newPassword,
			@RequestParam(value="confirmPassword", required=false) String confirmPassword,
			ModelMap model) throws Exception {
		
		String actionresult = "";
		
		try {
			
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			
			String userid = loginVO.getId();
			String uniqid = loginVO.getUniqId();
			//Password 암호화
			String currentEncryptPass = EgovFileScrty.encryptPassword(currentPassword, loginVO.getId());
			String newEncryptPass = EgovFileScrty.encryptPassword(newPassword, loginVO.getId());
			String confirmEncryptPass = EgovFileScrty.encryptPassword(confirmPassword, loginVO.getId());
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("uniqid", uniqid);
			hp.put("currentEncryptPass", currentEncryptPass);
			hp.put("newEncryptPass", newEncryptPass);
			hp.put("confirmEncryptPass", confirmEncryptPass);
			List<HashMap> result = SmartCommonDAO.commonDataProc("setChgPassword", hp);
			
			if(result != null && result.size() > 0) {
				actionresult = result.get(0).get("ACTION_RESULT").toString();
			}
			
		} catch(Exception e) {
			logger.error("[/smart/common/SmartChangePassword.do] Exception :: " + e.toString());
		}
		
		return actionresult;
	}
	
	
	@RequestMapping(value="/smart/common/SmartAlarmMessageSend.do")
	@ResponseBody
	public String SmartAlarmMessageSend(
			@RequestParam(value="gubun", required=false) String gubun,
			@RequestParam(value="modelid", required=false) String modelid,
			ModelMap model) throws Exception {
		
		String actionresult = "";
		
		try {
			
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			hp.put("gubun", gubun);
			hp.put("modelid", modelid);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("setAlarmMessageSend", hp);
			
			if(result != null && result.size() > 0) {
				actionresult = result.get(0).get("ACTION_RESULT").toString();
			}
			
			
		} catch(Exception e) {
			logger.error("[/smart/common/SmartAlarmMessageSend.do] Exception :: " + e.toString());
		}
		
		return actionresult;
	}
	
	
	
	//화면 우측 상단의 어플설치 화면
	@RequestMapping("/smart/common/SmartMobileApp.do")
    public String smartProductDescSave(
    		ModelMap model
            )throws Exception {
				
		return "smart/common/SmartMobileApp";
    }
	
}