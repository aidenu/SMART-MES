package smart.common;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import egovframework.com.cmm.LoginVO;
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
	
	
	@RequestMapping(value = "/smart/common/SmartDashBoard.do")
	public String SmartDashBoard(
			ModelMap model) throws Exception {
		
		try {
			
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			
			model.addAttribute("userid", loginVO.getId());
			model.addAttribute("useremail", loginVO.getEmail());
			
		} catch(Exception e) {
			logger.error("[/smart/common/SmartDashBoard.do] Exception :: " + e.toString());
		}
		
		return "smart/common/SmartDashBoard";
	}
	
	@RequestMapping(value = "/smart/common/SmartBasicData.do")
	public String getSmartBasicDataPage(ModelMap model) throws Exception {
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
    	if(!isAuthenticated) {
    		model.addAttribute("sessionmessage", "session expire");
    		return "uat/uia/EgovLoginUsr";
    	}
    	
    	
    	LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
    	
    	HashMap<String,String> hp = new HashMap<String,String>();
		hp.put("userid", loginVO.getId());
		
		List<HashMap> result = SmartCommonDAO.commonDataProc("selectUserRoleData",hp);
    	model.addAttribute("result", result.get(0).get("AUTHOR_CODE"));
    	
    	return "smart/common/SmartBasicData";
	}
	
	
	
	@RequestMapping(value = "/smart/common/SmartBasicDataList.do")
	public String getSmartBasicDataListPage(
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
	public String getSmartBasicDataActionPage(
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
	
	
	//화면 우측 상단의 알림 리스트 가져오기
	@RequestMapping("/smart/common/SmartAlarm.do")
    public String SmartAlarm(
    		ModelMap model
    		)throws Exception {

		return "smart/common/SmartAlarm";
    }
		
	
	//화면 우측 상단의 알림 리스트 가져오기
	@RequestMapping("/smart/common/SmartAlarmList.do")
    public String SmartAlarmList(
    		@RequestParam(value="gubun", required=false) String gubun,
    		@RequestParam(value="startDateField", required=false) String startDateField,
    		@RequestParam(value="endDateField", required=false) String endDateField,
    		ModelMap model
    		)throws Exception {

		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
    	if(!isAuthenticated) {
    		model.addAttribute("sessionmessage", "session expire");
    		return "uat/uia/EgovLoginUsr";
    	}
    	
		try{
			
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			hp.put("gubun", gubun);
			hp.put("startDateField", startDateField);
			hp.put("endDateField", endDateField);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("getAlarmList",hp);
			
			model.addAttribute("result", result);
		}
		catch(Exception e){
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
	
	
	
	@RequestMapping("/smart/common/SmartLogInfo.do")
    public String SmartLogInfo(
    		ModelMap model
    		)throws Exception {

		return "smart/common/SmartLogInfo";
    }
	
	
	
	@RequestMapping("/smart/common/SmartLogInfoList.do")
    public String SmartLogInfoList(
    		@RequestParam(value="startDateField", required=false) String startDateField,
    		@RequestParam(value="endDateField", required=false) String endDateField,
    		@RequestParam(value="pageno", required=false) int pageno,
    		ModelMap model
    		)throws Exception {

		try{
			
			HashMap<String,String> hp = new HashMap<String,String>();
			
			hp.put("startdate", startDateField);
			hp.put("enddate", endDateField);
			
			List<HashMap> resultTotalCnt = SmartCommonDAO.commonDataProc("getLogInfoListTotalCntProc",hp);
			
			hp.put("pageno", String.valueOf(pageno));
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("getLogInfoList",hp);
			
			model.addAttribute("result", result);
			
			if(resultTotalCnt != null && resultTotalCnt.size()>0)
			{
				SmartPagingMgr smartPagingMgr = new SmartPagingMgr(pageno,20,20,Integer.parseInt(resultTotalCnt.get(0).get("TOTAL_CNT").toString()));//현재페이지번호,페이지당출력갯수,페이지번호갯수,전체갯수
				model.addAttribute("paginationInfo", smartPagingMgr.print());
			}
		}
		catch(Exception e){
			logger.error("[/smart/common/SmartLogInfoList.do] Exception :: " + e.toString());
		}
		
		return "smart/common/SmartLogInfoList";
    }
	
	
	
	//화면 우측 상단의 어플설치 화면
	@RequestMapping("/smart/common/SmartMobileApp.do")
    public String smartProductDescSave(
    		ModelMap model
            )throws Exception {
				
		return "smart/common/SmartMobileApp";
    }
	
}