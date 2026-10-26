// Generated automatically from org.apache.tools.ant.types.Mapper for testing purposes

package org.apache.tools.ant.types;

import org.apache.tools.ant.Project;
import org.apache.tools.ant.types.DataType;
import org.apache.tools.ant.types.EnumeratedAttribute;
import org.apache.tools.ant.types.Path;
import org.apache.tools.ant.types.Reference;
import org.apache.tools.ant.util.FileNameMapper;

public class Mapper extends DataType
{
    protected Mapper() {}
    protected Class<? extends FileNameMapper> getImplementationClass(){ return null; }
    protected Mapper getRef(){ return null; }
    protected Mapper.MapperType type = null;
    protected Path classpath = null;
    protected String classname = null;
    protected String from = null;
    protected String to = null;
    public FileNameMapper getImplementation(){ return null; }
    public Mapper(Project p0){}
    public Path createClasspath(){ return null; }
    public void add(FileNameMapper p0){}
    public void addConfigured(FileNameMapper p0){}
    public void addConfiguredMapper(Mapper p0){}
    public void setClassname(String p0){}
    public void setClasspath(Path p0){}
    public void setClasspathRef(Reference p0){}
    public void setFrom(String p0){}
    public void setRefid(Reference p0){}
    public void setTo(String p0){}
    public void setType(Mapper.MapperType p0){}
    static public class MapperType extends EnumeratedAttribute
    {
        public MapperType(){}
        public String getImplementation(){ return null; }
        public String[] getValues(){ return null; }
    }
}
