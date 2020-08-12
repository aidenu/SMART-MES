package smart.assembly;

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
public class SmartAssemblyController {
	
	
	Logger logger = Logger.getLogger("egovframework");
	
	@Resource(name="smartCommonDAO")
	private SmartCommonDAOImpl SmartCommonDAO;
		
	@Resource(name="messageSource")
	MessageSource messageSource ;
		
	@Resource(name = "propertiesService")
    protected EgovPropertyService propertyService;
	
	
	@RequestMapping("/smart/assembly/SmartAssembly.do")
	public String SmartAssembly (
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
			logger.error("[/smart/assembly/SmartAssembly.do] Exception :: " + e.toString());
		}
		
		return "smart/assembly/SmartAssembly";
	}
	
	@RequestMapping("/smart/assembly/SmartAssemblyModelData.do")
	@ResponseBody
	public List<HashMap> SmartAssemblyModelData(
			@RequestParam(value="startDate", required=false) String startDate,
			@RequestParam(value="endDate", required=false) String endDate,
			ModelMap model) throws Exception {
		
		List<HashMap> result  = null;
		try {
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("startDate", startDate);
			hp.put("endDate", endDate);
			hp.put("userid", loginVO.getId());
			
			result = SmartCommonDAO.commonDataProc("getAssemblyModelData", hp);
			model.addAttribute("result", result);
			
		} catch(Exception e) {
			logger.error("[/smart/assembly/SmartAssemblyModelData.do] Exception :: " + e.toString());
		}
		
		return result;
	}
	
	@RequestMapping(value="/smart/assembly/SmartAssemblyData.do")
	public String SmartAssemblyData(
			@RequestParam(value="modelid", required=false) String modelid,
			ModelMap model) throws Exception {
		
		List<HashMap> result = null;
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("modelid", modelid);
			
			result = SmartCommonDAO.commonDataProc("getAssemblyData", hp);
			model.addAttribute("result", result);
			
			List<HashMap> resultWork = SmartCommonDAO.commonDataProc("getAssemblyWorkDate", hp);
			if(resultWork != null && resultWork.size() > 0) {
				model.addAttribute("ASSEMBLY_START_DATE", resultWork.get(0).get("ASSEMBLY_START_DATE"));
				model.addAttribute("ASSEMBLY_END_DATE", resultWork.get(0).get("ASSEMBLY_END_DATE"));
			}
			
			model.addAttribute("modelid", modelid);
			
		} catch(Exception e) {
			logger.error("[/smart/assembly/SmartAssemblyData.do] Exception :: " + e.toString());
		}
		
		return "smart/assembly/SmartAssemblyData";
	}
	
	
	@RequestMapping(value="/smart/assembly/SmartAssemblyWorkSave.do")
	@ResponseBody
	public String SmartAssemblyWorkSave(
			@RequestParam(value="modelid", required=false) String modelid,
			@RequestParam(value="actiontype", required=false) String actiontype,
			ModelMap model) throws Exception {
		
		String actionresult = "";
		
		try {
			
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			hp.put("modelid", modelid);
			hp.put("actiontype", actiontype);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("setAssemblyWorkSave", hp);
			if(result != null && result.size() > 0) {
				actionresult = result.get(0).get("ACTION_RESULT").toString();
			}
			
		} catch(Exception e) {
			logger.error("[/smart/assembkly/SmartAssemblyWorkSave.do] Exception :: " + e.toString());
		}
		
		
		return actionresult;
	}
	
	
	@RequestMapping(value="/smart/assembly/SmartAssemblyWorkChange.do")
	@ResponseBody
	public String SmartAssemblyWorkChange(
			@RequestParam(value="modelid", required=false) String modelid,
			@RequestParam(value="startdate", required=false) String startdate,
			@RequestParam(value="enddate", required=false) String enddate,
			ModelMap model) throws Exception {
		
		String actionresult = "";
		
		try {
			
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			hp.put("modelid", modelid);
			hp.put("startdate", startdate);
			hp.put("enddate", enddate);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("setAssemblyWorkChange", hp);
			if(result != null && result.size() > 0) {
				actionresult = result.get(0).get("ACTION_RESULT").toString();
			}
			
		} catch(Exception e) {
			logger.error("[/smart/assembly/SmartAssemblyWorkChange.do] Exception :: " + e.toString());
		}

		return actionresult;
	}
	
}
