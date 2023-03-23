// Generated automatically from org.apache.commons.lang.exception.Nestable for testing purposes

package org.apache.commons.lang.exception;

import java.io.PrintStream;
import java.io.PrintWriter;

public interface Nestable
{
    String getMessage();
    String getMessage(int p0);
    String[] getMessages();
    Throwable getCause();
    Throwable getThrowable(int p0);
    Throwable[] getThrowables();
    int getThrowableCount();
    int indexOfThrowable(Class p0);
    int indexOfThrowable(Class p0, int p1);
    void printPartialStackTrace(PrintWriter p0);
    void printStackTrace(PrintStream p0);
    void printStackTrace(PrintWriter p0);
}
