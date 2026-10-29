// Generated automatically from org.thymeleaf.linkbuilder.ILinkBuilder for testing purposes

package org.thymeleaf.linkbuilder;

import java.util.Map;
import org.thymeleaf.context.IExpressionContext;

public interface ILinkBuilder
{
    Integer getOrder();
    String buildLink(IExpressionContext p0, String p1, Map<String, Object> p2);
    String getName();
}
