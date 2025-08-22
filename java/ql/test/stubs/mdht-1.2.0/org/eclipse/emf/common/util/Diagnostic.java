// Generated automatically from org.eclipse.emf.common.util.Diagnostic for testing purposes

package org.eclipse.emf.common.util;

import java.util.List;

public interface Diagnostic
{
    List<? extends Object> getData();
    String getMessage();
    String getSource();
    Throwable getException();
    int getCode();
    int getSeverity();
    java.util.List<Diagnostic> getChildren();
    static Diagnostic CANCEL_INSTANCE = null;
    static Diagnostic OK_INSTANCE = null;
    static int CANCEL = 0;
    static int ERROR = 0;
    static int INFO = 0;
    static int OK = 0;
    static int WARNING = 0;
}
