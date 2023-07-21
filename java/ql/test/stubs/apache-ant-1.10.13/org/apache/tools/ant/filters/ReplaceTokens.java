// Generated automatically from org.apache.tools.ant.filters.ReplaceTokens for testing purposes

package org.apache.tools.ant.filters;

import java.io.Reader;
import org.apache.tools.ant.filters.BaseParamFilterReader;
import org.apache.tools.ant.filters.ChainableReader;
import org.apache.tools.ant.types.Resource;

public class ReplaceTokens extends BaseParamFilterReader implements ChainableReader
{
    public Reader chain(Reader p0){ return null; }
    public ReplaceTokens(){}
    public ReplaceTokens(Reader p0){}
    public int read(){ return 0; }
    public void addConfiguredToken(ReplaceTokens.Token p0){}
    public void setBeginToken(String p0){}
    public void setEndToken(String p0){}
    public void setPropertiesResource(Resource p0){}
    static public class Token
    {
        public Token(){}
        public final String getKey(){ return null; }
        public final String getValue(){ return null; }
        public final void setKey(String p0){}
        public final void setValue(String p0){}
    }
}
