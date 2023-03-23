// Generated automatically from org.apache.tools.ant.types.selectors.TypeSelector for testing purposes

package org.apache.tools.ant.types.selectors;

import java.io.File;
import org.apache.tools.ant.types.EnumeratedAttribute;
import org.apache.tools.ant.types.Parameter;
import org.apache.tools.ant.types.selectors.BaseExtendSelector;

public class TypeSelector extends BaseExtendSelector
{
    public String toString(){ return null; }
    public TypeSelector(){}
    public boolean isSelected(File p0, String p1, File p2){ return false; }
    public static String TYPE_KEY = null;
    public void setParameters(Parameter... p0){}
    public void setType(TypeSelector.FileType p0){}
    public void verifySettings(){}
    static public class FileType extends EnumeratedAttribute
    {
        public FileType(){}
        public String[] getValues(){ return null; }
        public static String DIR = null;
        public static String FILE = null;
    }
}
