// Generated automatically from org.apache.tools.ant.filters.StripLineComments for testing purposes

package org.apache.tools.ant.filters;

import java.io.Reader;
import org.apache.tools.ant.filters.BaseParamFilterReader;
import org.apache.tools.ant.filters.ChainableReader;

public class StripLineComments extends BaseParamFilterReader implements ChainableReader
{
    public Reader chain(Reader p0){ return null; }
    public StripLineComments(){}
    public StripLineComments(Reader p0){}
    public int read(){ return 0; }
    public void addConfiguredComment(StripLineComments.Comment p0){}
    static public class Comment
    {
        public Comment(){}
        public final String getValue(){ return null; }
        public final void setValue(String p0){}
        public void addText(String p0){}
    }
}
