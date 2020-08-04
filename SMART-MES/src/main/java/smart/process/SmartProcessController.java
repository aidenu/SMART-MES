package smart.process;

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
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import smart.common.SmartCommonDAOImpl;

@Controller
public class SmartProcessController {

	Logger logger = Logger.getLogger("egovframework");
	
	@Resource(name="smartCommonDAO")
	private SmartCommonDAOImpl SmartCommonDAO;
		
	@Resource(name="messageSource")
	MessageSource messageSource ;
		
	@Resource(name = "propertiesService")
    protected EgovPropertyService propertyService;
	
	@RequestMapping("/smart/process/SmartSchedule.do")
	public String SmartSchedule(
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
			logger.error("[/smart/process/SmartSchedule.do] Exception :: " + e.toString());
		}
		
		return "smart/process/SmartSchedule";
	}
	
	@RequestMapping("/smart/process/SmartScheduleData.do")
	@ResponseBody
	public List<HashMap> SmartScheduleData(
			@RequestParam(value="startDate", required=false) String startDate,
			@RequestParam(value="endDate", required=false) String endDate,
			ModelMap model) throws Exception {
		
		List<HashMap> result = null;
		
		try {
			
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("startDate", startDate);
			hp.put("endDate", endDate);
			hp.put("userid", loginVO.getId());
			
			result = SmartCommonDAO.commonDataProc("getScheduleModelData", hp);
			model.addAttribute("result", result);
			
		} catch(Exception e) {
			logger.error("[/smart/process/SmartScheduleData.do] Exception :: " + e.toString());
		}
		
		return result;
	}
	
	
	@RequestMapping("/smart/process/SmartScheduleView.do")
	public String SmartScheduleView(
			@RequestParam(value="modelid", required=false) String modelid,
			@RequestParam(value="modelno", required=false) String modelno,
			ModelMap model) throws Exception {
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("modelid", modelid);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("getScheduleData", hp);
			model.addAttribute("result", result);
			
			
			model.addAttribute("modelid", modelid);
			model.addAttribute("modelno", modelno);
			
		} catch(Exception e) {
			e.printStackTrace();
			logger.error("[/smart/process/SmartScheduleView.do] Exception :: " + e.toString());
		}
		
		return "smart/process/SmartScheduleView";
	}
	
	
	@RequestMapping(value="/smart/process/SmartScheduleAddData.do")
	@ResponseBody
	public String SmartScheduleAddData(
			@RequestParam(value="modelid", required=false) String modelid,
			@RequestParam(value="scheduleName", required=false) String scheduleName,
			@RequestParam(value="dependSchedule", required=false) String dependSchedule,
			@RequestParam(value="startdate", required=false) String startdate,
			@RequestParam(value="enddate", required=false) String enddate,
			ModelMap model) throws Exception {
		
		String actionresult = "";
		
		try {
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			hp.put("modelid", modelid);
			hp.put("scheduleName", scheduleName);
			hp.put("dependSchedule", dependSchedule);
			hp.put("startdate", startdate);
			hp.put("enddate", enddate);
			
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("setScheduleAdd", hp);
			if(result != null && result.size() > 0) {
				actionresult = result.get(0).get("ACTION_RESULT").toString();
			}
			
		} catch(Exception e) {
			logger.error("[/smart/process/SmartScheduleAddData.do] Exception :: " + e.toString());
		}
		
		return actionresult;
	}
	
	
	@RequestMapping(value="/smart/process/SmartScheduleDeleteData.do")
	@ResponseBody
	public String SmartScheduleDeleteData(
			@RequestParam(value="modelid", required=false) String modelid,
			@RequestParam(value="scheduleid", required=false) String scheduleid,
			ModelMap model) throws Exception {
		
		String actionresult = "";
		
		try {
			
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			hp.put("modelid", modelid);
			hp.put("scheduleid", scheduleid);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("setScheduleDelete", hp);
			if(result != null && result.size() > 0) {
				actionresult = result.get(0).get("ACTION_RESULT").toString();
			}
			
		} catch(Exception e) {
			logger.error("[/smart/process/SmartScheduleDeleteData.do] Exception :: " + e.toString());
		}
		
		return actionresult;
	}
	
	
	@RequestMapping(value="/smart/process/SmartScheduleSaveData.do")
	@ResponseBody
	public String SmartScheduleSaveData(
			@RequestParam(value="modelid", required=false) String modelid,
			@RequestParam(value="arraystr", required=false) String arraystr,
			ModelMap model) throws Exception {
		
		String actionresult = "";
		
		try {
			
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			hp.put("modelid", modelid);
			hp.put("arraystr", arraystr);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("setScheduleSave", hp);
			if(result != null && result.size() > 0) {
				actionresult = result.get(0).get("ACTION_RESULT").toString();
			}
			
		} catch(Exception e) {
			logger.error("[/smart/process/SmartScheduleSaveData.do] Exception :: " + e.toString());
		}
		
		return actionresult;
	}
	
	@RequestMapping(value="/smart/process/SmartScheduleViewData.do")
	@ResponseBody
	public List<HashMap> SmartScheduleViewData(
			@RequestParam(value="modelid", required=false) String modelid,
			ModelMap model) throws Exception {
		
		List<HashMap> result = null;
		
		try {

			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("modelid", modelid);
			
			result = SmartCommonDAO.commonDataProc("getScheduleData", hp);
			model.addAttribute("result", result);
			
			
		} catch(Exception e) {
			logger.error("[/smart/process/SmartScheduleViewData.do] Exception :: " + e.toString());
		}
		
		return result;
	}
	
	
	@RequestMapping(value="/smart/process/SmartProcManage.do")
	public String SmartProcManage(
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
			logger.error("[/smart/process/SmartProcManage.do] Exception :: " + e.toString());
		}
		
		return "/smart/process/SmartProcManage";
	}
	
	@RequestMapping(value="/smart/process/SmartProcManageData.do")
	@ResponseBody
	public List<HashMap> SmartProcManageData(
			@RequestParam(value="startDate", required=false) String startDate,
			@RequestParam(value="endDate", required=false) String endDate,
			ModelMap model) throws Exception {
		
		List<HashMap> result = null;
		
		try {
			
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("startDate", startDate);
			hp.put("endDate", endDate);
			hp.put("userid", loginVO.getId());
			
			result = SmartCommonDAO.commonDataProc("getProcManageModelData", hp);
			model.addAttribute("result", result);
			
		} catch(Exception e) {
			logger.error("[/smart/process/SmartProcManageData.do] Exception :: " + e.toString());
		}
		
		return result;
	}
	
	
	@RequestMapping(value="/smart/process/SmartProcManageSched.do")
	@ResponseBody
	public List<HashMap> SmartProcManageSched(
			@RequestParam(value="modelid", required=false) String modelid,
			ModelMap model) throws Exception {
		
		List<HashMap> result = null;
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("modelid", modelid);
			
			result = SmartCommonDAO.commonDataProc("getProcSchedule", hp);
			
			
		} catch(Exception e) {
			logger.error("[/smart/process/SmartProcManageSched.do] Exception :: " + e.toString());
		}
		
		return result;
	}
	
	
	@RequestMapping(value="/smart/process/SmartProcManagePartSched.do")
	@ResponseBody
	public List<HashMap> SmartProcManagePartSched(
			@RequestParam(value="modelid", required=false) String modelid,
			@RequestParam(value="partgroupid", required=false) String partgroupid,
			ModelMap model) throws Exception {
		
		List<HashMap> result = null;
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("modelid",modelid);
			hp.put("partgroupid", partgroupid);
			
			result = SmartCommonDAO.commonDataProc("getPartSchedule", hp);
			model.addAttribute("result", result);
			
		} catch(Exception e) {
			logger.error("[/smart/process/SmartProcManagePartSched.dp] Exception :: " + e.toString());
		}
		
		return result;
	}
	
	
	@RequestMapping(value="/smart/process/SmartProcManagePartSchedAdd.do")
	@ResponseBody
	public String SmartProcManagePartSchedAdd(
			@RequestParam(value="modelid", required=false) String modelid,
			@RequestParam(value="partgroupid", required=false) String partgroupid,
			@RequestParam(value="workname", required=false) String workname,
			@RequestParam(value="startdate", required=false) String startdate,
			@RequestParam(value="enddate", required=false) String enddate,
			ModelMap model) throws Exception {
		
		String actionresult = "";
		
		try {
			
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			
			HashMap<String, String> hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			hp.put("modelid", modelid);
			hp.put("partgroupid", partgroupid);
			hp.put("workname", workname);
			hp.put("startdate", startdate);
			hp.put("enddate", enddate);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("setPartScheduleAdd", hp);
			if(result != null && result.size() > 0) {
				actionresult = result.get(0).get("ACTION_RESULT").toString();
			}
			
		} catch(Exception e) {
			logger.error("[/smart/process/SmartProcManagePartSchedAdd.do] Exception :: " + e.toString());
		}
		
		return actionresult;
	}
	
	
	@RequestMapping(value="/smart/process/SmartProcManagePartSchedDel.do")
	@ResponseBody
	public String SmartProcManagePartSchedDel(
			@RequestParam(value="modelid", required=false) String modelid,
			@RequestParam(value="partgroupid", required=false) String partgroupid,
			@RequestParam(value="workid", required=false) String workid,
			ModelMap model) throws Exception {
		
		String actionresult = "";
		
		try {
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			hp.put("modelid", modelid);
			hp.put("partgroupid", partgroupid);
			hp.put("workid", workid);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("setPartScheduleDel", hp);
			
			if(result != null && result.size() > 0) {
				actionresult = result.get(0).get("ACTION_RESULT").toString();
			}
			
		} catch(Exception e) {
			logger.error("[/smart/process/SmartProcManagePartSchedDel.do] Exception :: " + e.toString());
		}
		
		return actionresult;
	}
	
}
