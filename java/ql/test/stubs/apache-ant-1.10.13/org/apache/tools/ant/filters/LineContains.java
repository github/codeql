// Generated automatically from org.apache.tools.ant.filters.LineContains for testing purposes

package org.apache.tools.ant.filters;

import java.io.Reader;
import org.apache.tools.ant.filters.BaseParamFilterReader;
import org.apache.tools.ant.filters.ChainableReader;

public class LineContains extends BaseParamFilterReader implements ChainableReader
{
    public LineContains(){}
    public LineContains(Reader p0){}
    public Reader chain(Reader p0){ return null; }
    public boolean isMatchAny(){ return false; }
    public boolean isNegated(){ return false; }
    public int read(){ return 0; }
    public void addConfiguredContains(LineContains.Contains p0){}
    public void setMatchAny(boolean p0){}
    public void setNegate(boolean p0){}
    static public class Contains
    {
        public Contains(){}
        public final String getValue(){ return null; }
        public final void setValue(String p0){}
    }
}
