// Generated automatically from org.springframework.validation.AbstractPropertyBindingResult for testing purposes

package org.springframework.validation;

import java.beans.PropertyEditor;
import org.springframework.beans.ConfigurablePropertyAccessor;
import org.springframework.beans.PropertyEditorRegistry;
import org.springframework.core.convert.ConversionService;
import org.springframework.validation.AbstractBindingResult;

abstract public class AbstractPropertyBindingResult extends AbstractBindingResult
{
    protected AbstractPropertyBindingResult() {}
    protected AbstractPropertyBindingResult(String p0){}
    protected Object formatFieldValue(String p0, Object p1){ return null; }
    protected Object getActualFieldValue(String p0){ return null; }
    protected PropertyEditor getCustomEditor(String p0){ return null; }
    protected String canonicalFieldName(String p0){ return null; }
    public Class<? extends Object> getFieldType(String p0){ return null; }
    public PropertyEditor findEditor(String p0, Class<? extends Object> p1){ return null; }
    public PropertyEditorRegistry getPropertyEditorRegistry(){ return null; }
    public abstract ConfigurablePropertyAccessor getPropertyAccessor();
    public void initConversion(ConversionService p0){}
}
