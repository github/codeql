package org.apache.velocity.runtime;

import org.apache.velocity.runtime.parser.node.*;

import org.apache.velocity.context.Context;
import java.io.Reader;
import java.io.Writer;
import org.apache.velocity.Template;

public class RuntimeServices {
    public RuntimeServices() {
    }

    public static SimpleNode parse(Reader reader, Template template) {
        return null;
    }

    public static boolean evaluate(Context context, Writer out, String logTag, String instring) {
        return true;
    }

    public static boolean evaluate(Context context, Writer writer, String logTag, Reader reader) {
        return true;
    }
}
