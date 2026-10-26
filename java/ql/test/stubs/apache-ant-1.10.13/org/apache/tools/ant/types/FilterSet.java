// Generated automatically from org.apache.tools.ant.types.FilterSet for testing purposes

package org.apache.tools.ant.types;

import java.io.File;
import java.util.Hashtable;
import java.util.Vector;
import org.apache.tools.ant.types.DataType;
import org.apache.tools.ant.types.EnumeratedAttribute;
import org.apache.tools.ant.types.PropertySet;

public class FilterSet extends DataType implements Cloneable
{
    protected FilterSet getRef(){ return null; }
    protected FilterSet(FilterSet p0){}
    protected Vector<FilterSet.Filter> getFilters(){ return null; }
    public FilterSet(){}
    public FilterSet.FiltersFile createFiltersfile(){ return null; }
    public FilterSet.OnMissing getOnMissingFiltersFile(){ return null; }
    public Hashtable<String, String> getFilterHash(){ return null; }
    public Object clone(){ return null; }
    public String getBeginToken(){ return null; }
    public String getEndToken(){ return null; }
    public String replaceTokens(String p0){ return null; }
    public boolean hasFilters(){ return false; }
    public boolean isRecurse(){ return false; }
    public class FiltersFile
    {
        public FiltersFile(){}
        public void setFile(File p0){}
    }
    public static String DEFAULT_TOKEN_END = null;
    public static String DEFAULT_TOKEN_START = null;
    public void addConfiguredFilterSet(FilterSet p0){}
    public void addConfiguredPropertySet(PropertySet p0){}
    public void addFilter(FilterSet.Filter p0){}
    public void addFilter(String p0, String p1){}
    public void readFiltersFromFile(File p0){}
    public void setBeginToken(String p0){}
    public void setEndToken(String p0){}
    public void setFiltersfile(File p0){}
    public void setOnMissingFiltersFile(FilterSet.OnMissing p0){}
    public void setRecurse(boolean p0){}
    static public class Filter
    {
        public Filter(){}
        public Filter(String p0, String p1){}
        public String getToken(){ return null; }
        public String getValue(){ return null; }
        public void setToken(String p0){}
        public void setValue(String p0){}
    }
    static public class OnMissing extends EnumeratedAttribute
    {
        public OnMissing(){}
        public OnMissing(String p0){}
        public String[] getValues(){ return null; }
        public static FilterSet.OnMissing FAIL = null;
        public static FilterSet.OnMissing IGNORE = null;
        public static FilterSet.OnMissing WARN = null;
    }
}
