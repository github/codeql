// Generated automatically from org.apache.tools.ant.types.selectors.PresentSelector for testing purposes

package org.apache.tools.ant.types.selectors;

import java.io.File;
import org.apache.tools.ant.types.EnumeratedAttribute;
import org.apache.tools.ant.types.Mapper;
import org.apache.tools.ant.types.selectors.BaseSelector;
import org.apache.tools.ant.util.FileNameMapper;

public class PresentSelector extends BaseSelector
{
    public Mapper createMapper(){ return null; }
    public PresentSelector(){}
    public String toString(){ return null; }
    public boolean isSelected(File p0, String p1, File p2){ return false; }
    public void addConfigured(FileNameMapper p0){}
    public void setPresent(PresentSelector.FilePresence p0){}
    public void setTargetdir(File p0){}
    public void verifySettings(){}
    static public class FilePresence extends EnumeratedAttribute
    {
        public FilePresence(){}
        public String[] getValues(){ return null; }
    }
}
