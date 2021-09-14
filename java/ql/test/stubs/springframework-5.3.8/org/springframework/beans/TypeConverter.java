// Generated automatically from org.springframework.beans.TypeConverter for testing purposes

package org.springframework.beans;

import java.lang.reflect.Field;
import org.springframework.core.MethodParameter;
import org.springframework.core.convert.TypeDescriptor;

public interface TypeConverter
{
    <T> T convertIfNecessary(Object p0, Class<T> p1);
    <T> T convertIfNecessary(Object p0, Class<T> p1, Field p2);
    <T> T convertIfNecessary(Object p0, Class<T> p1, MethodParameter p2);
    default <T> T convertIfNecessary(Object p0, Class<T> p1, TypeDescriptor p2){ return null; }
}
