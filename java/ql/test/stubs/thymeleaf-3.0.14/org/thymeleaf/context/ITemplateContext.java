// Generated automatically from org.thymeleaf.context.ITemplateContext for testing purposes

package org.thymeleaf.context;

import java.util.List;
import java.util.Map;
import org.thymeleaf.context.IExpressionContext;
import org.thymeleaf.context.IdentifierSequences;
import org.thymeleaf.engine.TemplateData;
import org.thymeleaf.inline.IInliner;
import org.thymeleaf.model.IModelFactory;
import org.thymeleaf.model.IProcessableElementTag;
import org.thymeleaf.templatemode.TemplateMode;

public interface ITemplateContext extends IExpressionContext
{
    IInliner getInliner();
    IModelFactory getModelFactory();
    IdentifierSequences getIdentifierSequences();
    List<IProcessableElementTag> getElementStack();
    List<TemplateData> getTemplateStack();
    Map<String, Object> getTemplateResolutionAttributes();
    Object getSelectionTarget();
    String buildLink(String p0, Map<String, Object> p1);
    String getMessage(Class<? extends Object> p0, String p1, Object[] p2, boolean p3);
    TemplateData getTemplateData();
    TemplateMode getTemplateMode();
    boolean hasSelectionTarget();
}
