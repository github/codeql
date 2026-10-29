// Generated automatically from org.kohsuke.stapler.export.Property for testing purposes

package org.kohsuke.stapler.export;

import java.lang.reflect.Type;
import org.kohsuke.stapler.export.DataWriter;
import org.kohsuke.stapler.export.Model;
import org.kohsuke.stapler.export.TreePruner;

abstract public class Property implements Comparable<Property>
{
    protected Property() {}
    public abstract Class getType();
    public abstract Object getValue(Object p0);
    public abstract String getJavadoc();
    public abstract Type getGenericType();
    public final Model parent = null;
    public final String name = null;
    public final boolean inline = false;
    public final boolean merge = false;
    public final int visibility = 0;
    public int compareTo(Property p0){ return 0; }
    public void writeTo(Object p0, TreePruner p1, DataWriter p2){}
    public void writeTo(Object p0, int p1, DataWriter p2){}
}
