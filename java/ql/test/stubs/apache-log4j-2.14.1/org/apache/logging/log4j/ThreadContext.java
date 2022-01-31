// Generated automatically from org.apache.logging.log4j.ThreadContext for testing purposes

package org.apache.logging.log4j;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import org.apache.logging.log4j.spi.ReadOnlyThreadContextMap;
import org.apache.logging.log4j.spi.ThreadContextStack;

public class ThreadContext
{
    protected ThreadContext() {}
    public static Map<String, String> EMPTY_MAP = null;
    public static Map<String, String> getContext(){ return null; }
    public static Map<String, String> getImmutableContext(){ return null; }
    public static ReadOnlyThreadContextMap getThreadContextMap(){ return null; }
    public static String get(String p0){ return null; }
    public static String peek(){ return null; }
    public static String pop(){ return null; }
    public static ThreadContext.ContextStack cloneStack(){ return null; }
    public static ThreadContext.ContextStack getImmutableStack(){ return null; }
    public static ThreadContextStack EMPTY_STACK = null;
    public static boolean containsKey(String p0){ return false; }
    public static boolean isEmpty(){ return false; }
    public static int getDepth(){ return 0; }
    public static void clearAll(){}
    public static void clearMap(){}
    public static void clearStack(){}
    public static void push(String p0){}
    public static void push(String p0, Object... p1){}
    public static void put(String p0, String p1){}
    public static void putAll(Map<String, String> p0){}
    public static void putIfNull(String p0, String p1){}
    public static void remove(String p0){}
    public static void removeAll(Iterable<String> p0){}
    public static void removeStack(){}
    public static void setStack(Collection<String> p0){}
    public static void trim(int p0){}
    static public interface ContextStack extends Collection<String>, Serializable
    {
        List<String> asList();
        String peek();
        String pop();
        ThreadContext.ContextStack copy();
        ThreadContext.ContextStack getImmutableStackOrNull();
        int getDepth();
        void push(String p0);
        void trim(int p0);
    }
}
