// Generated automatically from org.kohsuke.stapler.lang.KlassNavigator for testing purposes

package org.kohsuke.stapler.lang;

import java.net.URL;
import java.util.List;
import org.kohsuke.stapler.Function;
import org.kohsuke.stapler.lang.FieldRef;
import org.kohsuke.stapler.lang.Klass;
import org.kohsuke.stapler.lang.MethodRef;

abstract public class KlassNavigator<C>
{
    public KlassNavigator(){}
    public List<FieldRef> getDeclaredFields(C p0){ return null; }
    public List<Function> getFunctions(C p0){ return null; }
    public Object getArrayElement(Object p0, int p1){ return null; }
    public Object getMapElement(Object p0, String p1){ return null; }
    public abstract Class toJavaClass(C p0);
    public abstract Iterable<Klass<? extends Object>> getAncestors(C p0);
    public abstract Klass<? extends Object> getSuperClass(C p0);
    public abstract List<MethodRef> getDeclaredMethods(C p0);
    public abstract URL getResource(C p0, String p1);
    public boolean isArray(C p0){ return false; }
    public boolean isMap(C p0){ return false; }
    public static KlassNavigator<Class> JAVA = null;
}
