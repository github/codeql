// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.ser.impl.ObjectIdWriter for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.ser.impl;

import org.apache.htrace.shaded.fasterxml.jackson.annotation.ObjectIdGenerator;
import org.apache.htrace.shaded.fasterxml.jackson.core.SerializableString;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonSerializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.PropertyName;

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
