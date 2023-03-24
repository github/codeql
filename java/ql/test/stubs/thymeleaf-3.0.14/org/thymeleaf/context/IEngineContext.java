// Generated automatically from org.thymeleaf.context.IEngineContext for testing purposes

package org.thymeleaf.context;

import java.util.List;
import java.util.Map;
import org.thymeleaf.context.ITemplateContext;
import org.thymeleaf.engine.TemplateData;
import org.thymeleaf.inline.IInliner;
import org.thymeleaf.model.IProcessableElementTag;

public interface IEngineContext extends ITemplateContext
{
    List<IProcessableElementTag> getElementStackAbove(int p0);
    boolean isVariableLocal(String p0);
    int level();
    void decreaseLevel();
    void increaseLevel();
    void removeVariable(String p0);
    void setElementTag(IProcessableElementTag p0);
    void setInliner(IInliner p0);
    void setSelectionTarget(Object p0);
    void setTemplateData(TemplateData p0);
    void setVariable(String p0, Object p1);
    void setVariables(Map<String, Object> p0);
}
