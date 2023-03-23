// Generated automatically from org.apache.tools.ant.types.selectors.MappingSelector for testing purposes

package org.apache.tools.ant.types.selectors;

import java.io.File;
import org.apache.tools.ant.types.Mapper;
import org.apache.tools.ant.types.selectors.BaseSelector;
import org.apache.tools.ant.util.FileNameMapper;

abstract public class MappingSelector extends BaseSelector
{
    protected File targetdir = null;
    protected FileNameMapper map = null;
    protected Mapper mapperElement = null;
    protected abstract boolean selectionTest(File p0, File p1);
    protected int granularity = 0;
    public Mapper createMapper(){ return null; }
    public MappingSelector(){}
    public boolean isSelected(File p0, String p1, File p2){ return false; }
    public void addConfigured(FileNameMapper p0){}
    public void setGranularity(int p0){}
    public void setTargetdir(File p0){}
    public void verifySettings(){}
}
