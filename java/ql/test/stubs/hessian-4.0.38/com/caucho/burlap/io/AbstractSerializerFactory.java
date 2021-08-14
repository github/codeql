package com.caucho.hessian.io;

public abstract class AbstractSerializerFactory {
    public AbstractSerializerFactory() {
    }

    public abstract Serializer getSerializer(Class var1) throws HessianProtocolException;

    public abstract Deserializer getDeserializer(Class var1) throws HessianProtocolException;
}

