// Generated automatically from com.mitchellbosecke.pebble.template.EvaluationContextImpl for testing purposes

package com.mitchellbosecke.pebble.template;

import com.mitchellbosecke.pebble.cache.CacheKey;
import com.mitchellbosecke.pebble.cache.PebbleCache;
import com.mitchellbosecke.pebble.extension.ExtensionRegistry;
import com.mitchellbosecke.pebble.template.EvaluationContext;
import com.mitchellbosecke.pebble.template.EvaluationOptions;
import com.mitchellbosecke.pebble.template.Hierarchy;
import com.mitchellbosecke.pebble.template.PebbleTemplateImpl;
import com.mitchellbosecke.pebble.template.RenderedSizeContext;
import com.mitchellbosecke.pebble.template.ScopeChain;
import com.mitchellbosecke.pebble.utils.Callbacks;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.concurrent.ExecutorService;

public class EvaluationContextImpl implements EvaluationContext, RenderedSizeContext
{
    protected EvaluationContextImpl() {}
    public EvaluationContextImpl shallowCopyWithoutInheritanceChain(PebbleTemplateImpl p0){ return null; }
    public EvaluationContextImpl threadSafeCopy(PebbleTemplateImpl p0){ return null; }
    public EvaluationContextImpl(PebbleTemplateImpl p0, boolean p1, Locale p2, int p3, ExtensionRegistry p4, PebbleCache<CacheKey, Object> p5, ExecutorService p6, List<PebbleTemplateImpl> p7, Map<String, PebbleTemplateImpl> p8, ScopeChain p9, Hierarchy p10, EvaluationOptions p11){}
    public EvaluationOptions getEvaluationOptions(){ return null; }
    public ExecutorService getExecutorService(){ return null; }
    public ExtensionRegistry getExtensionRegistry(){ return null; }
    public Hierarchy getHierarchy(){ return null; }
    public List<PebbleTemplateImpl> getImportedTemplates(){ return null; }
    public Locale getLocale(){ return null; }
    public Object getVariable(String p0){ return null; }
    public PebbleCache<CacheKey, Object> getTagCache(){ return null; }
    public PebbleTemplateImpl getNamedImportedTemplate(String p0){ return null; }
    public ScopeChain getScopeChain(){ return null; }
    public boolean isStrictVariables(){ return false; }
    public int addAndGet(int p0){ return 0; }
    public int getMaxRenderedSize(){ return 0; }
    public void addNamedImportedTemplates(String p0, PebbleTemplateImpl p1){}
    public void scopedShallowWithoutInheritanceChain(PebbleTemplateImpl p0, Map<? extends Object, ? extends Object> p1, Callbacks.PebbleConsumer<EvaluationContextImpl> p2){}
}
