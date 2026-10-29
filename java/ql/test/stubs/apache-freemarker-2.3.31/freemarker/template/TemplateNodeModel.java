// Generated automatically from freemarker.template.TemplateNodeModel for testing purposes

package freemarker.template;

import freemarker.template.TemplateModel;
import freemarker.template.TemplateSequenceModel;

public interface TemplateNodeModel extends TemplateModel
{
    String getNodeName();
    String getNodeNamespace();
    String getNodeType();
    TemplateNodeModel getParentNode();
    TemplateSequenceModel getChildNodes();
}
