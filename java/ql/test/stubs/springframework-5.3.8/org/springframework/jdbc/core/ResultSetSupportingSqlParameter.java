// Generated automatically from org.springframework.jdbc.core.ResultSetSupportingSqlParameter for testing purposes

package org.springframework.jdbc.core;

import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.jdbc.core.RowCallbackHandler;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.SqlParameter;

public class ResultSetSupportingSqlParameter extends SqlParameter
{
    protected ResultSetSupportingSqlParameter() {}
    public ResultSetExtractor<? extends Object> getResultSetExtractor(){ return null; }
    public ResultSetSupportingSqlParameter(String p0, int p1){}
    public ResultSetSupportingSqlParameter(String p0, int p1, ResultSetExtractor<? extends Object> p2){}
    public ResultSetSupportingSqlParameter(String p0, int p1, RowCallbackHandler p2){}
    public ResultSetSupportingSqlParameter(String p0, int p1, RowMapper<? extends Object> p2){}
    public ResultSetSupportingSqlParameter(String p0, int p1, String p2){}
    public ResultSetSupportingSqlParameter(String p0, int p1, int p2){}
    public RowCallbackHandler getRowCallbackHandler(){ return null; }
    public RowMapper<? extends Object> getRowMapper(){ return null; }
    public boolean isInputValueProvided(){ return false; }
    public boolean isResultSetSupported(){ return false; }
}
