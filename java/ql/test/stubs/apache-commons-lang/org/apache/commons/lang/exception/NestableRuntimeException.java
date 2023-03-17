// Generated automatically from org.apache.commons.lang.exception.NestableRuntimeException for testing purposes

package org.apache.commons.lang.exception;

import java.io.PrintStream;
import java.io.PrintWriter;
import org.apache.commons.lang.exception.Nestable;
import org.apache.commons.lang.exception.NestableDelegate;

public class NestableRuntimeException extends RuntimeException implements Nestable
{
    protected NestableDelegate delegate = null;
    public NestableRuntimeException(){}
    public NestableRuntimeException(String p0){}
    public NestableRuntimeException(String p0, Throwable p1){}
    public NestableRuntimeException(Throwable p0){}
    public String getMessage(){ return null; }
    public String getMessage(int p0){ return null; }
    public String[] getMessages(){ return null; }
    public Throwable getCause(){ return null; }
    public Throwable getThrowable(int p0){ return null; }
    public Throwable[] getThrowables(){ return null; }
    public final void printPartialStackTrace(PrintWriter p0){}
    public int getThrowableCount(){ return 0; }
    public int indexOfThrowable(Class p0){ return 0; }
    public int indexOfThrowable(Class p0, int p1){ return 0; }
    public void printStackTrace(){}
    public void printStackTrace(PrintStream p0){}
    public void printStackTrace(PrintWriter p0){}
}
