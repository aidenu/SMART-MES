package smart.common;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import com.notnoop.apns.APNS;
import com.notnoop.apns.ApnsNotification;
import com.notnoop.apns.ApnsService;
import com.notnoop.apns.ApnsServiceBuilder;

import egovframework.rte.fdl.property.EgovPropertyService;

@Repository("smartGcmSender")
public class SmartGcmSender {
	
	Logger logger = Logger.getLogger("egovframework");

	@Resource(name="smartCommonDAO")
	private SmartCommonDAOImpl SmartCommonDAO;

	@Resource(name = "propertiesService")
    protected EgovPropertyService propertyService;
	
	public String gcmSender(String Appkey,String PushMsg,int MsgCnt)
	{
		String result = "";
		String OsType = "";

		try
		{
			HashMap<String,String> hp = new HashMap<String,String>();
			hp.put("appkey", Appkey);
			List<HashMap> resultMsg = SmartCommonDAO.commonDataProc("getAppKeyInfo",hp);
			
			if(resultMsg != null && resultMsg.size()>0)
			{
				OsType = resultMsg.get(0).get("OS_TYPE").toString();
			}
			
			if("IOS".equals(OsType))
			{
				String certPath = propertyService.getString("Globals.fileStorePath")  + "app/monitorsystem.p12";
				String certPassWord = "monitor123";
								
				ApnsServiceBuilder serviceBuilder = APNS.newService();
				
				serviceBuilder.withCert(certPath, certPassWord).withProductionDestination();
				
				ApnsService service = serviceBuilder.build();
				
				String payload = APNS.newPayload().alertBody(URLDecoder.decode(PushMsg)).sound("default").customField("custom", "custom value").build();
				
				logger.debug("Push Message :: " + payload);
				
				ApnsNotification notification = service.push(Appkey, payload);
				result = notification.toString();
				logger.debug("[/smart/common/SmartGcmSender.do] Push Message result :: "+result+"");
				
			}
			else//ANDROID
			{
				final String apiKey = "AAAAEigDOWc:APA91bHeKCX8_PrZ8YCVaxqWS4rubRq-FQ6LhEarpRMWWIyWzintw5DnKwJ_I5gFpGF5e3GjfUKYYNEO9m7LT3CmCYjaQCNfJyeHHzBpBwv4GJMWZI3d1ClEBFHnc7d3dezCxQjA57G5";
				
                URL url = new URL("https://fcm.googleapis.com/fcm/send");
                
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                
                conn.setDoOutput(true);
                conn.setRequestMethod("POST");
                conn.setRequestProperty("Content-Type", "application/json");
                conn.setRequestProperty("Authorization", "key=" + apiKey);
 
                conn.setDoOutput(true);
                
                //String input = "{\"notification\" : {\"title\" : \"Mold Manager 알림\", \"body\" : \""+URLDecoder.decode(PushMsg,"utf-8")+"\" }, \"to\":\""+Appkey+"\"}";
                String input = "{\"data\" : {\"title\" : \"SMART-MES 알림\", \"body\" : \""+URLDecoder.decode(PushMsg,"utf-8")+"\" }, \"to\":\""+Appkey+"\"}";
                 
                OutputStream os = conn.getOutputStream();
                
                // 서버에서 날려서 한글 깨지는 사람은 아래처럼  UTF-8로 인코딩해서 날려주자
                os.write(input.getBytes("UTF-8"));
                os.flush();
                os.close();
 
                int responseCode = conn.getResponseCode();
                
                logger.debug("\nSending 'POST' request to URL : " + url);
                logger.debug("Post parameters : " + input);
                logger.debug("Response Code : " + responseCode);
                
                BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                String inputLine;
                StringBuffer response = new StringBuffer();
 
                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }
                
                in.close();
                
                // print result
                logger.debug(response.toString());
			}
		}
		catch(Exception e)
		{
			logger.debug("[/smart/common/SmartGcmSender.do] Push Message Error :: "+e.toString()+"");
		}
		
		return result;
	}
	
	
}
