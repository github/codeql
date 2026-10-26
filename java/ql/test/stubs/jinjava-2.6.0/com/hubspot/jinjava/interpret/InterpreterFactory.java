// Generated automatically from com.hubspot.jinjava.interpret.InterpreterFactory for testing purposes

package com.hubspot.jinjava.interpret;

import com.hubspot.jinjava.Jinjava;
import com.hubspot.jinjava.JinjavaConfig;
import com.hubspot.jinjava.interpret.Context;
import com.hubspot.jinjava.interpret.JinjavaInterpreter;

public interface InterpreterFactory
{
    JinjavaInterpreter newInstance(Jinjava p0, Context p1, JinjavaConfig p2);
    JinjavaInterpreter newInstance(JinjavaInterpreter p0);
}
