// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.deser.ValueInstantiator for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.deser;

import org.apache.htrace.shaded.fasterxml.jackson.databind.DeserializationConfig;
import org.apache.htrace.shaded.fasterxml.jackson.databind.DeserializationContext;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.deser.SettableBeanProperty;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotatedParameter;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotatedWithParams;

abstract public class ValueInstantiator
{
    protected Object _createFromStringFallbacks(DeserializationContext p0, String p1){ return null; }
    public AnnotatedParameter getIncompleteParameter(){ return null; }
    public AnnotatedWithParams getDefaultCreator(){ return null; }
    public AnnotatedWithParams getDelegateCreator(){ return null; }
    public AnnotatedWithParams getWithArgsCreator(){ return null; }
    public JavaType getDelegateType(DeserializationConfig p0){ return null; }
    public Object createFromBoolean(DeserializationContext p0, boolean p1){ return null; }
    public Object createFromDouble(DeserializationContext p0, double p1){ return null; }
    public Object createFromInt(DeserializationContext p0, int p1){ return null; }
    public Object createFromLong(DeserializationContext p0, long p1){ return null; }
    public Object createFromObjectWith(DeserializationContext p0, Object[] p1){ return null; }
    public Object createFromString(DeserializationContext p0, String p1){ return null; }
    public Object createUsingDefault(DeserializationContext p0){ return null; }
    public Object createUsingDelegate(DeserializationContext p0, Object p1){ return null; }
    public SettableBeanProperty[] getFromObjectArguments(DeserializationConfig p0){ return null; }
    public ValueInstantiator(){}
    public abstract String getValueTypeDesc();
    public boolean canCreateFromBoolean(){ return false; }
    public boolean canCreateFromDouble(){ return false; }
    public boolean canCreateFromInt(){ return false; }
    public boolean canCreateFromLong(){ return false; }
    public boolean canCreateFromObjectWith(){ return false; }
    public boolean canCreateFromString(){ return false; }
    public boolean canCreateUsingDefault(){ return false; }
    public boolean canCreateUsingDelegate(){ return false; }
    public boolean canInstantiate(){ return false; }
}
