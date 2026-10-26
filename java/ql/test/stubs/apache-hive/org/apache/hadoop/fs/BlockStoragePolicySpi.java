// Generated automatically from org.apache.hadoop.fs.BlockStoragePolicySpi for testing purposes

package org.apache.hadoop.fs;

import org.apache.hadoop.fs.StorageType;

public interface BlockStoragePolicySpi
{
    StorageType[] getCreationFallbacks();
    StorageType[] getReplicationFallbacks();
    StorageType[] getStorageTypes();
    String getName();
    boolean isCopyOnCreateFile();
}
