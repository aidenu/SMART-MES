package smes.common;

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
public class SmesCommonController {

	Logger logger = Logger.getLogger("egovframework");
	
	@Resource(name="SmesCommonDAO")
	private SmesCommonDAOImpl SmesCommonDAO;
		
	@Resource(name="messageSource")
	MessageSource messageSource ;
		
	@Resource(name = "propertiesService")
    protected EgovPropertyService propertyService;
		
	@Resource(name = "egovFileIdGnrService")
    private EgovIdGnrService idgenService;
	
	@Resource(name="smesGcmSender")
	private SmesGcmSender smesGcmSender; 
	
	
	@RequestMapping(value = "/smes/common/SmesBasicData.do")
	public String getSmesBasicDataPage(ModelMap model) throws Exception {
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
    	if(!isAuthenticated) {
    		model.addAttribute("sessionmessage", "session expire");
    		return "uat/uia/EgovLoginUsr";
    	}
    	
    	
    	LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
    	
    	HashMap<String,String> hp = new HashMap<String,String>();
		hp.put("userid", loginVO.getId());
		
		List<HashMap> result = SmesCommonDAO.commonDataProc("selectUserRoleData",hp);
    	model.addAttribute("result", result.get(0).get("AUTHOR_CODE"));
    	
    	return "smes/common/SmesBasicData";
	}
	
	
	
	@RequestMapping(value = "/smes/common/SmesBasicDataList.do")
	public String getSmesBasicDataListPage(
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
			    	
	    	List<HashMap> result = SmesCommonDAO.commonDataProc("selectBasicDataList",hp);
			
	    	model.addAttribute("actiontype", "select");
	    	model.addAttribute("actionlevel", actionlevel);
			model.addAttribute("basicdatalist", result);
    	}
    	catch(Exception e){
			logger.error("[/smes/common/SmesBasicDataList.do] Exception :: " + e.toString());
		}
				    	
		return "smes/common/SmesBasicDataList";
	}
	
	
	
	@RequestMapping(value = "/smes/common/SmesBasicDataAction.do")
	public String getSmesBasicDataActionPage(
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
	    	
	    	List<HashMap> result = SmesCommonDAO.commonDataProc("updateBasicDataList",hp);
	    	model.addAttribute("actionlevel", actionlevel);
	    	model.addAttribute("parentid", parentid);
			model.addAttribute("result", result.get(0).get("out_data"));
    	}
    	catch(Exception e){
			logger.error("[/smes/common/SmesBasicDataAction.do] Exception :: " + e.toString());
		}
    	
		return "smes/common/SmesBasicDataResult";
	}
	
	
	//화면 우측 상단의 알림 리스트 가져오기
	@RequestMapping("/smes/common/SmesAlarm.do")
    public String SmesAlarm(
    		ModelMap model
    		)throws Exception {

		return "smes/common/SmesAlarm";
    }
		
	
	//화면 우측 상단의 알림 리스트 가져오기
	@RequestMapping("/smes/common/SmesAlarmList.do")
    public String SmesAlarmList(
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
			
			List<HashMap> result = SmesCommonDAO.commonDataProc("getAlarmList",hp);
			
			model.addAttribute("result", result);
		}
		catch(Exception e){
			logger.error("[/smes/common/SmesAlarmList.do] Exception :: " + e.toString());
		}
		
		return "smes/common/SmesAlarmList";
    }
	
	
	
	//알림 확인 처리
	@RequestMapping(value = "/smes/common/SmesAlarmSave.do")
	public String SmesAlarmSave(
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
			
			List<HashMap>  resultPart  =  SmesCommonDAO.commonDataProc("setAlarmSave",hp);
			
    		model.addAttribute("actionresult", resultPart.get(0).get("ACTION_RESULT").toString());
    		
    	}
    	catch(Exception e){
			logger.error("[/smes/common/SmesAlarmSave.do] Exception :: " + e.toString());
		}
    	
		return "smes/common/SmesAlarmSave";
	}
	
	
	
	@RequestMapping("/smes/common/SmesLogInfo.do")
    public String SmesLogInfo(
    		ModelMap model
    		)throws Exception {

		return "smes/common/SmesLogInfo";
    }
	
	
	
	@RequestMapping("/smes/common/SmesLogInfoList.do")
    public String SmesLogInfoList(
    		@RequestParam(value="startDateField", required=false) String startDateField,
    		@RequestParam(value="endDateField", required=false) String endDateField,
    		@RequestParam(value="pageno", required=false) int pageno,
    		ModelMap model
    		)throws Exception {

		try{
			
			HashMap<String,String> hp = new HashMap<String,String>();
			
			hp.put("startdate", startDateField);
			hp.put("enddate", endDateField);
			
			List<HashMap> resultTotalCnt = SmesCommonDAO.commonDataProc("getLogInfoListTotalCntProc",hp);
			
			hp.put("pageno", String.valueOf(pageno));
			
			List<HashMap> result = SmesCommonDAO.commonDataProc("getLogInfoList",hp);
			
			model.addAttribute("result", result);
			
			if(resultTotalCnt != null && resultTotalCnt.size()>0)
			{
				SmesPagingMgr smesPagingMgr = new SmesPagingMgr(pageno,20,20,Integer.parseInt(resultTotalCnt.get(0).get("TOTAL_CNT").toString()));//현재페이지번호,페이지당출력갯수,페이지번호갯수,전체갯수
				model.addAttribute("paginationInfo", smesPagingMgr.print());
			}
		}
		catch(Exception e){
			logger.error("[/smes/common/SmesLogInfoList.do] Exception :: " + e.toString());
		}
		
		return "smes/common/SmesLogInfoList";
    }
	
	
	
	//화면 우측 상단의 어플설치 화면
	@RequestMapping("/smes/common/SmesMobileApp.do")
    public String smesProductDescSave(
    		ModelMap model
            )throws Exception {
				
		return "smes/common/SmesMobileApp";
    }
	
}