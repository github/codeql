package com.fasterxml.jackson.databind;

import java.io.IOException;

// This interface does not actually have these types.. This is a significantly oversimplified stub.
public interface JsonSerializable {
    public void serialize(Object gen, Object serializers) throws IOException;

    public void serializeWithType(Object gen, Object serializers, Object typeSer) throws IOException;
}
