// Generated automatically from org.thymeleaf.messageresolver.IMessageResolver for testing purposes

package org.thymeleaf.messageresolver;

import org.thymeleaf.context.ITemplateContext;

public interface IMessageResolver
{
    Integer getOrder();
    String createAbsentMessageRepresentation(ITemplateContext p0, Class<? extends Object> p1, String p2, Object[] p3);
    String getName();
    String resolveMessage(ITemplateContext p0, Class<? extends Object> p1, String p2, Object[] p3);
}
