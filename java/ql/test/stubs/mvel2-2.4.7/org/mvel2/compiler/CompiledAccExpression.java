package org.mvel2.compiler;

import org.mvel2.ParserContext;
import org.mvel2.integration.VariableResolverFactory;

public class CompiledAccExpression implements ExecutableStatement {
  public CompiledAccExpression(char[] expression, Class ingressType, ParserContext context) {}
  public Object getValue(Object staticContext, VariableResolverFactory factory) { return null; }
  public Object getValue(Object ctx, Object elCtx, VariableResolverFactory variableFactory) { return null; }
}
