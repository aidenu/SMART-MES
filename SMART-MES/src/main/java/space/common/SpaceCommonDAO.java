package space.common;

import javax.annotation.Resource;

import com.ibatis.sqlmap.client.SqlMapClient;

import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

public abstract class SpaceCommonDAO extends EgovAbstractDAO{
	
	@Resource(name="space.sqlMapClient")
	public void setSuperSqlMapClient(SqlMapClient sqlMapClient){
		super.setSuperSqlMapClient(sqlMapClient);
	}

}
