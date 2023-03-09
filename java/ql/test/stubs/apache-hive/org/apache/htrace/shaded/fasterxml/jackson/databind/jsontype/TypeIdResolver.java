// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.TypeIdResolver for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype;

import org.apache.htrace.shaded.fasterxml.jackson.annotation.JsonTypeInfo;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;

public interface TypeIdResolver
{
    JavaType typeFromId(String p0);
    JsonTypeInfo.Id getMechanism();
    String idFromBaseType();
    String idFromValue(Object p0);
    String idFromValueAndType(Object p0, Class<? extends Object> p1);
    void init(JavaType p0);
}
