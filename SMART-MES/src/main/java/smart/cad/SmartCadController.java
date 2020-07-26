package smart.cad;

import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.cmm.LoginVO;
import egovframework.let.utl.fcc.service.EgovStringUtil;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import smart.common.SmartCommonDAOImpl;

@Controller
public class SmartCadController {
	
	
	Logger logger = Logger.getLogger("egovframework");
	
	@Resource(name="smartCommonDAO")
	private SmartCommonDAOImpl SmartCommonDAO;
		
	@Resource(name="messageSource")
	MessageSource messageSource ;
		
	@Resource(name = "propertiesService")
    protected EgovPropertyService propertyService;
	
	
	@RequestMapping("/smart/cad/SmartCad.do")
	public String SmartCad (
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
			logger.error("[/smart/cad/SmartCad.do] Exception :: " + e.toString());
		}
		
		return "smart/cad/SmartCad";
	}
	
	@RequestMapping("/smart/cad/SmartCadData.do")
	@ResponseBody
	public List<HashMap> SmartCadData(
			@RequestParam(value="startDate", required=false) String startDate,
			@RequestParam(value="endDate", required=false) String endDate,
			ModelMap model) throws Exception {
		
		List<HashMap> result  = null;
		try {
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("startDate", startDate);
			hp.put("endDate", endDate);
			hp.put("userid", loginVO.getId());
			
			result = SmartCommonDAO.commonDataProc("getCadModelData", hp);
			model.addAttribute("result", result);
			
		} catch(Exception e) {
			logger.error("[/smart/cad/SmartCadData.do] Exception :: " + e.toString());
		}
		
		return result;
	}
	
	
	@RequestMapping("/smart/cad/SmartCadPartListExcel.do")
	@ResponseBody
	public String SmartCadPartListExcel(
			MultipartHttpServletRequest request,
			@RequestParam(value="modelid", required=false) String modelid,
			ModelMap model) throws Exception {
		
		String actionresult = "";
		
		try {
			String storePathString = propertyService.getString("Globals.fileStorePath")  + "PART_LIST/"+modelid ;//첨부 기본 경로
			
			MultipartFile file = request.getFile("partlist");
			String excelFilename = "";
			InputStream stream = null;
			HashMap<String,String> hm = null;
			ArrayList<HashMap<String,String>> result = new ArrayList<HashMap<String,String>>();
			
			if(!file.isEmpty()) {
				excelFilename = file.getOriginalFilename();
				stream = file.getInputStream();
				
				if(!"".equals(excelFilename) && stream != null && excelFilename.lastIndexOf("xlsx")>-1) {
					//xlsx 포맷 엑셀인 경우
					XSSFWorkbook  workbook = new XSSFWorkbook (stream);//MultipartHttpServletRequest로 넘어온 파일을 서버에 쓰지 않고 바로 InputStream으로 받아서 읽어 들인다
					XSSFRow row;
					XSSFCell cell;
					FormulaEvaluator formulaEval = workbook.getCreationHelper().createFormulaEvaluator();//Cell안에 수식이 들어 있는 경우 해당 값을 가져오기 위한 클래스
						
					XSSFSheet sheet = workbook.getSheetAt(0);
					
					//취득된 sheet에서 rows수 취득
					int rows = sheet.getPhysicalNumberOfRows();
					
					//취득된 row에서 취득대상 cell수 취득
					int cells = sheet.getRow(0).getPhysicalNumberOfCells();
					
					
					String valueRow = "";
					String valueCell = "";
					
					for (int r = 2; r < rows; r++) {
						//3번째 줄부터 데이터로 인식 
						row = sheet.getRow(r); // row 가져오기
						
						valueRow = "";
						
						hm = new HashMap<String,String>();
						
						if (row != null) {
							for (int c = 0; c < cells; c++) {
								cell = row.getCell(c);
								
								valueCell = "";
								
								if (cell != null) {
									switch (cell.getCellType()) {
										case XSSFCell.CELL_TYPE_FORMULA:
											valueRow += formulaEval.evaluate(cell).formatAsString();
											valueCell = formulaEval.evaluate(cell).formatAsString();
											break;
										case XSSFCell.CELL_TYPE_NUMERIC:
											valueRow +=  cell.getNumericCellValue() + "";
											if(DateUtil.isCellDateFormatted(cell)) {
												Date date = cell.getDateCellValue();
												valueCell = new SimpleDateFormat("yyyy-MM-dd").format(date);
											} else {
												valueCell =  cell.getNumericCellValue() + "";
											}
											break;
										case XSSFCell.CELL_TYPE_STRING:
											valueRow += cell.getStringCellValue();
											valueCell = cell.getStringCellValue();
											break;
										case XSSFCell.CELL_TYPE_BLANK:
											break;
										case XSSFCell.CELL_TYPE_ERROR:
											break;
										default:
									}
								} else {
									//System.out.print("[null]\t");
								}
								
								
								if(!"".equals(valueRow)) {
									//ROW값이 비어 있지 않은 경우에만 넣는다
									if(c==0) {
										hm.put("PRODUCTNO", valueCell.replace("\"","'").toString());
									} else if(c==1) {
										hm.put("PRODUCTNAME", valueCell.replace("\"","'"));
									} else if(c==2) {
										hm.put("SIZE", valueCell.replace("\"","'").replaceAll("\n", " / "));
									} else if(c==3) {
										hm.put("MATERIAL", valueCell.replace("\"","'"));
									} else if(c==4) {
										hm.put("COUNT", valueCell.replace("\"","'"));
									} else if(c==5) {
										hm.put("GUBUN", valueCell.replace("\"","'"));
									}
								}
																		
							} // for(c) 문


							if(!"".equals(valueRow)) {
								//ROW값이 비오 있지 않은 경우에만 넣는다
								result.add(hm);
							}
						}
					} // for(r) 문
				}
				else if(!"".equals(excelFilename) && stream != null && excelFilename.lastIndexOf("xls")>-1) {
					//xls 포맷 엑셀인 경우
					HSSFWorkbook  workbook = new HSSFWorkbook (stream);//MultipartHttpServletRequest로 넘어온 파일을 서버에 쓰지 않고 바로 InputStream으로 받아서 읽어 들인다
					HSSFRow row;
					HSSFCell cell;
					FormulaEvaluator formulaEval = workbook.getCreationHelper().createFormulaEvaluator();//Cell안에 수식이 들어 있는 경우 해당 값을 가져오기 위한 클래스
					
					
					HSSFSheet sheet = workbook.getSheetAt(0);
					
					//취득된 sheet에서 rows수 취득
					int rows = sheet.getPhysicalNumberOfRows();
					
					
					//취득된 row에서 취득대상 cell수 취득
					int cells = sheet.getRow(0).getPhysicalNumberOfCells(); //
					
					String valueRow = "";
					String valueCell = "";
					String partgroupno = "";
					
					for (int r = 2; r < rows; r++) //3번쨰 줄부터 데이터로 인식
					{
						row = sheet.getRow(r); // row 가져오기
						
						valueRow = "";
						
						hm = new HashMap<String,String>();
						
						if (row != null) {
							for (int c = 0; c < cells; c++) {
								cell = row.getCell(c);
								
								valueCell = "";
								
								if (cell != null)  {
									switch (cell.getCellType()) {
										case HSSFCell.CELL_TYPE_FORMULA:
											valueRow += formulaEval.evaluate(cell).formatAsString();
											valueCell = formulaEval.evaluate(cell).formatAsString();
											break;
										case HSSFCell.CELL_TYPE_NUMERIC:
											valueRow +=  cell.getNumericCellValue() + "";
											if(DateUtil.isCellDateFormatted(cell)) {
												Date date = cell.getDateCellValue();
												valueCell = new SimpleDateFormat("yyyy-MM-dd").format(date);
											} else {
												valueCell =  cell.getNumericCellValue() + "";
											}
											break;
										case HSSFCell.CELL_TYPE_STRING:
											valueRow += cell.getStringCellValue();
											valueCell = cell.getStringCellValue();
											break;
										case HSSFCell.CELL_TYPE_BLANK:
											break;
										case HSSFCell.CELL_TYPE_ERROR:
											break;
										default:
									}
								} else {
									//System.out.print("[null]\t");
								}
								
								
								if(!"".equals(valueRow)) {
									//ROW값이 비오 있지 않은 경우에만 넣는다
									if(c==0) {
										hm.put("PRODUCTNO", valueCell.replace("\"","'").toString());
									} else if(c==1) {
										hm.put("PRODUCTNAME", valueCell.replace("\"","'"));
									} else if(c==2) {
										hm.put("SIZE", valueCell.replace("\"","'").replaceAll("\n", " / "));
									} else if(c==3) {
										hm.put("MATERIAL", valueCell.replace("\"","'"));
									} else if(c==4) {
										hm.put("COUNT", valueCell.replace("\"","'"));
									} else if(c==5) {
										hm.put("GUBUN", valueCell.replace("\"","'"));
									}
								}
		                    	
							} // for(c) 문


							if(!"".equals(valueRow)) {
								//ROW값이 비오 있지 않은 경우에만 넣는다
								result.add(hm);
							}
						}
					} // for(r) 문
				}
				
			}
			
			if(result != null && result.size()>0)
			{
				StringBuffer sb = new StringBuffer();
				
				for(int i=0 ; i<result.size() ; i++)
				{
					sb.append(EgovStringUtil.isNullToString(result.get(i).get("PRODUCTNO")).toString().replaceAll("\"", ""));
					sb.append("♬");
					sb.append(EgovStringUtil.isNullToString(result.get(i).get("PRODUCTNAME")).toString().replaceAll("\"", ""));
					sb.append("♬");
					sb.append(EgovStringUtil.isNullToString(result.get(i).get("SIZE")).toString().replaceAll("\"", ""));
					sb.append("♬");
					sb.append(EgovStringUtil.isNullToString(result.get(i).get("MATERIAL")).toString().replaceAll("\"", ""));
					sb.append("♬");
					sb.append(EgovStringUtil.isNullToString(result.get(i).get("COUNT")).toString().replaceAll("\"", ""));
					sb.append("♬");
					sb.append(EgovStringUtil.isNullToString(result.get(i).get("GUBUN")).toString().replaceAll("\"", ""));
					sb.append("♩");
				}
				
				LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
				HashMap<String,String> hp = new HashMap<String,String>();
				hp.put("userid", loginVO.getId());
				hp.put("modelid", modelid);
				hp.put("arraystr", sb.toString().substring(0, sb.toString().length()-1));//마지막 ♩는 잘라낸다
				
				List<HashMap>  resultSave  =  SmartCommonDAO.commonDataProc("setPartListExcelRegist",hp);
				
				if(resultSave != null && resultSave.size()>0)
				{
					actionresult = resultSave.get(0).get("ACTION_RESULT").toString();
				}
			}
			else
			{
				actionresult =  "NO DATA";
			}
			
			stream.close();
			
		} catch(Exception e) {
			e.printStackTrace();
			logger.error("[/smart/cad/SmartCadPartListExcel.do] Exception :: " + e.toString());
		}
		return actionresult;
	}
	
	
	@RequestMapping("/smart/cad/SmartCadView.do")
	public String SmartCadView(
			@RequestParam(value="modelid", required=false) String modelid,
			ModelMap model) throws Exception {
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("modelid", modelid);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("getPartList", hp);
			model.addAttribute("result", result);
			
			List<HashMap> resultBasic = SmartCommonDAO.commonDataProc("getBasicData");
			model.addAttribute("resultBasic", resultBasic);
			
			model.addAttribute("modelid", modelid);
			
		} catch(Exception e) {
			logger.error("[/smart/cad/SmartCadView.do] Exception :: " + e.toString());
		}
		
		return "smart/cad/SmartCadView";
	}
	
	
	@RequestMapping("/smart/cad/SmartCadPartRegist.do")
	@ResponseBody
	public String SmartCadPartRegist(
			@RequestParam(value="modelid", required=false) String modelid,
			@RequestParam(value="partgroupno", required=false) String partgroupno,
			@RequestParam(value="partgroupname", required=false) String partgroupname,
			@RequestParam(value="partgroupsize", required=false) String partgroupsize,
			@RequestParam(value="partgroupmaterial", required=false) String partgroupmaterial,
			@RequestParam(value="partgroupcount", required=false) String partgroupcount,
			@RequestParam(value="partgroupgubun", required=false) String partgroupgubun,
			ModelMap model) throws Exception {
		
		String actionresult = "";
		
		try {
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			hp.put("modelid", modelid);
			hp.put("partgroupno", partgroupno);
			hp.put("partgroupname", partgroupname);
			hp.put("partgroupsize", partgroupsize);
			hp.put("partgroupmaterial", partgroupmaterial);
			hp.put("partgroupcount", partgroupcount);
			hp.put("partgroupgubun", partgroupgubun);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("setPartListRegist", hp);
			if(result != null && result.size() > 0) {
				actionresult = result.get(0).get("ACTION_RESULT").toString();
			}
			
			
		} catch(Exception e) {
			logger.error("[/smart/cad/SmartCadPartRegist.do] Exception :: " + e.toString());
		}
		
		return actionresult;
	}
	
	
	@RequestMapping("/smart/cad/SmartCadPartSave.do")
	@ResponseBody
	public String SmartCadPartSave(
			@RequestParam(value="modelid", required=false) String modelid,
			@RequestParam(value="partgroupid", required=false) String partgroupid,
			@RequestParam(value="partgroupno", required=false) String partgroupno,
			@RequestParam(value="partgroupname", required=false) String partgroupname,
			@RequestParam(value="partgroupsize", required=false) String partgroupsize,
			@RequestParam(value="partgroupmaterial", required=false) String partgroupmaterial,
			@RequestParam(value="partgroupcount", required=false) String partgroupcount,
			@RequestParam(value="partgroupgubun", required=false) String partgroupgubun,
			ModelMap model) throws Exception {
		
		String actionresult = "";
		
		try {
			
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			hp.put("modelid", modelid);
			hp.put("partgroupid", partgroupid);
			hp.put("partgroupno", partgroupno);
			hp.put("partgroupname", partgroupname);
			hp.put("partgroupsize", partgroupsize);
			hp.put("partgroupmaterial", partgroupmaterial);
			hp.put("partgroupcount", partgroupcount);
			hp.put("partgroupgubun", partgroupgubun);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("setPartListSave", hp);
			if(result != null && result.size() > 0) {
				actionresult = result.get(0).get("ACTION_RESULT").toString();
			}
			
			
		} catch(Exception e) {
			logger.error("[/smart/cad/SmartCadPartSave.do] Exception :: " + e.toString());
		}
		
		return actionresult;
	}
	
	
	@RequestMapping(value="/smart/cad/SmartCadPartData.do")
	@ResponseBody
	public List<HashMap> SmartCadPartData(
			@RequestParam(value="modelid", required=false) String modelid,
			ModelMap model) throws Exception {
		
		List<HashMap> result = null;
		
		try {
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("modelid", modelid);
			
			result = SmartCommonDAO.commonDataProc("getPartList", hp);
			
		} catch(Exception e) {
			logger.error("[/smart/cad/SmartCadPartData.do] Exception :: " + e.toString());
		}
		return result;
	}
	
	
	
	@RequestMapping(value="/smart/cad/SmartCadPartDelete.do")
	@ResponseBody
	public String SmartCadPartDelete(
			@RequestParam(value="partgroupid", required=false) String partgroupid,
			ModelMap model) throws Exception {
		
		String actionresult = "";
		
		try {
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			hp.put("partgroupid", partgroupid);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("setPartListDelete", hp);
			
			if(result != null && result.size() > 0) {
				actionresult = result.get(0).get("ACTION_RESULT").toString();
			}
			
		} catch(Exception e) {
			logger.error("[/smart/cad/SmartCadPartDelete.do] Exception :: " + e.toString());
		}
		
		return actionresult;
	}
	
	
	@RequestMapping(value="/smart/cad/SmartCadPartOrderSave.do")
	@ResponseBody
	public String SmartCadPartOrderSave(
			@RequestParam(value="actiontype", required=false) String actiontype,
			@RequestParam(value="partgroupid", required=false) String partgroupid,
			@RequestParam(value="orderorg", required=false) String orderorg,
			ModelMap model) throws Exception {
		
		String actionresult = "";
		
		try {
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			hp.put("actiontype", actiontype);
			hp.put("partgroupid", partgroupid);
			hp.put("orderorg", orderorg);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("setPartListOrderSave", hp);
			
			if(result != null && result.size() > 0) {
				actionresult = result.get(0).get("ACTION_RESULT").toString();
			}
			
		} catch(Exception e) {
			logger.error("[/smart/cad/SmartCadPartOrderSave.do] Exception :: " + e.toString());
		}
		
		return actionresult;
	}
	
}
