// Generated automatically from org.apache.tools.ant.types.PropertySet for testing purposes

package org.apache.tools.ant.types;

import java.util.Iterator;
import java.util.Properties;
import java.util.Stack;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.types.DataType;
import org.apache.tools.ant.types.EnumeratedAttribute;
import org.apache.tools.ant.types.Mapper;
import org.apache.tools.ant.types.Reference;
import org.apache.tools.ant.types.Resource;
import org.apache.tools.ant.types.ResourceCollection;
import org.apache.tools.ant.util.FileNameMapper;

public class PropertySet extends DataType implements ResourceCollection
{
    protected PropertySet getRef(){ return null; }
    protected final void assertNotReference(){}
    protected void dieOnCircularReference(Stack<Object> p0, Project p1){}
    public Iterator<Resource> iterator(){ return null; }
    public Mapper createMapper(){ return null; }
    public Mapper getMapper(){ return null; }
    public Properties getProperties(){ return null; }
    public PropertySet(){}
    public String toString(){ return null; }
    public boolean getDynamic(){ return false; }
    public boolean isFilesystemOnly(){ return false; }
    public final void setRefid(Reference p0){}
    public int size(){ return 0; }
    public void add(FileNameMapper p0){}
    public void addPropertyref(PropertySet.PropertyRef p0){}
    public void addPropertyset(PropertySet p0){}
    public void appendBuiltin(PropertySet.BuiltinPropertySetName p0){}
    public void appendName(String p0){}
    public void appendPrefix(String p0){}
    public void appendRegex(String p0){}
    public void setDynamic(boolean p0){}
    public void setMapper(String p0, String p1, String p2){}
    public void setNegate(boolean p0){}
    static public class BuiltinPropertySetName extends EnumeratedAttribute
    {
        public BuiltinPropertySetName(){}
        public String[] getValues(){ return null; }
    }
    static public class PropertyRef
    {
        public PropertyRef(){}
        public String toString(){ return null; }
        public void setBuiltin(PropertySet.BuiltinPropertySetName p0){}
        public void setName(String p0){}
        public void setPrefix(String p0){}
        public void setRegex(String p0){}
    }
}
