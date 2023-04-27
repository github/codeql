// Generated automatically from org.apache.tools.ant.types.selectors.SizeSelector for testing purposes

package org.apache.tools.ant.types.selectors;

import java.io.File;
import org.apache.tools.ant.types.Comparison;
import org.apache.tools.ant.types.EnumeratedAttribute;
import org.apache.tools.ant.types.Parameter;
import org.apache.tools.ant.types.selectors.BaseExtendSelector;

public class SizeSelector extends BaseExtendSelector
{
    public SizeSelector(){}
    public String toString(){ return null; }
    public boolean isSelected(File p0, String p1, File p2){ return false; }
    public static String SIZE_KEY = null;
    public static String UNITS_KEY = null;
    public static String WHEN_KEY = null;
    public void setParameters(Parameter... p0){}
    public void setUnits(SizeSelector.ByteUnits p0){}
    public void setValue(long p0){}
    public void setWhen(SizeSelector.SizeComparisons p0){}
    public void verifySettings(){}
    static public class ByteUnits extends EnumeratedAttribute
    {
        public ByteUnits(){}
        public String[] getValues(){ return null; }
    }
    static public class SizeComparisons extends Comparison
    {
        public SizeComparisons(){}
    }
}
