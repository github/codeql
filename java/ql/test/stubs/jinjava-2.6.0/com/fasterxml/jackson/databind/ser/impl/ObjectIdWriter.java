// Generated automatically from com.fasterxml.jackson.databind.ser.impl.ObjectIdWriter for testing purposes

package com.fasterxml.jackson.databind.ser.impl;

import com.fasterxml.jackson.annotation.ObjectIdGenerator;
import com.fasterxml.jackson.core.SerializableString;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.PropertyName;

public class ObjectIdWriter
{
    protected ObjectIdWriter() {}
    protected ObjectIdWriter(JavaType p0, SerializableString p1, ObjectIdGenerator<? extends Object> p2, JsonSerializer<? extends Object> p3, boolean p4){}
    public ObjectIdWriter withAlwaysAsId(boolean p0){ return null; }
    public ObjectIdWriter withSerializer(JsonSerializer<? extends Object> p0){ return null; }
    public final JavaType idType = null;
    public final JsonSerializer<Object> serializer = null;
    public final ObjectIdGenerator<? extends Object> generator = null;
    public final SerializableString propertyName = null;
    public final boolean alwaysAsId = false;
    public static ObjectIdWriter construct(JavaType p0, PropertyName p1, ObjectIdGenerator<? extends Object> p2, boolean p3){ return null; }
    public static ObjectIdWriter construct(JavaType p0, String p1, ObjectIdGenerator<? extends Object> p2, boolean p3){ return null; }
}
