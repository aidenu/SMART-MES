package egovframework.let.uat.uia.web;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpServletResponse;

import org.springframework.context.ApplicationContext;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.support.WebApplicationContextUtils;

import space.common.SpaceCommonDAOImpl;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.utl.slm.EgovHttpSessionBindingListener;
import egovframework.com.utl.slm.EgovMultiLoginPreventor;
import egovframework.let.sym.mnu.mpm.service.EgovMenuManageService;
import egovframework.let.sym.mnu.mpm.service.MenuManageVO;
import egovframework.let.uat.uap.service.EgovLoginPolicyService;
import egovframework.let.uat.uap.service.LoginPolicyVO;
import egovframework.let.uat.uia.service.EgovLoginService;
import egovframework.let.utl.sim.service.EgovClntInfo;
import egovframework.rte.fdl.cmmn.trace.LeaveaTrace;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;

/**
 * 일반 로그인, 인증서 로그인을 처리하는 컨트롤러 클래스
 * @author 공통서비스 개발팀 박지욱
 * @since 2009.03.06
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자          수정내용
 *  -------    --------    ---------------------------
 *  2009.03.06  박지욱          최초 생성
 *  2011.08.31  JJY            경량환경 템플릿 커스터마이징버전 생성
 *
 *  </pre>
 */
@Controller
public class EgovLoginController {

    /** EgovLoginService */
	@Resource(name = "loginService")
    private EgovLoginService loginService;

	/** EgovMessageSource */
    @Resource(name="egovMessageSource")
    EgovMessageSource egovMessageSource;

	/** EgovLoginPolicyService */
	@Resource(name="egovLoginPolicyService")
	EgovLoginPolicyService egovLoginPolicyService;

	/** EgovPropertyService */
    @Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;

    /** TRACE */
    @Resource(name="leaveaTrace")
    LeaveaTrace leaveaTrace;
    
    @Resource(name="spaceCommonDAO")
	private SpaceCommonDAOImpl spaceCommonDAO;
    
    /** EgovMenuManageService */
	@Resource(name = "meunManageService")
    private EgovMenuManageService menuManageService;

	/**
	 * 로그인 화면으로 들어간다
	 * @param vo - 로그인후 이동할 URL이 담긴 LoginVO
	 * @return 로그인 페이지
	 * @exception Exception
	 */
    @RequestMapping(value="/uat/uia/egovLoginUsr.do")
	public String loginUsrView(@ModelAttribute("loginVO") LoginVO loginVO,
			HttpServletRequest request,
			HttpServletResponse response,
			ModelMap model)
			throws Exception {
    	return "uat/uia/EgovLoginUsr";
	}

    /**
	 * 일반(스프링 시큐리티) 로그인을 처리한다
	 * @param vo - 아이디, 비밀번호가 담긴 LoginVO
	 * @param request - 세션처리를 위한 HttpServletRequest
	 * @return result - 로그인결과(세션정보)
	 * @exception Exception
	 */
    @RequestMapping(value="/uat/uia/actionSecurityLogin.do")
    public String actionSecurityLogin(@ModelAttribute("loginVO") LoginVO loginVO, HttpServletResponse response,
    		                   HttpServletRequest request,
    		                   ModelMap model)
            throws Exception {
    	
    	// 접속IP
    	String userIp = EgovClntInfo.getClntIP(request);

    	// 메뉴 컨텐츠 링크로 바로 들어 올 경우 사용자 정보가 없으면 로그인 화면으로 넘긴다
    	if(loginVO.getId() == null) {
    		model.addAttribute("message", egovMessageSource.getMessage("space.common.alert.session.expire"));
        	return "uat/uia/EgovLoginUsr";
    	}
    	
    	// 1. 일반 로그인 처리
        LoginVO resultVO = loginService.actionLogin(loginVO);
        
        //퇴사자는 로그인 할 수 없게 함
        if("Y".equals(resultVO.getIhidNum()))
        {
            model.addAttribute("message", egovMessageSource.getMessage("fail.common.login.expire"));
            return "uat/uia/EgovLoginUsr";
        }

        boolean loginPolicyYn = true;

        LoginPolicyVO loginPolicyVO = new LoginPolicyVO();
		loginPolicyVO.setEmplyrId(resultVO.getId());
		loginPolicyVO = egovLoginPolicyService.selectLoginPolicy(loginPolicyVO);

		if (loginPolicyVO == null) {
		    loginPolicyYn = true;
		} else {
		    if (loginPolicyVO.getLmttAt().equals("Y")) {
				if (!userIp.equals(loginPolicyVO.getIpInfo())) {
				    loginPolicyYn = false;
				}
		    }
		}

        if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("") && loginPolicyYn) {

        	/*if(EgovMultiLoginPreventor.findByLoginId(resultVO.getId()))
        	{
        		model.addAttribute("message", "이미 사용중인 아이디 입니다");
            	return "uat/uia/EgovLoginUsr";
        	}
        	else
        	{*/
	            // 2. spring security 연동
	        	UsernamePasswordAuthenticationFilter springSecurity = null;
	
	        	ApplicationContext act = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getSession().getServletContext());
	        	@SuppressWarnings("rawtypes")
	        	Map beans = act.getBeansOfType(UsernamePasswordAuthenticationFilter.class);
	        	if (beans.size() > 0) {
	        		springSecurity = (UsernamePasswordAuthenticationFilter)beans.values().toArray()[0];
	        	} else {
	        		throw new IllegalStateException("No AuthenticationProcessingFilter");
	        	}
	
	        	springSecurity.setContinueChainBeforeSuccessfulAuthentication(false);	// false 이면 chain 처리 되지 않음.. (filter가 아닌 경우 false로...)
	
	        	springSecurity.doFilter(new RequestWrapperForSecurity(request, resultVO.getUserSe() + resultVO.getId() , resultVO.getUniqId()), response, null);
	        	
	        	request.getSession().setAttribute("LoginVO", resultVO);
	        	
	        	EgovHttpSessionBindingListener listener = new EgovHttpSessionBindingListener();
	        	request.getSession().setAttribute(resultVO.getId(), listener);
	        	
	        	return "forward:/uat/uia/actionMain.do";	// 성공 시 페이지.. (redirect 불가)
        	//}

        } else {
        	model.addAttribute("message", egovMessageSource.getMessage("fail.common.login"));
        	return "uat/uia/EgovLoginUsr";
        }
    }
    

    /**
	 * 로그인 후 메인화면으로 들어간다
	 * @param
	 * @return 로그인 페이지
	 * @exception Exception
	 */
    @RequestMapping(value="/uat/uia/actionMain.do")
	public String actionMain(
			HttpServletResponse response,
            HttpServletRequest request,
			ModelMap model)
			throws Exception {
    	// 1. Spring Security 사용자권한 처리
    	
    	Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
    	
    	FileReader filereader = null;
    	BufferedReader bufferedReaderr = null;
    	    	
    	if(!isAuthenticated) {
    		//model.addAttribute("message", egovMessageSource.getMessage("fail.common.login"));
    		
    		/*
    		// 타임서버의 시간과 라이센스 파일의 만료일을 비교하여 만료일이 지나면 로그인 불가
        	try
        	{
        		//타임서버에서 현재 시간을 가져온다
        		String TIME_SERVER = "time-a.nist.gov";   
    			NTPUDPClient timeClient = new NTPUDPClient();
    			InetAddress inetAddress = InetAddress.getByName(TIME_SERVER);
    			TimeInfo timeInfo = timeClient.getTime(inetAddress);
    			long returnTime = timeInfo.getMessage().getTransmitTimeStamp().getTime();
    			Date servertime = new Date(returnTime);
    			SimpleDateFormat format = new SimpleDateFormat("yyyy.MM.dd");
    			String timeServer = format.format(servertime);
    			
    			//라이센스 파일에서 만료일을 가져온다
    			File file = new File(propertiesService.getString("Globals.fileStorePath")+"license.srt");
    			filereader = new FileReader(file);
    			bufferedReaderr = new BufferedReader(filereader);
    			
    			String expire = "";
    			
    			long diffDate = 0L;
    			int countDate = 0;
    			
    			if((expire = bufferedReaderr.readLine()) != null)
    			{
    				expire = EgovFileScrty.decode(expire);
    				
    				Calendar startCal = Calendar.getInstance();
    				Calendar endCal = Calendar.getInstance();
    				
    				startCal.set(Integer.parseInt(timeServer.substring(0, 4)),Integer.parseInt(timeServer.substring(5, 7)),Integer.parseInt(timeServer.substring(8, 10)));
    				endCal.set(Integer.parseInt(expire.substring(0, 4)),Integer.parseInt(expire.substring(5, 7)),Integer.parseInt(expire.substring(8, 10)));
    				
    				diffDate = startCal.getTimeInMillis() - endCal.getTimeInMillis();
    				
    				countDate = (int) (diffDate/(24 *60 * 60 *1000));
    				
    				if(countDate == 0)
    				{
    					request.getSession().setAttribute("expiremsg", egovMessageSource.getMessage("alert.license.today"));
    					//msg =  egovMessageSource.getMessage("alert.license.today");
    				}
    				else if(countDate<0 && countDate>-31)
    				{
    					request.getSession().setAttribute("expiremsg", egovMessageSource.getMessage("alert.license.remind.pre") + Math.abs(countDate) + egovMessageSource.getMessage("alert.license.remind.suf"));
    					//msg =  egovMessageSource.getMessage("alert.license.remind.pre") + Math.abs(countDate) + egovMessageSource.getMessage("alert.license.remind.suf");
    				}
    				else if(countDate>0)
    				{
    					model.addAttribute("message", egovMessageSource.getMessage("alert.license.expire"));
    					return "uat/uia/EgovLoginUsr";
    				}
    			}
    			else
    			{
    				System.out.println("license file not found");
    				return "uat/uia/EgovLoginUsr";
    			}
    			
    			bufferedReaderr.close();
    			filereader.close();
        	}
        	catch(Exception e)
        	{
        		System.out.println("license file read error : " + e.toString());
        	}
        	
        	if(bufferedReaderr != null){bufferedReaderr.close();}
        	if(filereader != null){filereader.close();}
        	
        	
        	//사용자 정보 테이블의 유효 사용자수가 계약된 사용자수 보다 많으면 사용 제한을 건다
        	try
        	{
        		//라이센스 파일에서 사용자 제한 수를 가져온다
    			File file = new File(propertiesService.getString("Globals.fileStorePath")+"user.srt");
    			filereader = new FileReader(file);
    			bufferedReaderr = new BufferedReader(filereader);
    			
    			String userlimit = "";
    			
    			if((userlimit = bufferedReaderr.readLine()) != null)
    			{
    				userlimit = EgovFileScrty.decode(userlimit);
    			}
    			
    	    	List<HashMap> resultUser = spaceCommonDAO.nosessioncommonDataProc("selectUserCount");
    	    	
    			if (resultUser != null && resultUser.size() > 0)
    			{
    					
    				String userCnt = resultUser.get(0).get("USER_CNT").toString();
    				
    				int iuserCnt = Integer.parseInt(userCnt);
    				int iuserlimit = Integer.parseInt(userlimit);
    			
    				if(iuserCnt > iuserlimit)
    				{
    					model.addAttribute("message", egovMessageSource.getMessage("alert.license.user.count"));
    					return "uat/uia/EgovLoginUsr";
    				}
    			}
    			
    			bufferedReaderr.close();
    			filereader.close();
        	}
        	catch(Exception ee)
        	{
        		System.out.println("user count select error : " + ee.toString());
        	}
        	
        	if(bufferedReaderr != null){bufferedReaderr.close();}
        	if(filereader != null){filereader.close();}*/
        	
        	return "uat/uia/EgovLoginUsr";
    	}
    	    	
		// 2. 메인 페이지 이동
    	//return "forward:/cmm/main/mainPage.do";
    	
    	MenuManageVO menuManageVO = new MenuManageVO();
    	
    	LoginVO user = EgovUserDetailsHelper.isAuthenticated()? (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser():null;
    	
    	menuManageVO.setTmp_UniqId(user.getUniqId());
    	
    	// 사용자별 첫번째 메뉴 링크를 가져 온다
    	List munuList = menuManageService.selectMainMenuFirst(menuManageVO);
    	String returnUrl = "";
    	
    	if(munuList != null && munuList.size()>0)
    	{
    			//System.out.println(munuList.get(0).toString().replace("{", "").replace("}", "").replace("returnurl=", ""));
    			returnUrl = munuList.get(0).toString().replace("{", "").replace("}", "").replace("returnurl=", "");
    	}
    	
    	
    	return "forward:"+returnUrl;
	}

    /**
	 * 로그아웃한다.
	 * @return String
	 * @exception Exception
	 */
    @RequestMapping(value="/uat/uia/actionLogout.do")
	public String actionLogout(HttpServletRequest request, ModelMap model) throws Exception {
    	
    	if(request.getSession() != null)
    	{
    		//request.getSession().setAttribute("LoginVO", null);
    		RequestContextHolder.getRequestAttributes().removeAttribute("LoginVO", RequestAttributes.SCOPE_SESSION);
    		request.getSession().invalidate();
    	}
    	
    	return "redirect:/j_spring_security_logout";
    }
}

class RequestWrapperForSecurity extends HttpServletRequestWrapper {
	private String username = null;
	private String password = null;

	public RequestWrapperForSecurity(HttpServletRequest request, String username, String password) {
		super(request);

		this.username = username;
		this.password = password;
	}

	@Override
	public String getRequestURI() {
		return ((HttpServletRequest)super.getRequest()).getContextPath() + "/j_spring_security_check";
	}

	@Override
	public String getParameter(String name) {
        if (name.equals("j_username")) {
        	return username;
        }

        if (name.equals("j_password")) {
        	return password;
        }

        return super.getParameter(name);
    }
}