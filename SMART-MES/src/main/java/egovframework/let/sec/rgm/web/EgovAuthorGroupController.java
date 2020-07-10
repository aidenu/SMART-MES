package egovframework.let.sec.rgm.web;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.let.sec.ram.service.AuthorManageVO;
import egovframework.let.sec.ram.service.EgovAuthorManageService;
import egovframework.let.sec.rgm.service.AuthorGroup;
import egovframework.let.sec.rgm.service.AuthorGroupVO;
import egovframework.let.sec.rgm.service.EgovAuthorGroupService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import smart.common.SmartCommonDAO;
import smart.common.SmartCommonDAOImpl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.support.SessionStatus;

/**
 * 권한그룹에 관한 controller 클래스를 정의한다.
 * @author 공통서비스 개발팀 이문준
 * @since 2009.06.01
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2009.03.11  이문준          최초 생성
 *   2011.08.31  JJY            경량환경 템플릿 커스터마이징버전 생성 
 *
 * </pre>
 */

@Controller
public class EgovAuthorGroupController {

    @Resource(name="egovMessageSource")
    EgovMessageSource egovMessageSource;
    
    @Resource(name = "egovAuthorGroupService")
    private EgovAuthorGroupService egovAuthorGroupService;
    
    @Resource(name = "egovAuthorManageService")
    private EgovAuthorManageService egovAuthorManageService;
    
    /** EgovPropertyService */
    @Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;

    LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
	HashMap<String,String> hp = new HashMap<String,String>();;
    
    @Resource(name="smartCommonDAO")
	private SmartCommonDAOImpl SmartCommonDAO;
    
    /**
	 * 권한 목록화면 이동
	 * @return String
	 * @exception Exception
	 */
    @RequestMapping("/sec/rgm/EgovAuthorGroupListView.do")
    public String selectAuthorGroupListView(@ModelAttribute("authorGroupVO") AuthorGroupVO authorGroupVO,
            @ModelAttribute("authorManageVO") AuthorManageVO authorManageVO,
            ModelMap model) throws Exception {

    	/** paging */
    	PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(authorGroupVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(authorGroupVO.getPageUnit());
		paginationInfo.setPageSize(authorGroupVO.getPageSize());
		
		authorGroupVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		authorGroupVO.setLastIndex(paginationInfo.getLastRecordIndex());
		authorGroupVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());
		
		authorGroupVO.setAuthorGroupList(egovAuthorGroupService.selectAuthorGroupList(authorGroupVO));
        model.addAttribute("authorGroupList", authorGroupVO.getAuthorGroupList());
        
        int totCnt = egovAuthorGroupService.selectAuthorGroupListTotCnt(authorGroupVO);
		paginationInfo.setTotalRecordCount(totCnt);
        model.addAttribute("paginationInfo", paginationInfo);

    	authorManageVO.setAuthorManageList(egovAuthorManageService.selectAuthorAllList(authorManageVO));
        model.addAttribute("authorManageList", authorManageVO.getAuthorManageList());

        model.addAttribute("message", egovMessageSource.getMessage("success.common.select"));
        
        LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
    	HashMap<String,String> hp = new HashMap<String,String>();
    	//Alarm List, userid/username/email
    	hp = new HashMap<String,String>();
		hp.put("userid", loginVO.getId());
		List<HashMap> resultAlarm = SmartCommonDAO.commonDataProc("getAlarmList", hp);
		model.addAttribute("resultAlarm", resultAlarm);	
    	model.addAttribute("userid", loginVO.getId());
		model.addAttribute("username", loginVO.getName());
		model.addAttribute("useremail", loginVO.getEmail());
		
        return "/sec/rgm/EgovAuthorGroupManage";
    }    

	/**
	 * 그룹별 할당된 권한 목록 조회
	 * @param authorGroupVO AuthorGroupVO
	 * @param authorManageVO AuthorManageVO
	 * @return String
	 * @exception Exception
	 */
    @RequestMapping(value="/sec/rgm/EgovAuthorGroupList.do")
	public String selectAuthorGroupList(@ModelAttribute("authorGroupVO") AuthorGroupVO authorGroupVO,
			                            @ModelAttribute("authorManageVO") AuthorManageVO authorManageVO,
			                             ModelMap model) throws Exception {

    	/** paging */
    	PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(authorGroupVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(authorGroupVO.getPageUnit());
		paginationInfo.setPageSize(authorGroupVO.getPageSize());
		
		authorGroupVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		authorGroupVO.setLastIndex(paginationInfo.getLastRecordIndex());
		authorGroupVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());
		
		authorGroupVO.setAuthorGroupList(egovAuthorGroupService.selectAuthorGroupList(authorGroupVO));
        model.addAttribute("authorGroupList", authorGroupVO.getAuthorGroupList());
        
        int totCnt = egovAuthorGroupService.selectAuthorGroupListTotCnt(authorGroupVO);
		paginationInfo.setTotalRecordCount(totCnt);
        model.addAttribute("paginationInfo", paginationInfo);

    	authorManageVO.setAuthorManageList(egovAuthorManageService.selectAuthorAllList(authorManageVO));
        model.addAttribute("authorManageList", authorManageVO.getAuthorManageList());

        model.addAttribute("message", egovMessageSource.getMessage("success.common.select"));
        
        return "/sec/rgm/EgovAuthorGroupManage";
	}

	/**
	 * 그룹에 권한정보를 할당하여 데이터베이스에 등록
	 * @param userIds String
	 * @param authorCodes String
	 * @param regYns String
	 * @param authorGroup AuthorGroup
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value="/sec/rgm/EgovAuthorGroupInsert.do")
	public String insertAuthorGroup(@RequestParam(value="userIds",required=false) String userIds,
			                        @RequestParam(value="authorCodes",required=false) String authorCodes,
			                        @RequestParam(value="regYns",required=false) String regYns,
			                        @RequestParam(value="mberTyCodes",required=false) String mberTyCode,
			                        @ModelAttribute("authorGroup") AuthorGroup authorGroup,
			                         SessionStatus status,
			                         ModelMap model) throws Exception {
		
		if(userIds != null && userIds != ""){
	    	String [] strUserIds = userIds.split(";");
	    	String [] strAuthorCodes = authorCodes.split(";");
	    	String [] strRegYns = regYns.split(";");
	    	String [] strMberTyCode = mberTyCode.split(";");
	    	
	    	for(int i=0; i<strUserIds.length;i++) {
	    		authorGroup.setUniqId(strUserIds[i]);
	    		authorGroup.setAuthorCode(strAuthorCodes[i]);
	    		authorGroup.setMberTyCode(strMberTyCode[i]);
	    		if(strRegYns[i].equals("N"))
	    		    egovAuthorGroupService.insertAuthorGroup(authorGroup);
	    		else 
	    		    egovAuthorGroupService.updateAuthorGroup(authorGroup);
	    	}
	
	        status.setComplete();
	        model.addAttribute("message", egovMessageSource.getMessage("success.common.insert"));
		}
		
		return "forward:/sec/rgm/EgovAuthorGroupList.do";
	}

	/**
	 * 그룹별 할당된 시스템 메뉴 접근권한을 삭제
	 * @param userIds String
	 * @param authorGroup AuthorGroup
	 * @return String
	 * @exception Exception
	 */ 
	@RequestMapping(value="/sec/rgm/EgovAuthorGroupDelete.do")
	public String deleteAuthorGroup(@RequestParam(value="userIds",required=false) String userIds,
                                    @ModelAttribute("authorGroup") AuthorGroup authorGroup,
                                     SessionStatus status,
                                     ModelMap model) throws Exception {
		
		if(userIds != null && userIds != ""){
	    	String [] strUserIds = userIds.split(";");
	    	for(int i=0; i<strUserIds.length;i++) {
	    		authorGroup.setUniqId(strUserIds[i]);
	    		egovAuthorGroupService.deleteAuthorGroup(authorGroup);
	    	}
	    	
			status.setComplete();
			model.addAttribute("message", egovMessageSource.getMessage("success.common.delete"));
		}
		
		return "forward:/sec/rgm/EgovAuthorGroupList.do";
	}



}