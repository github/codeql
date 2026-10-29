// Generated automatically from org.thymeleaf.model.IAttribute for testing purposes

package org.thymeleaf.model;

import java.io.Writer;
import org.thymeleaf.engine.AttributeDefinition;
import org.thymeleaf.model.AttributeValueQuotes;

public interface IAttribute
{
    AttributeDefinition getAttributeDefinition();
    AttributeValueQuotes getValueQuotes();
    String getAttributeCompleteName();
    String getOperator();
    String getTemplateName();
    String getValue();
    boolean hasLocation();
    int getCol();
    int getLine();
    void write(Writer p0);
}
