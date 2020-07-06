package smart.eqp;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
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
	
	@RequestMapping(value = "/smart/eqp/SmartEqpRatio.do")
	public String SmartEqpRatio(ModelMap model) throws Exception {
		
		try {
			
			List<HashMap> resultBasic = SmartCommonDAO.commonDataProc("getEqpRatioPartBasic");
			model.addAttribute("resultBasic", resultBasic);
			
		} catch(Exception e) {
			logger.error("[/smart/eqp/SmartEqpRatio.do] Exception :: " + e.toString());
		}
		
    	return "smart/eqp/SmartEqpRatio";
	}
	
	@RequestMapping(value = "/smart/eqp/SmartEqpRatioData.do")
	public String SmartEqpRatioData(
			@RequestParam(value="datetype", required=false) String datetype,
			@RequestParam(value="startMonth", required=false) String startMonth,
			@RequestParam(value="endMonth", required=false) String endMonth,
			@RequestParam(value="startDateField", required=false) String startDateField,
			@RequestParam(value="endDateField", required=false) String endDateField,
			@RequestParam(value="eqp_part", required=false) String eqp_part,
			ModelMap model) throws Exception {
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
    	if(!isAuthenticated) {
    		model.addAttribute("sessionmessage", "session expire");
    		return "uat/uia/EgovLoginUsr";
    	}
    	
		try {
			
    		HashMap<String,String> hp = new HashMap<String,String>();
    		List<HashMap> result = new ArrayList();
    		List<String> dateTemp = new ArrayList<String>();
    		
    		if("MONTH".equals(datetype))
    		{
        		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
    			Date startDate = sdf.parse(startMonth);
    			Calendar calendar = Calendar.getInstance();
    			calendar.setTime(startDate);
    			String dt = sdf.format(calendar.getTime());
    			calendar.setTime(sdf.parse(dt));
    			
    			while(true) {
        			dt = sdf.format(calendar.getTime());
        			dateTemp.add(dt);
    				if(dt.equals(endMonth))
    					break;
    				calendar.setTime(sdf.parse(dt));
    				calendar.add(Calendar.MONTH, 1);
    			}
    		}
    		else
    		{
    			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    			Date startDate = sdf.parse(startDateField);
    			Calendar calendar = Calendar.getInstance();
    			calendar.setTime(startDate);
    			String dt = sdf.format(calendar.getTime());
    			calendar.setTime(sdf.parse(dt));
    			
    			while(true) {
        			dt = sdf.format(calendar.getTime());
        			dateTemp.add(dt);
    				if(dt.equals(endDateField))
    					break;
    				calendar.setTime(sdf.parse(dt));
    				calendar.add(Calendar.DATE, 1);
    			}
    		}
    		
    			
			if("MONTH".equals(datetype))
			{
				hp = new HashMap<String,String>();
				hp.put("startdate", startMonth);
				hp.put("enddate", endMonth);
				hp.put("gubun", datetype);
				hp.put("eqp_part", eqp_part);
				
				result = SmartCommonDAO.commonDataProc("getEqpRatioData", hp);
			}
			else
			{
				hp = new HashMap<String,String>();
				hp.put("startdate", startDateField);
				hp.put("enddate", endDateField);
				hp.put("gubun", datetype);
				hp.put("eqp_part", eqp_part);
				
				result = SmartCommonDAO.commonDataProc("getEqpRatioData", hp);
			}
			
			double tot_ratio = 0;
			
			if(result != null && result.size() > 0)
			{
				for(int i=0; i<result.size(); i++)
				{
					tot_ratio += Double.parseDouble(result.get(i).get("SUM_RATIO").toString());
				}
			}
			
			if(result != null)
			{
				model.addAttribute("TOT_RATIO", String.format("%.2f", tot_ratio/result.size()));
				model.addAttribute("UNTOT_RATIO", String.format("%.2f", 100-(tot_ratio/result.size())));
			}
			
    		model.addAttribute("listTargetDate", dateTemp);
    		model.addAttribute("datetype", datetype);
    		model.addAttribute("result", result);
    		
		} catch(Exception e) {
			logger.error("[/smart/eqp/SmartEqpRatioData.do] Exception :: " + e.toString());
			e.printStackTrace();
		}
		
		return "smart/eqp/SmartEqpRatioData";
	}
	
	
	
	@RequestMapping(value = "/smart/eqp/SmartEqpError.do")
	public String SmartEqpError(ModelMap model) throws Exception {
		
		try {
			
			List<HashMap> resultBasic = SmartCommonDAO.commonDataProc("getEqpRatioPartBasic");
			model.addAttribute("resultBasic", resultBasic);
			
		} catch(Exception e) {
			logger.error("[/smart/eqp/SmartEqpError.do] Exception :: " + e.toString());
		}
		
    	return "smart/eqp/SmartEqpError";
	}
	
	
	
	@RequestMapping(value = "/smart/eqp/SmartEqpErrorData.do")
	public String SmartEqpErrorData(
			@RequestParam(value="startDateField", required=false) String startDateField,
			@RequestParam(value="endDateField", required=false) String endDateField,
			@RequestParam(value="eqp_part", required=false) String eqp_part,
			ModelMap model) throws Exception {
		
		try {
			
    		HashMap<String,String> hp = new HashMap<String,String>();
    	
			hp = new HashMap<String,String>();
			hp.put("startdate", startDateField);
			hp.put("enddate", endDateField);
			hp.put("eqppart", eqp_part);
			
			List<HashMap> 	result = SmartCommonDAO.commonDataProc("getEqpErrorData", hp);
				
			model.addAttribute("result", result);
			
		} catch(Exception e) {
			logger.error("[/smart/eqp/SmartEqpErrorData.do] Exception :: " + e.toString());
		}
		
		return "smart/eqp/SmartEqpErrorData";
	}
	
	
	
	@RequestMapping(value = "/smart/eqp/SmartEqpErrorExcel.do")
	public String SmartEqpErrorExcel(
			@RequestParam(value="startDateField", required=false) String startDateField,
			@RequestParam(value="endDateField", required=false) String endDateField,
			@RequestParam(value="eqp_part", required=false) String eqp_part,
			ModelMap model) throws Exception {
		
		try {
			
    		HashMap<String,String> hp = new HashMap<String,String>();
    	
			hp = new HashMap<String,String>();
			hp.put("startdate", startDateField);
			hp.put("enddate", endDateField);
			hp.put("eqppart", eqp_part);
			
			List<HashMap> 	result = SmartCommonDAO.commonDataProc("getEqpErrorData", hp);
				
			model.addAttribute("result", result);
			model.addAttribute("startdate", startDateField);
			model.addAttribute("enddate", endDateField);
			model.addAttribute("eqppart", eqp_part);
    		
		} catch(Exception e) {
			logger.error("[/smart/eqp/SmartEqpErrorExcel.do] Exception :: " + e.toString());
		}
		
		return "smart/eqp/SmartEqpErrorExcel";
	}
	
	@RequestMapping(value = "/smart/eqp/SmartEqpRatioExcel.do")
	public void SmartEqpRatioExcel(
			@RequestParam(value="datetype", required=false) String datetype,
			@RequestParam(value="startMonth", required=false) String startMonth,
			@RequestParam(value="endMonth", required=false) String endMonth,
			@RequestParam(value="startDateField", required=false) String startDateField,
			@RequestParam(value="endDateField", required=false) String endDateField,
			@RequestParam(value="eqp_part", required=false) String eqp_part,
			HttpServletRequest request, 
			HttpServletResponse response,
			ModelMap model) throws Exception {
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
    	if(!isAuthenticated) {
    		model.addAttribute("sessionmessage", "session expire");
    	}
    	
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
    		List<HashMap> result = new ArrayList();
    		List<String> dateTemp = new ArrayList<String>();
    		
    		//시작일과 종료일로부터 월/일 간격으로 파일에 출력할 일자를 List에 add
    		if("MONTH".equals(datetype))
    		{
        		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
    			Date startDate = sdf.parse(startMonth);
    			Calendar calendar = Calendar.getInstance();
    			calendar.setTime(startDate);
    			String dt = sdf.format(calendar.getTime());
    			calendar.setTime(sdf.parse(dt));
    			
    			while(true) {
        			dt = sdf.format(calendar.getTime());
        			dateTemp.add(dt);
    				if(dt.equals(endMonth))
    					break;
    				calendar.setTime(sdf.parse(dt));
    				calendar.add(Calendar.MONTH, 1);
    			}
    		}
    		else
    		{
    			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    			Date startDate = sdf.parse(startDateField);
    			Calendar calendar = Calendar.getInstance();
    			calendar.setTime(startDate);
    			String dt = sdf.format(calendar.getTime());
    			calendar.setTime(sdf.parse(dt));

    			while(true) {
        			dt = sdf.format(calendar.getTime());
        			dateTemp.add(dt);
    				if(dt.equals(endDateField))
    					break;
    				calendar.setTime(sdf.parse(dt));
    				calendar.add(Calendar.DATE, 1);
    			}
    		}
    			
    		//설비가동률 데이터 SELECT
			if("MONTH".equals(datetype))
			{
				hp = new HashMap<String,String>();
				hp.put("startdate", startMonth);
				hp.put("enddate", endMonth);
				hp.put("gubun", datetype);
				hp.put("eqp_part", eqp_part);
				
				result = SmartCommonDAO.commonDataProc("getEqpRatioData", hp);
			}
			else
			{
				hp = new HashMap<String,String>();
				hp.put("startdate", startDateField);
				hp.put("enddate", endDateField);
				hp.put("gubun", datetype);
				hp.put("eqp_part", eqp_part);
				
				result = SmartCommonDAO.commonDataProc("getEqpRatioData", hp);
			}
			
			
			double tot_ratio_temp = 0;
			String totRatio = "";
			String unTotRatio = "";
			
			if(result != null && result.size() > 0)
			{
				for(int i=0; i<result.size(); i++)
				{
					tot_ratio_temp += Double.parseDouble(result.get(i).get("SUM_RATIO").toString());
				}
				
				totRatio = String.format("%.2f", tot_ratio_temp/result.size());
				unTotRatio = String.format("%.2f", 100-(tot_ratio_temp/result.size()));
			}
			
			
			
			Workbook wb = new XSSFWorkbook();
			Sheet sheet = wb.createSheet("Sheet 1");
	 
	        // Create a row and put some cells in it. Rows are 0 based.
			/*
			 * 0~15 row : 그래프 row
			 * 16~ row : 데이터 table
			 */ 
			Row row;
			Cell cell;
			
			//cell style 지정
			//real data style
			XSSFCellStyle dataStyle = (XSSFCellStyle) wb.createCellStyle();
			dataStyle.setBorderTop(BorderStyle.THIN);
			dataStyle.setBorderLeft(BorderStyle.THIN);
			dataStyle.setBorderRight(BorderStyle.THIN);
			dataStyle.setBorderBottom(BorderStyle.THIN);
			
			//dataTitle, subTitle style
			XSSFCellStyle dataTitleStyle = (XSSFCellStyle) wb.createCellStyle();
			dataTitleStyle.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex());
			dataTitleStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			dataTitleStyle.setBorderTop(BorderStyle.THIN);
			dataTitleStyle.setBorderLeft(BorderStyle.THIN);
			dataTitleStyle.setBorderRight(BorderStyle.THIN);
			dataTitleStyle.setBorderBottom(BorderStyle.THIN);
			
			//Title style
			XSSFCellStyle titleStyle = (XSSFCellStyle) wb.createCellStyle();
			XSSFFont fontStyle = (XSSFFont) wb.createFont();
			fontStyle.setFontHeightInPoints((short) 24);
			fontStyle.setBold(true);
			titleStyle.setFont(fontStyle);
			titleStyle.setAlignment(HorizontalAlignment.CENTER);
			titleStyle.setVerticalAlignment(VerticalAlignment.CENTER);
			titleStyle.setBorderTop(BorderStyle.THIN);
			titleStyle.setBorderLeft(BorderStyle.THIN);
			titleStyle.setBorderRight(BorderStyle.THIN);
			titleStyle.setBorderBottom(BorderStyle.THIN);
			
			//subTitle Data style
			XSSFCellStyle subTitleDataStyle = (XSSFCellStyle) wb.createCellStyle();
			subTitleDataStyle.setFillForegroundColor(IndexedColors.LEMON_CHIFFON.getIndex());
			subTitleDataStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			subTitleDataStyle.setBorderTop(BorderStyle.THIN);
			subTitleDataStyle.setBorderLeft(BorderStyle.THIN);
			subTitleDataStyle.setBorderRight(BorderStyle.THIN);
			subTitleDataStyle.setBorderBottom(BorderStyle.THIN);
			
			
			
			//TITLE
			row = sheet.createRow((short) 0);
			sheet.addMergedRegion(new CellRangeAddress(0, 1, 0, 11));
			cell = row.createCell((short) 0);
			cell.setCellValue("설비가동률");
			cell.setCellStyle(titleStyle);
			
			//조회기간 TITLE
			row = sheet.createRow((short) 2);
			cell = row.createCell((short) 0);
			cell.setCellValue("조회기간");
			cell.setCellStyle(dataTitleStyle);
			
			//조회기간 TITLE Data
			sheet.addMergedRegion(new CellRangeAddress(2, 2, 1, 11));
			
			for(int i=1; i<12; i++)
			{
				cell = row.createCell((short) i);
				
				if(i == 1)
				{
					if("MONTH".equals(datetype))
						cell.setCellValue(startMonth + " ~ " + endMonth);
					else
						cell.setCellValue(startDateField + " ~ " + endDateField);
				}
				
				cell.setCellStyle(subTitleDataStyle);
			}
			
			//real Data setting
	        for (int rowIndex = 0; rowIndex < result.size()+1; rowIndex++)
	        {
	            row = sheet.createRow((short) rowIndex+18);	//19line 부터 title, data setting
	            
	            for (int colIndex = 0; colIndex < dateTemp.size()+2; colIndex++)
	            {
	                cell = row.createCell((short) colIndex);
	                
	                if(rowIndex == 0)
	                {
	                	if(colIndex == 0)
	                	{
	                		cell.setCellValue("");
	                		cell.setCellStyle(dataTitleStyle);
	                	}
	                	else if(colIndex == dateTemp.size()+1)
	                	{
	                		cell.setCellValue("가동률");
	                		cell.setCellStyle(dataTitleStyle);
	                	}
	                	else
	                	{
	                		cell.setCellValue(dateTemp.get(colIndex-1));
	                		cell.setCellStyle(dataTitleStyle);
	                	}
	                }
	                else
	                {
	                	if(colIndex == 0)
	                	{
	                		cell.setCellValue(result.get(rowIndex-1).get("EQP_NAME").toString());
	                		cell.setCellStyle(dataTitleStyle);
	                	}
	                	else if(colIndex == dateTemp.size()+1)
	                	{
	                		cell.setCellValue(Double.parseDouble(result.get(rowIndex-1).get("SUM_RATIO").toString()));
	                		cell.setCellStyle(dataStyle);
	                	}
	                	else
	                	{
	                		cell.setCellValue(Double.parseDouble(result.get(rowIndex-1).get(dateTemp.get(colIndex-1)).toString()));
	                		cell.setCellStyle(dataStyle);
	                	}
	                }
	            }
	        }
	        
	        row = sheet.createRow((short) result.size()+18+2);
	        cell = row.createCell((short) 0);
	        cell.setCellValue("전체 가동률");
    		cell.setCellStyle(dataTitleStyle);
	        cell = row.createCell((short) 1);
	        cell.setCellValue(Double.parseDouble(totRatio));
    		cell.setCellStyle(dataStyle);
    		
    		row = sheet.createRow((short) result.size()+18+3);
	        cell = row.createCell((short) 0);
	        cell.setCellValue("전체 비가동률");
    		cell.setCellStyle(dataTitleStyle);
	        cell = row.createCell((short) 1);
	        cell.setCellValue(Double.parseDouble(unTotRatio));
    		cell.setCellStyle(dataStyle);
	        
	        //cell width setting
	        for(int i=0; i<dateTemp.size()+1; i++)
	        {
	        	sheet.autoSizeColumn(i);
	        	
	        	if(i == 0)
	        	{
	        		if(sheet.getColumnWidth(i) < 3750)
	            		sheet.setColumnWidth(i, 3750);
	        	}
	        	else
	        	{
	        		if(sheet.getColumnWidth(i) < 2880)
	            		sheet.setColumnWidth(i, 2880);
	        	}
	        }
	        
	        Drawing<?> drawing = sheet.createDrawingPatriarch();
	        //(4.0) ~ (17,12) 그래프 영역
	        //createAnchor(int dx1, int dy1, int dx2, int dy2, int col1, int row1, int col2, int row2)
	        ClientAnchor anchor = drawing.createAnchor(0, 0, 0, 0, 0, 3, 12, 17);
	 
	        Chart chart = drawing.createChart(anchor);
	        ChartLegend legend = chart.getOrCreateLegend();
	        legend.setPosition(LegendPosition.TOP_RIGHT);
	        
	        LineChartData data = chart.getChartDataFactory().createLineChartData();
	        
	        // Use a category axis for the bottom axis.
	        ChartAxis bottomAxis = chart.getChartAxisFactory().createCategoryAxis(AxisPosition.BOTTOM);
	        ValueAxis leftAxis = chart.getChartAxisFactory().createValueAxis(AxisPosition.LEFT);
	        leftAxis.setCrosses(AxisCrosses.AUTO_ZERO);
	        leftAxis.setMinimum(0);
	        
	        int axisMax = 0;
	        
	        for(int i=0; i<result.size(); i++)
	        {
	        	for(int j=0; j<dateTemp.size(); j++)
	        	{
	        		if(Math.ceil(Float.parseFloat(result.get(i).get(dateTemp.get(j)).toString())) > axisMax)
	        			axisMax = (int) Math.ceil(Float.parseFloat(result.get(i).get(dateTemp.get(j)).toString()));
	        	}
	        }
	        
	        if(axisMax > 100)
	        	leftAxis.setMaximum(axisMax+20);
	        else
	        	leftAxis.setMaximum(100);
	        
	        LineChartSeries chartSeries = null;
	        
	        ChartDataSource<Number> xs = DataSources.fromNumericCellRange(sheet, new CellRangeAddress(18, 18, 1, dateTemp.size()));
	        
	        for(int i=0; i<result.size(); i++)
	        {
	        	ChartDataSource<Number> ys = DataSources.fromNumericCellRange(sheet, new CellRangeAddress(18+(i+1), 18+(i+1), 1, dateTemp.size()));
		        chartSeries = data.addSeries(xs,ys);
		        chartSeries.setTitle(result.get(i).get("EQP_NAME").toString());
	        }
	        
	        chart.plot(data, bottomAxis, leftAxis);
	        
	        //remove line smooth
			XSSFChart xssfChart = (XSSFChart) chart;
			CTPlotArea plotArea = xssfChart.getCTChart().getPlotArea();
			plotArea.getLineChartArray()[0].getSmooth();
			CTBoolean ctBool = CTBoolean.Factory.newInstance();
			ctBool.setVal(false);
			plotArea.getLineChartArray()[0].setSmooth(ctBool);
			
			for (CTLineSer ser : plotArea.getLineChartArray()[0].getSerArray())
			{
				ser.setSmooth(ctBool);
			}
	        
			
	        /* Finally define FileOutputStream and write chart information */               
	        boolean isFileOk = false;
			byte[] buf = new byte[1024];

	        String storePathString = propertyService.getString("Globals.fileStorePath")  + "temp/EqpOperationRatio.xlsx";//첨부 기본 경로
	        
	        FileOutputStream outputStream = null;
	        
	        try {
	            outputStream = new FileOutputStream(storePathString);
	            wb.write(outputStream);
	            outputStream.close();
	            isFileOk = true;
	        } catch (FileNotFoundException ee) {
	            ee.printStackTrace();
	        } catch (IOException eee) {
	            eee.printStackTrace();
	        }
	        finally
			{
				if(outputStream != null) outputStream.close();
			}
	        
	        /// 생성된 엑셀 파일 다운로드 //////////////////////////////////////////////////////////////////////////////////////////////////
	        if(isFileOk)
			{
				response.setContentType("application/vnd.ms-excel; charset=utf-8");
				response.setHeader("Content-Disposition", "inline; filename="+new File("EqpOperationRatio.xlsx").getName());
				
				OutputStream outstream = response.getOutputStream();
				InputStream instream = new FileInputStream(new File(storePathString));
				 
				try
				{
					int read = instream.read(buf);
					
					while (read != -1)
					{
						outstream.write(buf, 0, read);
						read = instream.read(buf);
					}
					
					outstream.flush();
					outstream.close();
					instream.close();
				}
				catch (FileNotFoundException e)
				{
					logger.warn("파일을 찾을 수 없습니다.",e);
				}
				catch (Exception e)
				{
					logger.warn("예외가 발생 했습니다.", e);
				}
				finally
				{
					if(outstream != null) outstream.close();
					if(instream != null) instream.close();	
				}
			}
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		} catch(Exception e) {
			logger.error("[/smart/eqp/SmartEqpRatioExcel.do] Exception :: " + e.toString());
			e.printStackTrace();
		}
	}
	
	
	
	@RequestMapping(value = "/smart/eqp/SmartEqpFlexStatus.do")
	public String SmartEqpFlexStatus(ModelMap model) throws Exception {
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
    	if(!isAuthenticated) {
    		model.addAttribute("sessionmessage", "session expire");
    		return "uat/uia/EgovLoginUsr";
    	}
    	
		try{

			List<HashMap> resultTime = SmartCommonDAO.commonDataProc("getEqpMonitoringTime");
			model.addAttribute("resultTime", resultTime);
			
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			List<HashMap> resultRole = SmartCommonDAO.commonDataProc("selectUserRoleData",hp);
    		
    		if(resultRole != null && resultRole.size()>0)
    		{
    			model.addAttribute("userrole", resultRole.get(0).get("AUTHOR_CODE"));
    		}
			
		} catch(Exception e) {
			logger.error("[/smart/eqp/SmartEqpFlexStatus.do] Exception :: " + e.toString());
		}
    	return "smart/eqp/SmartEqpFlexStatus";
	}
	
	
	
	@RequestMapping(value = "/smart/eqp/SmartEqpFlexStatusData.do")
	public String SmartEqpFlexStatusData(
			@RequestParam(value="userrole", required=false) String userrole,
			@RequestParam(value="reload_time", required=false) String reload_time,
			ModelMap model) throws Exception {
		
		RandomAccessFile csvfile = null;
    	File file = null;
    	
		try{

			List<HashMap> resultSpec = SmartCommonDAO.commonDataProc("getEqpFlexSpecData");
    		
    		model.addAttribute("resultSpec", resultSpec);
    		model.addAttribute("userrole", userrole);
    		model.addAttribute("reload_time", reload_time);
    		
    		
    		//설비 상태 정보 파일을 읽어 온다
    		HashMap<String,String> hp = new HashMap<String,String>();
			
			String fileLocate = "";
			List<HashMap> resultLocate = SmartCommonDAO.commonDataProc("getEqpLogLocate");
			if(resultLocate != null && resultLocate.size() > 0)
			{
				fileLocate = resultLocate.get(0).get("FILE_LOCATE").toString();
			}
			
			String lamplevel = "5";
			List<HashMap> resultLamp = SmartCommonDAO.commonDataProc("getLampLevel");
			if(resultLamp != null && resultLamp.size() > 0)
			{
				lamplevel = resultLamp.get(0).get("LAMP_LEVEL").toString();
			}
			
			model.addAttribute("lamplevel", lamplevel);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("getEqpFlexStatus");
			model.addAttribute("result", result);
			
			List<HashMap> resultStatus = new ArrayList();
			HashMap<String,String> status = null;;
		
			if(result != null && result.size() > 0)
			{
				for(int i=0; i<result.size(); i++)
				{
					
					boolean completeflag = false;
					
					status = new HashMap<String,String>();
					
					String macaddress = "";
					String eqpname = "";
					String eqppart = "";
					String username = "";
					String processid = "";
					String eqpnameid = "";
					
					
					if(result.get(i).get("EQP_NAME") != null)
						eqpname = result.get(i).get("EQP_NAME").toString();
					if(result.get(i).get("EQP_PART") != null)
						eqppart = result.get(i).get("EQP_PART").toString();
					if(result.get(i).get("PROCESS_ID") != null)
						processid = result.get(i).get("PROCESS_ID").toString();
					if(result.get(i).get("EQP_NAME_ID") != null)
						eqpnameid = result.get(i).get("EQP_NAME_ID").toString();
					if(result.get(i).get("USER_ID") != null)
						username = result.get(i).get("USER_ID").toString();
					if(result.get(i).get("MACADDRESS") != null)
						macaddress = result.get(i).get("MACADDRESS").toString();
					else
					{
						status.put("EQP_PART", eqppart);
						status.put("EQP_NAME", eqpname);
						status.put("PROCESS_ID", processid);
						status.put("EQP_NAME_ID", eqpnameid);
						status.put("WHITE_STATUS", "OFF");
						status.put("WHITE_VALUE", "0");
						status.put("ACTIVE_FLAG", "DEAD");
						status.put("USER_NAME", username);
						resultStatus.add(status);
					}
					
		    		File dir = new File(fileLocate);
		    		File[] fileList = dir.listFiles();
		    		
		    		int fileCnt = 0;
		    		
		    		if(fileList != null && fileList.length>0)
		    		{
			    		for(int j=(fileList.length-1); j>-1; j--)
			    		{
			    			if(fileCnt > 1) {
			    				//RED
								status.put("EQP_PART", eqppart);
								status.put("EQP_NAME", eqpname);
								status.put("RED_STATUS", "OFF");
								status.put("RED_VALUE", "0");
								status.put("ACTIVE_FLAG", "DEAD");
								status.put("USER_NAME", username);
								
								//AMBER
								status.put("EQP_PART", eqppart);
								status.put("EQP_NAME", eqpname);
								status.put("AMBER_STATUS", "OFF");
								status.put("AMBER_VALUE", "0");
								status.put("ACTIVE_FLAG", "DEAD");
								status.put("USER_NAME", username);
								
								//GREEN
								status.put("EQP_PART", eqppart);
								status.put("EQP_NAME", eqpname);
								status.put("GREEN_STATUS", "OFF");
								status.put("GREEN_VALUE", "0");
								status.put("ACTIVE_FLAG", "DEAD");
								status.put("USER_NAME", username);
								
								//BLUE
								status.put("EQP_PART", eqppart);
								status.put("EQP_NAME", eqpname);
								status.put("BLUE_STATUS", "OFF");
								status.put("BLUE_VALUE", "0");
								status.put("ACTIVE_FLAG", "DEAD");
								status.put("USER_NAME", username);
								
								//WHITE
								status.put("EQP_PART", eqppart);
								status.put("EQP_NAME", eqpname);
								status.put("WHITE_STATUS", "OFF");
								status.put("WHITE_VALUE", "0");
								status.put("ACTIVE_FLAG", "DEAD");
								status.put("USER_NAME", username);
								
								resultStatus.add(status);
								
			    				break;//어제꺼까지만 체크하고 정지
			    			}
			    			
			    			file = fileList[j];
			    			
				    		if(file.isFile() && file.toString().indexOf(".csv")>-1)
				    		{
				    			//파일의 뒤에서부터 읽기 위해 RandomAccessFile 사용
								csvfile = new RandomAccessFile(file,"r");
								long fileLength = csvfile.length();	//파일 총 문자 수
								long pos = fileLength-1;	//제일 마지막 line
								String line = "";
								String activeflag = "";
								String eventTime = "";
								String Appkey = "";
								String PushMsg = "";
								String gcmresult = "";
								
								String[] temp = null;
							
								while(true)
								{
									//파일의 지정된 위치로 이동 (최초에는 제일 마지막 line)
									csvfile.seek(pos);
									//RandomAccessFile은 문자 하나씩 체크를 하므로 줄넘김이 나오면 해당 라인 확인 
									if(csvfile.readByte() == '\n' && csvfile.readLine() != null)
									{
										csvfile.seek(pos+1);
										line = csvfile.readLine();
										temp = line.split(",");
										if(macaddress.equals(temp[1]))
										{
											//WDTMonitoring
											if("0".equals(temp[9]))
											{
												activeflag = "DEAD";
												
												//알림 method
												eventTime = temp[0];
												
												//동일한 이벤트 알림 내역이 있는지 확인한다.
												//알림 내역 유/무 FLAG:ALREADY/NOT
												hp = new HashMap<String,String>();
												hp.put("eventtime", eventTime);
												hp.put("eqpname", eqpname);
												List<HashMap> resultevent = SmartCommonDAO.commonDataProc("getEventHist", hp);
												
												if(resultevent != null && resultevent.size()>0)
												{
													if("NOT".equals(resultevent.get(0).get("FLAG").toString()))
													{
														PushMsg = "[" + eventTime + "]" + eqpname + " 장비의 전원이 꺼졌습니다.";
														
														//알림 보내기
														hp = new HashMap<String,String>();
														hp.put("eventtime", eventTime);
														hp.put("eqpname", eqpname);
														hp.put("userid", username);
														hp.put("gubun", "DAED");
														hp.put("alarmmsg", PushMsg);
														List<HashMap> resultAlarm = SmartCommonDAO.commonDataProc("setEqpStatusAlarm",hp);
														
														//모바일 PUSH method
														hp = new HashMap<String,String>();
														hp.put("gubun", username);
														List<HashMap> resultAppkey = SmartCommonDAO.commonDataProc("getMobileAppkey",hp);
														if(resultAppkey != null && resultAppkey.size()>0)
														{
															Appkey = resultAppkey.get(0).get("APPKEY").toString();
															gcmresult = smartGcmSender.gcmSender(Appkey, PushMsg, 1);
														}
													}
												}
											}
											else
											{
												activeflag = "ACTIVE";
											}
											
											if(!"0".equals(temp[3]))
											{
												//RED
												status.put("EQP_PART", eqppart);
												status.put("EQP_NAME", eqpname);
												status.put("PROCESS_ID", processid);
												status.put("EQP_NAME_ID", eqpnameid);
												status.put("RED_STATUS", "ON");
												status.put("RED_VALUE", temp[3]);
												status.put("ACTIVE_FLAG", activeflag);
												status.put("USER_NAME", username);
												
												//알림 method
												eventTime = temp[0];
												hp = new HashMap<String,String>();
												hp.put("eventtime", eventTime);
												hp.put("eqpname", eqpname);
												List<HashMap> resultevent = SmartCommonDAO.commonDataProc("getEventHist", hp);
												
												if(resultevent != null && resultevent.size()>0)
												{
													if("NOT".equals(resultevent.get(0).get("FLAG").toString()))
													{
														PushMsg = "[" + eventTime + "]" + eqpname + " 장비의 오류가 발생하였습니다.";
														
														//알림 보내기
														hp = new HashMap<String,String>();
														hp.put("eventtime", eventTime);
														hp.put("eqpname", eqpname);
														hp.put("userid", username);
														hp.put("gubun", "RED");
														hp.put("alarmmsg", PushMsg);
														List<HashMap> resultAlarm = SmartCommonDAO.commonDataProc("setEqpStatusAlarm",hp);
														
														//모바일 PUSH method
														hp = new HashMap<String,String>();
														hp.put("gubun", username);
														List<HashMap> resultAppkey = SmartCommonDAO.commonDataProc("getMobileAppkey",hp);
														if(resultAppkey != null && resultAppkey.size()>0)
														{
															for(int k=0 ; k<resultAppkey.size() ; k++)
															{
																Appkey = resultAppkey.get(0).get("APPKEY").toString();
																gcmresult = smartGcmSender.gcmSender(Appkey, PushMsg, 1);
															}
														}
													}
												}
											}
											else
											{
												//RED
												status.put("EQP_PART", eqppart);
												status.put("EQP_NAME", eqpname);
												status.put("PROCESS_ID", processid);
												status.put("EQP_NAME_ID", eqpnameid);
												status.put("RED_STATUS", "OFF");
												status.put("RED_VALUE", temp[3]);
												status.put("ACTIVE_FLAG", activeflag);
												status.put("USER_NAME", username);
											}
											if(!"0".equals(temp[4]))
											{
												//AMBER
												status.put("EQP_PART", eqppart);
												status.put("EQP_NAME", eqpname);
												status.put("PROCESS_ID", processid);
												status.put("EQP_NAME_ID", eqpnameid);
												status.put("AMBER_STATUS", "ON");
												status.put("AMBER_VALUE", temp[4]);
												status.put("ACTIVE_FLAG", activeflag);
												status.put("USER_NAME", username);
											}
											else
											{
												//AMBER
												status.put("EQP_PART", eqppart);
												status.put("EQP_NAME", eqpname);
												status.put("PROCESS_ID", processid);
												status.put("EQP_NAME_ID", eqpnameid);
												status.put("AMBER_STATUS", "OFF");
												status.put("AMBER_VALUE", temp[4]);
												status.put("ACTIVE_FLAG", activeflag);
												status.put("USER_NAME", username);
											}
											if(!"0".equals(temp[5]))
											{
												//GREEN
												status.put("EQP_PART", eqppart);
												status.put("EQP_NAME", eqpname);
												status.put("PROCESS_ID", processid);
												status.put("EQP_NAME_ID", eqpnameid);
												status.put("GREEN_STATUS", "ON");
												status.put("GREEN_VALUE", temp[5]);
												status.put("ACTIVE_FLAG", activeflag);
												status.put("USER_NAME", username);
											}
											else
											{
												//GREEN
												status.put("EQP_PART", eqppart);
												status.put("EQP_NAME", eqpname);
												status.put("PROCESS_ID", processid);
												status.put("EQP_NAME_ID", eqpnameid);
												status.put("GREEN_STATUS", "OFF");
												status.put("GREEN_VALUE", temp[5]);
												status.put("ACTIVE_FLAG", activeflag);
												status.put("USER_NAME", username);
											}
											if(!"0".equals(temp[6]))
											{
												//BLUE
												status.put("EQP_PART", eqppart);
												status.put("EQP_NAME", eqpname);
												status.put("PROCESS_ID", processid);
												status.put("EQP_NAME_ID", eqpnameid);
												status.put("BLUE_STATUS", "ON");
												status.put("BLUE_VALUE", temp[6]);
												status.put("ACTIVE_FLAG", activeflag);
												status.put("USER_NAME", username);
											}
											else
											{
												//BLUE
												status.put("EQP_PART", eqppart);
												status.put("EQP_NAME", eqpname);
												status.put("PROCESS_ID", processid);
												status.put("EQP_NAME_ID", eqpnameid);
												status.put("BLUE_STATUS", "OFF");
												status.put("BLUE_VALUE", temp[6]);
												status.put("ACTIVE_FLAG", activeflag);
												status.put("USER_NAME", username);
											}
											if(!"0".equals(temp[7]))
											{
												//WHITE
												status.put("EQP_PART", eqppart);
												status.put("EQP_NAME", eqpname);
												status.put("PROCESS_ID", processid);
												status.put("EQP_NAME_ID", eqpnameid);
												status.put("WHITE_STATUS", "ON");
												status.put("WHITE_VALUE", temp[7]);
												status.put("ACTIVE_FLAG", activeflag);
												status.put("USER_NAME", username);
											}
											else
											{
												//WHITE
												status.put("EQP_PART", eqppart);
												status.put("EQP_NAME", eqpname);
												status.put("PROCESS_ID", processid);
												status.put("EQP_NAME_ID", eqpnameid);
												status.put("WHITE_STATUS", "OFF");
												status.put("WHITE_VALUE", temp[7]);
												status.put("ACTIVE_FLAG", activeflag);
												status.put("USER_NAME", username);
											}
											
											resultStatus.add(status);
											completeflag = true;
											break;
										}
									}
									if(pos == 0)
										break;
									pos--;
								}	//while 종료
								
								if(completeflag)
									break;
							}	//isFile if 종료
				    		
				    		fileCnt++;
				    		
			    		}	//file for 종료
			    		
		    		}
		    		
		    		if(csvfile != null) {
						csvfile.close();
					}
		    		
				}	//for 종료
			}
						
			model.addAttribute("resultStatus", resultStatus);
    		
		} catch(Exception e) {
			logger.error("[/smart/eqp/SmartEqpFlexStatusData.do] Exception :: " + e.toString());
		}
    	return "smart/eqp/SmartEqpFlexStatusData";
	}
	
	
	
	@RequestMapping(value = "/smart/eqp/SmartEqpFlexStatusSave.do")
	public String SmartSiteMaterialSave(
			@RequestParam(value="arraystr", required=false) String arraystr,
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
			hp.put("arraystr", arraystr);
			
			List<HashMap>  result =  SmartCommonDAO.commonDataProc("setEqpFlexSpecSave",hp);
			
    		if(result != null && result.size()>0)
    		{
    			model.addAttribute("actionresult", result.get(0).get("ACTION_RESULT"));
			}
    	}
    	catch(Exception e){
			logger.error("[/smart/eqp/SmartEqpFlexStatusSave.do] Exception :: " + e.toString());
		}
    	
		return "smart/eqp/SmartEqpFlexStatusSave";
	}
	
	
	
	@RequestMapping(value = "/smart/eqp/SmartEqpTimeLine.do")
	public String SmartEqpTimeLine(ModelMap model) throws Exception {
		
    	return "smart/eqp/SmartEqpTimeLine";
	}
	
	
	
	@RequestMapping(value = "/smart/eqp/SmartEqpTimeLineData.do")
	public String SmartEqpTimeLineData(
			@RequestParam(value="searchdate", required=false) String searchdate,
			ModelMap model) throws Exception {
		
		try {
    		HashMap<String,String> hp = new HashMap<String,String>();
    	
			hp = new HashMap<String,String>();
			hp.put("searchdate", searchdate);
			
			List<HashMap> 	result = SmartCommonDAO.commonDataProc("getDailyTimeLine", hp);
				
			model.addAttribute("result", result);
			
			if(result != null && result.size()>0)
			{
				model.addAttribute("GATHERING_TIME", result.get(0).get("GATHERING_TIME"));
			}
			
			model.addAttribute("SEARCH_YEAR", searchdate.substring(0, 4));
			model.addAttribute("SEARCH_MONTH", searchdate.substring(5, 7));
			model.addAttribute("SEARCH_DAY", searchdate.substring(8, 10));
			
		} catch(Exception e) {
			logger.error("[/smart/eqp/SmartEqpTimeLineData.do] Exception :: " + e.toString());
		}
		
		return "smart/eqp/SmartEqpTimeLineData";
	}
	
	
	
	@RequestMapping(value = "/smart/eqp/SmartEqpTimeLineDetail.do")
	public String SmartEqpTimeLineDetail(
			@RequestParam(value="searchdate", required=false) String searchdate,
			@RequestParam(value="eqpname", required=false) String eqpname,
			ModelMap model) throws Exception {
		
		try {
			
    		HashMap<String,String> hp = new HashMap<String,String>();
    	
			hp = new HashMap<String,String>();
			hp.put("searchdate", searchdate);
			hp.put("eqpname", eqpname);
			
			List<HashMap> 	result = SmartCommonDAO.commonDataProc("getDailyDetailData", hp);
						
			if(result != null && result.size()>0)
			{
				model.addAttribute("GREEN_TIME", result.get(0).get("GREEN_TIME"));
				model.addAttribute("AMBER_TIME", result.get(0).get("AMBER_TIME"));
				model.addAttribute("RED_TIME", result.get(0).get("RED_TIME"));
				model.addAttribute("NORMAL_TIME", result.get(0).get("NORMAL_TIME"));
			}
			
			model.addAttribute("searchdate", searchdate);
			model.addAttribute("eqpname", eqpname);
			
		} catch(Exception e) {
			logger.error("[/smart/eqp/SmartEqpTimeLineDetail.do] Exception :: " + e.toString());
		}
		
		return "smart/eqp/SmartEqpTimeLineDetail";
	}
	
	
	
	
	@RequestMapping(value = "/smart/eqp/SmartEqpRunning.do")
	public String SmartEqpRunning(ModelMap model) throws Exception {
		
		try {
			
			List<HashMap> resultBasic = SmartCommonDAO.commonDataProc("getEqpRatioPartBasic");
			model.addAttribute("resultBasic", resultBasic);
			
		} catch(Exception e) {
			logger.error("[/smart/eqp/SmartEqpRunning.do] Exception :: " + e.toString());
		}
		
    	return "smart/eqp/SmartEqpRunning";
	}
	
	@RequestMapping(value = "/smart/eqp/SmartEqpRunningData.do")
	public String SmartEqpRunningData(
			@RequestParam(value="datetype", required=false) String datetype,
			@RequestParam(value="startMonth", required=false) String startMonth,
			@RequestParam(value="endMonth", required=false) String endMonth,
			@RequestParam(value="startDateField", required=false) String startDateField,
			@RequestParam(value="endDateField", required=false) String endDateField,
			@RequestParam(value="eqp_part", required=false) String eqp_part,
			ModelMap model) throws Exception {
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
    	if(!isAuthenticated) {
    		model.addAttribute("sessionmessage", "session expire");
    		return "uat/uia/EgovLoginUsr";
    	}

    	try {
			
    		HashMap<String,String> hp = new HashMap<String,String>();
    		List<HashMap> result = new ArrayList();
			if("MONTH".equals(datetype))
			{
				hp = new HashMap<String,String>();
				hp.put("startdate", startMonth);
				hp.put("enddate", endMonth);
				hp.put("gubun", datetype);
				hp.put("eqp_part", eqp_part);
				
				result = SmartCommonDAO.commonDataProc("getEqpRunningData", hp);
			}
			else if("DAY".equals(datetype))
			{
				hp = new HashMap<String,String>();
				hp.put("startdate", startDateField);
				hp.put("enddate", endDateField);
				hp.put("gubun", datetype);
				hp.put("eqp_part", eqp_part);
				
				result = SmartCommonDAO.commonDataProc("getEqpRunningData", hp);
			}
			
    		model.addAttribute("datetype", datetype);
    		model.addAttribute("result", result);
    		
		} catch(Exception e) {
			e.printStackTrace();
			logger.error("[/smart/eqp/SmartEqpRunningData.do] Exception :: " + e.toString());
		}
		
		return "smart/eqp/SmartEqpRunningData";
	}
	
	
	
	@RequestMapping(value = "/smart/eqp/SmartEqpToolManage.do")
	public String SmartEqpToolManage(ModelMap model) throws Exception {
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("toollevel", "1");
			hp.put("toolid", "");
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("getEqpToolBasic",hp);
			model.addAttribute("result", result);
			
		} catch(Exception e) {
			logger.error("[/smart/eqp/SmartEqpToolManage.do] Exception :: " + e.toString());
		}
    	return "smart/eqp/SmartEqpToolManage";
	}
	
	
	
	@RequestMapping(value = "/smart/eqp/SmartEqpToolManageList.do")
	public String SmartEqpToolManageList(
			@RequestParam(value="tool_level_1", required=false) String tool_level_1,
			@RequestParam(value="tool_level_2", required=false) String tool_level_2,
			@RequestParam(value="tool_pie", required=false) String tool_pie,
			@RequestParam(value="tool_fb", required=false) String tool_fb,
			@RequestParam(value="tool_radius", required=false) String tool_radius,
			@RequestParam(value="tool_length", required=false) String tool_length,
			ModelMap model
			) throws Exception {
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("tool_level_1", tool_level_1);
			hp.put("tool_level_2", tool_level_2);
			hp.put("tool_pie", tool_pie);
			hp.put("tool_fb", tool_fb);
			hp.put("tool_radius", tool_radius);
			hp.put("tool_length", tool_length);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("getEqpToolManageList",hp);
			
			model.addAttribute("result", result);
			
		} catch(Exception e) {
			logger.error("[/smart/eqp/SmartEqpToolManageList.do] Exception :: " + e.toString());
		}
    	return "smart/eqp/SmartEqpToolManageList";
	}
	
	
	
	@RequestMapping(value = "/smart/eqp/SmartEqpToolManageExcel.do")
	public String SmartEqpToolManageExcel(
			@RequestParam(value="tool_level_1", required=false) String tool_level_1,
			@RequestParam(value="tool_level_2", required=false) String tool_level_2,
			@RequestParam(value="tool_pie", required=false) String tool_pie,
			@RequestParam(value="tool_fb", required=false) String tool_fb,
			@RequestParam(value="tool_radius", required=false) String tool_radius,
			@RequestParam(value="tool_length", required=false) String tool_length,
			ModelMap model
			) throws Exception {
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("tool_level_1", tool_level_1);
			hp.put("tool_level_2", tool_level_2);
			hp.put("tool_pie", tool_pie);
			hp.put("tool_fb", tool_fb);
			hp.put("tool_radius", tool_radius);
			hp.put("tool_length", tool_length);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("getEqpToolManageList",hp);
			
			model.addAttribute("result", result);
			
			model.addAttribute("tool_level_1", tool_level_1);
			model.addAttribute("tool_level_2", tool_level_2);
			model.addAttribute("tool_pie", tool_pie);
			model.addAttribute("tool_fb", tool_fb);
			model.addAttribute("tool_radius", tool_radius);
			model.addAttribute("tool_length", tool_length);
			
		} catch(Exception e) {
			logger.error("[/smart/eqp/SmartEqpToolManageExcel.do] Exception :: " + e.toString());
		}
    	return "smart/eqp/SmartEqpToolManageExcel";
	}
	
	
	
	@RequestMapping(value = "/smart/eqp/SmartEqpToolManageSave.do")
	public String SmartEqpToolManageSave(
			@RequestParam(value="actiontype", required=false) String actiontype,
			@RequestParam(value="arraystr", required=false) String arraystr,
			ModelMap model
			) throws Exception {
		
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
			hp.put("arraystr", arraystr);
    			
			List<HashMap> result = SmartCommonDAO.commonDataProc("setEqpToolManageSave",hp);
			
			if(result != null && result.size()>0)
    		{
    			model.addAttribute("actiontype", actiontype);
				model.addAttribute("actionresult", result.get(0).get("ACTION_RESULT"));
			}
												
    	}
    	catch(Exception e){
    		System.out.println("[/smart/eqp/SmartEqpToolManageSave.do] Exception :: " + e.toString());
    	}
    	
    	return "smart/eqp/SmartEqpToolManageSave";
    	
	}
	
	
	
	@RequestMapping(value = "/smart/eqp/SmartEqpToolManageStock.do")
	public String SmartEqpToolManageStock(
			@RequestParam(value="actiontype", required=false) String actiontype,
			@RequestParam(value="arraystr", required=false) String arraystr,
			ModelMap model
			) throws Exception {
		
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
			hp.put("arraystr", arraystr);
    			
			List<HashMap> result = SmartCommonDAO.commonDataProc("setEqpToolManageStock",hp);
			
			if(result != null && result.size()>0)
    		{
    			model.addAttribute("actiontype", actiontype);
				model.addAttribute("actionresult", result.get(0).get("ACTION_RESULT"));
			}
												
    	}
    	catch(Exception e){
    		System.out.println("[/smart/eqp/SmartEqpToolManageStock.do] Exception :: " + e.toString());
    	}
    	
    	return "smart/eqp/SmartEqpToolManageStock";
    	
	}
	
	
	
	@RequestMapping(value = "/smart/eqp/SmartEqpToolLevelList.do")
	public String SmartEqpToolLevelList(
			@RequestParam(value="gubun", required=false) String gubun,
			@RequestParam(value="tool_level_1", required=false) String tool_level_1,
			ModelMap model
			) throws Exception {
		
    	try{
    		
    		HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("toollevel", "2");
			hp.put("toolid", tool_level_1);
    			
			List<HashMap> result = SmartCommonDAO.commonDataProc("getEqpToolBasic",hp);
			
			model.addAttribute("result", result);
			
			model.addAttribute("gubun", gubun);
												
    	}
    	catch(Exception e){
    		System.out.println("[/smart/eqp/SmartEqpToolLevelList.do] Exception :: " + e.toString());
    	}
    	
    	return "smart/eqp/SmartEqpToolLevelList";
    	
	}
	
	
	
	@RequestMapping(value = "/smart/eqp/SmartEqpToolInsert.do")
	public String SmartEqpToolInsert(ModelMap model) throws Exception {
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("toollevel", "1");
			hp.put("toolid", "");
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("getEqpToolBasic",hp);
			model.addAttribute("result", result);
			
		} catch(Exception e) {
			logger.error("[/smart/eqp/SmartEqpToolInsert.do] Exception :: " + e.toString());
		}
    	return "smart/eqp/SmartEqpToolInsert";
	}
	
	
	
	@RequestMapping(value = "/smart/eqp/SmartEqpToolInsertSave.do")
	public String SmartEqpToolInsertSave(
			@RequestParam(value="tool_level_1", required=false) String tool_level_1,
			@RequestParam(value="tool_level_2", required=false) String tool_level_2,
			@RequestParam(value="tool_pie", required=false) String tool_pie,
			@RequestParam(value="tool_fb", required=false) String tool_fb,
			@RequestParam(value="tool_radius", required=false) String tool_radius,
			@RequestParam(value="tool_length", required=false) String tool_length,
			@RequestParam(value="tool_unit", required=false) String tool_unit,
			@RequestParam(value="tool_safe", required=false) String tool_safe,
			@RequestParam(value="tool_current", required=false) String tool_current,
			ModelMap model
			) throws Exception {
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
    	if(!isAuthenticated) {
    		model.addAttribute("sessionmessage", "session expire");
    		return "uat/uia/EgovLoginUsr";
    	}
    	
		try {
			
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			hp.put("tool_level_1", tool_level_1);
			hp.put("tool_level_2", tool_level_2);
			hp.put("tool_pie", tool_pie);
			hp.put("tool_fb", tool_fb);
			hp.put("tool_radius", tool_radius);
			hp.put("tool_length", tool_length);
			hp.put("tool_unit", tool_unit);
			hp.put("tool_safe", tool_safe);
			hp.put("tool_current", tool_current);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("setEqpToolInsert",hp);
			
			if(result != null && result.size()>0){
    			model.addAttribute("actionresult", result.get(0).get("ACTION_RESULT"));
			}
			
		} catch(Exception e) {
			logger.error("[/smart/eqp/SmartEqpToolInsertSave.do] Exception :: " + e.toString());
		}
    	return "smart/eqp/SmartEqpToolInsertSave";
	}
	
	
	
	@RequestMapping(value = "/smart/eqp/SmartEqpToolHist.do")
    public String SmartEqpToolHist(
    		ModelMap model) throws Exception {
				
		return "smart/eqp/SmartEqpToolHist";
	}
	
	
	
	@RequestMapping(value = "/smart/eqp/SmartEqpToolHistData.do")
    public String SmartEqpToolHistData(
    		@RequestParam(value="startDate", required=false) String startDate,
    		@RequestParam(value="endDate", required=false) String endDate,
    		ModelMap model) throws Exception {
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
    	if(!isAuthenticated) {
    		model.addAttribute("sessionmessage", "session expire");
    		return "uat/uia/EgovLoginUsr";
    	}
    	
    	try {
    		
    		HashMap<String,String> hp = new HashMap<String,String>();
    		hp.put("startDate", startDate);
    		hp.put("endDate", endDate);
    		
    		List<HashMap> result = SmartCommonDAO.commonDataProc("getEqpToolHistData", hp);
    		
    		model.addAttribute("result", result);
    		model.addAttribute("startDate", startDate);
    		model.addAttribute("endDate", endDate);

    		List<String> listDate = new ArrayList<String>();
    		
    		int startYear = Integer.parseInt(startDate.substring(0,4));
    		int startMonth = Integer.parseInt(startDate.substring(5,7));
    		int endYear = Integer.parseInt(endDate.substring(0,4));
    		int endMonth = Integer.parseInt(endDate.substring(5,7));
    		int monthDiff = (endYear-startYear)*12 + (endMonth-startMonth) + 1;
    		
    		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM");
    		Date date = df.parse(startDate);
    		Calendar cal = Calendar.getInstance();
    		cal.setTime(date);
    		for(int i=0; i<monthDiff; i++) {
    			listDate.add(df.format(cal.getTime()));
    			cal.add(Calendar.MONTH, 1);
    		}
    		model.addAttribute("listDate", listDate);
    		
    	} catch(Exception e) {
    		logger.error("[/smart/eqp/SmartEqpToolHistData.do] Exception :: " + e.toString());
    	}
				
		return "smart/eqp/SmartEqpToolHistData";
	}
	
	
	
	@RequestMapping(value="/smart/eqp/SmartEqpToolHistExcelDown.do")
	public String SmartEqpToolHistExcelDown(
    		@RequestParam(value="startDate", required=false) String startDate,
    		@RequestParam(value="endDate", required=false) String endDate,
    		ModelMap model) throws Exception {
		
		try {
    		
    		HashMap<String,String> hp = new HashMap<String,String>();
    		hp.put("startDate", startDate);
    		hp.put("endDate", endDate);
    		
    		List<HashMap> result = SmartCommonDAO.commonDataProc("getEqpToolHistData", hp);
    		
    		model.addAttribute("result", result);
    		model.addAttribute("startDate", startDate);
    		model.addAttribute("endDate", endDate);

    		List<String> listDate = new ArrayList<String>();
    		
    		int startYear = Integer.parseInt(startDate.substring(0,4));
    		int startMonth = Integer.parseInt(startDate.substring(5,7));
    		int endYear = Integer.parseInt(endDate.substring(0,4));
    		int endMonth = Integer.parseInt(endDate.substring(5,7));
    		int monthDiff = (endYear-startYear)*12 + (endMonth-startMonth) + 1;
    		
    		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM");
    		Date date = df.parse(startDate);
    		Calendar cal = Calendar.getInstance();
    		cal.setTime(date);
    		for(int i=0; i<monthDiff; i++) {
    			listDate.add(df.format(cal.getTime()));
    			cal.add(Calendar.MONTH, 1);
    		}
    		model.addAttribute("listDate", listDate);
    		
    	} catch(Exception e) {
    		logger.error("[/smart/eqp/SmartEqpToolHistExcelDown.do] Exception :: " + e.toString());
    	}
		
		return "smart/eqp/SmartEqpToolHistExcelDown";
	}
    
	
	
	@RequestMapping(value="/smart/eqp/SmartEqpToolHistMonthly.do")
	public String SmartEqpToolHistMonthly(
			@RequestParam(value="searchDate", required=false) String searchDate,
			ModelMap model) throws Exception {
		
    	try {
    		
    		HashMap<String,String> hp = new HashMap<String,String>();
    		hp.put("searchDate", searchDate);
    		
    		List<HashMap> result = SmartCommonDAO.commonDataProc("getEqpToolHistMonthly", hp);
    		model.addAttribute("result", result);
	
			List<String> listDate = new ArrayList<String>();
    		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM");
    		Date date = df.parse(searchDate);
    		Calendar cal = Calendar.getInstance();
    		cal.setTime(date);
    		for(int i=1; i<cal.getActualMaximum(Calendar.DAY_OF_MONTH)+1; i++) {
    			listDate.add(Integer.toString(i));
    		}
    		model.addAttribute("listDate", listDate);
    		model.addAttribute("searchDate", searchDate);
    		
    	} catch(Exception e) {
    		logger.error("[/smart/eqp/SmartEqpToolHistMonthly.do] Exception :: " + e.toString());
    	}
    	return "smart/eqp/SmartEqpToolHistMonthly";
	}
	
	
	
	@RequestMapping(value="/smart/eqp/SmartEqpToolHistMonthlyExcelDown.do")
	public String SmartEqpToolHistMonthlyExcelDown(
			@RequestParam(value="searchDate", required=false) String searchDate,
			ModelMap model) throws Exception {
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
    		hp.put("searchDate", searchDate);
    		
    		List<HashMap> result = SmartCommonDAO.commonDataProc("getEqpToolHistMonthly", hp);
    		model.addAttribute("result", result);
    		
    		List<String> listDate = new ArrayList<String>();
    		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM");
    		Date date = df.parse(searchDate);
    		Calendar cal = Calendar.getInstance();
    		cal.setTime(date);
    		for(int i=1; i<cal.getActualMaximum(Calendar.DAY_OF_MONTH)+1; i++) {
    			listDate.add(Integer.toString(i));
    		}
    		model.addAttribute("listDate", listDate);
    		model.addAttribute("searchDate", searchDate);
    		
		} catch(Exception e) {
    		logger.error("[/smart/eqp/SmartEqpToolHistMonthlyExcelDown.do] Exception :: " + e.toString());
		}
		return "smart/eqp/SmartEqpToolHistMonthlyExcelDown";
	}
	
	
	
	@RequestMapping(value = "/smart/eqp/SmartEqpPm.do")
	public String SmartEqpPm(ModelMap model) throws Exception {
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("gubun","EQP_PART");
			hp.put("eqppart","");
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("getEqpPmBasic",hp);
			model.addAttribute("result", result);
			
		} catch(Exception e) {
			logger.error("[/smart/eqp/SmartEqpPm.do] Exception :: " + e.toString());
		}
    	return "smart/eqp/SmartEqpPm";
	}
	
	
	
	@RequestMapping(value = "/smart/eqp/SmartEqpPmList.do")
	public String SmartEqpPmList(
			@RequestParam(value="startDateField", required=false) String startdate,
			@RequestParam(value="endDateField", required=false) String enddate,
			@RequestParam(value="pm_type", required=false) String pm_type,
			@RequestParam(value="eqppart", required=false) String eqppart,
			@RequestParam(value="eqpname", required=false) String eqpname,
			ModelMap model
			) throws Exception {
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("startdate", startdate);
			hp.put("enddate", enddate);
			hp.put("pm_type", pm_type);
			hp.put("eqppart", eqppart);
			hp.put("eqpname", eqpname);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("getEqpPmList",hp);
			
			model.addAttribute("result", result);
			
		} catch(Exception e) {
			logger.error("[/smart/eqp/SmartEqpPmList.do] Exception :: " + e.toString());
		}
    	return "smart/eqp/SmartEqpPmList";
	}
	
	
	
	@RequestMapping(value = "/smart/eqp/SmartEqpPmExcel.do")
	public String SmartEqpPmExcel(
			@RequestParam(value="startDateField", required=false) String startdate,
			@RequestParam(value="endDateField", required=false) String enddate,
			@RequestParam(value="pm_type", required=false) String pm_type,
			@RequestParam(value="eqppart", required=false) String eqppart,
			@RequestParam(value="eqpname", required=false) String eqpname,
			ModelMap model
			) throws Exception {
		
		try {
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("startdate", startdate);
			hp.put("enddate", enddate);
			hp.put("pm_type", pm_type);
			hp.put("eqppart", eqppart);
			hp.put("eqpname", eqpname);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("getEqpPmList",hp);
			
			model.addAttribute("result", result);
			
		} catch(Exception e) {
			logger.error("[/smart/eqp/SmartEqpPmExcel.do] Exception :: " + e.toString());
		}
    	return "smart/eqp/SmartEqpPmExcel";
	}
	
	
	
	@RequestMapping(value = "/smart/eqp/SmartEqpPmEqpList.do")
	public String SmartEqpPmEqpList(
			@RequestParam(value="type", required=false) String type,
			@RequestParam(value="eqppart", required=false) String eqppart,
			@RequestParam(value="firstflag", required=false) String firstflag,
			ModelMap model
			) throws Exception {
		
    	try{
    		
    		HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("gubun","EQP_NAME");
			hp.put("eqppart", eqppart);
    			
			List<HashMap> result = SmartCommonDAO.commonDataProc("getEqpPmBasic",hp);
			
			model.addAttribute("result", result);
			
			model.addAttribute("type", type);
			model.addAttribute("firstflag", firstflag);
												
    	}
    	catch(Exception e){
    		System.out.println("[/smart/eqp/SmartEqpPmEqpList.do] Exception :: " + e.toString());
    	}
    	
    	return "smart/eqp/SmartEqpPmEqpList";
    	
	}
	
	
	
	@RequestMapping(value = "/smart/eqp/SmartEqpPmView.do")
	public String SmartEqpPmView(
			@RequestParam(value="pm_id", required=false) String pm_id,
			ModelMap model) throws Exception {
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
    	if(!isAuthenticated) {
    		model.addAttribute("sessionmessage", "session expire");
    		return "uat/uia/EgovLoginUsr";
    	}
    	
		try{
			
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			String storePathString = propertyService.getString("Globals.fileStorePath")  + "image/" ;//첨부 기본 경로
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("gubun","EQP_PART");
			hp.put("eqppart","");
			
			List<HashMap> resultBasic = SmartCommonDAO.commonDataProc("getEqpPmBasic",hp);
			model.addAttribute("resultBasic", resultBasic);
	    	
	    	hp = new HashMap<String,String>();
			hp.put("pm_id", pm_id);
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("getEqpPmInfo",hp);
			
			if(result != null && result.size()>0)
			{
				model.addAttribute("PM_ID", result.get(0).get("PM_ID"));
				model.addAttribute("PM_TYPE", result.get(0).get("PM_TYPE"));
				model.addAttribute("PM_EQPPART", result.get(0).get("PM_EQPPART"));
				model.addAttribute("PM_EQP", result.get(0).get("PM_EQP"));
				model.addAttribute("PM_DATE", result.get(0).get("PM_DATE"));
				model.addAttribute("PM_HOUR", result.get(0).get("PM_HOUR"));
				model.addAttribute("PM_COST", result.get(0).get("PM_COST"));
				model.addAttribute("PM_DETAIL", result.get(0).get("PM_DETAIL"));
				model.addAttribute("PM_DESC", result.get(0).get("PM_DESC"));
				model.addAttribute("PM_WORKER", result.get(0).get("PM_WORKER"));
				model.addAttribute("PM_WORKER_NAME", result.get(0).get("PM_WORKER_NAME"));
				
				model.addAttribute("IMAGE_INFO_1", result.get(0).get("IMAGE_INFO_1"));
				model.addAttribute("IMAGE_INFO_2", result.get(0).get("IMAGE_INFO_2"));
				model.addAttribute("IMAGE_INFO_3", result.get(0).get("IMAGE_INFO_3"));
				model.addAttribute("IMAGE_INFO_4", result.get(0).get("IMAGE_INFO_4"));
				model.addAttribute("FILE_LOCATION", storePathString);

			}
			
			hp = new HashMap<String,String>();
			hp.put("userid", loginVO.getId());
			List<HashMap> resultRole = SmartCommonDAO.commonDataProc("selectUserRoleData",hp);
    		
    		if(resultRole != null && resultRole.size()>0)
    		{
    			model.addAttribute("userrole", resultRole.get(0).get("AUTHOR_CODE"));
    		}
    		
			model.addAttribute("pm_id", pm_id);
			model.addAttribute("userid", loginVO.getId());
			
		}catch(Exception e){
			logger.error("[/smart/eqp/SmartEqpPmView.do] Exception :: " + e.toString());
		}
    	
    	return "smart/eqp/SmartEqpPmView";
	}
	
	
	
	@RequestMapping(value = "/smart/eqp/SmartEqpPmNew.do")
	public String SmartEqpPmNew(ModelMap model) throws Exception {
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
    	if(!isAuthenticated) {
    		model.addAttribute("sessionmessage", "session expire");
    		return "uat/uia/EgovLoginUsr";
    	}
    	
		try {
			
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("gubun","EQP_PART");
			hp.put("eqppart","");
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("getEqpPmBasic",hp);
			
			model.addAttribute("result", result);
			model.addAttribute("username", loginVO.getName());
			
		} catch(Exception e) {
			logger.error("[/smart/eqp/SmartEqpPmNew.do] Exception :: " + e.toString());
		}
    	return "smart/eqp/SmartEqpPmNew";
	}
	
	
	
	@RequestMapping(value = "/smart/eqp/SmartEqpPmSave.do")
	public String SmartEqpPmSave(
			HttpServletRequest request, 
			ModelMap model) throws Exception {
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
    	if(!isAuthenticated) {
    		model.addAttribute("sessionmessage", "session expire");
    		return "uat/uia/EgovLoginUsr";
    	}
		
		try{
			
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			
			List<FileVO> _result = null;
			String _atchFileId = "";
			String actiontype = "";
			
			HashMap<String,String> hp = new HashMap<String,String>();
	
			MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest)request;
			
			Enumeration em = request.getParameterNames();
			String paramName = "";
			
			hp.put("pm_worker", loginVO.getId());
    		
			while(em.hasMoreElements())
			{
				paramName = em.nextElement().toString();
			
				if("actiontype".equals(paramName))
				{
					hp.put("actiontype",request.getParameter(paramName));
					actiontype = request.getParameter(paramName);
				}
				else if("pm_id".equals(paramName))
				{
					hp.put("pm_id",request.getParameter(paramName));
				}
				else if("pm_type".equals(paramName))
				{
					hp.put("pm_type",request.getParameter(paramName));
				}
				else if("eqppart".equals(paramName))
				{
					hp.put("eqppart",request.getParameter(paramName));
				}
				else if("eqpname".equals(paramName))
				{
					hp.put("eqpname",request.getParameter(paramName));
				}
				else if("pm_date".equals(paramName))
				{
					hp.put("pm_date",request.getParameter(paramName));
				}
				else if("pm_hour".equals(paramName))
				{
					hp.put("pm_hour",request.getParameter(paramName));
				}
				else if("pm_cost".equals(paramName))
				{
					hp.put("pm_cost",request.getParameter(paramName));
				}
				else if("pm_detail".equals(paramName))
				{
					hp.put("pm_detail",request.getParameter(paramName));
				}
				else if("pm_desc".equals(paramName))
				{
					hp.put("pm_desc",request.getParameter(paramName));
				}
			}
			
			List<MultipartFile> files = null;
			String imageInfo = "";
			String storePathString = propertyService.getString("Globals.fileStorePath")  + "image/" ;//첨부 기본 경로
			
			files = mptRequest.getFiles("file_image_1");
			
			if(files != null && files.size()>0)
			{
				_result = fileUtil.parseFileImageResizeUpload(files, "support", 0, "", "", storePathString); 
				_atchFileId = fileMngService.insertFileInfs(_result);  //파일이 생성되고나면 생성된 첨부파일 ID를 리턴한다.
				
				if(_result != null && _result.size()>0)
				{
					imageInfo = _result.get(0).getStreFileNm();
				}
			}
			
			hp.put("image_info_1", imageInfo);
			
			imageInfo = "";
			
			files = mptRequest.getFiles("file_image_2");
			
			if(files != null && files.size()>0)
			{
				_result = fileUtil.parseFileImageResizeUpload(files, "support", 0, "", "", storePathString); 
				_atchFileId = fileMngService.insertFileInfs(_result);  //파일이 생성되고나면 생성된 첨부파일 ID를 리턴한다.
				
				if(_result != null && _result.size()>0)
				{
					imageInfo = _result.get(0).getStreFileNm();
				}
			}
			
			hp.put("image_info_2", imageInfo);
			
			imageInfo = "";
			
			files = mptRequest.getFiles("file_image_3");
			
			if(files != null && files.size()>0)
			{
				_result = fileUtil.parseFileImageResizeUpload(files, "support", 0, "", "", storePathString); 
				_atchFileId = fileMngService.insertFileInfs(_result);  //파일이 생성되고나면 생성된 첨부파일 ID를 리턴한다.
				
				if(_result != null && _result.size()>0)
				{
					imageInfo = _result.get(0).getStreFileNm();
				}
			}
			
			hp.put("image_info_3", imageInfo);
			
			imageInfo = "";
			
			files = mptRequest.getFiles("file_image_4");
			
			if(files != null && files.size()>0)
			{
				_result = fileUtil.parseFileImageResizeUpload(files, "support", 0, "", "", storePathString); 
				_atchFileId = fileMngService.insertFileInfs(_result);  //파일이 생성되고나면 생성된 첨부파일 ID를 리턴한다.
				
				if(_result != null && _result.size()>0)
				{
					imageInfo = _result.get(0).getStreFileNm();
				}
			}
			
			hp.put("image_info_4", imageInfo);
					
			
			
			
			List<HashMap> result = SmartCommonDAO.commonDataProc("setEqpPmSave",hp);
			
			if(result != null && result.size()>0){
    			
				model.addAttribute("ACTION_RESULT", result.get(0).get("ACTION_RESULT"));
			}
			
			model.addAttribute("actiontype", actiontype);
	    	
		}catch(Exception e){
			logger.error("[/smart/eqp/SmartEqpPmSave.do] Exception :: " + e.toString());
		}
    	
    	return "smart/eqp/SmartEqpPmSave";
	}
}