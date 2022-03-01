package org.apache.velocity.app;

import org.apache.velocity.context.Context;
import java.io.Writer;
import java.lang.String;
import java.io.Reader;

public class VelocityEngine {
    public static boolean evaluate(Context context, Writer out, String logTag, String instring) {
        return true;
    }

    public static boolean evaluate(Context context, Writer writer, String logTag, Reader reader) {
        return true;
    }

    public static boolean mergeTemplate(String templateName, String encoding, Context context, Writer writer) {
        return true;
    }
}
