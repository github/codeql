// Generated automatically from org.springframework.web.bind.WebDataBinder for testing purposes

package org.springframework.web.bind;

import java.util.List;
import java.util.Map;
import org.springframework.beans.MutablePropertyValues;
import org.springframework.validation.DataBinder;
import org.springframework.web.multipart.MultipartFile;

public class WebDataBinder extends DataBinder
{
    protected WebDataBinder() {}
    protected Object getEmptyValue(String p0, Class<? extends Object> p1){ return null; }
    protected void adaptEmptyArrayIndices(MutablePropertyValues p0){}
    protected void bindMultipart(Map<String, List<MultipartFile>> p0, MutablePropertyValues p1){}
    protected void checkFieldDefaults(MutablePropertyValues p0){}
    protected void checkFieldMarkers(MutablePropertyValues p0){}
    protected void doBind(MutablePropertyValues p0){}
    public Object getEmptyValue(Class<? extends Object> p0){ return null; }
    public String getFieldDefaultPrefix(){ return null; }
    public String getFieldMarkerPrefix(){ return null; }
    public WebDataBinder(Object p0){}
    public WebDataBinder(Object p0, String p1){}
    public boolean isBindEmptyMultipartFiles(){ return false; }
    public static String DEFAULT_FIELD_DEFAULT_PREFIX = null;
    public static String DEFAULT_FIELD_MARKER_PREFIX = null;
    public void setBindEmptyMultipartFiles(boolean p0){}
    public void setFieldDefaultPrefix(String p0){}
    public void setFieldMarkerPrefix(String p0){}
}
