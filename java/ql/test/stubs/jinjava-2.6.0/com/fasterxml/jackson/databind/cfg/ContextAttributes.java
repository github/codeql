// Generated automatically from com.fasterxml.jackson.databind.cfg.ContextAttributes for testing purposes

package com.fasterxml.jackson.databind.cfg;

import java.util.Map;

abstract public class ContextAttributes
{
    public ContextAttributes(){}
    public abstract ContextAttributes withPerCallAttribute(Object p0, Object p1);
    public abstract ContextAttributes withSharedAttribute(Object p0, Object p1);
    public abstract ContextAttributes withSharedAttributes(Map<? extends Object, ? extends Object> p0);
    public abstract ContextAttributes withoutSharedAttribute(Object p0);
    public abstract Object getAttribute(Object p0);
    public static ContextAttributes getEmpty(){ return null; }
}
