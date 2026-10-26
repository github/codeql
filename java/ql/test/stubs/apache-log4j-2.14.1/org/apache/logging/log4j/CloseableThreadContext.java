// Generated automatically from org.apache.logging.log4j.CloseableThreadContext for testing purposes

package org.apache.logging.log4j;

import java.util.List;
import java.util.Map;

public class CloseableThreadContext
{
    protected CloseableThreadContext() {}
    public static CloseableThreadContext.Instance push(String p0){ return null; }
    public static CloseableThreadContext.Instance push(String p0, Object... p1){ return null; }
    public static CloseableThreadContext.Instance pushAll(List<String> p0){ return null; }
    public static CloseableThreadContext.Instance put(String p0, String p1){ return null; }
    public static CloseableThreadContext.Instance putAll(Map<String, String> p0){ return null; }
    static public class Instance implements AutoCloseable
    {
        protected Instance() {}
        public CloseableThreadContext.Instance push(String p0){ return null; }
        public CloseableThreadContext.Instance push(String p0, Object[] p1){ return null; }
        public CloseableThreadContext.Instance pushAll(List<String> p0){ return null; }
        public CloseableThreadContext.Instance put(String p0, String p1){ return null; }
        public CloseableThreadContext.Instance putAll(Map<String, String> p0){ return null; }
        public void close(){}
    }
}
