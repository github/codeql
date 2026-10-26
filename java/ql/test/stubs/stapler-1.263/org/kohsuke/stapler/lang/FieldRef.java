// Generated automatically from org.kohsuke.stapler.lang.FieldRef for testing purposes

package org.kohsuke.stapler.lang;

import java.lang.reflect.Field;
import org.kohsuke.stapler.lang.AnnotatedRef;

abstract public class FieldRef extends AnnotatedRef
{
    public FieldRef(){}
    public abstract Class<? extends Object> getReturnType();
    public abstract Object get(Object p0);
    public abstract String getName();
    public abstract String getQualifiedName();
    public abstract String getSignature();
    public abstract boolean isStatic();
    public boolean isRoutable(){ return false; }
    public static FieldRef wrap(Field p0){ return null; }
    static public interface Filter
    {
        boolean keep(FieldRef p0);
        static FieldRef.Filter ALWAYS_OK = null;
    }
}
