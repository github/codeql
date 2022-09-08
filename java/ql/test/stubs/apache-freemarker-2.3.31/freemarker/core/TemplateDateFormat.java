// Generated automatically from freemarker.core.TemplateDateFormat for testing purposes

package freemarker.core;

import freemarker.core.TemplateValueFormat;
import freemarker.template.TemplateDateModel;

abstract public class TemplateDateFormat extends TemplateValueFormat
{
    public Object format(TemplateDateModel p0){ return null; }
    public TemplateDateFormat(){}
    public abstract Object parse(String p0, int p1);
    public abstract String formatToPlainText(TemplateDateModel p0);
    public abstract boolean isLocaleBound();
    public abstract boolean isTimeZoneBound();
}
