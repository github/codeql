// Generated automatically from com.hubspot.jinjava.interpret.CallStack for testing purposes

package com.hubspot.jinjava.interpret;

import com.hubspot.jinjava.interpret.TagCycleException;
import java.util.Optional;

public class CallStack
{
    protected CallStack() {}
    public CallStack(CallStack p0, Class<? extends TagCycleException> p1){}
    public Optional<String> peek(){ return null; }
    public Optional<String> pop(){ return null; }
    public boolean contains(String p0){ return false; }
    public boolean isEmpty(){ return false; }
    public int getTopLineNumber(){ return 0; }
    public int getTopStartPosition(){ return 0; }
    public void push(String p0, int p1, int p2){}
    public void pushWithMaxDepth(String p0, int p1, int p2, int p3){}
    public void pushWithoutCycleCheck(String p0, int p1, int p2){}
}
