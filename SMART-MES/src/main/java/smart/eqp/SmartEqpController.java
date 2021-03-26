package smart.eqp;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.RandomAccessFile;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.usermodel.charts.*;
import org.apache.poi.ss.util.*;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFChart;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.openxmlformats.schemas.drawingml.x2006.chart.CTBoolean;
import org.openxmlformats.schemas.drawingml.x2006.chart.CTLineSer;
import org.openxmlformats.schemas.drawingml.x2006.chart.CTPlotArea;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.EgovFileMngService;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.com.cmm.service.FileVO;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import smart.common.SmartCommonDAOImpl;
import smart.common.SmartGcmSender;

@Controller
public class SmartEqpController {

	Logger logger = Logger.getLogger("egovframework");
	
	@Resource(name="smartCommonDAO")
	private SmartCommonDAOImpl SmartCommonDAO;
	
	@Resource(name="smartGcmSender")
	private SmartGcmSender smartGcmSender;
	
	@Resource(name = "propertiesService")
    protected EgovPropertyService propertyService;
	
	/** 파일첨부 Util */
	@Resource(name="EgovFileMngUtil")
	private EgovFileMngUtil fileUtil;
	
	/** 파일첨부 관리 서비스 */
	@Resource(name="EgovFileMngService")
	private EgovFileMngService fileMngService;
	
	
	
	@RequestMapping(value="/smart/eqp/SmartPatLite.do")
	public String SmartPatLite(
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
			logger.error("[/smart/eqp/SmartPatLite.do] Exception :: " + e.toString());
		}
		
		return "smart/eqp/SmartPatLite";
	}
	
	
	
	@RequestMapping(value="/smart/eqp/SmartSodicEqp.do")
	public String SmartSodicEqp(
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
			logger.error("[/smart/smes/SmartSodicEqp.do] Exception :: " + e.toString());
		}
		
		return "smart/eqp/SmartSodicEqp";
	}
	
	
	@RequestMapping(value="/smart/eqp/SmartSodicEqpData.do")
	public String SmartSodicEqpData(
			ModelMap model) throws Exception {
		
		
		try {
			
			List<HashMap> resultLocate = SmartCommonDAO.commonDataProc("getSodicLocate");
			if(resultLocate != null && resultLocate.size() > 0) 
			{
				model.addAttribute("filelocation", resultLocate.get(0).get("FILE_LOCATE"));
			}
			
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("getSodicEqpData");
			model.addAttribute("result", result);
			
			List<HashMap> resultStack = SmartCommonDAO.commonDataProc("getSodicEqpDailyStack");
			model.addAttribute("resultStack", resultStack);
			
			List<HashMap> resultTimeline = SmartCommonDAO.commonDataProc("getSodicEqpDailyTimeline");
			model.addAttribute("resultTimeline", resultTimeline);
			
		} catch(Exception e) {
			logger.error("[/smart/eqp/SmartSodicEqpData.do] Exception :: " + e.toString());
		}
		return "smart/eqp/SmartSodicEqpData";
	}
	
	
	@RequestMapping(value="/smart/eqp/SmartPxEqp.do")
	public String SmartPxEqp(
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
			logger.error("[/smart/eqp/SmartPxEqp.do] Exception :: " + e.toString());
		}
		
		return "smart/eqp/SmartPxEqp";
	}
	
	
	@RequestMapping(value="/smart/eqp/SmartPxEqpData.do")
	public String SmartPxEqpData(ModelMap model) throws Exception {
		
		try {
			
			String fileLocate = "";
			
			List<HashMap> resultLocate = SmartCommonDAO.commonDataProc("getPxFileLocate");
			
			if(resultLocate != null && resultLocate.size() > 0)
			{
				fileLocate = resultLocate.get(0).get("FILE_LOCATE").toString();
				model.addAttribute("fileLocate", fileLocate);
			}
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("getPxEqpInfo");
			
			HashMap<String,String> status = null;
			
			File pxFile = null;
			File pxImgFile = null;
			BufferedReader filereader;
			String line = "";
			
			if(result != null && result.size() > 0)
			{
				for(int i=0; i<result.size(); i++)
				{
					String os = System.getProperty("os.name").toLowerCase();
					if (os.contains("mac")) { 
						pxFile = new File(fileLocate +"/" + result.get(i).get("FOLDER_NAME") + "/STATUS.dat");
					} else { 
						pxFile = new File(fileLocate +"\\" + result.get(i).get("FOLDER_NAME") + "\\STATUS.dat");
					}
					
					
					if(pxFile.exists())
					{
						filereader = new BufferedReader(new FileReader(pxFile));
						
						//첫번째 줄의 데이터만 출력
						while((line = filereader.readLine()) != null)
						{
							String[] lineData = line.split("\\t");
//							System.out.println(result.get(i).get("FOLDER_NAME") +"::"+ line);
							result.get(i).put("EQP_FLAG", lineData[0]);
							result.get(i).put("EQP_STATUS", lineData[1]);
							break;
						}
						
						filereader.close();
					}
				}
			}
			
			model.addAttribute("result", result);
			
			System.out.println(result);
			
		} catch(Exception e) {
			logger.error("[/smart/eqp/SmartPxEqpData.do] Exception :: " + e.toString());
		}
		
		return "smart/eqp/SmartPxEqpData";
	}
	
	
}