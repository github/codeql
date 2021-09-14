// Generated automatically from org.springframework.validation.DataBinder for testing purposes

package org.springframework.validation;

import java.beans.PropertyEditor;
import java.lang.reflect.Field;
import java.util.List;
import java.util.Map;
import org.apache.commons.logging.Log;
import org.springframework.beans.ConfigurablePropertyAccessor;
import org.springframework.beans.MutablePropertyValues;
import org.springframework.beans.PropertyEditorRegistry;
import org.springframework.beans.PropertyValues;
import org.springframework.beans.SimpleTypeConverter;
import org.springframework.beans.TypeConverter;
import org.springframework.core.MethodParameter;
import org.springframework.core.convert.ConversionService;
import org.springframework.core.convert.TypeDescriptor;
import org.springframework.format.Formatter;
import org.springframework.validation.AbstractPropertyBindingResult;
import org.springframework.validation.BindingErrorProcessor;
import org.springframework.validation.BindingResult;
import org.springframework.validation.MessageCodesResolver;
import org.springframework.validation.Validator;

public class DataBinder implements PropertyEditorRegistry, TypeConverter
{
    protected DataBinder() {}
    protected AbstractPropertyBindingResult createBeanPropertyBindingResult(){ return null; }
    protected AbstractPropertyBindingResult createDirectFieldBindingResult(){ return null; }
    protected AbstractPropertyBindingResult getInternalBindingResult(){ return null; }
    protected ConfigurablePropertyAccessor getPropertyAccessor(){ return null; }
    protected PropertyEditorRegistry getPropertyEditorRegistry(){ return null; }
    protected SimpleTypeConverter getSimpleTypeConverter(){ return null; }
    protected TypeConverter getTypeConverter(){ return null; }
    protected boolean isAllowed(String p0){ return false; }
    protected static Log logger = null;
    protected void applyPropertyValues(MutablePropertyValues p0){}
    protected void checkAllowedFields(MutablePropertyValues p0){}
    protected void checkRequiredFields(MutablePropertyValues p0){}
    protected void doBind(MutablePropertyValues p0){}
    public <T> T convertIfNecessary(Object p0, Class<T> p1){ return null; }
    public <T> T convertIfNecessary(Object p0, Class<T> p1, Field p2){ return null; }
    public <T> T convertIfNecessary(Object p0, Class<T> p1, MethodParameter p2){ return null; }
    public <T> T convertIfNecessary(Object p0, Class<T> p1, TypeDescriptor p2){ return null; }
    public BindingErrorProcessor getBindingErrorProcessor(){ return null; }
    public BindingResult getBindingResult(){ return null; }
    public ConversionService getConversionService(){ return null; }
    public DataBinder(Object p0){}
    public DataBinder(Object p0, String p1){}
    public List<Validator> getValidators(){ return null; }
    public Map<? extends Object, ? extends Object> close(){ return null; }
    public Object getTarget(){ return null; }
    public PropertyEditor findCustomEditor(Class<? extends Object> p0, String p1){ return null; }
    public String getObjectName(){ return null; }
    public String[] getAllowedFields(){ return null; }
    public String[] getDisallowedFields(){ return null; }
    public String[] getRequiredFields(){ return null; }
    public Validator getValidator(){ return null; }
    public boolean isAutoGrowNestedPaths(){ return false; }
    public boolean isIgnoreInvalidFields(){ return false; }
    public boolean isIgnoreUnknownFields(){ return false; }
    public int getAutoGrowCollectionLimit(){ return 0; }
    public static String DEFAULT_OBJECT_NAME = null;
    public static int DEFAULT_AUTO_GROW_COLLECTION_LIMIT = 0;
    public void addCustomFormatter(Formatter<? extends Object> p0){}
    public void addCustomFormatter(Formatter<? extends Object> p0, Class<? extends Object>... p1){}
    public void addCustomFormatter(Formatter<? extends Object> p0, String... p1){}
    public void addValidators(Validator... p0){}
    public void bind(PropertyValues p0){}
    public void initBeanPropertyAccess(){}
    public void initDirectFieldAccess(){}
    public void registerCustomEditor(Class<? extends Object> p0, PropertyEditor p1){}
    public void registerCustomEditor(Class<? extends Object> p0, String p1, PropertyEditor p2){}
    public void replaceValidators(Validator... p0){}
    public void setAllowedFields(String... p0){}
    public void setAutoGrowCollectionLimit(int p0){}
    public void setAutoGrowNestedPaths(boolean p0){}
    public void setBindingErrorProcessor(BindingErrorProcessor p0){}
    public void setConversionService(ConversionService p0){}
    public void setDisallowedFields(String... p0){}
    public void setIgnoreInvalidFields(boolean p0){}
    public void setIgnoreUnknownFields(boolean p0){}
    public void setMessageCodesResolver(MessageCodesResolver p0){}
    public void setRequiredFields(String... p0){}
    public void setValidator(Validator p0){}
    public void validate(){}
    public void validate(Object... p0){}
}
