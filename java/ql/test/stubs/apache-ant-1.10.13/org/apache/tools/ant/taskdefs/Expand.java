// Generated automatically from org.apache.tools.ant.taskdefs.Expand for testing purposes

package org.apache.tools.ant.taskdefs;

import java.io.File;
import java.io.InputStream;
import java.util.Date;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.types.FileSet;
import org.apache.tools.ant.types.Mapper;
import org.apache.tools.ant.types.PatternSet;
import org.apache.tools.ant.types.Resource;
import org.apache.tools.ant.types.ResourceCollection;
import org.apache.tools.ant.util.FileNameMapper;
import org.apache.tools.ant.util.FileUtils;

public class Expand extends Task
{
    protected Expand(String p0){}
    protected FileNameMapper getMapper(){ return null; }
    protected void expandFile(FileUtils p0, File p1, File p2){}
    protected void expandResource(Resource p0, File p1){}
    protected void extractFile(FileUtils p0, File p1, File p2, InputStream p3, String p4, Date p5, boolean p6, FileNameMapper p7){}
    protected void internalSetEncoding(String p0){}
    protected void internalSetScanForUnicodeExtraFields(boolean p0){}
    public Boolean getAllowFilesToEscapeDest(){ return null; }
    public Expand(){}
    public Mapper createMapper(){ return null; }
    public String getEncoding(){ return null; }
    public boolean getFailOnEmptyArchive(){ return false; }
    public boolean getScanForUnicodeExtraFields(){ return false; }
    public static String ERROR_MULTIPLE_MAPPERS = null;
    public static String NATIVE_ENCODING = null;
    public void add(FileNameMapper p0){}
    public void add(ResourceCollection p0){}
    public void addFileset(FileSet p0){}
    public void addPatternset(PatternSet p0){}
    public void execute(){}
    public void setAllowFilesToEscapeDest(boolean p0){}
    public void setDest(File p0){}
    public void setEncoding(String p0){}
    public void setFailOnEmptyArchive(boolean p0){}
    public void setOverwrite(boolean p0){}
    public void setScanForUnicodeExtraFields(boolean p0){}
    public void setSrc(File p0){}
    public void setStripAbsolutePathSpec(boolean p0){}
}
