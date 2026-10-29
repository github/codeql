// Generated automatically from org.apache.tools.ant.types.selectors.DateSelector for testing purposes

package org.apache.tools.ant.types.selectors;

import java.io.File;
import org.apache.tools.ant.types.Parameter;
import org.apache.tools.ant.types.TimeComparison;
import org.apache.tools.ant.types.selectors.BaseExtendSelector;

public class DateSelector extends BaseExtendSelector
{
    public DateSelector(){}
    public String toString(){ return null; }
    public boolean isSelected(File p0, String p1, File p2){ return false; }
    public long getMillis(){ return 0; }
    public static String CHECKDIRS_KEY = null;
    public static String DATETIME_KEY = null;
    public static String GRANULARITY_KEY = null;
    public static String MILLIS_KEY = null;
    public static String PATTERN_KEY = null;
    public static String WHEN_KEY = null;
    public void setCheckdirs(boolean p0){}
    public void setDatetime(String p0){}
    public void setGranularity(int p0){}
    public void setMillis(long p0){}
    public void setParameters(Parameter... p0){}
    public void setPattern(String p0){}
    public void setWhen(DateSelector.TimeComparisons p0){}
    public void setWhen(TimeComparison p0){}
    public void verifySettings(){}
    static public class TimeComparisons extends TimeComparison
    {
        public TimeComparisons(){}
    }
}
