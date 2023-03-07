// Generated automatically from org.apache.hadoop.fs.StorageType for testing purposes

package org.apache.hadoop.fs;

import java.util.List;

public enum StorageType
{
    ARCHIVE, DISK, PROVIDED, RAM_DISK, SSD;
    private StorageType() {}
    public boolean isMovable(){ return false; }
    public boolean isTransient(){ return false; }
    public boolean supportTypeQuota(){ return false; }
    public static List<StorageType> asList(){ return null; }
    public static List<StorageType> getMovableTypes(){ return null; }
    public static List<StorageType> getTypesSupportingQuota(){ return null; }
    public static StorageType DEFAULT = null;
    public static StorageType parseStorageType(String p0){ return null; }
    public static StorageType parseStorageType(int p0){ return null; }
    public static StorageType[] EMPTY_ARRAY = null;
}
