// Generated automatically from org.apache.commons.lang.exception.NestableDelegate for testing purposes

package org.apache.commons.lang.exception;

import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.Serializable;
import java.util.List;
import org.apache.commons.lang.exception.Nestable;

public class NestableDelegate implements Serializable
{
    protected NestableDelegate() {}
    protected String[] getStackFrames(Throwable p0){ return null; }
    protected void trimStackFrames(List p0){}
    public NestableDelegate(Nestable p0){}
    public String getMessage(String p0){ return null; }
    public String getMessage(int p0){ return null; }
    public String[] getMessages(){ return null; }
    public Throwable getThrowable(int p0){ return null; }
    public Throwable[] getThrowables(){ return null; }
    public int getThrowableCount(){ return 0; }
    public int indexOfThrowable(Class p0, int p1){ return 0; }
    public static boolean matchSubclasses = false;
    public static boolean topDown = false;
    public static boolean trimStackFrames = false;
    public void printStackTrace(){}
    public void printStackTrace(PrintStream p0){}
    public void printStackTrace(PrintWriter p0){}
}
