package smart.cad;

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
public class SmartCadController {
	
	
	Logger logger = Logger.getLogger("egovframework");
	
	@Resource(name="smartCommonDAO")
	private SmartCommonDAOImpl SmartCommonDAO;
		
	@Resource(name="messageSource")
	MessageSource messageSource ;
		
	@Resource(name = "propertiesService")
    protected EgovPropertyService propertyService;
	
	
	@RequestMapping("/smart/cad/SmartCad.do")
	public String SmartCad (
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
			logger.error("[/smart/cad/SmartCad.do] Exception :: " + e.toString());
		}
		
		return "smart/cad/SmartCad";
	}
	
	@RequestMapping("/smart/cad/SmartCadData.do")
	@ResponseBody
	public List<HashMap> SmartCadData(
			@RequestParam(value="startDate", required=false) String startDate,
			@RequestParam(value="endDate", required=false) String endDate,
			ModelMap model) throws Exception {
		
		List<HashMap> result  = null;
		try {
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("startDate", startDate);
			hp.put("endDate", endDate);
			hp.put("userid", loginVO.getId());
			
			result = SmartCommonDAO.commonDataProc("getCadData", hp);
			model.addAttribute("result", result);
			
		} catch(Exception e) {
			logger.error("[/smart/cad/SmartCadData.do] Exception :: " + e.toString());
		}
		
		return result;
	}
	
	
	@RequestMapping("/smart/cad/SmartCadView.do")
	public String SmartCadView(
			@RequestParam(value="modelid", required=false) String modelid,
			ModelMap model) throws Exception {
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("modelid", modelid);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("getPartList", hp);
			model.addAttribute("result", result);
			
			model.addAttribute("modelid", modelid);
			
		} catch(Exception e) {
			logger.error("[/smart/cad/SmartCadView.do] Exception :: " + e.toString());
		}
		
		return "smart/cad/SmartCadView";
	}
	
	
	@RequestMapping("/smart/cad/SmartCadPartRegist.do")
	@ResponseBody
	public String SmartCadPartRegist(
			@RequestParam(value="modelid", required=false) String modelid,
			@RequestParam(value="partgroupno", required=false) String partgroupno,
			@RequestParam(value="partgroupname", required=false) String partgroupname,
			@RequestParam(value="partgroupsize", required=false) String partgroupsize,
			@RequestParam(value="partgroupmaterial", required=false) String partgroupmaterial,
			@RequestParam(value="partgroupcount", required=false) String partgroupcount,
			@RequestParam(value="partgroupgubun", required=false) String partgroupgubun,
			ModelMap model) throws Exception {
		
		String actionresult = "";
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("modelid", modelid);
			hp.put("partgroupno", partgroupno);
			hp.put("partgroupname", partgroupname);
			hp.put("partgroupsize", partgroupsize);
			hp.put("partgroupmaterial", partgroupmaterial);
			hp.put("partgroupcount", partgroupcount);
			hp.put("partgroupgubun", partgroupgubun);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("setPartListRegist", hp);
			if(result != null && result.size() > 0) {
				actionresult = result.get(0).get("ACTION_RESULT").toString();
			}
			
			
		} catch(Exception e) {
			logger.error("[/smart/cad/SmartCadPartRegist.do] Exception :: " + e.toString());
		}
		
		return actionresult;
	}
	
	
	@RequestMapping(value="/smart/cad/SmartCadPartData.do")
	@ResponseBody
	public List<HashMap> SmartCadPartData(
			@RequestParam(value="modelid", required=false) String modelid,
			ModelMap model) throws Exception {
		
		List<HashMap> result = null;
		
		try {
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("modelid", modelid);
			
			result = SmartCommonDAO.commonDataProc("getPartList", hp);
			
		} catch(Exception e) {
			logger.error("[/smart/cad/SmartCadPartData.do] Exception :: " + e.toString());
		}
		return result;
	}
	
	
	
	@RequestMapping(value="/smart/cad/SmartCadPartDelete.do")
	@ResponseBody
	public String SmartCadPartDelete(
			@RequestParam(value="partgroupid", required=false) String partgroupid,
			ModelMap model) throws Exception {
		
		String actionresult = "";
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("partgroupid", partgroupid);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("setPartListDelete", hp);
			
			if(result != null && result.size() > 0) {
				actionresult = result.get(0).get("ACTION_RESULT").toString();
			}
			
		} catch(Exception e) {
			logger.error("[/smart/cad/SmartCadPartDelete.do] Exception :: " + e.toString());
		}
		
		return actionresult;
	}
	
}
