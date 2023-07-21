// Generated automatically from org.kohsuke.stapler.Dispatcher for testing purposes

package org.kohsuke.stapler;

import org.kohsuke.stapler.RequestImpl;
import org.kohsuke.stapler.ResponseImpl;
import org.kohsuke.stapler.StaplerRequest;
import org.kohsuke.stapler.StaplerResponse;

abstract public class Dispatcher
{
    public Dispatcher(){}
    public abstract String toString();
    public abstract boolean dispatch(RequestImpl p0, ResponseImpl p1, Object p2);
    public static boolean TRACE = false;
    public static boolean TRACE_PER_REQUEST = false;
    public static boolean isTraceEnabled(StaplerRequest p0){ return false; }
    public static boolean traceable(){ return false; }
    public static void anonymizedTraceEval(StaplerRequest p0, StaplerResponse p1, Object p2, String p3, String... p4){}
    public static void trace(StaplerRequest p0, StaplerResponse p1, String p2){}
    public static void trace(StaplerRequest p0, StaplerResponse p1, String p2, Object... p3){}
    public static void traceEval(StaplerRequest p0, StaplerResponse p1, Object p2){}
    public static void traceEval(StaplerRequest p0, StaplerResponse p1, Object p2, String p3){}
    public static void traceEval(StaplerRequest p0, StaplerResponse p1, Object p2, String p3, String p4){}
}
