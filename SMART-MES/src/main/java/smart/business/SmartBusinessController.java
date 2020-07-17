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
	
	
	@RequestMapping("/smart/business/SmartBusinessView.do")
	public String SmartBusinessView(
			@RequestParam(value="gubun", required=false) String gubun,
			@RequestParam(value="modelid", required=false) String modelid,
			ModelMap model) throws Exception {
		
		try {
			
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			model.addAttribute("userid", loginVO.getId());
			
			List<HashMap> resultUser = SmartCommonDAO.commonDataProc("getUserList");
			model.addAttribute("resultUser", resultUser);
			
			List<HashMap> resultBasic = SmartCommonDAO.commonDataProc("getBasicData");
			model.addAttribute("resultBasic", resultBasic);
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("modelid", modelid);
			List<HashMap> result = SmartCommonDAO.commonDataProc("getBusinessViewData", hp);
			if(result != null && result.size() > 0) {
				model.addAttribute("MODEL_NO", result.get(0).get("MODEL_NO"));
				model.addAttribute("PRODUCT_NO", result.get(0).get("PRODUCT_NO"));
				model.addAttribute("PRODUCT_NAME", result.get(0).get("PRODUCT_NAME"));
				model.addAttribute("PRODUCT_GROUP", result.get(0).get("PRODUCT_GROUP"));
				model.addAttribute("ORDER_DATE", result.get(0).get("ORDER_DATE"));
				model.addAttribute("DUE_DATE", result.get(0).get("DUE_DATE"));
				model.addAttribute("VENDOR", result.get(0).get("VENDOR"));
				model.addAttribute("BUSINESS_WORKER", result.get(0).get("BUSINESS_WORKER"));
				model.addAttribute("CAD_WORKER", result.get(0).get("CAD_WORKER"));
				model.addAttribute("ASSEMBLY_WORKER", result.get(0).get("ASSEMBLY_WORKER"));
			}
			model.addAttribute("MODEL_ID", modelid);
			model.addAttribute("gubun", gubun);
			
		} catch(Exception e) {
			logger.error("[/smart/business/SmartBusinessView.do] Exception :: " + e.toString());
		}
		
		return "smart/business/SmartBusinessView";
	}
	
	
	@RequestMapping("/smart/business/SmartBusinessSave.do")
	public String SmartBusinessSave(
			@RequestParam(value="gubun", required=false) String gubun,
			@RequestParam(value="modelid", required=false) String modelid,
			@RequestParam(value="modelno", required=false) String modelno,
			@RequestParam(value="productno", required=false) String productno,
			@RequestParam(value="productname", required=false) String productname,
			@RequestParam(value="productgroup", required=false) String productgroup,
			@RequestParam(value="vendor", required=false) String vendor,
			@RequestParam(value="businessworker", required=false) String businessworker,
			@RequestParam(value="orderdate", required=false) String orderdate,
			@RequestParam(value="duedate", required=false) String duedate,
			@RequestParam(value="cadworker", required=false) String cadworker,
			@RequestParam(value="assemblyworker", required=false) String assemblyworker,
			ModelMap model) throws Exception {
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("gubun", gubun);
			hp.put("modelid", modelid);
			hp.put("modelno", modelno);
			hp.put("productno", productno);
			hp.put("productname", productname);
			hp.put("productgroup", productgroup);
			hp.put("vendor", vendor);
			hp.put("businessworker", businessworker);
			hp.put("orderdate", orderdate);
			hp.put("duedate", duedate);
			hp.put("cadworker", cadworker);
			hp.put("assemblyworker", assemblyworker);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("setBusinessDataSave", hp);
			
			if(result != null && result.size() > 0) {
				model.addAttribute("actionresult", result.get(0).get("ACTION_RESULT"));
			}
			
		} catch(Exception e) {
			logger.error("[smart/business/SmartBusinessSave.do] Excption :: " + e.toString());
		}
		
		return "smart/business/SmartBusinessSave";
	}
	
	
	@RequestMapping("/smart/business/SmartBusinessDelete.do")
	@ResponseBody
	public String SmartBusinessDelete(
			@RequestParam(value="modelid", required=false) String modelid,
			ModelMap model) throws Exception {
		
		String actionresult = "";
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("modelid", modelid);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("setBusinessDelete", hp);
			if(result != null && result.size() > 0) {
				actionresult = result.get(0).get("ACTION_RESULT").toString();
			}
			
			
			
		} catch(Exception e) {
			logger.error("[/smart/business/SmartBusinessDelete.do] Exception :: " + e.toString());
		}
		return actionresult;
	}
	
}
