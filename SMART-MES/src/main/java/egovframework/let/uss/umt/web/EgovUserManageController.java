package egovframework.let.uss.umt.web;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springmodules.validation.commons.DefaultBeanValidator;

import egovframework.com.cmm.ComDefaultCodeVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovCmmUseService;
import egovframework.let.uss.umt.service.EgovUserManageService;
import egovframework.let.uss.umt.service.UserDefaultVO;
import egovframework.let.uss.umt.service.UserManageVO;
import egovframework.let.utl.sim.service.EgovFileScrty;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import smart.common.SmartCommonDAOImpl;

/**
 * 업무사용자관련 요청을  비지니스 클래스로 전달하고 처리된결과를  해당   웹 화면으로 전달하는  Controller를 정의한다
 * @author 공통서비스 개발팀 조재영
 * @since 2009.04.10
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2009.04.10  조재영          최초 생성
 *   2011.08.31  JJY            경량환경 템플릿 커스터마이징버전 생성
 *
 * </pre>
 */
@Controller
public class EgovUserManageController {

    /** userManageService */
    @Resource(name = "userManageService")
    private EgovUserManageService userManageService;

    /** cmmUseService */
    @Resource(name="EgovCmmUseService")
    private EgovCmmUseService cmmUseService;

    /** EgovPropertyService */
    @Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;

    /** DefaultBeanValidator beanValidator */
    @Autowired
	private DefaultBeanValidator beanValidator;
    
    @Resource(name="smartCommonDAO")
	private SmartCommonDAOImpl SmartCommonDAO;
    
    /** EgovMessageSource */
    @Resource(name="egovMessageSource")
    EgovMessageSource egovMessageSource;

    /**
     * 사용자목록을 조회한다. (pageing)
     * @param userSearchVO 검색조건정보
     * @param model 화면모델
     * @return cmm/uss/umt/EgovUserManage
     * @throws Exception
     */
    @RequestMapping(value="/uss/umt/user/EgovUserManage.do")
    public String selectUserList(@ModelAttribute("userSearchVO") UserDefaultVO userSearchVO,
            ModelMap model)
            throws Exception {
        /** EgovPropertyService.sample */
        userSearchVO.setPageUnit(propertiesService.getInt("pageUnit"));
        userSearchVO.setPageSize(propertiesService.getInt("pageSize"));

        /** pageing */
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(userSearchVO.getPageIndex());
        paginationInfo.setRecordCountPerPage(userSearchVO.getPageUnit());
        paginationInfo.setPageSize(userSearchVO.getPageSize());

        userSearchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
        userSearchVO.setLastIndex(paginationInfo.getLastRecordIndex());
        userSearchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

        model.addAttribute("resultList", userManageService.selectUserList(userSearchVO));

        int totCnt = userManageService.selectUserListTotCnt(userSearchVO);
        paginationInfo.setTotalRecordCount(totCnt);
        model.addAttribute("paginationInfo", paginationInfo);

        //사용자상태코드를 코드정보로부터 조회
        ComDefaultCodeVO vo = new ComDefaultCodeVO();
        vo.setCodeId("COM013");
        model.addAttribute("emplyrSttusCode_result",cmmUseService.selectCmmCodeDetail(vo));//사용자상태코드목록
        
        return "cmm/uss/umt/EgovUserManage";
    }

    /**
     * 사용자등록화면으로 이동한다.
     * @param userSearchVO 검색조건정보
     * @param userManageVO 사용자초기화정보
     * @param model 화면모델
     * @return cmm/uss/umt/EgovUserInsert
     * @throws Exception
     */
    @RequestMapping("/uss/umt/user/EgovUserInsertView.do")
    public String insertUserView(
            @ModelAttribute("userSearchVO") UserDefaultVO userSearchVO,
            @ModelAttribute("userManageVO") UserManageVO userManageVO,
            Model model
            )throws Exception {
        ComDefaultCodeVO vo = new ComDefaultCodeVO();

        //패스워드힌트목록을 코드정보로부터 조회
        vo.setCodeId("COM022");
        model.addAttribute("passwordHint_result", cmmUseService.selectCmmCodeDetail(vo));     //패스워트힌트목록

        //성별구분코드를 코드정보로부터 조회
        vo.setCodeId("COM014");
        //List sexdstnCode_result = cmmUseService.selectCmmCodeDetail(vo);
        model.addAttribute("sexdstnCode_result", cmmUseService.selectCmmCodeDetail(vo));

        //사용자상태코드를 코드정보로부터 조회
        vo.setCodeId("COM013");
        model.addAttribute("emplyrSttusCode_result",cmmUseService.selectCmmCodeDetail(vo));

        //소속기관코드를 코드정보로부터 조회 - COM025
        vo.setCodeId("COM025");
        model.addAttribute("insttCode_result", cmmUseService.selectCmmCodeDetail(vo));

        //조직정보를 조회 - ORGNZT_ID정보
        vo.setTableNm("LETTNORGNZTINFO");
        model.addAttribute("orgnztId_result", cmmUseService.selectOgrnztIdDetail(vo));

        //그룹정보를 조회 - GROUP_ID정보
        vo.setTableNm("LETTNORGNZTINFO");
        model.addAttribute("groupId_result", cmmUseService.selectGroupIdDetail(vo));

        return "cmm/uss/umt/EgovUserInsertView";
    }

    /**
     * 사용자등록처리후 목록화면으로 이동한다.
     * @param userManageVO 사용자등록정보
     * @param bindingResult 입력값검증용 bindingResult
     * @param model 화면모델
     * @return forward:/uss/umt/user/EgovUserManage.do
     * @throws Exception
     */
    @RequestMapping("/uss/umt/user/EgovUserInsert.do")
    public String insertUser(
            @ModelAttribute("userManageVO") UserManageVO userManageVO,
            BindingResult bindingResult,
            Model model
            )throws Exception {

        beanValidator.validate(userManageVO, bindingResult);
    	if (bindingResult.hasErrors()){
    		ComDefaultCodeVO vo = new ComDefaultCodeVO();
    		//패스워드힌트목록을 코드정보로부터 조회
            //vo.setCodeId("COM022");
            //model.addAttribute("passwordHint_result", cmmUseService.selectCmmCodeDetail(vo));     //패스워트힌트목록

            //성별구분코드를 코드정보로부터 조회
            vo.setCodeId("COM014");
            //List sexdstnCode_result = cmmUseService.selectCmmCodeDetail(vo);
            model.addAttribute("sexdstnCode_result", cmmUseService.selectCmmCodeDetail(vo));

            //사용자상태코드를 코드정보로부터 조회
            vo.setCodeId("COM013");
            model.addAttribute("emplyrSttusCode_result",cmmUseService.selectCmmCodeDetail(vo));

            //소속기관코드를 코드정보로부터 조회 - COM025
            vo.setCodeId("COM025");
            model.addAttribute("insttCode_result", cmmUseService.selectCmmCodeDetail(vo));

            //조직정보를 조회 - ORGNZT_ID정보
            vo.setTableNm("LETTNORGNZTINFO");
            model.addAttribute("orgnztId_result", cmmUseService.selectOgrnztIdDetail(vo));

            //그룹정보를 조회 - GROUP_ID정보
            vo.setTableNm("LETTNORGNZTINFO");
            model.addAttribute("groupId_result", cmmUseService.selectGroupIdDetail(vo));
    		//return "forward:/uss/umt/user/EgovUserInsertView.do";
                    	
    		return "cmm/uss/umt/EgovUserInsert";
		}else{
			userManageService.insertUser(userManageVO);
	        //Exception 없이 진행시 등록성공메시지
	        model.addAttribute("resultMsg", "success.common.insert");
		}
    	return "cmm/uss/umt/EgovUserInsert";
    }

    /**
     * 사용자정보 수정을 위해 사용자정보를 상세조회한다.
     * @param uniqId 상세조회대상 사용자아이디
     * @param userSearchVO 검색조건
     * @param model 화면모델
     * @return cmm/uss/umt/EgovUserSelectUpdt
     * @throws Exception
     */
    @RequestMapping("/uss/umt/user/EgovUserSelectUpdtView.do")
    public String updateUserView(
            @RequestParam("selectedId") String uniqId ,
            @ModelAttribute("searchVO") UserDefaultVO userSearchVO, Model model)
            throws Exception {

        ComDefaultCodeVO vo = new ComDefaultCodeVO();

        //패스워드힌트목록을 코드정보로부터 조회
        vo.setCodeId("COM022");
        model.addAttribute("passwordHint_result", cmmUseService.selectCmmCodeDetail(vo));

        //성별구분코드를 코드정보로부터 조회
        vo.setCodeId("COM014");
        model.addAttribute("sexdstnCode_result", cmmUseService.selectCmmCodeDetail(vo));

        //사용자상태코드를 코드정보로부터 조회
        vo.setCodeId("COM013");
        model.addAttribute("emplyrSttusCode_result", cmmUseService.selectCmmCodeDetail(vo));

        //소속기관코드를 코드정보로부터 조회 - COM025
        vo.setCodeId("COM025");
        model.addAttribute("insttCode_result", cmmUseService.selectCmmCodeDetail(vo));

        //조직정보를 조회 - ORGNZT_ID정보
        vo.setTableNm("LETTNORGNZTINFO");
        model.addAttribute("orgnztId_result", cmmUseService.selectOgrnztIdDetail(vo));

        //그룹정보를 조회 - GROUP_ID정보
        vo.setTableNm("LETTNORGNZTINFO");
        model.addAttribute("groupId_result", cmmUseService.selectGroupIdDetail(vo));

        UserManageVO userManageVO = new UserManageVO();
        userManageVO = userManageService.selectUser(uniqId);
        model.addAttribute("userSearchVO", userSearchVO);
        model.addAttribute("userManageVO", userManageVO);
        
        vo.setCodeId("COM030");
        model.addAttribute("expireFlag_result", cmmUseService.selectCmmCodeDetail(vo));

        return "cmm/uss/umt/EgovUserSelectUpdt";
    }

    /**
     * 사용자정보 수정후 목록조회 화면으로 이동한다.
     * @param userManageVO 사용자수정정보
     * @param bindingResult 입력값검증용 bindingResult
     * @param model 화면모델
     * @return forward:/uss/umt/user/EgovUserManage.do
     * @throws Exception
     */
    @RequestMapping("/uss/umt/user/EgovUserSelectUpdt.do")
    public String updateUser(
			@RequestParam Map<String, Object> commandMap,
            @ModelAttribute("userManageVO") UserManageVO userManageVO,
            BindingResult bindingResult,
            Model model
            )throws Exception {

        beanValidator.validate(userManageVO, bindingResult);
    	if (bindingResult.hasErrors()){
    		ComDefaultCodeVO vo = new ComDefaultCodeVO();

            //패스워드힌트목록을 코드정보로부터 조회
            vo.setCodeId("COM022");
            model.addAttribute("passwordHint_result", cmmUseService.selectCmmCodeDetail(vo));

            //성별구분코드를 코드정보로부터 조회
            vo.setCodeId("COM014");
            model.addAttribute("sexdstnCode_result", cmmUseService.selectCmmCodeDetail(vo));

            //사용자상태코드를 코드정보로부터 조회
            vo.setCodeId("COM013");
            model.addAttribute("emplyrSttusCode_result", cmmUseService.selectCmmCodeDetail(vo));

            //소속기관코드를 코드정보로부터 조회 - COM025
            vo.setCodeId("COM025");
            model.addAttribute("insttCode_result", cmmUseService.selectCmmCodeDetail(vo));

            //조직정보를 조회 - ORGNZT_ID정보
            vo.setTableNm("LETTNORGNZTINFO");
            model.addAttribute("orgnztId_result", cmmUseService.selectOgrnztIdDetail(vo));

            //그룹정보를 조회 - GROUP_ID정보
            vo.setTableNm("LETTNORGNZTINFO");
            model.addAttribute("groupId_result", cmmUseService.selectGroupIdDetail(vo));
            
            return "cmm/uss/umt/EgovUserSelectUpdt";
            
		}else{
			
			String oldPassword = (String)commandMap.get("oldpassword");
	        String newPassword = (String)commandMap.get("newpassword");
	        String newPassword2 = (String)commandMap.get("newpassword2");
	        String emplyrId = (String)commandMap.get("emplyrId");
	        String uniqId = (String)commandMap.get("uniqId");

	        //패스워드 업데이트
	        userManageVO.setPassword(EgovFileScrty.encryptPassword(newPassword, userManageVO.getEmplyrId()));
    		userManageService.updatePassword(userManageVO);
    		//그 외 정보 업데이트
    		//업무사용자 수정시 히스토리 정보를 등록한다.
	        userManageService.insertUserHistory(userManageVO);
	        userManageService.updateUser(userManageVO);
	        
            model.addAttribute("userManageVO", userManageVO);
            
            String resultMsg = "success.common.update";
	    	model.addAttribute("resultMsg", resultMsg);
	    	
//	        return "forward:/uss/umt/user/EgovUserManage.do";
	    	return "cmm/uss/umt/EgovUserUpdate";
		}
    }

    /**
     * 사용자정보삭제후 목록조회 화면으로 이동한다.
     * @param checkedIdForDel 삭제대상아이디 정보
     * @param userSearchVO 검색조건
     * @param model 화면모델
     * @return forward:/uss/umt/user/EgovUserManage.do
     * @throws Exception
     */
    @RequestMapping("/uss/umt/user/EgovUserDelete.do")
    public String deleteUser(
            @RequestParam("checkedIdForDel") String checkedIdForDel ,
            @ModelAttribute("searchVO") UserDefaultVO userSearchVO, Model model)
            throws Exception {
    	//log.debug("jjycon_delete-->"+checkedIdForDel);
        userManageService.deleteUser(checkedIdForDel);
        //Exception 없이 진행시 등록성공메시지
        model.addAttribute("resultMsg", "success.common.delete");
        return "forward:/uss/umt/user/EgovUserManage.do";
    }

    /**
     * 입력한 사용자아이디의 중복확인화면 이동
     * @param model 화면모델
     * @return cmm/uss/umt/EgovIdDplctCnfirm
     * @throws Exception
     */
    @RequestMapping(value="/uss/umt/cmm/EgovIdDplctCnfirmView.do")
    public String checkIdDplct(ModelMap model)
            throws Exception {
        model.addAttribute("checkId", "");
        model.addAttribute("usedCnt", "-1");
        return "cmm/uss/umt/EgovIdDplctCnfirm";
    }

    /**
     * 입력한 사용자아이디의 중복여부를 체크하여 사용가능여부를 확인
     * @param commandMap 파라메터전달용 commandMap
     * @param model 화면모델
     * @return cmm/uss/umt/EgovIdDplctCnfirm
     * @throws Exception
     */
    @RequestMapping(value="/uss/umt/cmm/EgovIdDplctCnfirm.do")
    public String checkIdDplct(@RequestParam Map<String, Object> commandMap, ModelMap model)throws Exception {

    	String checkId = (String)commandMap.get("checkId");
    	checkId =  new String(checkId.getBytes("ISO-8859-1"), "UTF-8");

    	if (checkId==null || checkId.equals("")) return "forward:/uss/umt/EgovIdDplctCnfirmView.do";

        int usedCnt = userManageService.checkIdDplct(checkId);
        model.addAttribute("usedCnt", usedCnt);
        model.addAttribute("checkId", checkId);

        return "cmm/uss/umt/EgovIdDplctCnfirm";
    }

    /**
     * 업무사용자 암호 수정처리 후 화면 이동
     * @param model 화면모델
     * @param commandMap 파라메터전달용 commandMap
     * @param userSearchVO 검색조 건
     * @param userManageVO 사용자수정정보(비밀번호)
     * @return cmm/uss/umt/EgovUserPasswordUpdt
     * @throws Exception
     */
    @RequestMapping(value="/uss/umt/user/EgovUserPasswordUpdt.do")
    public String updatePassword(ModelMap model,
    							 @RequestParam Map<String, Object> commandMap,
    		  					 @ModelAttribute("searchVO") UserDefaultVO userSearchVO,
    		  					 @ModelAttribute("userManageVO") UserManageVO userManageVO)
    							throws Exception {
    	String oldPassword = (String)commandMap.get("oldPassword");
        String newPassword = (String)commandMap.get("newPassword");
        String newPassword2 = (String)commandMap.get("newPassword2");
        String uniqId = (String)commandMap.get("uniqId");

        boolean isCorrectPassword=false;
        UserManageVO resultVO = new UserManageVO();
        userManageVO.setPassword(newPassword);
        userManageVO.setOldPassword(oldPassword);
        userManageVO.setUniqId(uniqId);

    	String resultMsg = "";
    	resultVO = userManageService.selectPassword(userManageVO);
    	//패스워드 암호화
		String encryptPass = EgovFileScrty.encryptPassword(oldPassword, userManageVO.getEmplyrId());
    	if (encryptPass.equals(resultVO.getPassword())){
    		if (newPassword.equals(newPassword2)){
        		isCorrectPassword = true;
        	}else{
        		isCorrectPassword = false;
        		resultMsg="fail.user.passwordUpdate2";
        	}
    	}else{
    		isCorrectPassword = false;
    		resultMsg="fail.user.passwordUpdate1";
    	}

    	if (isCorrectPassword){
    		userManageVO.setPassword(EgovFileScrty.encryptPassword(newPassword, userManageVO.getEmplyrId()));
    		userManageService.updatePassword(userManageVO);
            model.addAttribute("userManageVO", userManageVO);
            resultMsg = "success.common.update";
        }else{
        	model.addAttribute("userManageVO", userManageVO);
        }
    	model.addAttribute("userSearchVO", userSearchVO);
    	model.addAttribute("resultMsg", resultMsg);

        return "cmm/uss/umt/EgovUserPasswordUpdt";
    }
    
    
    @RequestMapping(value="/uss/umt/user/EgovUserUserPasswordUpdt.do")
    public String updateUserPassword(ModelMap model,
    							 @RequestParam Map<String, Object> commandMap,
    		  					 @ModelAttribute("userManageVO") UserManageVO userManageVO)
    							throws Exception {
    	String oldPassword = (String)commandMap.get("oldPassword");
        String newPassword = (String)commandMap.get("newPassword");
        String newPassword2 = (String)commandMap.get("newPassword2");
        String emplyrId = (String)commandMap.get("emplyrId");
        String uniqId = (String)commandMap.get("uniqId");

        boolean isCorrectPassword=false;
        UserManageVO resultVO = new UserManageVO();
        userManageVO.setPassword(newPassword);
        userManageVO.setOldPassword(oldPassword);
        userManageVO.setUniqId(uniqId);
        
    	String resultMsg = "";
    	resultVO = userManageService.selectPassword(userManageVO);
    	
    	//패스워드 암호화
		String encryptPass = EgovFileScrty.encryptPassword(oldPassword, userManageVO.getEmplyrId());
		
    	if (encryptPass.equals(resultVO.getPassword())){
    	
    		if (newPassword.equals(newPassword2)){
    			isCorrectPassword = true;
        	}else{
        		isCorrectPassword = false;
        		resultMsg="fail.user.passwordUpdate2";
        	}
    	}else{
    		isCorrectPassword = false;
    		resultMsg="fail.user.passwordUpdate1";
    	}
    	
    	if (isCorrectPassword){
    		userManageVO.setPassword(EgovFileScrty.encryptPassword(newPassword, userManageVO.getEmplyrId()));
    		userManageService.updatePassword(userManageVO);
            model.addAttribute("userManageVO", userManageVO);
            resultMsg = "success.common.update";
        }else{
        	model.addAttribute("userManageVO", userManageVO);
        }

    	model.addAttribute("userId", emplyrId);
    	model.addAttribute("selectedId", uniqId);
    	model.addAttribute("resultMsg", resultMsg);
    	
        return "cmm/uss/umt/EgovUserPasswordUserUpdt";
    }

    /**
     * 업무사용자 암호 수정  화면 이동
     * @param model 화면모델
     * @param commandMap 파라메터전달용 commandMap
     * @param userSearchVO 검색조건
     * @param userManageVO 사용자수정정보(비밀번호)
     * @return cmm/uss/umt/EgovUserPasswordUpdt
     * @throws Exception
     */
    @RequestMapping(value="/uss/umt/user/EgovUserPasswordUpdtView.do")
    public String updatePasswordView(ModelMap model,
    								@RequestParam Map<String, Object> commandMap,
    								@ModelAttribute("searchVO") UserDefaultVO userSearchVO,
    								@ModelAttribute("userManageVO") UserManageVO userManageVO) throws Exception {
    	String userTyForPassword = (String)commandMap.get("userTyForPassword");
    	userManageVO.setUserTy(userTyForPassword);

    	model.addAttribute("userManageVO", userManageVO);
        model.addAttribute("userSearchVO", userSearchVO);
    	return "cmm/uss/umt/EgovUserPasswordUpdt";
    }


    @RequestMapping(value="/uss/umt/user/EgovUserPasswordUpdtUserView.do")
    public String updatePasswordUserView(ModelMap model,
    		@RequestParam("selectedId") String userId ,
    		@RequestParam("uniqueId") String uniqId  ) throws Exception {
    	
    	model.addAttribute("userId", userId);
        model.addAttribute("selectedId", uniqId);
    	return "cmm/uss/umt/EgovUserPasswordUserUpdt";
    }
}
