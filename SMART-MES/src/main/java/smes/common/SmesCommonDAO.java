package smes.common;

import javax.annotation.Resource;

import com.ibatis.sqlmap.client.SqlMapClient;

import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

public abstract class SmesCommonDAO extends EgovAbstractDAO{
	
	@Resource(name="smes.sqlMapClient")
	public void setSuperSqlMapClient(SqlMapClient sqlMapClient){
		super.setSuperSqlMapClient(sqlMapClient);
	}

}
