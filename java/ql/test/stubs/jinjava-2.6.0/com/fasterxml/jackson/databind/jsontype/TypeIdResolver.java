// Generated automatically from com.fasterxml.jackson.databind.jsontype.TypeIdResolver for testing purposes

package com.fasterxml.jackson.databind.jsontype;

import com.fasterxml.jackson.annotation.JsonTypeInfo;
import com.fasterxml.jackson.databind.DatabindContext;
import com.fasterxml.jackson.databind.JavaType;

public interface TypeIdResolver
{
    JavaType typeFromId(DatabindContext p0, String p1);
    JavaType typeFromId(String p0);
    JsonTypeInfo.Id getMechanism();
    String getDescForKnownTypeIds();
    String idFromBaseType();
    String idFromValue(Object p0);
    String idFromValueAndType(Object p0, Class<? extends Object> p1);
    void init(JavaType p0);
}
