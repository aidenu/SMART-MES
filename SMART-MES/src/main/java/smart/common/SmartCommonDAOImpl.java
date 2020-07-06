package smart.common;

import java.util.HashMap;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import egovframework.com.cmm.LoginVO;
import egovframework.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import smart.common.SmartCommonDAO;

@Repository("smartCommonDAO")
public class SmartCommonDAOImpl extends SmartCommonDAO {
	
	Logger logger = Logger.getLogger("db_procedure");

	@SuppressWarnings("unchecked")
	public List<HashMap> commonDataProc(String procName,HashMap<String,String> hp)
			throws Exception {

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		List<HashMap> sqlRes = null;
		
		try {
			
			if(hp != null && hp.size()>0)
			{
				logger.debug("                                                                                                                                                         ");
				logger.debug(" ---------------------------  DB INPUT PARAMETER START ---------------------------");
				logger.debug("            [User Name  ::: " + loginVO.getId() + " ]");
				logger.debug("            [Query Name  ::: " + procName + " ]");
				logger.debug("            [Parameter Value ::: " + hp.toString() + " ] ");
				logger.debug(" ---------------------------  DB INPUT PARAMETER END  ----------------------------");
			}

			sqlRes = (List<HashMap>) this.list(procName, hp);

			if(sqlRes != null)
			{
				logger.debug("                                                                                                                                                         ");
				logger.debug(" ---------------------------  DB RESULT START  ------------------------------------");
				logger.debug("            [User Name  ::: " + loginVO.getId() + " ]");
				logger.debug("            [Query Name  ::: " + procName + " ]");
				logger.debug("            [Result Cursor Count :: " + sqlRes.size() + " ]");
				logger.debug(" ---------------------------  DB RESULT END --------------------------------------");
			}
			else
			{
				logger.debug("                                                                                                                                                         ");
				logger.debug(" ---------------------------  DB RESULT START  ------------------------------------");
				logger.debug("            [User Name  ::: " + loginVO.getId() + " ]");
				logger.debug("            [Query Name  ::: " + procName + " ]");
				logger.debug("            [Result Cursor Count :: NULL ]");
				logger.debug(" ---------------------------  DB RESULT END --------------------------------------");
			}

		} catch (Exception e) {
			logger.debug("[SmartCommonDAO] commonDataProc method Execute Exception :::" + e.toString());
		}

		return sqlRes;
	}
	
	
	@SuppressWarnings("unchecked")
	public List<HashMap> commonDataProc(String procName)
			throws Exception {

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		List<HashMap> sqlRes = null;
		try {
			
			logger.debug("                                                                                                                                                         ");
			logger.debug(" ---------------------------  DB INPUT PARAMETER START ---------------------------");
			logger.debug("            [User Name  ::: " + loginVO.getId() + " ]");
			logger.debug("            [Query Name  ::: " + procName + " ]");
			logger.debug(" ---------------------------   DB INPUT PARAMETER END  ---------------------------");

			sqlRes = (List<HashMap>) this.list(procName);
			
			if(sqlRes != null)
			{
				logger.debug("                                                                                                                                                         ");
				logger.debug(" ---------------------------  DB RESULT START  ------------------------------------");
				logger.debug("            [User Name  ::: " + loginVO.getId() + " ]");
				logger.debug("            [Query Name  ::: " + procName + " ]");
				logger.debug("            [Result Cursor Count :: " + sqlRes.size() + " ]");
				logger.debug(" ---------------------------  DB RESULT END --------------------------------------");
			}
			else
			{
				logger.debug("                                                                                                                                                         ");
				logger.debug(" ---------------------------  DB RESULT START  ------------------------------------");
				logger.debug("            [User Name  ::: " + loginVO.getId() + " ]");
				logger.debug("            [Query Name  ::: " + procName + " ]");
				logger.debug("            [Result Cursor Count :: NULL ]");
				logger.debug(" ---------------------------  DB RESULT END --------------------------------------");
			}

		} catch (Exception e) {
			logger.debug("[SmartCommonDAO] commonDataProc method Execute Exception :::" + e.toString());
		}

		return sqlRes;
	}
	
	
	
	@SuppressWarnings("unchecked")
	public List<HashMap> nosessioncommonDataProc(String procName,HashMap<String,String> hp)
			throws Exception {

		List<HashMap> sqlRes = null;
		
		try {
			
			if(hp != null && hp.size()>0)
			{
				logger.debug("                                                                                                                                                         ");
				logger.debug(" ---------------------------  DB INPUT PARAMETER START ---------------------------");
				logger.debug("            [Query Name  ::: " + procName + " ]");
				logger.debug("            [Parameter Value ::: " + hp.toString() + " ] ");
				logger.debug(" ---------------------------  DB INPUT PARAMETER END  ----------------------------");
			}

			sqlRes = (List<HashMap>) this.list(procName, hp);
			
			if(sqlRes != null)
			{
				logger.debug("                                                                                                                                                         ");
				logger.debug(" ---------------------------  DB RESULT START  ------------------------------------");
				logger.debug("            [Query Name  ::: " + procName + " ]");
				logger.debug("            [Result Cursor Count :: " + sqlRes.size() + " ]");
				logger.debug(" ---------------------------  DB RESULT END --------------------------------------");
			}
			else
			{
				logger.debug("                                                                                                                                                         ");
				logger.debug(" ---------------------------  DB RESULT START  ------------------------------------");
				logger.debug("            [Query Name  ::: " + procName + " ]");
				logger.debug("            [Result Cursor Count :: NULL ]");
				logger.debug(" ---------------------------  DB RESULT END --------------------------------------");
			}

		} catch (Exception e) {
			logger.debug("[SmartCommonDAO] nosessioncommonDataProc method Execute Exception :::" + e.toString());
		}

		return sqlRes;
	}
	
	
	
	@SuppressWarnings("unchecked")
	public List<HashMap> nosessioncommonDataProc(String procName)
			throws Exception {

		List<HashMap> sqlRes = null;
		
		try {
			
			logger.debug("                                                                                                                                                         ");
			logger.debug(" ---------------------------  DB INPUT PARAMETER START ---------------------------");
			logger.debug("            [Query Name  ::: " + procName + " ]");
			logger.debug(" ---------------------------   DB INPUT PARAMETER END  ---------------------------");

			sqlRes = (List<HashMap>) this.list(procName);
			
			if(sqlRes != null)
			{
				logger.debug("                                                                                                                                                         ");
				logger.debug(" ---------------------------  DB RESULT START  ------------------------------------");
				logger.debug("            [Query Name  ::: " + procName + " ]");
				logger.debug("            [Result Cursor Count :: " + sqlRes.size() + " ]");
				logger.debug(" ---------------------------  DB RESULT END --------------------------------------");
			}
			else
			{
				logger.debug("                                                                                                                                                         ");
				logger.debug(" ---------------------------  DB RESULT START  ------------------------------------");
				logger.debug("            [Query Name  ::: " + procName + " ]");
				logger.debug("            [Result Cursor Count :: NULL ]");
				logger.debug(" ---------------------------  DB RESULT END --------------------------------------");
			}

		} catch (Exception e) {
			logger.debug("[SmartCommonDAO] nosessioncommonDataProc method Execute Exception :::" + e.toString());
		}

		return sqlRes;
	}
	
}
