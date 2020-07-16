package smart.business;

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
public class SmartBusinessController {
	
	
	Logger logger = Logger.getLogger("egovframework");
	
	@Resource(name="smartCommonDAO")
	private SmartCommonDAOImpl SmartCommonDAO;
		
	@Resource(name="messageSource")
	MessageSource messageSource ;
		
	@Resource(name = "propertiesService")
    protected EgovPropertyService propertyService;
	
	
	@RequestMapping("/smart/business/SmartBusiness.do")
	public String SmartBusiness (
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
			logger.error("[/smart/business/SmartBusiness.do] Exception :: " + e.toString());
		}
		
		return "smart/business/SmartBusiness";
	}
	
	@RequestMapping("/smart/business/SmartBusinessData.do")
	@ResponseBody
	public List<HashMap> SmartBusinessData(
			@RequestParam(value="startDate", required=false) String startDate,
			@RequestParam(value="endDate", required=false) String endDate,
			ModelMap model) throws Exception {
		
		List<HashMap> result  = null;
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("startDate", startDate);
			hp.put("endDate", endDate);
			
			result = SmartCommonDAO.commonDataProc("getBusinessData", hp);
			model.addAttribute("result", result);
			
		} catch(Exception e) {
			logger.error("[/smart/business/SmartBusinessData.do] Exception :: " + e.toString());
		}
		
		return result;
	}
	
	
	@RequestMapping("/smart/business/SmartBusinessInsertView.do")
	public String SmartBusinessInsertView(
			ModelMap model) throws Exception {
		
		try {
			
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			
			List<HashMap> resultUser = SmartCommonDAO.commonDataProc("getUserList");
			model.addAttribute("resultUser", resultUser);
			
			List<HashMap> resultBasic = SmartCommonDAO.commonDataProc("getBasicData");
			model.addAttribute("resultBasic", resultBasic);
			
			model.addAttribute("userid", loginVO.getId());
			
		} catch(Exception e) {
			logger.error("[/smart/business/SmartBusinessInsertView.do] Exception :: " + e.toString());
		}
		
		return "smart/business/SmartBusinessInsertView";
	}
	
}
