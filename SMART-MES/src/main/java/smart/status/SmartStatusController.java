package smart.status;

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
public class SmartStatusController {
	
	
	Logger logger = Logger.getLogger("egovframework");
	
	@Resource(name="smartCommonDAO")
	private SmartCommonDAOImpl SmartCommonDAO;
		
	@Resource(name="messageSource")
	MessageSource messageSource ;
		
	@Resource(name = "propertiesService")
    protected EgovPropertyService propertyService;
	
	
	@RequestMapping(value="/smart/status/SmartModelStatus.do")
	public String SmartModelStatus (
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
			logger.error("[/smart/status/SmartModelStatus.do] Exception :: " + e.toString());
		}
		
		return "smart/status/SmartModelStatus";
	}
	
	@RequestMapping(value="/smart/status/SmartModelStatusModelData.do")
	@ResponseBody
	public List<HashMap> SmartModelStatusModelData(
			@RequestParam(value="startDate", required=false) String startDate,
			@RequestParam(value="endDate", required=false) String endDate,
			@RequestParam(value="gubun", required=false) String gubun,
			ModelMap model) throws Exception {
		
		List<HashMap> result  = null;
		try {
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("startDate", startDate);
			hp.put("endDate", endDate);
			hp.put("gubun", gubun);
			
			result = SmartCommonDAO.commonDataProc("getModelStatusData", hp);
			model.addAttribute("result", result);
			
		} catch(Exception e) {
			logger.error("[/smart/status/SmartModelStatusModelData.do] Exception :: " + e.toString());
		}
		
		return result;
	}
	
	
	@RequestMapping(value="/smart/status/SmartModelStatusDetail.do")
	public String SmartModelStatusDetail(
			@RequestParam(value="modelid", required=false) String modelid,
			ModelMap model) throws Exception {
		
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("modelid", modelid);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("getModelStatusPartData", hp);
			model.addAttribute("result", result);
			
			List<HashMap> resultWork = SmartCommonDAO.commonDataProc("getModelStatusWorkData", hp);
			model.addAttribute("resultWork", resultWork);
			
		} catch(Exception e) {
			logger.error("[/smart/status/SmartModelStatusDetail.do] Exception :: " + e.toString());
		}
		return "smart/status/SmartModelStatusDetail";
	}
	
}
