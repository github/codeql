// Generated automatically from org.jdbi.v3.core.array.SqlArrayType for testing purposes

package org.jdbi.v3.core.array;

import java.util.function.Function;

public interface SqlArrayType<T>
{
    Object convertArrayElement(T p0);
    String getTypeName();
    default Class<? extends Object> getArrayElementClass(){ return null; }
    static <T> SqlArrayType<T> of(String p0, java.util.function.Function<T, ? extends Object> p1){ return null; }
}
