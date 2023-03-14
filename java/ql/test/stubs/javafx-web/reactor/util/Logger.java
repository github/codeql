// Generated automatically from reactor.util.Logger for testing purposes

package reactor.util;


public interface Logger
{
    String getName();
    boolean isDebugEnabled();
    boolean isErrorEnabled();
    boolean isInfoEnabled();
    boolean isTraceEnabled();
    boolean isWarnEnabled();
    default void errorOrDebug(Logger.ChoiceOfMessageSupplier p0){}
    default void errorOrDebug(Logger.ChoiceOfMessageSupplier p0, Throwable p1){}
    default void infoOrDebug(Logger.ChoiceOfMessageSupplier p0){}
    default void infoOrDebug(Logger.ChoiceOfMessageSupplier p0, Throwable p1){}
    default void warnOrDebug(Logger.ChoiceOfMessageSupplier p0){}
    default void warnOrDebug(Logger.ChoiceOfMessageSupplier p0, Throwable p1){}
    static public interface ChoiceOfMessageSupplier
    {
        String get(boolean p0);
    }
    void debug(String p0);
    void debug(String p0, Object... p1);
    void debug(String p0, Throwable p1);
    void error(String p0);
    void error(String p0, Object... p1);
    void error(String p0, Throwable p1);
    void info(String p0);
    void info(String p0, Object... p1);
    void info(String p0, Throwable p1);
    void trace(String p0);
    void trace(String p0, Object... p1);
    void trace(String p0, Throwable p1);
    void warn(String p0);
    void warn(String p0, Object... p1);
    void warn(String p0, Throwable p1);
}
