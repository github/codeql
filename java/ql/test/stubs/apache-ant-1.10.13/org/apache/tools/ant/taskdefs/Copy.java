// Generated automatically from org.apache.tools.ant.taskdefs.Copy for testing purposes

package org.apache.tools.ant.taskdefs;

import java.io.File;
import java.util.Hashtable;
import java.util.Map;
import java.util.Vector;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.types.FileSet;
import org.apache.tools.ant.types.FilterChain;
import org.apache.tools.ant.types.FilterSet;
import org.apache.tools.ant.types.Mapper;
import org.apache.tools.ant.types.Resource;
import org.apache.tools.ant.types.ResourceCollection;
import org.apache.tools.ant.util.FileNameMapper;
import org.apache.tools.ant.util.FileUtils;

public class Copy extends Task
{
    protected File destDir = null;
    protected File destFile = null;
    protected File file = null;
    protected FileUtils fileUtils = null;
    protected FileUtils getFileUtils(){ return null; }
    protected Hashtable<File, File> completeDirMap = null;
    protected Hashtable<String, String[]> dirCopyMap = null;
    protected Hashtable<String, String[]> fileCopyMap = null;
    protected Map<Resource, String[]> buildMap(Resource[] p0, File p1, FileNameMapper p2){ return null; }
    protected Map<Resource, String[]> scan(Resource[] p0, File p1){ return null; }
    protected Mapper mapperElement = null;
    protected Vector<FilterChain> getFilterChains(){ return null; }
    protected Vector<FilterSet> getFilterSets(){ return null; }
    protected Vector<ResourceCollection> filesets = null;
    protected Vector<ResourceCollection> rcs = null;
    protected boolean failonerror = false;
    protected boolean filtering = false;
    protected boolean flatten = false;
    protected boolean forceOverwrite = false;
    protected boolean includeEmpty = false;
    protected boolean preserveLastModified = false;
    protected boolean supportsNonFileResources(){ return false; }
    protected int verbosity = 0;
    protected void buildMap(File p0, File p1, String[] p2, FileNameMapper p3, Hashtable<String, String[]> p4){}
    protected void doFileOperations(){}
    protected void doResourceOperations(Map<Resource, String[]> p0){}
    protected void scan(File p0, File p1, String[] p2, String[] p3){}
    protected void validateAttributes(){}
    public Copy(){}
    public FilterChain createFilterChain(){ return null; }
    public FilterSet createFilterSet(){ return null; }
    public Mapper createMapper(){ return null; }
    public String getEncoding(){ return null; }
    public String getOutputEncoding(){ return null; }
    public boolean getForce(){ return false; }
    public boolean getPreserveLastModified(){ return false; }
    public boolean isEnableMultipleMapping(){ return false; }
    public void add(FileNameMapper p0){}
    public void add(ResourceCollection p0){}
    public void addFileset(FileSet p0){}
    public void execute(){}
    public void setEnableMultipleMappings(boolean p0){}
    public void setEncoding(String p0){}
    public void setFailOnError(boolean p0){}
    public void setFile(File p0){}
    public void setFiltering(boolean p0){}
    public void setFlatten(boolean p0){}
    public void setForce(boolean p0){}
    public void setGranularity(long p0){}
    public void setIncludeEmptyDirs(boolean p0){}
    public void setOutputEncoding(String p0){}
    public void setOverwrite(boolean p0){}
    public void setPreserveLastModified(String p0){}
    public void setPreserveLastModified(boolean p0){}
    public void setQuiet(boolean p0){}
    public void setTodir(File p0){}
    public void setTofile(File p0){}
    public void setVerbose(boolean p0){}
}
