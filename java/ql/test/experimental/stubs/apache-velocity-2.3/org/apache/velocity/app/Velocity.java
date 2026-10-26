package org.apache.velocity.app;

import org.apache.velocity.context.Context;
import java.io.Reader;
import java.io.Writer;

public class Velocity {
    public static boolean evaluate(Context context, Writer out, String logTag, String instring) {
        return true;
    }

    public static boolean evaluate(Context context, Writer writer, String logTag, Reader reader) {
        return true;
    }
}
