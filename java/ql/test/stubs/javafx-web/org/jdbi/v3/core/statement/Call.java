// Generated automatically from org.jdbi.v3.core.statement.Call for testing purposes

package org.jdbi.v3.core.statement;

import java.util.function.Consumer;
import java.util.function.Function;
import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.statement.CallableStatementMapper;
import org.jdbi.v3.core.statement.OutParameters;
import org.jdbi.v3.core.statement.SqlStatement;

public class Call extends SqlStatement<Call>
{
    protected Call() {}
    public <T> T invoke(Function<OutParameters, T> p0){ return null; }
    public Call registerOutParameter(String p0, int p1){ return null; }
    public Call registerOutParameter(String p0, int p1, CallableStatementMapper p2){ return null; }
    public Call registerOutParameter(int p0, int p1){ return null; }
    public Call registerOutParameter(int p0, int p1, CallableStatementMapper p2){ return null; }
    public Call(Handle p0, CharSequence p1){}
    public Call(Handle p0, String p1){}
    public OutParameters invoke(){ return null; }
    public void invoke(Consumer<OutParameters> p0){}
}
