// Generated automatically from com.hubspot.jinjava.interpret.JinjavaInterpreter for testing purposes

package com.hubspot.jinjava.interpret;

import com.hubspot.jinjava.Jinjava;
import com.hubspot.jinjava.JinjavaConfig;
import com.hubspot.jinjava.interpret.Context;
import com.hubspot.jinjava.interpret.TemplateError;
import com.hubspot.jinjava.objects.serialization.PyishSerializable;
import com.hubspot.jinjava.tree.Node;
import com.hubspot.jinjava.tree.output.BlockInfo;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Random;
import java.util.Set;

public class JinjavaInterpreter implements PyishSerializable
{
    protected JinjavaInterpreter() {}
    public Context getContext(){ return null; }
    public JinjavaConfig getConfig(){ return null; }
    public JinjavaConfig getConfiguration(){ return null; }
    public JinjavaInterpreter(Jinjava p0, Context p1, JinjavaConfig p2){}
    public JinjavaInterpreter(JinjavaInterpreter p0){}
    public JinjavaInterpreter.InterpreterScopeClosable enterNonStackingScope(){ return null; }
    public JinjavaInterpreter.InterpreterScopeClosable enterScope(){ return null; }
    public JinjavaInterpreter.InterpreterScopeClosable enterScope(Map<Context.Library, Set<String>> p0){ return null; }
    public List<TemplateError> getErrors(){ return null; }
    public List<TemplateError> getErrorsCopy(){ return null; }
    public Node parse(String p0){ return null; }
    public Object resolveELExpression(String p0, int p1){ return null; }
    public Object resolveELExpression(String p0, int p1, int p2){ return null; }
    public Object resolveObject(String p0, int p1){ return null; }
    public Object resolveObject(String p0, int p1, int p2){ return null; }
    public Object resolveProperty(Object p0, List<String> p1){ return null; }
    public Object resolveProperty(Object p0, String p1){ return null; }
    public Object retraceVariable(String p0, int p1){ return null; }
    public Object retraceVariable(String p0, int p1, int p2){ return null; }
    public Object wrap(Object p0){ return null; }
    public Optional<TemplateError> getLastError(){ return null; }
    public Random getRandom(){ return null; }
    public String getAsString(Object p0){ return null; }
    public String getResource(String p0){ return null; }
    public String render(Node p0){ return null; }
    public String render(Node p0, boolean p1){ return null; }
    public String render(String p0){ return null; }
    public String renderFlat(String p0){ return null; }
    public String resolveResourceLocation(String p0){ return null; }
    public String resolveString(String p0, int p1){ return null; }
    public String resolveString(String p0, int p1, int p2){ return null; }
    public String toPyishString(){ return null; }
    public boolean isValidationMode(){ return false; }
    public class InterpreterScopeClosable implements AutoCloseable
    {
        public InterpreterScopeClosable(){}
        public void close(){}
    }
    public int getLineNumber(){ return 0; }
    public int getPosition(){ return 0; }
    public int getScopeDepth(){ return 0; }
    public static JinjavaInterpreter getCurrent(){ return null; }
    public static Optional<JinjavaInterpreter> getCurrentMaybe(){ return null; }
    public static void popCurrent(){}
    public static void pushCurrent(JinjavaInterpreter p0){}
    public void addAllChildErrors(String p0, Collection<TemplateError> p1){}
    public void addAllErrors(Collection<TemplateError> p0){}
    public void addBlock(String p0, BlockInfo p1){}
    public void addError(TemplateError p0){}
    public void addExtendParentRoot(Node p0){}
    public void endRender(String p0){}
    public void endRender(String p0, Map<String, Object> p1){}
    public void leaveScope(){}
    public void removeLastError(){}
    public void setLineNumber(int p0){}
    public void setPosition(int p0){}
    public void startRender(String p0){}
}
