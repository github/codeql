// Generated automatically from org.apache.tools.ant.Project for testing purposes

package org.apache.tools.ant;

import java.io.File;
import java.io.InputStream;
import java.util.Hashtable;
import java.util.Map;
import java.util.Set;
import java.util.Vector;
import org.apache.tools.ant.AntClassLoader;
import org.apache.tools.ant.BuildListener;
import org.apache.tools.ant.Executor;
import org.apache.tools.ant.Target;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.input.InputHandler;
import org.apache.tools.ant.types.FilterSet;
import org.apache.tools.ant.types.Path;
import org.apache.tools.ant.types.Resource;
import org.apache.tools.ant.types.ResourceFactory;

public class Project implements ResourceFactory
{
    protected void fireMessageLogged(Project p0, String p1, Throwable p2, int p3){}
    protected void fireMessageLogged(Project p0, String p1, int p2){}
    protected void fireMessageLogged(Target p0, String p1, Throwable p2, int p3){}
    protected void fireMessageLogged(Target p0, String p1, int p2){}
    protected void fireMessageLogged(Task p0, String p1, Throwable p2, int p3){}
    protected void fireMessageLogged(Task p0, String p1, int p2){}
    protected void fireTargetFinished(Target p0, Throwable p1){}
    protected void fireTargetStarted(Target p0){}
    protected void fireTaskFinished(Task p0, Throwable p1){}
    protected void fireTaskStarted(Task p0){}
    public <T> T getReference(String p0){ return null; }
    public AntClassLoader createClassLoader(ClassLoader p0, Path p1){ return null; }
    public AntClassLoader createClassLoader(Path p0){ return null; }
    public ClassLoader getCoreLoader(){ return null; }
    public Executor getExecutor(){ return null; }
    public File getBaseDir(){ return null; }
    public File resolveFile(String p0){ return null; }
    public File resolveFile(String p0, File p1){ return null; }
    public FilterSet getGlobalFilterSet(){ return null; }
    public Hashtable<String, Class<? extends Object>> getDataTypeDefinitions(){ return null; }
    public Hashtable<String, Class<? extends Object>> getTaskDefinitions(){ return null; }
    public Hashtable<String, Object> getInheritedProperties(){ return null; }
    public Hashtable<String, Object> getProperties(){ return null; }
    public Hashtable<String, Object> getReferences(){ return null; }
    public Hashtable<String, Object> getUserProperties(){ return null; }
    public Hashtable<String, String> getFilters(){ return null; }
    public Hashtable<String, Target> getTargets(){ return null; }
    public InputHandler getInputHandler(){ return null; }
    public InputStream getDefaultInputStream(){ return null; }
    public Map<String, Class<? extends Object>> getCopyOfDataTypeDefinitions(){ return null; }
    public Map<String, Class<? extends Object>> getCopyOfTaskDefinitions(){ return null; }
    public Map<String, Object> getCopyOfReferences(){ return null; }
    public Map<String, Target> getCopyOfTargets(){ return null; }
    public Object createDataType(String p0){ return null; }
    public Project createSubProject(){ return null; }
    public Project(){}
    public Resource getResource(String p0){ return null; }
    public Set<String> getPropertyNames(){ return null; }
    public String getDefaultTarget(){ return null; }
    public String getDescription(){ return null; }
    public String getElementName(Object p0){ return null; }
    public String getName(){ return null; }
    public String getProperty(String p0){ return null; }
    public String getUserProperty(String p0){ return null; }
    public String replaceProperties(String p0){ return null; }
    public Task createTask(String p0){ return null; }
    public Task getThreadTask(Thread p0){ return null; }
    public Vector<BuildListener> getBuildListeners(){ return null; }
    public boolean hasReference(String p0){ return false; }
    public boolean isKeepGoingMode(){ return false; }
    public final Vector<Target> topoSort(String p0, Hashtable<String, Target> p1){ return null; }
    public final Vector<Target> topoSort(String p0, Hashtable<String, Target> p1, boolean p2){ return null; }
    public final Vector<Target> topoSort(String[] p0, Hashtable<String, Target> p1, boolean p2){ return null; }
    public final void setProjectReference(Object p0){}
    public int defaultInput(byte[] p0, int p1, int p2){ return 0; }
    public int demuxInput(byte[] p0, int p1, int p2){ return 0; }
    public static Project getProject(Object p0){ return null; }
    public static String JAVA_1_0 = null;
    public static String JAVA_1_1 = null;
    public static String JAVA_1_2 = null;
    public static String JAVA_1_3 = null;
    public static String JAVA_1_4 = null;
    public static String TOKEN_END = null;
    public static String TOKEN_START = null;
    public static String getJavaVersion(){ return null; }
    public static String translatePath(String p0){ return null; }
    public static boolean toBoolean(String p0){ return false; }
    public static int MSG_DEBUG = 0;
    public static int MSG_ERR = 0;
    public static int MSG_INFO = 0;
    public static int MSG_VERBOSE = 0;
    public static int MSG_WARN = 0;
    public void addBuildListener(BuildListener p0){}
    public void addDataTypeDefinition(String p0, Class<? extends Object> p1){}
    public void addFilter(String p0, String p1){}
    public void addIdReference(String p0, Object p1){}
    public void addOrReplaceTarget(String p0, Target p1){}
    public void addOrReplaceTarget(Target p0){}
    public void addReference(String p0, Object p1){}
    public void addTarget(String p0, Target p1){}
    public void addTarget(Target p0){}
    public void addTaskDefinition(String p0, Class<? extends Object> p1){}
    public void checkTaskClass(Class<? extends Object> p0){}
    public void copyFile(File p0, File p1){}
    public void copyFile(File p0, File p1, boolean p2){}
    public void copyFile(File p0, File p1, boolean p2, boolean p3){}
    public void copyFile(File p0, File p1, boolean p2, boolean p3, boolean p4){}
    public void copyFile(String p0, String p1){}
    public void copyFile(String p0, String p1, boolean p2){}
    public void copyFile(String p0, String p1, boolean p2, boolean p3){}
    public void copyFile(String p0, String p1, boolean p2, boolean p3, boolean p4){}
    public void copyInheritedProperties(Project p0){}
    public void copyUserProperties(Project p0){}
    public void demuxFlush(String p0, boolean p1){}
    public void demuxOutput(String p0, boolean p1){}
    public void executeSortedTargets(Vector<Target> p0){}
    public void executeTarget(String p0){}
    public void executeTargets(Vector<String> p0){}
    public void fireBuildFinished(Throwable p0){}
    public void fireBuildStarted(){}
    public void fireSubBuildFinished(Throwable p0){}
    public void fireSubBuildStarted(){}
    public void inheritIDReferences(Project p0){}
    public void init(){}
    public void initProperties(){}
    public void initSubProject(Project p0){}
    public void log(String p0){}
    public void log(String p0, Throwable p1, int p2){}
    public void log(String p0, int p1){}
    public void log(Target p0, String p1, Throwable p2, int p3){}
    public void log(Target p0, String p1, int p2){}
    public void log(Task p0, String p1, Throwable p2, int p3){}
    public void log(Task p0, String p1, int p2){}
    public void registerThreadTask(Thread p0, Task p1){}
    public void removeBuildListener(BuildListener p0){}
    public void setBaseDir(File p0){}
    public void setBasedir(String p0){}
    public void setCoreLoader(ClassLoader p0){}
    public void setDefault(String p0){}
    public void setDefaultInputStream(InputStream p0){}
    public void setDefaultTarget(String p0){}
    public void setDescription(String p0){}
    public void setExecutor(Executor p0){}
    public void setFileLastModified(File p0, long p1){}
    public void setInheritedProperty(String p0, String p1){}
    public void setInputHandler(InputHandler p0){}
    public void setJavaVersionProperty(){}
    public void setKeepGoingMode(boolean p0){}
    public void setName(String p0){}
    public void setNewProperty(String p0, String p1){}
    public void setProperty(String p0, String p1){}
    public void setSystemProperties(){}
    public void setUserProperty(String p0, String p1){}
}
