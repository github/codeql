// Generated automatically from freemarker.cache.TemplateLoader for testing purposes

package freemarker.cache;

import java.io.Reader;

public interface TemplateLoader
{
    Object findTemplateSource(String p0);
    Reader getReader(Object p0, String p1);
    long getLastModified(Object p0);
    void closeTemplateSource(Object p0);
}
