package space.common;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.Map;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;


@Controller
public class SpaceFileDownController {

    private static final Logger LOGGER = LoggerFactory.getLogger(SpaceFileDownController.class);

    /**
     * 브라우저 구분 얻기.
     *
     * @param request
     * @return
     */
    private String getBrowser(HttpServletRequest request) {
        String header = request.getHeader("User-Agent");
        if (header.indexOf("MSIE") > -1) {
            return "MSIE";
        } else if (header.indexOf("Trident") > -1) {	// IE11 문자열 깨짐 방지
            return "Trident";
        } else if (header.indexOf("Chrome") > -1) {
            return "Chrome";
        } else if (header.indexOf("Opera") > -1) {
            return "Opera";
        }
        return "Firefox";
    }

    /**
     * Disposition 지정하기.
     *
     * @param filename
     * @param request
     * @param response
     * @throws Exception
     */
    private void setDisposition(String filename, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String browser = getBrowser(request);

		String dispositionPrefix = "attachment; filename=";
		String encodedFilename = null;

		if (browser.equals("MSIE")) {
			encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
		} else if (browser.equals("Trident")) {		// IE11 문자열 깨짐 방지
			encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
		} else if (browser.equals("Firefox")) {
			encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.equals("Opera")) {
			encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.equals("Chrome")) {
			StringBuffer sb = new StringBuffer();
			for (int i = 0; i < filename.length(); i++) {
				char c = filename.charAt(i);
				if (c > '~') {
					sb.append(URLEncoder.encode("" + c, "UTF-8"));
				} else {
					sb.append(c);
				}
			}
			encodedFilename = sb.toString();
		} else {
			//throw new RuntimeException("Not supported browser");
			throw new IOException("Not supported browser");
		}

		response.setHeader("Content-Disposition", dispositionPrefix + encodedFilename);

		if ("Opera".equals(browser)){
			response.setContentType("application/octet-stream;charset=UTF-8");
		}
    }

    /**
     * 첨부파일로 등록된 파일에 대하여 다운로드를 제공한다.
     *
     * @param commandMap
     * @param response
     * @throws Exception
     */
    @RequestMapping(value = "/space/common/SpaceFileDown.do")
    public void cvplFileDownload(@RequestParam Map<String, Object> commandMap, HttpServletRequest request, HttpServletResponse response) throws Exception {

    	String filelocation = (String)commandMap.get("filelocation");
    	String filename = (String)commandMap.get("filename");

		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
	
		if (isAuthenticated) {
	
		    File uFile = new File(filelocation, filename);
		    int fSize = (int)uFile.length();
		    
		    if (fSize > 0) {
		    	
				String mimetype = "application/x-msdownload";
		
				//response.setBufferSize(fSize);	// OutOfMemeory 발생
				response.setContentType(mimetype);
				//response.setHeader("Content-Disposition", "attachment; filename=\"" + URLEncoder.encode(fvo.getOrignlFileNm(), "utf-8") + "\"");
				setDisposition(filename, request, response);
				response.setContentLength(fSize);
		
				/*
				 * FileCopyUtils.copy(in, response.getOutputStream());
				 * in.close();
				 * response.getOutputStream().flush();
				 * response.getOutputStream().close();
				 */
				BufferedInputStream in = null;
				BufferedOutputStream out = null;
		
				try {
				    in = new BufferedInputStream(new FileInputStream(uFile));
				    out = new BufferedOutputStream(response.getOutputStream());
		
				    FileCopyUtils.copy(in, out);
				    out.flush();
				} catch (Exception ex) {
				    //ex.printStackTrace();
				    // 다음 Exception 무시 처리
				    // Connection reset by peer: socket write error
					LOGGER.debug("IGNORED: {}", ex.getMessage());
				} finally {
				    if (in != null) {
					try {
					    in.close();
					} catch (Exception ignore) {
						LOGGER.debug("IGNORED: {}", ignore.getMessage());
					}
				    }
				    if (out != null) {
					try {
					    out.close();
					} catch (Exception ignore) {
						LOGGER.debug("IGNORED: {}", ignore.getMessage());
					}
				    }
				}
	
		    } else {
				response.setContentType("application/x-msdownload");
		
				PrintWriter printwriter = response.getWriter();
				printwriter.println("<html>");
				printwriter.println("<br><br><br><h2>Could not get file name:<br>" + filename + "</h2>");
				printwriter.println("<br><br><br><center><h3><a href='javascript: history.go(-1)'>Back</a></h3></center>");
				printwriter.println("<br><br><br>&copy; webAccess");
				printwriter.println("</html>");
				printwriter.flush();
				printwriter.close();
		    }
		}
    }
}
