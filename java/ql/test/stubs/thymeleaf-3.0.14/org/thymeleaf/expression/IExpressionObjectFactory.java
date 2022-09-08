// Generated automatically from org.thymeleaf.expression.IExpressionObjectFactory for testing purposes

package org.thymeleaf.expression;

import java.util.Set;
import org.thymeleaf.context.IExpressionContext;

public interface IExpressionObjectFactory
{
    Object buildObject(IExpressionContext p0, String p1);
    Set<String> getAllExpressionObjectNames();
    boolean isCacheable(String p0);
}
