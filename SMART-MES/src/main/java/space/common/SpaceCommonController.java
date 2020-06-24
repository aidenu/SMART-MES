package space.common;

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
public class SpaceCommonController {

	Logger logger = Logger.getLogger("egovframework");
	
	@Resource(name="spaceCommonDAO")
	private SpaceCommonDAOImpl spaceCommonDAO;
		
	@Resource(name="messageSource")
	MessageSource messageSource ;
		
	@Resource(name = "propertiesService")
    protected EgovPropertyService propertyService;
		
	@Resource(name = "egovFileIdGnrService")
    private EgovIdGnrService idgenService;
	
	@Resource(name="spaceGcmSender")
	private SpaceGcmSender spaceGcmSender; 
	
	
	
	//화면 우측 상단의 알림 리스트 가져오기
	@RequestMapping("/space/common/SpaceAlarm.do")
    public String SpaceAlarm(
    		ModelMap model
    		)throws Exception {

		return "space/common/SpaceAlarm";
    }
		
	
	//화면 우측 상단의 알림 리스트 가져오기
	@RequestMapping("/space/common/SpaceAlarmList.do")
    public String SpaceAlarmList(
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
			
			List<HashMap> result = spaceCommonDAO.commonDataProc("getAlarmList",hp);
			
			model.addAttribute("result", result);
		}
		catch(Exception e){
			logger.error("[/space/common/SpaceAlarmList.do] Exception :: " + e.toString());
		}
		
		return "space/common/SpaceAlarmList";
    }
	
	
	
	//알림 확인 처리
	@RequestMapping(value = "/space/common/SpaceAlarmSave.do")
	public String SpaceAlarmSave(
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
			
			List<HashMap>  resultPart  =  spaceCommonDAO.commonDataProc("setAlarmSave",hp);
			
    		model.addAttribute("actionresult", resultPart.get(0).get("ACTION_RESULT").toString());
    		
    	}
    	catch(Exception e){
			logger.error("[/space/common/SpaceAlarmSave.do] Exception :: " + e.toString());
		}
    	
		return "space/common/SpaceAlarmSave";
	}
	
	
	
	@RequestMapping("/space/common/SpaceLogInfo.do")
    public String SpaceLogInfo(
    		ModelMap model
    		)throws Exception {

		return "space/common/SpaceLogInfo";
    }
	
	
	
	@RequestMapping("/space/common/SpaceLogInfoList.do")
    public String SpaceLogInfoList(
    		@RequestParam(value="startDateField", required=false) String startDateField,
    		@RequestParam(value="endDateField", required=false) String endDateField,
    		@RequestParam(value="pageno", required=false) int pageno,
    		ModelMap model
    		)throws Exception {

		try{
			
			HashMap<String,String> hp = new HashMap<String,String>();
			
			hp.put("startdate", startDateField);
			hp.put("enddate", endDateField);
			
			List<HashMap> resultTotalCnt = spaceCommonDAO.commonDataProc("getLogInfoListTotalCntProc",hp);
			
			hp.put("pageno", String.valueOf(pageno));
			
			List<HashMap> result = spaceCommonDAO.commonDataProc("getLogInfoList",hp);
			
			model.addAttribute("result", result);
			
			if(resultTotalCnt != null && resultTotalCnt.size()>0)
			{
				SpacePagingMgr spacePagingMgr = new SpacePagingMgr(pageno,20,20,Integer.parseInt(resultTotalCnt.get(0).get("TOTAL_CNT").toString()));//현재페이지번호,페이지당출력갯수,페이지번호갯수,전체갯수
				model.addAttribute("paginationInfo", spacePagingMgr.print());
			}
		}
		catch(Exception e){
			logger.error("[/space/common/SpaceLogInfoList.do] Exception :: " + e.toString());
		}
		
		return "space/common/SpaceLogInfoList";
    }
	
	
	
	//화면 우측 상단의 어플설치 화면
	@RequestMapping("/space/common/SpaceMobileApp.do")
    public String spaceProductDescSave(
    		ModelMap model
            )throws Exception {
				
		return "space/common/SpaceMobileApp";
    }
	
}