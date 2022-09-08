// Generated automatically from com.hubspot.jinjava.lib.expression.ExpressionStrategy for testing purposes

package com.hubspot.jinjava.lib.expression;

import com.hubspot.jinjava.interpret.JinjavaInterpreter;
import com.hubspot.jinjava.tree.output.RenderedOutputNode;
import com.hubspot.jinjava.tree.parse.ExpressionToken;
import java.io.Serializable;

public interface ExpressionStrategy extends Serializable
{
    RenderedOutputNode interpretOutput(ExpressionToken p0, JinjavaInterpreter p1);
}
