// Generated automatically from jinjava.javax.el.ELResolver for testing purposes

package jinjava.javax.el;

import java.beans.FeatureDescriptor;
import java.util.Iterator;
import jinjava.javax.el.ELContext;

abstract public class ELResolver
{
    public ELResolver(){}
    public Object invoke(ELContext p0, Object p1, Object p2, Class<? extends Object>[] p3, Object[] p4){ return null; }
    public abstract Class<? extends Object> getCommonPropertyType(ELContext p0, Object p1);
    public abstract Class<? extends Object> getType(ELContext p0, Object p1, Object p2);
    public abstract Iterator<FeatureDescriptor> getFeatureDescriptors(ELContext p0, Object p1);
    public abstract Object getValue(ELContext p0, Object p1, Object p2);
    public abstract boolean isReadOnly(ELContext p0, Object p1, Object p2);
    public abstract void setValue(ELContext p0, Object p1, Object p2, Object p3);
    public static String RESOLVABLE_AT_DESIGN_TIME = null;
    public static String TYPE = null;
}
