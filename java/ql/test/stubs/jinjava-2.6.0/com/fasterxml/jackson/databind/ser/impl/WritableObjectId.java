// Generated automatically from com.fasterxml.jackson.databind.ser.impl.WritableObjectId for testing purposes

package com.fasterxml.jackson.databind.ser.impl;

import com.fasterxml.jackson.annotation.ObjectIdGenerator;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.ser.impl.ObjectIdWriter;

public class WritableObjectId
{
    protected WritableObjectId() {}
    protected boolean idWritten = false;
    public Object generateId(Object p0){ return null; }
    public Object id = null;
    public WritableObjectId(ObjectIdGenerator<? extends Object> p0){}
    public boolean writeAsId(JsonGenerator p0, SerializerProvider p1, ObjectIdWriter p2){ return false; }
    public final ObjectIdGenerator<? extends Object> generator = null;
    public void writeAsField(JsonGenerator p0, SerializerProvider p1, ObjectIdWriter p2){}
}
