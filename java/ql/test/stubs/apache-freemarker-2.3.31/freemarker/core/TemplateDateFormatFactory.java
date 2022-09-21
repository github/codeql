// Generated automatically from freemarker.core.TemplateDateFormatFactory for testing purposes

package freemarker.core;

import freemarker.core.Environment;
import freemarker.core.TemplateDateFormat;
import freemarker.core.TemplateValueFormatFactory;
import java.util.Locale;
import java.util.TimeZone;

abstract public class TemplateDateFormatFactory extends TemplateValueFormatFactory
{
    public TemplateDateFormatFactory(){}
    public abstract TemplateDateFormat get(String p0, int p1, Locale p2, TimeZone p3, boolean p4, Environment p5);
}
