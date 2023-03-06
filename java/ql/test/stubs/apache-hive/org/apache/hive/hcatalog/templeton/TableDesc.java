// Generated automatically from org.apache.hive.hcatalog.templeton.TableDesc for testing purposes

package org.apache.hive.hcatalog.templeton;

import java.util.List;
import java.util.Map;
import org.apache.hive.hcatalog.templeton.ColumnDesc;
import org.apache.hive.hcatalog.templeton.GroupPermissionsDesc;

public class TableDesc extends GroupPermissionsDesc
{
    public List<ColumnDesc> columns = null;
    public List<ColumnDesc> partitionedBy = null;
    public Map<String, String> tableProperties = null;
    public String comment = null;
    public String location = null;
    public String table = null;
    public String toString(){ return null; }
    public TableDesc(){}
    public TableDesc.ClusteredByDesc clusteredBy = null;
    public TableDesc.StorageFormatDesc format = null;
    public boolean equals(Object p0){ return false; }
    public boolean external = false;
    public boolean ifNotExists = false;
    static public class ClusterSortOrderDesc
    {
        public ClusterSortOrderDesc(){}
        public ClusterSortOrderDesc(String p0, TableDesc.SortDirectionDesc p1){}
        public String columnName = null;
        public String toString(){ return null; }
        public TableDesc.SortDirectionDesc order = null;
        public boolean equals(Object p0){ return false; }
    }
    static public class ClusteredByDesc
    {
        public ClusteredByDesc(){}
        public List<String> columnNames = null;
        public List<TableDesc.ClusterSortOrderDesc> sortedBy = null;
        public String toString(){ return null; }
        public boolean equals(Object p0){ return false; }
        public int numberOfBuckets = 0;
    }
    static public class RowFormatDesc
    {
        public RowFormatDesc(){}
        public String collectionItemsTerminatedBy = null;
        public String fieldsTerminatedBy = null;
        public String linesTerminatedBy = null;
        public String mapKeysTerminatedBy = null;
        public TableDesc.SerdeDesc serde = null;
        public boolean equals(Object p0){ return false; }
    }
    static public class SerdeDesc
    {
        public Map<String, String> properties = null;
        public SerdeDesc(){}
        public String name = null;
        public boolean equals(Object p0){ return false; }
    }
    static public class StorageFormatDesc
    {
        public StorageFormatDesc(){}
        public String storedAs = null;
        public TableDesc.RowFormatDesc rowFormat = null;
        public TableDesc.StoredByDesc storedBy = null;
        public boolean equals(Object p0){ return false; }
    }
    static public class StoredByDesc
    {
        public Map<String, String> properties = null;
        public StoredByDesc(){}
        public String className = null;
        public boolean equals(Object p0){ return false; }
    }
    static public enum SortDirectionDesc
    {
        ASC, DESC;
        private SortDirectionDesc() {}
    }
}
