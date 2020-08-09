package smart.work;

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
public class SmartWorkController {
	
	
	Logger logger = Logger.getLogger("egovframework");
	
	@Resource(name="smartCommonDAO")
	private SmartCommonDAOImpl SmartCommonDAO;
		
	@Resource(name="messageSource")
	MessageSource messageSource ;
		
	@Resource(name = "propertiesService")
    protected EgovPropertyService propertyService;
	
	
	@RequestMapping("/smart/work/SmartSiteWork.do")
	public String SmartSiteWork (
			@RequestParam(value="startDate", required=false) String startDate,
			@RequestParam(value="endDate", required=false) String endDate,
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
			logger.error("[/smart/work/SmartSiteWork.do] Exception :: " + e.toString());
		}
		
		return "smart/work/SmartSiteWork";
	}
	
	@RequestMapping("/smart/work/SmartSiteWorkModelData.do")
	@ResponseBody
	public List<HashMap> SmartSiteWorkModelData(
			@RequestParam(value="startDate", required=false) String startDate,
			@RequestParam(value="endDate", required=false) String endDate,
			ModelMap model) throws Exception {
		
		List<HashMap> result  = null;
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("startDate", startDate);
			hp.put("endDate", endDate);
			
			result = SmartCommonDAO.commonDataProc("getSiteWorkModelData", hp);
			model.addAttribute("result", result);
			
		} catch(Exception e) {
			logger.error("[/smart/work/SmartSiteWorkModelData.do] Exception :: " + e.toString());
		}
		
		return result;
	}
	
	@RequestMapping(value="/smart/work/SmartSiteWorkData.do")
	@ResponseBody
	public List<HashMap> SmartSiteWorkData(
			@RequestParam(value="modelid", required=false) String modelid,
			ModelMap model) throws Exception {
		
		List<HashMap> result = null;
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("modelid", modelid);
			
			result = SmartCommonDAO.commonDataProc("getSiteWorkData", hp);
			
		} catch(Exception e) {
			logger.error("[/smart/work/SmartSiteWorkData.do] Exception :: " + e.toString());
		}
		return result;
	}
	
	
	@RequestMapping(value="/smart/work/SmartSiteWorkSave.do")
	@ResponseBody
	public String SmartSiteWorkSave(
			@RequestParam(value="actiontype", required=false) String actiontype,
			@RequestParam(value="modelid", required=false) String modelid,
			@RequestParam(value="partgroupid", required=false) String partgroupid,
			@RequestParam(value="workid", required=false) String workid,
			ModelMap model) throws Exception {
		
		String actionresult = "";
		
		try {
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			hp.put("actiontype", actiontype);
			hp.put("modelid", modelid);
			hp.put("partgroupid", partgroupid);
			hp.put("workid", workid);
			
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("setSiteWorkDataSave", hp);
			
			if(result != null && result.size() > 0) {
				actionresult = result.get(0).get("ACTION_RESULT").toString();
			}
			
		} catch(Exception e) {
			logger.error("[/smart/work/SmartSiteWorkSave.do] Exception :: " + e.toString());
		}
		
		return actionresult;
	}
	
	
	@RequestMapping(value="/smart/work/SmartOutWork.do")
	public String SmartOutWork(
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
			logger.error("[/smart/work/SmartOutWork.do] Exception :: " + e.toString());
		}
		
		return "smart/work/SmartOutWork";
	}
	
	
	@RequestMapping("/smart/work/SmartOutWorkModelData.do")
	@ResponseBody
	public List<HashMap> SmartOutWorkModelData(
			@RequestParam(value="startDate", required=false) String startDate,
			@RequestParam(value="endDate", required=false) String endDate,
			ModelMap model) throws Exception {
		
		List<HashMap> result  = null;
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("startDate", startDate);
			hp.put("endDate", endDate);
			
			result = SmartCommonDAO.commonDataProc("getOutWorkModelData", hp);
			model.addAttribute("result", result);
			
		} catch(Exception e) {
			logger.error("[/smart/work/SmartOutWorkModelData.do] Exception :: " + e.toString());
		}
		
		return result;
	}
	
	@RequestMapping(value="/smart/work/SmartOutWorkData.do")
	@ResponseBody
	public List<HashMap> SmartOutWorkData(
			@RequestParam(value="modelid", required=false) String modelid,
			ModelMap model) throws Exception {
		
		List<HashMap> result = null;
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("modelid", modelid);
			
			result = SmartCommonDAO.commonDataProc("getOutWorkData", hp);
			
		} catch(Exception e) {
			logger.error("[/smart/work/SmartOutWorkData.do] Exception :: " + e.toString());
		}
		return result;
	}
	
	
	@RequestMapping(value="/smart/work/SmartOutWorkSave.do")
	@ResponseBody
	public String SmartOutWorkSave(
			@RequestParam(value="actiontype", required=false) String actiontype,
			@RequestParam(value="modelid", required=false) String modelid,
			@RequestParam(value="partgroupid", required=false) String partgroupid,
			@RequestParam(value="workid", required=false) String workid,
			ModelMap model) throws Exception {
		
		String actionresult = "";
		
		try {
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			hp.put("actiontype", actiontype);
			hp.put("modelid", modelid);
			hp.put("partgroupid", partgroupid);
			hp.put("workid", workid);
			
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("setOutWorkDataSave", hp);
			
			if(result != null && result.size() > 0) {
				actionresult = result.get(0).get("ACTION_RESULT").toString();
			}
			
		} catch(Exception e) {
			logger.error("[/smart/work/SmartOutWorkSave.do] Exception :: " + e.toString());
		}
		
		return actionresult;
	}
	
	
}
