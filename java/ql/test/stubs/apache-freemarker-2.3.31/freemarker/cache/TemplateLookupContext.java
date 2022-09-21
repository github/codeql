// Generated automatically from freemarker.cache.TemplateLookupContext for testing purposes

package freemarker.cache;

import freemarker.cache.TemplateLookupResult;
import java.util.Locale;

abstract public class TemplateLookupContext
{
    protected TemplateLookupContext() {}
    public Locale getTemplateLocale(){ return null; }
    public Object getCustomLookupCondition(){ return null; }
    public String getTemplateName(){ return null; }
    public TemplateLookupResult createNegativeLookupResult(){ return null; }
    public abstract TemplateLookupResult lookupWithAcquisitionStrategy(String p0);
    public abstract TemplateLookupResult lookupWithLocalizedThenAcquisitionStrategy(String p0, Locale p1);
}
