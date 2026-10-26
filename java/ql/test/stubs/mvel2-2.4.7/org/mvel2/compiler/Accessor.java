package org.mvel2.compiler;

import org.mvel2.integration.VariableResolverFactory;

public interface Accessor {
  public Object getValue(Object ctx, Object elCtx, VariableResolverFactory factory);
}