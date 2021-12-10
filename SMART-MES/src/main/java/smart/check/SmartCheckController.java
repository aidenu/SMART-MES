package smart.check;

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
public class SmartCheckController {
	
	Logger logger = Logger.getLogger("egovframework");
	
	@Resource(name="smartCommonDAO")
	private SmartCommonDAOImpl SmartCommonDAO;
		
	@Resource(name="messageSource")
	MessageSource messageSource ;
		
	@Resource(name = "propertiesService")
    protected EgovPropertyService propertyService;
	
	
	@RequestMapping(value="/smart/check/SmartCheckOut.do")
	public String SmartCheckOut(
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
			logger.error("[/smart/check/SmartCheckOut.do] Exception :: " + e.toString());
		}
		
		return "smart/check/SmartCheckOut";
		
	}
	
	
	@RequestMapping(value="/smart/check/SmartCheckOutModelData.do")
	@ResponseBody
	public List<HashMap> SmartCheckOutModelData(
			@RequestParam(value="startDate", required=false) String startDate,
			@RequestParam(value="endDate", required=false) String endDate,
			ModelMap model) throws Exception {
		
		List<HashMap> result = null;
		
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("startDate", startDate);
			hp.put("endDate", endDate);
			
			result = SmartCommonDAO.commonDataProc("getCheckOutModelData", hp);
			
		} catch(Exception e) {
			logger.error("[/smart/check/SmartCheckOutModelData.do] Exception :: " + e.toString());
		}
		
		return result;
		
	}
	
	@RequestMapping(value="/smart/check/SmartCheckOutModelEnd.do")
	@ResponseBody
	public String SmartCheckOutModelEnd(
			@RequestParam(value="modelid", required=false) String modelid,
			ModelMap model) throws Exception {
		
		String actionresult = "";
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("modelid", modelid);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("setCheckOutModelEnd", hp);
			
			if(result != null && result.size() > 0) {
				actionresult = result.get(0).get("ACTION_RESULT").toString();
			}
			
		} catch(Exception e) {
			logger.error("[/smart/check/SmartCheckOutModelEnd.do] Exception :: " + e.toString());
		}
		
		return actionresult;
	}
	
	
	@RequestMapping(value="/smart/check/SmartCheckOutModelSave.do")
	@ResponseBody
	public String SmartCheckOutModelSave(
			@RequestParam(value="arraystr", required=false) String arraystr,
			ModelMap model) throws Exception {
		
		String actionresult = "";
		
		try {
			
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			hp.put("arraystr", arraystr);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("setCheckOutModelSave", hp);
			
			if(result != null && result.size() > 0) {
				actionresult = result.get(0).get("ACTION_RESULT").toString();
			}
			
		} catch(Exception e) {
			logger.error("[/smart/check/SmartCheckOutModelSave.do] Exception :: " + e.toString());
		}
		
		
		return actionresult;
	}
	
}
