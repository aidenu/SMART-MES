package smart.result;

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
public class SmartResultController {
	
	
	Logger logger = Logger.getLogger("egovframework");
	
	@Resource(name="smartCommonDAO")
	private SmartCommonDAOImpl SmartCommonDAO;
		
	@Resource(name="messageSource")
	MessageSource messageSource ;
		
	@Resource(name = "propertiesService")
    protected EgovPropertyService propertyService;
	
	
	@RequestMapping(value="/smart/result/SmartResultWorkTime.do")
	public String SmartResultWorkTime(
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
			logger.error("[/smart/result/SmartResultWorkTime.do] Exception :: " + e.toString());
		}
		
		return "smart/result/SmartResultWorkTime";
	}
	
	
	@RequestMapping(value="/smart/result/SmartResultWorkTimeData.do")
	@ResponseBody
	public List<HashMap> SmartResultWorkTimeData(
			@RequestParam(value="startDate", required=false) String startDate,
			@RequestParam(value="endDate", required=false) String endDate,
			ModelMap model) throws Exception {
		
		List<HashMap> result = null;
		
		try {
			
			HashMap<String, String> hp = new HashMap<String,String>();
			hp.put("startdate", startDate);
			hp.put("enddate", endDate);
			
			
			result = SmartCommonDAO.commonDataProc("getResultWorkTimeData", hp);
			
		} catch(Exception e) {
			logger.error("[/smart/result/SmartResultWorkTimeData.do] Exception :: " + e.toString());
		}
		
		return result;
	}
	
	
	
	@RequestMapping(value="/smart/result/SmartResultClaim.do")
	public String SmartResultClaim(
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
			logger.error("[/smart/result/SmartResultClaim.do] Exception :: " + e.toString());
		}
		
		return "smart/result/SmartResultClaim";
	}
	
	
	@RequestMapping(value="/smart/result/SmartResultClaimData.do")
	@ResponseBody
	public List<HashMap> SmartResultClaimData(
			@RequestParam(value="startDate", required=false) String startDate,
			@RequestParam(value="endDate", required=false) String endDate,
			ModelMap model) throws Exception {
		
		
		List<HashMap> result = null;
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("startdate", startDate);
			hp.put("enddate", endDate);
			
			result = SmartCommonDAO.commonDataProc("getResultClaimData", hp);
			
			
		} catch(Exception e) {
			logger.error("[/smart/result/SmartResultClaimData.do] Exception :: " + e.toString());
		}
		
		return result;
	}
	
	
	@RequestMapping(value="/smart/result/SmartResultPrice.do")
	public String SmartResultPrice(
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
			logger.error("[/smart/result/SmartResultPrice.do] Exception :: " + e.toString());
		}
		return "smart/result/SmartResultPrice";
	}
	
	
	@RequestMapping(value="/smart/result/SmartResultPriceModelData.do")
	@ResponseBody
	public List<HashMap> SmartResultPriceModelData(
			@RequestParam(value="startDate", required=false) String startDate,
			@RequestParam(value="endDate", required=false) String endDate,
			ModelMap model) throws Exception {
		
		
		List<HashMap> result = null;
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("startdate", startDate);
			hp.put("enddate", endDate);
			
			result = SmartCommonDAO.commonDataProc("getResultPriceModelData", hp);
			model.addAttribute("result", result);
			
		} catch(Exception e) {
			logger.error("[/smart/result/SmartResultPriceModelData.do] Exception :: " + e.toString());
		}
		return result;
	}
	
	
	@RequestMapping(value="/smart/result/SmartResultOutPrice.do")
	public String SmartResultOutPrice(
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
			logger.error("[/smart/result/SmartResultOutPrice.do] Exception :: " + e.toString());
		}
		
		return "smart/result/SmartResultOutPrice";
	}
	
	
	@RequestMapping(value="/smart/result/SmartResultOutPriceData.do")
	@ResponseBody
	public List<HashMap> SmartResultOutPriceData(
			@RequestParam(value="startDate", required=false) String startDate,
			@RequestParam(value="endDate", required=false) String endDate,
			ModelMap model) throws Exception {
		
		List<HashMap> result = null;
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("startdate", startDate);
			hp.put("enddate", endDate);
			
			result = SmartCommonDAO.commonDataProc("getResultOutPriceData", hp);
			
		} catch(Exception e) {
			logger.error("[/smart/result/SmartResultOutPriceData.do] Exception :: " + e.toString());
		}
		
		
		return result;
	}
	
	
	@RequestMapping(value="/smart/result/SmartResultOutPriceDetail.do")
	@ResponseBody
	public List<HashMap> SmartResultOutPriceDetail(
			@RequestParam(value="modelid", required=false) String modelid,
			ModelMap model) throws Exception {
		
		List<HashMap> result = null;
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("modelid", modelid);
			
			result = SmartCommonDAO.commonDataProc("getResultOutPriceDetail", hp);
			
		} catch(Exception e) {
			logger.error("[/smart/result/SmartResultOutPriceDetail.do] Exception :: " + e.toString());
		}
		
		return result;
	}
	
	
	@RequestMapping(value="/smart/result/SmartResultDeadLineRate.do")
	public String SmartResultDeadLineRate(
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
			logger.error("[/smart/result/SmartResultDeadLineRate.do] Exception :: " + e.toString());
		}
		
		
		return "smart/result/SmartResultDeadLineRate";
	}
	
	@RequestMapping(value="/smart/result/SmartResultDeadLineRateData.do")
	@ResponseBody
	public List<HashMap> SmartResultDeadLineRateData(
			@RequestParam(value="year", required=false) String year,
			ModelMap model) throws Exception {
		
		List<HashMap> result = null;
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("year", year);
			
			result = SmartCommonDAO.commonDataProc("getResultDeaeLineData", hp);
			
		} catch(Exception e) {
			logger.error("[/smart/result/SmartResultDeadLineRateData.do] Exception :: " + e.toString());
		}
		
		return result;
	}
	
}
