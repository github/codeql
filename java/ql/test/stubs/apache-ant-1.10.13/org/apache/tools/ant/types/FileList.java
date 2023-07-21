// Generated automatically from org.apache.tools.ant.types.FileList for testing purposes

package org.apache.tools.ant.types;

import java.io.File;
import java.util.Iterator;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.types.DataType;
import org.apache.tools.ant.types.Reference;
import org.apache.tools.ant.types.Resource;
import org.apache.tools.ant.types.ResourceCollection;

public class FileList extends DataType implements ResourceCollection
{
    protected FileList(FileList p0){}
    public File getDir(Project p0){ return null; }
    public FileList(){}
    public Iterator<Resource> iterator(){ return null; }
    public String[] getFiles(Project p0){ return null; }
    public boolean isFilesystemOnly(){ return false; }
    public int size(){ return 0; }
    public void addConfiguredFile(FileList.FileName p0){}
    public void setDir(File p0){}
    public void setFiles(String p0){}
    public void setRefid(Reference p0){}
    static public class FileName
    {
        public FileName(){}
        public String getName(){ return null; }
        public void setName(String p0){}
    }
}
