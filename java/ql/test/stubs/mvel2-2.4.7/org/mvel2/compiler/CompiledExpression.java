package org.mvel2.compiler;

import org.mvel2.integration.VariableResolverFactory;

public class CompiledExpression implements ExecutableStatement {
  public Object getDirectValue(Object staticContext, VariableResolverFactory factory) { return null; }
  public Object getValue(Object staticContext, VariableResolverFactory factory) { return null; }
  public Object getValue(Object ctx, Object elCtx, VariableResolverFactory factory) { return null; }
}