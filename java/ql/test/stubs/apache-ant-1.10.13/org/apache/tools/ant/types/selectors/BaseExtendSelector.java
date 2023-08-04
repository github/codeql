// Generated automatically from org.apache.tools.ant.types.selectors.BaseExtendSelector for testing purposes

package org.apache.tools.ant.types.selectors;

import java.io.File;
import org.apache.tools.ant.types.Parameter;
import org.apache.tools.ant.types.selectors.BaseSelector;
import org.apache.tools.ant.types.selectors.ExtendFileSelector;

abstract public class BaseExtendSelector extends BaseSelector implements ExtendFileSelector
{
    protected Parameter[] getParameters(){ return null; }
    protected Parameter[] parameters = null;
    public BaseExtendSelector(){}
    public abstract boolean isSelected(File p0, String p1, File p2);
    public void setParameters(Parameter... p0){}
}
