package space.common;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import egovframework.com.cmm.LoginVO;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;

@Controller
public class SpaceBasicDataController {

	Logger logger = Logger.getLogger("egovframework");
	
	@Resource(name="spaceCommonDAO")
	private SpaceCommonDAOImpl spaceCommonDAO;
	
	@RequestMapping(value = "/space/common/SpaceBasicData.do")
	public String getSpaceBasicDataPage(ModelMap model) throws Exception {
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
    	if(!isAuthenticated) {
    		model.addAttribute("sessionmessage", "session expire");
    		return "uat/uia/EgovLoginUsr";
    	}
    	
    	
    	LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
    	
    	HashMap<String,String> hp = new HashMap<String,String>();
		hp.put("userid", loginVO.getId());
		
		List<HashMap> result = spaceCommonDAO.commonDataProc("selectUserRoleData",hp);
    	model.addAttribute("result", result.get(0).get("AUTHOR_CODE"));
    	
    	return "space/common/SpaceBasicData";
	}
	
	
	
	@RequestMapping(value = "/space/common/SpaceBasicDataList.do")
	public String getSpaceBasicDataListPage(
			@RequestParam(value="actionlevel", required=false) String actionlevel,
    		@RequestParam(value="parentid", required=false) String parentid,
    		ModelMap model) throws Exception {
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
    	if(!isAuthenticated) {
    		model.addAttribute("sessionmessage", "session expire");
    		return "uat/uia/EgovLoginUsr";
    	}
		
    	try{
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("actionlevel", actionlevel);
			hp.put("parentid", parentid);
			    	
	    	List<HashMap> result = spaceCommonDAO.commonDataProc("selectBasicDataList",hp);
			
	    	model.addAttribute("actiontype", "select");
	    	model.addAttribute("actionlevel", actionlevel);
			model.addAttribute("basicdatalist", result);
    	}
    	catch(Exception e){
			logger.error("[/space/common/SpaceBasicDataList.do] Exception :: " + e.toString());
		}
				    	
		return "space/common/SpaceBasicDataList";
	}
	
	
	
	@RequestMapping(value = "/space/common/SpaceBasicDataAction.do")
	public String getSpaceBasicDataActionPage(
			@RequestParam(value="actiontype", required=false) String actiontype,
    		@RequestParam(value="actionlevel", required=false) String actionlevel,
    		@RequestParam(value="parentid", required=false) String parentid,
    		@RequestParam(value="childid", required=false) String childid,
    		@RequestParam(value="childvalue", required=false) String childvalue,
    		ModelMap model) throws Exception {
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
    	if(!isAuthenticated) {
    		model.addAttribute("sessionmessage", "session expire");
    		return "uat/uia/EgovLoginUsr";
    	}
    	
    	try{
	    	LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
	    	
	    	HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			hp.put("actiontype", actiontype);
			hp.put("actionlevel", actionlevel);
			hp.put("parentid", parentid);
			hp.put("childid", childid);
			hp.put("childvalue", childvalue);
	    	
	    	List<HashMap> result = spaceCommonDAO.commonDataProc("updateBasicDataList",hp);
	    	model.addAttribute("actionlevel", actionlevel);
	    	model.addAttribute("parentid", parentid);
			model.addAttribute("result", result.get(0).get("out_data"));
    	}
    	catch(Exception e){
			logger.error("[/space/common/SpaceBasicDataAction.do] Exception :: " + e.toString());
		}
    	
		return "space/common/SpaceBasicDataResult";
	}
}