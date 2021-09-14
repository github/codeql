// Generated automatically from org.springframework.core.convert.ConversionService for testing purposes

package org.springframework.core.convert;

import org.springframework.core.convert.TypeDescriptor;

public interface ConversionService
{
    <T> T convert(Object p0, Class<T> p1);
    Object convert(Object p0, TypeDescriptor p1, TypeDescriptor p2);
    boolean canConvert(Class<? extends Object> p0, Class<? extends Object> p1);
    boolean canConvert(TypeDescriptor p0, TypeDescriptor p1);
}
