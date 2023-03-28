// Generated automatically from org.apache.hadoop.fs.permission.FsPermission for testing purposes

package org.apache.hadoop.fs.permission;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.ObjectInputValidation;
import java.io.Serializable;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.permission.FsAction;
import org.apache.hadoop.io.Writable;

public class FsPermission implements ObjectInputValidation, Serializable, Writable
{
    protected FsPermission() {}
    public FsAction getGroupAction(){ return null; }
    public FsAction getOtherAction(){ return null; }
    public FsAction getUserAction(){ return null; }
    public FsPermission applyUMask(FsPermission p0){ return null; }
    public FsPermission getMasked(){ return null; }
    public FsPermission getUnmasked(){ return null; }
    public FsPermission(FsAction p0, FsAction p1, FsAction p2){}
    public FsPermission(FsAction p0, FsAction p1, FsAction p2, boolean p3){}
    public FsPermission(FsPermission p0){}
    public FsPermission(String p0){}
    public FsPermission(int p0){}
    public FsPermission(short p0){}
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean getAclBit(){ return false; }
    public boolean getEncryptedBit(){ return false; }
    public boolean getErasureCodedBit(){ return false; }
    public boolean getStickyBit(){ return false; }
    public int hashCode(){ return 0; }
    public short toExtendedShort(){ return 0; }
    public short toOctal(){ return 0; }
    public short toShort(){ return 0; }
    public static FsPermission createImmutable(short p0){ return null; }
    public static FsPermission getCachePoolDefault(){ return null; }
    public static FsPermission getDefault(){ return null; }
    public static FsPermission getDirDefault(){ return null; }
    public static FsPermission getFileDefault(){ return null; }
    public static FsPermission getUMask(Configuration p0){ return null; }
    public static FsPermission read(DataInput p0){ return null; }
    public static FsPermission valueOf(String p0){ return null; }
    public static String UMASK_LABEL = null;
    public static int DEFAULT_UMASK = 0;
    public static int MAX_PERMISSION_LENGTH = 0;
    public static void setUMask(Configuration p0, FsPermission p1){}
    public void fromShort(short p0){}
    public void readFields(DataInput p0){}
    public void validateObject(){}
    public void write(DataOutput p0){}
}
