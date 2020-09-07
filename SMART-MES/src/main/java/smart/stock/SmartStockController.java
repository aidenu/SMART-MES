package smart.stock;

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
public class SmartStockController {
	
	
	Logger logger = Logger.getLogger("egovframework");
	
	@Resource(name="smartCommonDAO")
	private SmartCommonDAOImpl SmartCommonDAO;
		
	@Resource(name="messageSource")
	MessageSource messageSource ;
		
	@Resource(name = "propertiesService")
    protected EgovPropertyService propertyService;
	
	
	@RequestMapping(value="/smart/stock/SmartStock.do")
	public String SmartStock (
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
			
			hp = new HashMap<String,String>();
			hp.put("stockid", "ALL");
			List<HashMap> result = SmartCommonDAO.commonDataProc("getStockData", hp);
			model.addAttribute("result", result);
			
		} catch(Exception e) {
			logger.error("[/smart/stock/SmartStock.do] Exception :: " + e.toString());
		}
		
		return "smart/stock/SmartStock";
	}
	
	
	
	@RequestMapping(value="/smart/stock/SmartStockData.do")
	@ResponseBody
	public List<HashMap> SmartStockData(ModelMap model) throws Exception {
		
		List<HashMap> result = null;
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("stockid", "ALL");
			result = SmartCommonDAO.commonDataProc("getStockData", hp);
			
		} catch(Exception e) {
			logger.error("[/smart/stock/SmartStockData.do] Exception :: " + e.toString());
		}
		
		
		return result;
	}
	
	@RequestMapping(value="/smart/stock/SmartStockDataSave.do")
	@ResponseBody
	public String SmartStockDataSave(
			@RequestParam(value="stockname", required=false) String stockname,
			@RequestParam(value="stocksize", required=false) String stocksize,
			@RequestParam(value="stockcount", required=false) String stockcount,
			@RequestParam(value="stockprice", required=false) String stockprice,
			@RequestParam(value="safecount", required=false) String safecount,
			@RequestParam(value="gubun", required=false) String gubun,
			ModelMap model) throws Exception {
		
		String actionresult = "";
		
		try {
			
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			hp.put("stockname", stockname);
			hp.put("stocksize", stocksize);
			hp.put("stockcount", stockcount);
			hp.put("stockprice", stockprice);
			hp.put("safecount", safecount);
			hp.put("gubun", gubun);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("setStockDataSave", hp);
			if(result != null && result.size() > 0) {
				actionresult = result.get(0).get("ACTION_RESULT").toString();
			}
			
		} catch(Exception e) {
			logger.error("[/smart/stock/SmartStockDataSave.do] Exception :: " + e.toString());
		}
		
		return actionresult;
	}
	
	
	@RequestMapping(value="/smart/stock/SmartStockDataDelete.do")
	@ResponseBody
	public String SmartStockDataDelete(
			@RequestParam(value="stockid", required=false) String stockid,
			ModelMap model) throws Exception {
		
		String actionresult = "";
		
		try {
			
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			hp.put("stockid", stockid);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("setStockDataDelete", hp);
			
			if(result != null && result.size() > 0) {
				actionresult = result.get(0).get("ACTION_RESULT").toString();
			}
			
		} catch(Exception e) {
			logger.error("[/smart/stock/SmartStockDataDelete.do] Exception :: " + e.toString());
		}
		
		return actionresult;
	}
	
	@RequestMapping(value="/smart/stock/SmartStockDataOrder.do")
	@ResponseBody
	public String SmartStockDataOrder(
			@RequestParam(value="stockid", required=false) String stockid,
			@RequestParam(value="ordercount", required=false) String ordercount,
			@RequestParam(value="gubun", required=false) String gubun,
			ModelMap model) throws Exception {
		
		String actionresult = "";
		
		try {
			
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			hp.put("stockid", stockid);
			hp.put("ordercount", ordercount);
			hp.put("gubun", gubun);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("setStockDataOrder", hp);
			
			if(result != null && result.size() > 0) {
				actionresult = result.get(0).get("ACTION_RESULT").toString();
			}
			
		} catch(Exception e) {
			logger.error("[/smart/stock/SmartStockDataOrder.do] Exception :: " + e.toString());
		}
		
		return actionresult;
	}
	
	
	@RequestMapping(value="/smart/stock/SmartStockDataDetail.do")
	@ResponseBody
	public List<HashMap> SmartStockDataDetail(
			@RequestParam(value="stockid", required=false) String stockid,
			ModelMap model) throws Exception {
		
		List<HashMap> result = null;
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("stockid", stockid);
			result = SmartCommonDAO.commonDataProc("getStockData", hp);
			
		} catch(Exception e) {
			logger.error("[/smart/stock/SmartStockDataDetail.do] Exception :: " + e.toString());
		}
		
		return result;
	}
	
	
	@RequestMapping(value="/smart/stock/SmartStockDataModify.do")
	@ResponseBody
	public String SmartStockDataModify(
			@RequestParam(value="stockname", required=false) String stockname,
			@RequestParam(value="stocksize", required=false) String stocksize,
			@RequestParam(value="stockcount", required=false) String stockcount,
			@RequestParam(value="stockprice", required=false) String stockprice,
			@RequestParam(value="safecount", required=false) String safecount,
			@RequestParam(value="stockid", required=false) String stockid,
			ModelMap model) throws Exception {
		
		String actionresult = "";
		
		try {
			
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			hp.put("stockname", stockname);
			hp.put("stocksize", stocksize);
			hp.put("stockcount", stockcount);
			hp.put("stockprice", stockprice);
			hp.put("safecount", safecount);
			hp.put("stockid", stockid);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("setStockDataModify", hp);
			if(result != null && result.size() > 0) {
				actionresult = result.get(0).get("ACTION_RESULT").toString();
			}
			
		} catch(Exception e) {
			logger.error("[/smart/stock/SmartStockDataModify.do] Exception :: " + e.toString());
		}
		
		return actionresult;
	}
	
	
	
	@RequestMapping(value="/smart/stock/SmartTool.do")
	public String SmartTool(
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
			
			List<HashMap> resultBasic = SmartCommonDAO.commonDataProc("getToolBasic");
			model.addAttribute("resultBasic", resultBasic);
			
		} catch(Exception e) {
			logger.error("[/smart/stock/SmartTool.do] Exception :: " + e.toString());
		}
		
		return "smart/stock/SmartTool";
	}
	
	
	@RequestMapping(value="/smart/stock/SmartToolBasicData.do")
	@ResponseBody
	public List<HashMap> SmartToolBasicData(
			@RequestParam(value="maincategory", required=false) String maincategory,
			ModelMap model) throws Exception {
		
		List<HashMap> result = null;
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("maincategory", maincategory);
			result = SmartCommonDAO.commonDataProc("getToolCategoryBasic", hp);
			
		} catch(Exception e) {
			logger.error("[/smart/stock/SmartToolBasicData.do] Exception :: " + e.toString());
		}
		
		return result;
	}
	
	
	@RequestMapping(value="/smart/stock/SmartToolDataSave.do")
	@ResponseBody
	public String SmartToolDataSave(
			@RequestParam(value="maincategory", required=false) String maincategory,
			@RequestParam(value="subcategory", required=false) String subcategory,
			@RequestParam(value="toolpie", required=false) String toolpie,
			@RequestParam(value="toolfb", required=false) String toolfb,
			@RequestParam(value="toolr", required=false) String toolr,
			@RequestParam(value="toollength", required=false) String toollength,
			@RequestParam(value="toolcount", required=false) String toolcount,
			@RequestParam(value="safecount", required=false) String safecount,
			@RequestParam(value="toolprice", required=false) String toolprice,
			@RequestParam(value="gubun", required=false) String gubun,
			ModelMap model) throws Exception {
		
		String actionresult = "";
		
		try {
			
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			hp.put("maincategory", maincategory);
			hp.put("subcategory", subcategory);
			hp.put("toolpie", toolpie);
			hp.put("toolfb", toolfb);
			hp.put("toolr", toolr);
			hp.put("toollength", toollength);
			hp.put("toolcount", toolcount);
			hp.put("safecount", safecount);
			hp.put("toolprice", toolprice);
			hp.put("gubun", gubun);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("setToolDataSafe", hp);
			if(result != null && result.size() > 0) {
				actionresult = result.get(0).get("ACTION_RESULT").toString();
			}
			
			
		} catch(Exception e) {
			logger.error("[/smart/stock/SmartToolDataSave.do] Exception :: " + e.toString());
		}
		
		
		return actionresult;
	}
	
}
