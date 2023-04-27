// Generated automatically from org.kohsuke.stapler.WebApp for testing purposes

package org.kohsuke.stapler;

import java.util.List;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArrayList;
import javax.servlet.ServletContext;
import org.kohsuke.stapler.AbstractTearOff;
import org.kohsuke.stapler.BindInterceptor;
import org.kohsuke.stapler.CrumbIssuer;
import org.kohsuke.stapler.DispatchValidator;
import org.kohsuke.stapler.DispatchersFilter;
import org.kohsuke.stapler.Facet;
import org.kohsuke.stapler.FunctionList;
import org.kohsuke.stapler.HttpResponseRenderer;
import org.kohsuke.stapler.JsonInErrorMessageSanitizer;
import org.kohsuke.stapler.MetaClass;
import org.kohsuke.stapler.Stapler;
import org.kohsuke.stapler.bind.BoundObjectTable;
import org.kohsuke.stapler.event.FilteredDispatchTriggerListener;
import org.kohsuke.stapler.event.FilteredDoActionTriggerListener;
import org.kohsuke.stapler.event.FilteredFieldTriggerListener;
import org.kohsuke.stapler.event.FilteredGetterTriggerListener;
import org.kohsuke.stapler.lang.FieldRef;
import org.kohsuke.stapler.lang.Klass;

public class WebApp
{
    protected WebApp() {}
    public <T extends Facet> T getFacet(java.lang.Class<T> p0){ return null; }
    public ClassLoader getClassLoader(){ return null; }
    public CopyOnWriteArrayList<HttpResponseRenderer> getResponseRenderers(){ return null; }
    public CrumbIssuer getCrumbIssuer(){ return null; }
    public DispatchValidator getDispatchValidator(){ return null; }
    public DispatchersFilter getDispatchersFilter(){ return null; }
    public FieldRef.Filter getFilterForFields(){ return null; }
    public FilteredDispatchTriggerListener getFilteredDispatchTriggerListener(){ return null; }
    public FilteredDoActionTriggerListener getFilteredDoActionTriggerListener(){ return null; }
    public FilteredFieldTriggerListener getFilteredFieldTriggerListener(){ return null; }
    public FilteredGetterTriggerListener getFilteredGetterTriggerListener(){ return null; }
    public FunctionList.Filter getFilterForDoActions(){ return null; }
    public FunctionList.Filter getFilterForGetMethods(){ return null; }
    public JsonInErrorMessageSanitizer getJsonInErrorMessageSanitizer(){ return null; }
    public Klass<? extends Object> getKlass(Object p0){ return null; }
    public MetaClass getMetaClass(Class p0){ return null; }
    public MetaClass getMetaClass(Klass<? extends Object> p0){ return null; }
    public MetaClass getMetaClass(Object p0){ return null; }
    public Object getApp(){ return null; }
    public Stapler getSomeStapler(){ return null; }
    public WebApp(ServletContext p0){}
    public final BoundObjectTable boundObjectTable = null;
    public final List<BindInterceptor> bindInterceptors = null;
    public final List<Facet> facets = null;
    public final Map<Class, Class[]> wrappers = null;
    public final Map<String, String> defaultEncodingForStaticResources = null;
    public final Map<String, String> mimeTypes = null;
    public final ServletContext context = null;
    public static WebApp get(ServletContext p0){ return null; }
    public static WebApp getCurrent(){ return null; }
    public void clearMetaClassCache(){}
    public void clearScripts(Class<? extends AbstractTearOff> p0){}
    public void setApp(Object p0){}
    public void setClassLoader(ClassLoader p0){}
    public void setCrumbIssuer(CrumbIssuer p0){}
    public void setDispatchValidator(DispatchValidator p0){}
    public void setDispatchersFilter(DispatchersFilter p0){}
    public void setFilterForDoActions(FunctionList.Filter p0){}
    public void setFilterForFields(FieldRef.Filter p0){}
    public void setFilterForGetMethods(FunctionList.Filter p0){}
    public void setFilteredDispatchTriggerListener(FilteredDispatchTriggerListener p0){}
    public void setFilteredDoActionTriggerListener(FilteredDoActionTriggerListener p0){}
    public void setFilteredFieldTriggerListener(FilteredFieldTriggerListener p0){}
    public void setFilteredGetterTriggerListener(FilteredGetterTriggerListener p0){}
    public void setJsonInErrorMessageSanitizer(JsonInErrorMessageSanitizer p0){}
}
