// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.util.Converter for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.util;

import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.TypeFactory;

public interface Converter<IN, OUT>
{
    JavaType getInputType(TypeFactory p0);
    JavaType getOutputType(TypeFactory p0);
    OUT convert(IN p0);
    abstract static public class None implements Converter<Object, Object>
    {
        public None(){}
    }
}
