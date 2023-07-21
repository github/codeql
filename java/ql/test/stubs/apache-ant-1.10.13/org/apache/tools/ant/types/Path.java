// Generated automatically from org.apache.tools.ant.types.Path for testing purposes

package org.apache.tools.ant.types;

import java.io.File;
import java.util.Iterator;
import java.util.Stack;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.types.DataType;
import org.apache.tools.ant.types.DirSet;
import org.apache.tools.ant.types.FileList;
import org.apache.tools.ant.types.FileSet;
import org.apache.tools.ant.types.Reference;
import org.apache.tools.ant.types.Resource;
import org.apache.tools.ant.types.ResourceCollection;

public class Path extends DataType implements Cloneable, ResourceCollection
{
    protected Path() {}
    protected ResourceCollection assertFilesystemOnly(ResourceCollection p0){ return null; }
    protected boolean delegateIteratorToList(){ return false; }
    protected static boolean translateFileSep(StringBuffer p0, int p1){ return false; }
    protected void dieOnCircularReference(Stack<Object> p0, Project p1){}
    public Object clone(){ return null; }
    public Path concatSystemBootClasspath(String p0){ return null; }
    public Path concatSystemClasspath(){ return null; }
    public Path concatSystemClasspath(String p0){ return null; }
    public Path createPath(){ return null; }
    public Path(Project p0){}
    public Path(Project p0, String p1){}
    public Path.PathElement createPathElement(){ return null; }
    public String toString(){ return null; }
    public String[] list(){ return null; }
    public boolean isFilesystemOnly(){ return false; }
    public class PathElement implements ResourceCollection
    {
        public Iterator<Resource> iterator(){ return null; }
        public PathElement(){}
        public String[] getParts(){ return null; }
        public boolean isFilesystemOnly(){ return false; }
        public int size(){ return 0; }
        public void setLocation(File p0){}
        public void setPath(String p0){}
    }
    public final Iterator<Resource> iterator(){ return null; }
    public int size(){ return 0; }
    public static Path systemBootClasspath = null;
    public static Path systemClasspath = null;
    public static String translateFile(String p0){ return null; }
    public static String[] translatePath(Project p0, String p1){ return null; }
    public void add(Path p0){}
    public void add(ResourceCollection p0){}
    public void addDirset(DirSet p0){}
    public void addExisting(Path p0){}
    public void addExisting(Path p0, boolean p1){}
    public void addExtdirs(Path p0){}
    public void addFilelist(FileList p0){}
    public void addFileset(FileSet p0){}
    public void addJavaRuntime(){}
    public void append(Path p0){}
    public void setCache(boolean p0){}
    public void setLocation(File p0){}
    public void setPath(String p0){}
    public void setRefid(Reference p0){}
}
