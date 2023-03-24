// Generated automatically from freemarker.template.TemplateDateModel for testing purposes

package freemarker.template;

import freemarker.template.TemplateModel;
import java.util.Date;
import java.util.List;

public interface TemplateDateModel extends TemplateModel
{
    Date getAsDate();
    int getDateType();
    static List TYPE_NAMES = null;
    static int DATE = 0;
    static int DATETIME = 0;
    static int TIME = 0;
    static int UNKNOWN = 0;
}
