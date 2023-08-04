// Generated automatically from net.sf.json.JsonConfig for testing purposes

package net.sf.json;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import net.sf.json.processors.DefaultValueProcessor;
import net.sf.json.processors.DefaultValueProcessorMatcher;
import net.sf.json.processors.JsonBeanProcessor;
import net.sf.json.processors.JsonBeanProcessorMatcher;
import net.sf.json.processors.JsonValueProcessor;
import net.sf.json.processors.JsonValueProcessorMatcher;
import net.sf.json.processors.PropertyNameProcessor;
import net.sf.json.processors.PropertyNameProcessorMatcher;
import net.sf.json.util.CycleDetectionStrategy;
import net.sf.json.util.JavaIdentifierTransformer;
import net.sf.json.util.JsonEventListener;
import net.sf.json.util.NewBeanInstanceStrategy;
import net.sf.json.util.PropertyExclusionClassMatcher;
import net.sf.json.util.PropertyFilter;
import net.sf.json.util.PropertySetStrategy;

public class JsonConfig
{
    public Class getCollectionType(){ return null; }
    public Class getEnclosedType(){ return null; }
    public Class getRootClass(){ return null; }
    public Collection getMergedExcludes(){ return null; }
    public Collection getMergedExcludes(Class p0){ return null; }
    public CycleDetectionStrategy getCycleDetectionStrategy(){ return null; }
    public DefaultValueProcessor findDefaultValueProcessor(Class p0){ return null; }
    public DefaultValueProcessorMatcher getDefaultValueProcessorMatcher(){ return null; }
    public JavaIdentifierTransformer getJavaIdentifierTransformer(){ return null; }
    public JsonBeanProcessor findJsonBeanProcessor(Class p0){ return null; }
    public JsonBeanProcessorMatcher getJsonBeanProcessorMatcher(){ return null; }
    public JsonConfig copy(){ return null; }
    public JsonConfig(){}
    public JsonValueProcessor findJsonValueProcessor(Class p0){ return null; }
    public JsonValueProcessor findJsonValueProcessor(Class p0, Class p1, String p2){ return null; }
    public JsonValueProcessor findJsonValueProcessor(Class p0, String p1){ return null; }
    public JsonValueProcessorMatcher getJsonValueProcessorMatcher(){ return null; }
    public List getIgnoreFieldAnnotations(){ return null; }
    public List getJsonEventListeners(){ return null; }
    public Map getClassMap(){ return null; }
    public NewBeanInstanceStrategy getNewBeanInstanceStrategy(){ return null; }
    public PropertyExclusionClassMatcher getPropertyExclusionClassMatcher(){ return null; }
    public PropertyFilter getJavaPropertyFilter(){ return null; }
    public PropertyFilter getJsonPropertyFilter(){ return null; }
    public PropertyNameProcessor findJavaPropertyNameProcessor(Class p0){ return null; }
    public PropertyNameProcessor findJsonPropertyNameProcessor(Class p0){ return null; }
    public PropertyNameProcessor findPropertyNameProcessor(Class p0){ return null; }
    public PropertyNameProcessorMatcher getJavaPropertyNameProcessorMatcher(){ return null; }
    public PropertyNameProcessorMatcher getJsonPropertyNameProcessorMatcher(){ return null; }
    public PropertyNameProcessorMatcher getPropertyNameProcessorMatcher(){ return null; }
    public PropertySetStrategy getPropertySetStrategy(){ return null; }
    public String[] getExcludes(){ return null; }
    public boolean isAllowNonStringKeys(){ return false; }
    public boolean isEventTriggeringEnabled(){ return false; }
    public boolean isHandleJettisonEmptyElement(){ return false; }
    public boolean isHandleJettisonSingleElementArray(){ return false; }
    public boolean isIgnoreDefaultExcludes(){ return false; }
    public boolean isIgnoreJPATransient(){ return false; }
    public boolean isIgnorePublicFields(){ return false; }
    public boolean isIgnoreTransientFields(){ return false; }
    public boolean isIgnoreUnreadableProperty(){ return false; }
    public boolean isJavascriptCompliant(){ return false; }
    public boolean isSkipJavaIdentifierTransformationInMapKeys(){ return false; }
    public int getArrayMode(){ return 0; }
    public static DefaultValueProcessorMatcher DEFAULT_DEFAULT_VALUE_PROCESSOR_MATCHER = null;
    public static JsonBeanProcessorMatcher DEFAULT_JSON_BEAN_PROCESSOR_MATCHER = null;
    public static JsonValueProcessorMatcher DEFAULT_JSON_VALUE_PROCESSOR_MATCHER = null;
    public static NewBeanInstanceStrategy DEFAULT_NEW_BEAN_INSTANCE_STRATEGY = null;
    public static PropertyExclusionClassMatcher DEFAULT_PROPERTY_EXCLUSION_CLASS_MATCHER = null;
    public static PropertyNameProcessorMatcher DEFAULT_PROPERTY_NAME_PROCESSOR_MATCHER = null;
    public static int MODE_LIST = 0;
    public static int MODE_OBJECT_ARRAY = 0;
    public static int MODE_SET = 0;
    public void addIgnoreFieldAnnotation(Class p0){}
    public void addIgnoreFieldAnnotation(String p0){}
    public void addJsonEventListener(JsonEventListener p0){}
    public void clearJavaPropertyNameProcessors(){}
    public void clearJsonBeanProcessors(){}
    public void clearJsonEventListeners(){}
    public void clearJsonPropertyNameProcessors(){}
    public void clearJsonValueProcessors(){}
    public void clearPropertyExclusions(){}
    public void clearPropertyNameProcessors(){}
    public void disableEventTriggering(){}
    public void enableEventTriggering(){}
    public void registerDefaultValueProcessor(Class p0, DefaultValueProcessor p1){}
    public void registerJavaPropertyNameProcessor(Class p0, PropertyNameProcessor p1){}
    public void registerJsonBeanProcessor(Class p0, JsonBeanProcessor p1){}
    public void registerJsonPropertyNameProcessor(Class p0, PropertyNameProcessor p1){}
    public void registerJsonValueProcessor(Class p0, Class p1, JsonValueProcessor p2){}
    public void registerJsonValueProcessor(Class p0, JsonValueProcessor p1){}
    public void registerJsonValueProcessor(Class p0, String p1, JsonValueProcessor p2){}
    public void registerJsonValueProcessor(String p0, JsonValueProcessor p1){}
    public void registerPropertyExclusion(Class p0, String p1){}
    public void registerPropertyExclusions(Class p0, String[] p1){}
    public void registerPropertyNameProcessor(Class p0, PropertyNameProcessor p1){}
    public void removeIgnoreFieldAnnotation(Class p0){}
    public void removeIgnoreFieldAnnotation(String p0){}
    public void removeJsonEventListener(JsonEventListener p0){}
    public void reset(){}
    public void setAllowNonStringKeys(boolean p0){}
    public void setArrayMode(int p0){}
    public void setClassMap(Map p0){}
    public void setCollectionType(Class p0){}
    public void setCycleDetectionStrategy(CycleDetectionStrategy p0){}
    public void setDefaultValueProcessorMatcher(DefaultValueProcessorMatcher p0){}
    public void setEnclosedType(Class p0){}
    public void setExcludes(String[] p0){}
    public void setHandleJettisonEmptyElement(boolean p0){}
    public void setHandleJettisonSingleElementArray(boolean p0){}
    public void setIgnoreDefaultExcludes(boolean p0){}
    public void setIgnoreJPATransient(boolean p0){}
    public void setIgnorePublicFields(boolean p0){}
    public void setIgnoreTransientFields(boolean p0){}
    public void setIgnoreUnreadableProperty(boolean p0){}
    public void setJavaIdentifierTransformer(JavaIdentifierTransformer p0){}
    public void setJavaPropertyFilter(PropertyFilter p0){}
    public void setJavaPropertyNameProcessorMatcher(PropertyNameProcessorMatcher p0){}
    public void setJavascriptCompliant(boolean p0){}
    public void setJsonBeanProcessorMatcher(JsonBeanProcessorMatcher p0){}
    public void setJsonPropertyFilter(PropertyFilter p0){}
    public void setJsonPropertyNameProcessorMatcher(PropertyNameProcessorMatcher p0){}
    public void setJsonValueProcessorMatcher(JsonValueProcessorMatcher p0){}
    public void setNewBeanInstanceStrategy(NewBeanInstanceStrategy p0){}
    public void setPropertyExclusionClassMatcher(PropertyExclusionClassMatcher p0){}
    public void setPropertyNameProcessorMatcher(PropertyNameProcessorMatcher p0){}
    public void setPropertySetStrategy(PropertySetStrategy p0){}
    public void setRootClass(Class p0){}
    public void setSkipJavaIdentifierTransformationInMapKeys(boolean p0){}
    public void unregisterDefaultValueProcessor(Class p0){}
    public void unregisterJavaPropertyNameProcessor(Class p0){}
    public void unregisterJsonBeanProcessor(Class p0){}
    public void unregisterJsonPropertyNameProcessor(Class p0){}
    public void unregisterJsonValueProcessor(Class p0){}
    public void unregisterJsonValueProcessor(Class p0, Class p1){}
    public void unregisterJsonValueProcessor(Class p0, String p1){}
    public void unregisterJsonValueProcessor(String p0){}
    public void unregisterPropertyExclusion(Class p0, String p1){}
    public void unregisterPropertyExclusions(Class p0){}
    public void unregisterPropertyNameProcessor(Class p0){}
}
