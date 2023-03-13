// Generated automatically from org.springframework.http.converter.HttpMessageConverter for testing purposes

package org.springframework.http.converter;

import java.util.List;
import org.springframework.http.HttpInputMessage;
import org.springframework.http.HttpOutputMessage;
import org.springframework.http.MediaType;

public interface HttpMessageConverter<T>
{
    List<MediaType> getSupportedMediaTypes();
    T read(java.lang.Class<? extends T> p0, HttpInputMessage p1);
    boolean canRead(Class<? extends Object> p0, MediaType p1);
    boolean canWrite(Class<? extends Object> p0, MediaType p1);
    default List<MediaType> getSupportedMediaTypes(Class<? extends Object> p0){ return null; }
    void write(T p0, MediaType p1, HttpOutputMessage p2);
}
