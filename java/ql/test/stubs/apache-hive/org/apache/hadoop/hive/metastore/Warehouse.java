// Generated automatically from org.apache.hadoop.hive.metastore.Warehouse for testing purposes

package org.apache.hadoop.hive.metastore;

import java.util.AbstractList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileStatus;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.hive.metastore.api.Catalog;
import org.apache.hadoop.hive.metastore.api.Database;
import org.apache.hadoop.hive.metastore.api.FieldSchema;
import org.apache.hadoop.hive.metastore.api.Partition;
import org.apache.hadoop.hive.metastore.api.StorageDescriptor;
import org.apache.hadoop.hive.metastore.api.Table;
import org.slf4j.Logger;

public class Warehouse
{
    protected Warehouse() {}
    public FileSystem getFs(Path p0){ return null; }
    public List<FileStatus> getFileStatusesForLocation(String p0){ return null; }
    public List<FileStatus> getFileStatusesForSD(StorageDescriptor p0){ return null; }
    public List<FileStatus> getFileStatusesForUnpartitionedTable(Database p0, Table p1){ return null; }
    public Path determineDatabasePath(Catalog p0, Database p1){ return null; }
    public Path getDatabasePath(Database p0){ return null; }
    public Path getDefaultDatabasePath(String p0){ return null; }
    public Path getDefaultExternalDatabasePath(String p0){ return null; }
    public Path getDefaultPartitionPath(Database p0, Table p1, Map<String, String> p2){ return null; }
    public Path getDefaultTablePath(Database p0, String p1){ return null; }
    public Path getDefaultTablePath(Database p0, String p1, boolean p2){ return null; }
    public Path getDefaultTablePath(Database p0, Table p1){ return null; }
    public Path getDefaultTablePath(String p0, String p1, boolean p2){ return null; }
    public Path getDnsPath(Path p0){ return null; }
    public Path getPartitionPath(Database p0, Table p1, List<String> p2){ return null; }
    public Path getPartitionPath(Path p0, Map<String, String> p1){ return null; }
    public Path getWhRoot(){ return null; }
    public Path getWhRootExternal(){ return null; }
    public Warehouse(Configuration p0){}
    public boolean deleteDir(Path p0, boolean p1, Database p2){ return false; }
    public boolean deleteDir(Path p0, boolean p1, boolean p2, Database p3){ return false; }
    public boolean deleteDir(Path p0, boolean p1, boolean p2, boolean p3){ return false; }
    public boolean isDir(Path p0){ return false; }
    public boolean isEmpty(Path p0){ return false; }
    public boolean isWritable(Path p0){ return false; }
    public boolean mkdirs(Path p0){ return false; }
    public boolean renameDir(Path p0, Path p1, boolean p2){ return false; }
    public static AbstractList<String> makeValsFromName(String p0, AbstractList<String> p1){ return null; }
    public static FileSystem getFs(Path p0, Configuration p1){ return null; }
    public static LinkedHashMap<String, String> makeSpecFromName(String p0){ return null; }
    public static List<String> getPartValuesFromPartName(String p0){ return null; }
    public static Logger LOG = null;
    public static Map<String, String> makeEscSpecFromName(String p0){ return null; }
    public static Map<String, String> makeSpecFromValues(List<FieldSchema> p0, List<String> p1){ return null; }
    public static Path getDnsPath(Path p0, Configuration p1){ return null; }
    public static String DATABASE_WAREHOUSE_SUFFIX = null;
    public static String DEFAULT_CATALOG_COMMENT = null;
    public static String DEFAULT_CATALOG_NAME = null;
    public static String DEFAULT_DATABASE_COMMENT = null;
    public static String DEFAULT_DATABASE_NAME = null;
    public static String DEFAULT_SERIALIZATION_FORMAT = null;
    public static String getCatalogQualifiedDbName(String p0, String p1){ return null; }
    public static String getCatalogQualifiedTableName(String p0, String p1, String p2){ return null; }
    public static String getCatalogQualifiedTableName(Table p0){ return null; }
    public static String getQualifiedName(Partition p0){ return null; }
    public static String getQualifiedName(String p0, String p1){ return null; }
    public static String getQualifiedName(Table p0){ return null; }
    public static String makeDynamicPartName(Map<String, String> p0){ return null; }
    public static String makePartName(List<FieldSchema> p0, List<String> p1){ return null; }
    public static String makePartName(List<FieldSchema> p0, List<String> p1, String p2){ return null; }
    public static String makePartName(Map<String, String> p0, boolean p1){ return null; }
    public static String makePartPath(Map<String, String> p0){ return null; }
    public static boolean makeSpecFromName(Map<String, String> p0, Path p1, Set<String> p2){ return false; }
    public void recycleDirToCmPath(Path p0, boolean p1){}
}
