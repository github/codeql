package org.mvel2.compiler;

import java.io.Serializable;
import org.mvel2.integration.VariableResolverFactory;

public interface ExecutableStatement extends Accessor, Serializable {
  public Object getValue(Object staticContext, VariableResolverFactory factory);
}