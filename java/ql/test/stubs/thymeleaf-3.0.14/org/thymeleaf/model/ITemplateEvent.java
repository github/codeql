// Generated automatically from org.thymeleaf.model.ITemplateEvent for testing purposes

package org.thymeleaf.model;

import java.io.Writer;
import org.thymeleaf.model.IModelVisitor;

public interface ITemplateEvent
{
    String getTemplateName();
    boolean hasLocation();
    int getCol();
    int getLine();
    void accept(IModelVisitor p0);
    void write(Writer p0);
}
