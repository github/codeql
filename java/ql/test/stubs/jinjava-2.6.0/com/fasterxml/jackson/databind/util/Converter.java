// Generated automatically from com.fasterxml.jackson.databind.util.Converter for testing purposes

package com.fasterxml.jackson.databind.util;

import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.type.TypeFactory;

public interface Converter<IN, OUT>
{
    JavaType getInputType(TypeFactory p0);
    JavaType getOutputType(TypeFactory p0);
    OUT convert(IN p0);
}
