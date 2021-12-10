package smart.purchase;

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
public class SmartPurchaseController {
	
	
	Logger logger = Logger.getLogger("egovframework");
	
	@Resource(name="smartCommonDAO")
	private SmartCommonDAOImpl SmartCommonDAO;
		
	@Resource(name="messageSource")
	MessageSource messageSource ;
		
	@Resource(name = "propertiesService")
    protected EgovPropertyService propertyService;
	
	
	@RequestMapping("/smart/purchase/SmartPurchase.do")
	public String SmartSiteWork (
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
			logger.error("[/smart/purchase/SmartPurchase.do] Exception :: " + e.toString());
		}
		
		return "smart/purchase/SmartPurchase";
	}
	
	@RequestMapping("/smart/purchase/SmartPurchaseModelData.do")
	@ResponseBody
	public List<HashMap> SmartPurchaseModelData(
			@RequestParam(value="startDate", required=false) String startDate,
			@RequestParam(value="endDate", required=false) String endDate,
			ModelMap model) throws Exception {
		
		List<HashMap> result  = null;
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("startDate", startDate);
			hp.put("endDate", endDate);
			
			result = SmartCommonDAO.commonDataProc("getPurchaseModelData", hp);
			model.addAttribute("result", result);
			
		} catch(Exception e) {
			logger.error("[/smart/purchase/SmartPurchaseModelData.do] Exception :: " + e.toString());
		}
		
		return result;
	}
	
	
	@RequestMapping(value="/smart/purchase/SmartPurchaseView.do")
	public String SmartPurchaseView(
			@RequestParam(value="modelid", required=false) String modelid,
			ModelMap model) throws Exception {
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("modelid", modelid);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("getPurchasePartData", hp);
			model.addAttribute("result", result);
			
			List<HashMap> resultBasic = SmartCommonDAO.commonDataProc("getBasicData");
			model.addAttribute("resultBasic", resultBasic);
			
			model.addAttribute("modelid", modelid);
			
		} catch(Exception e) {
			logger.error("[/smart/purchase/SmartPurchaseView.do] Exception :: " + e.toString());
		}
		
		return "smart/purchase/SmartPurchaseView";
	}
	
	
	@RequestMapping(value="/smart/purchase/SmartPurchaseDataSave.do")
	@ResponseBody
	public String SmartPurchaseDataSave(
			@RequestParam(value="modelid", required=false) String modelid,
			@RequestParam(value="arraystr", required=false) String arraystr,
			ModelMap model) throws Exception {
		
		
		String actionresult = "";
		
		try {
			
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			hp.put("modelid", modelid);
			hp.put("arraystr", arraystr);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("setPurchaseDataSave", hp);
			
			if(result != null && result.size() > 0) {
				actionresult = result.get(0).get("ACTION_RESULT").toString();
			}
			
		} catch(Exception e) {
			logger.error("[/smart/purchase/SmartPurchaseDataSave.do] Exception :: " + e.toString());
		}
		
		return actionresult;
	}
	
	
	@RequestMapping(value="/smart/purchase/SmartWarehousing.do")
	public String SmartWarehousing(
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
			logger.error("[/smart/purchase/SmartWarehousing.do] Exception :: " + e.toString());
		}
		
		return "smart/purchase/SmartWarehousing";
	}
	
	@RequestMapping(value="/smart/purchase/SmartWarehousingModelData.do")
	@ResponseBody
	public List<HashMap> SmartWarehousingModelData(
			@RequestParam(value="startDate", required=false) String startDate,
			@RequestParam(value="endDate", required=false) String endDate,
			ModelMap model) throws Exception {
		
		List<HashMap> result = null;
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("startDate", startDate);
			hp.put("endDate", endDate);
			
			result = SmartCommonDAO.commonDataProc("getPurchaseModelData", hp);
			model.addAttribute("result", result);
			
		} catch(Exception e) {
			logger.error("[/smart/purchase/SmartWarehousingModelData.do] Exception :: " + e.toString());
		}
		
		return result;
	}
	
	
	@RequestMapping(value="/smart/purchase/SmartWarehousingView.do")
	public String SmartWarehousingView(
			@RequestParam(value="modelid", required=false) String modelid,
			ModelMap model) throws Exception {
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("modelid", modelid);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("getPurchasePartData", hp);
			
			model.addAttribute("modelid", modelid);
			model.addAttribute("result", result);
			
		} catch(Exception e) {
			logger.error("[/smart/purchase/SmartWarehousingView.do] Exception :: " + e.toString());
		}
		
		return "smart/purchase/SmartWarehousingView";
	}
	
}
