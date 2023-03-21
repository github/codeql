// Generated automatically from org.apache.tools.ant.types.Resource for testing purposes

package org.apache.tools.ant.types;

import java.io.InputStream;
import java.io.OutputStream;
import java.util.Iterator;
import java.util.Optional;
import org.apache.tools.ant.types.DataType;
import org.apache.tools.ant.types.Reference;
import org.apache.tools.ant.types.ResourceCollection;

public class Resource extends DataType implements Comparable<Resource>, ResourceCollection
{
    protected Resource getRef(){ return null; }
    protected static int MAGIC = 0;
    protected static int getMagicNumber(byte[] p0){ return 0; }
    public <T> T as(java.lang.Class<T> p0){ return null; }
    public <T> java.util.Optional<T> asOptional(java.lang.Class<T> p0){ return null; }
    public InputStream getInputStream(){ return null; }
    public Iterator<Resource> iterator(){ return null; }
    public Object clone(){ return null; }
    public OutputStream getOutputStream(){ return null; }
    public Resource(){}
    public Resource(String p0){}
    public Resource(String p0, boolean p1, long p2){}
    public Resource(String p0, boolean p1, long p2, boolean p3){}
    public Resource(String p0, boolean p1, long p2, boolean p3, long p4){}
    public String getName(){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean isDirectory(){ return false; }
    public boolean isExists(){ return false; }
    public boolean isFilesystemOnly(){ return false; }
    public final String toLongString(){ return null; }
    public int compareTo(Resource p0){ return 0; }
    public int hashCode(){ return 0; }
    public int size(){ return 0; }
    public long getLastModified(){ return 0; }
    public long getSize(){ return 0; }
    public static long UNKNOWN_DATETIME = 0;
    public static long UNKNOWN_SIZE = 0;
    public void setDirectory(boolean p0){}
    public void setExists(boolean p0){}
    public void setLastModified(long p0){}
    public void setName(String p0){}
    public void setRefid(Reference p0){}
    public void setSize(long p0){}
}
