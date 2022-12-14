// Generated automatically from com.hubspot.jinjava.lib.exptest.ExpTest for testing purposes

package com.hubspot.jinjava.lib.exptest;

import com.hubspot.jinjava.interpret.JinjavaInterpreter;
import com.hubspot.jinjava.lib.Importable;

public interface ExpTest extends Importable
{
    boolean evaluate(Object p0, JinjavaInterpreter p1, Object... p2);
    default boolean evaluateNegated(Object p0, JinjavaInterpreter p1, Object... p2){ return false; }
}
