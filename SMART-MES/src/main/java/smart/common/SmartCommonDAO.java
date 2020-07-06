package smart.common;

import javax.annotation.Resource;

import com.ibatis.sqlmap.client.SqlMapClient;

import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

public abstract class SmartCommonDAO extends EgovAbstractDAO{
	
	@Resource(name="smart.sqlMapClient")
	public void setSuperSqlMapClient(SqlMapClient sqlMapClient){
		super.setSuperSqlMapClient(sqlMapClient);
	}

}
