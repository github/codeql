// Generated automatically from org.apache.tools.ant.types.selectors.BaseSelector for testing purposes

package org.apache.tools.ant.types.selectors;

import java.io.File;
import org.apache.tools.ant.types.DataType;
import org.apache.tools.ant.types.selectors.FileSelector;

abstract public class BaseSelector extends DataType implements FileSelector
{
    public BaseSelector(){}
    public String getError(){ return null; }
    public abstract boolean isSelected(File p0, String p1, File p2);
    public void setError(String p0){}
    public void setError(String p0, Throwable p1){}
    public void validate(){}
    public void verifySettings(){}
}
