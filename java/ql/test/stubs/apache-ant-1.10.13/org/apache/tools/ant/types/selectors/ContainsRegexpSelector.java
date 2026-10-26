// Generated automatically from org.apache.tools.ant.types.selectors.ContainsRegexpSelector for testing purposes

package org.apache.tools.ant.types.selectors;

import java.io.File;
import org.apache.tools.ant.types.Parameter;
import org.apache.tools.ant.types.Resource;
import org.apache.tools.ant.types.resources.selectors.ResourceSelector;
import org.apache.tools.ant.types.selectors.BaseExtendSelector;

public class ContainsRegexpSelector extends BaseExtendSelector implements ResourceSelector
{
    public ContainsRegexpSelector(){}
    public String toString(){ return null; }
    public boolean isSelected(File p0, String p1, File p2){ return false; }
    public boolean isSelected(Resource p0){ return false; }
    public static String EXPRESSION_KEY = null;
    public void setCaseSensitive(boolean p0){}
    public void setExpression(String p0){}
    public void setMultiLine(boolean p0){}
    public void setParameters(Parameter... p0){}
    public void setSingleLine(boolean p0){}
    public void verifySettings(){}
}
