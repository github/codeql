// Generated automatically from freemarker.template.TemplateHashModelEx2 for testing purposes

package freemarker.template;

import freemarker.template.TemplateHashModelEx;
import freemarker.template.TemplateModel;

public interface TemplateHashModelEx2 extends TemplateHashModelEx
{
    TemplateHashModelEx2.KeyValuePairIterator keyValuePairIterator();
    static public interface KeyValuePair
    {
        TemplateModel getKey();
        TemplateModel getValue();
    }
    static public interface KeyValuePairIterator
    {
        TemplateHashModelEx2.KeyValuePair next();
        boolean hasNext();
    }
}
