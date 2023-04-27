// Generated automatically from org.kohsuke.stapler.export.Model for testing purposes

package org.kohsuke.stapler.export;

import java.util.List;
import org.kohsuke.stapler.export.DataWriter;
import org.kohsuke.stapler.export.Property;
import org.kohsuke.stapler.export.TreePruner;

public class Model<T>
{
    protected Model() {}
    public List<Property> getProperties(){ return null; }
    public final Model<? super T> superModel = null;
    public final java.lang.Class<T> type = null;
    public void writeTo(T p0, DataWriter p1){}
    public void writeTo(T p0, TreePruner p1, DataWriter p2){}
    public void writeTo(T p0, int p1, DataWriter p2){}
}
