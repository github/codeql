// Generated automatically from org.thymeleaf.processor.templateboundaries.ITemplateBoundariesStructureHandler for testing purposes

package org.thymeleaf.processor.templateboundaries;

import org.thymeleaf.inline.IInliner;
import org.thymeleaf.model.IModel;

public interface ITemplateBoundariesStructureHandler
{
    void insert(IModel p0, boolean p1);
    void insert(String p0, boolean p1);
    void removeLocalVariable(String p0);
    void reset();
    void setInliner(IInliner p0);
    void setLocalVariable(String p0, Object p1);
    void setSelectionTarget(Object p0);
}
