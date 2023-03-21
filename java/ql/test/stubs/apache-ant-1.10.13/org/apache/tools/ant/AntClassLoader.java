// Generated automatically from org.apache.tools.ant.AntClassLoader for testing purposes

package org.apache.tools.ant;

import java.io.Closeable;
import java.io.File;
import java.io.InputStream;
import java.net.URL;
import java.util.Enumeration;
import java.util.jar.Manifest;
import org.apache.tools.ant.BuildEvent;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.SubBuildListener;
import org.apache.tools.ant.types.Path;

public class AntClassLoader extends ClassLoader implements Closeable, SubBuildListener
{
    protected Class<? extends Object> defineClassFromData(File p0, byte[] p1, String p2){ return null; }
    protected Class<? extends Object> loadClass(String p0, boolean p1){ return null; }
    protected Enumeration<URL> findResources(String p0){ return null; }
    protected Enumeration<URL> findResources(String p0, boolean p1){ return null; }
    protected URL findResource(String p0){ return null; }
    protected URL getResourceURL(File p0, String p1){ return null; }
    protected boolean isInPath(File p0){ return false; }
    protected void addPathFile(File p0){}
    protected void definePackage(File p0, String p1){}
    protected void definePackage(File p0, String p1, Manifest p2){}
    protected void log(String p0, int p1){}
    public AntClassLoader(){}
    public AntClassLoader(ClassLoader p0, Project p1, Path p2){}
    public AntClassLoader(ClassLoader p0, Project p1, Path p2, boolean p3){}
    public AntClassLoader(ClassLoader p0, boolean p1){}
    public AntClassLoader(Project p0, Path p1){}
    public AntClassLoader(Project p0, Path p1, boolean p2){}
    public Class<? extends Object> findClass(String p0){ return null; }
    public Class<? extends Object> forceLoadClass(String p0){ return null; }
    public Class<? extends Object> forceLoadSystemClass(String p0){ return null; }
    public ClassLoader getConfiguredParent(){ return null; }
    public Enumeration<URL> getNamedResources(String p0){ return null; }
    public Enumeration<URL> getResources(String p0){ return null; }
    public InputStream getResourceAsStream(String p0){ return null; }
    public String getClasspath(){ return null; }
    public String toString(){ return null; }
    public URL getResource(String p0){ return null; }
    public static AntClassLoader newAntClassLoader(ClassLoader p0, Project p1, Path p2, boolean p3){ return null; }
    public static void initializeClass(Class<? extends Object> p0){}
    public void addJavaLibraries(){}
    public void addLoaderPackageRoot(String p0){}
    public void addPathComponent(File p0){}
    public void addPathElement(String p0){}
    public void addSystemPackageRoot(String p0){}
    public void buildFinished(BuildEvent p0){}
    public void buildStarted(BuildEvent p0){}
    public void cleanup(){}
    public void close(){}
    public void messageLogged(BuildEvent p0){}
    public void resetThreadContextLoader(){}
    public void setClassPath(Path p0){}
    public void setIsolated(boolean p0){}
    public void setParent(ClassLoader p0){}
    public void setParentFirst(boolean p0){}
    public void setProject(Project p0){}
    public void setThreadContextLoader(){}
    public void subBuildFinished(BuildEvent p0){}
    public void subBuildStarted(BuildEvent p0){}
    public void targetFinished(BuildEvent p0){}
    public void targetStarted(BuildEvent p0){}
    public void taskFinished(BuildEvent p0){}
    public void taskStarted(BuildEvent p0){}
}
