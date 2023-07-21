// Generated automatically from org.apache.tools.ant.types.selectors.ContainsSelector for testing purposes

package org.apache.tools.ant.types.selectors;

import java.io.File;
import org.apache.tools.ant.types.Parameter;
import org.apache.tools.ant.types.Resource;
import org.apache.tools.ant.types.resources.selectors.ResourceSelector;
import org.apache.tools.ant.types.selectors.BaseExtendSelector;

public class ContainsSelector extends BaseExtendSelector implements ResourceSelector
{
    public ContainsSelector(){}
    public String toString(){ return null; }
    public boolean isSelected(File p0, String p1, File p2){ return false; }
    public boolean isSelected(Resource p0){ return false; }
    public static String CASE_KEY = null;
    public static String CONTAINS_KEY = null;
    public static String EXPRESSION_KEY = null;
    public static String WHITESPACE_KEY = null;
    public void setCasesensitive(boolean p0){}
    public void setEncoding(String p0){}
    public void setIgnorewhitespace(boolean p0){}
    public void setParameters(Parameter... p0){}
    public void setText(String p0){}
    public void verifySettings(){}
}
