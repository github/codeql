// Generated automatically from org.thymeleaf.model.IProcessableElementTag for testing purposes

package org.thymeleaf.model;

import java.util.Map;
import org.thymeleaf.engine.AttributeName;
import org.thymeleaf.model.IAttribute;
import org.thymeleaf.model.IElementTag;

public interface IProcessableElementTag extends IElementTag
{
    IAttribute getAttribute(AttributeName p0);
    IAttribute getAttribute(String p0);
    IAttribute getAttribute(String p0, String p1);
    IAttribute[] getAllAttributes();
    Map<String, String> getAttributeMap();
    String getAttributeValue(AttributeName p0);
    String getAttributeValue(String p0);
    String getAttributeValue(String p0, String p1);
    boolean hasAttribute(AttributeName p0);
    boolean hasAttribute(String p0);
    boolean hasAttribute(String p0, String p1);
}
