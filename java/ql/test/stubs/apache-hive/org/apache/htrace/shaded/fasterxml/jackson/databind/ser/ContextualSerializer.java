// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.ser.ContextualSerializer for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.ser;

import org.apache.htrace.shaded.fasterxml.jackson.databind.BeanProperty;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonSerializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.SerializerProvider;

public interface ContextualSerializer
{
    JsonSerializer<? extends Object> createContextual(SerializerProvider p0, BeanProperty p1);
}
