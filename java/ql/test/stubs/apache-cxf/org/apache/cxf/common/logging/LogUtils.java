package org.apache.cxf.common.logging;

import java.util.logging.Level;
import java.util.logging.Logger;

public class LogUtils {
    public static void log(Logger logger, Level level, String message) {}

    public static void log(Logger logger, Level level, String message, Object parameter) {}

    public static void log(Logger logger, Level level, String message, Object[] parameters) {}

    public static void log(Logger logger, Level level, String message, Throwable throwable) {}

    public static void log(Logger logger, Level level, String message, Throwable throwable,
            Object parameter) {}

    public static void log(Logger logger, Level level, String message, Throwable throwable,
            Object... parameters) {}
}
