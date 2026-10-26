// Generated automatically from org.apache.hadoop.hive.metastore.utils.MetaStoreUtils for testing purposes

package org.apache.hadoop.hive.metastore.utils;

import java.security.MessageDigest;
import java.text.DateFormat;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.regex.Pattern;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileStatus;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.hive.metastore.Warehouse;
import org.apache.hadoop.hive.metastore.api.ColumnStatistics;
import org.apache.hadoop.hive.metastore.api.ColumnStatisticsObj;
import org.apache.hadoop.hive.metastore.api.Database;
import org.apache.hadoop.hive.metastore.api.Decimal;
import org.apache.hadoop.hive.metastore.api.EnvironmentContext;
import org.apache.hadoop.hive.metastore.api.FieldSchema;
import org.apache.hadoop.hive.metastore.api.MetaException;
import org.apache.hadoop.hive.metastore.api.Partition;
import org.apache.hadoop.hive.metastore.api.StorageDescriptor;
import org.apache.hadoop.hive.metastore.api.Table;
import org.apache.hadoop.hive.metastore.api.WMPoolSchedulingPolicy;
import org.apache.hadoop.hive.metastore.columnstats.aggr.ColumnStatsAggregator;
import org.apache.hadoop.hive.metastore.partition.spec.PartitionSpecProxy;
import org.apache.hadoop.hive.metastore.security.HadoopThriftAuthBridge;

public class MetaStoreUtils
{
    public MetaStoreUtils(){}
    public static <T> java.util.List<T> getMetaStoreListeners(java.lang.Class<T> p0, Configuration p1, String p2){ return null; }
    public static ClassLoader addToClassPath(ClassLoader p0, String[] p1){ return null; }
    public static List<ColumnStatisticsObj> aggrPartitionStats(List<ColumnStatistics> p0, String p1, String p2, String p3, List<String> p4, List<String> p5, boolean p6, boolean p7, double p8){ return null; }
    public static List<ColumnStatisticsObj> aggrPartitionStats(Map<ColumnStatsAggregator, List<MetaStoreUtils.ColStatsObjWithSourceInfo>> p0, List<String> p1, boolean p2, boolean p3, double p4){ return null; }
    public static List<String> getColumnNames(List<FieldSchema> p0){ return null; }
    public static List<String> getColumnNamesForPartition(Partition p0){ return null; }
    public static List<String> getColumnNamesForTable(Table p0){ return null; }
    public static List<String> getPvals(List<FieldSchema> p0, Map<String, String> p1){ return null; }
    public static Map<String, String> getMetaStoreSaslProperties(Configuration p0, boolean p1){ return null; }
    public static Map<String, String> trimMapNulls(Map<String, String> p0, boolean p1){ return null; }
    public static MetaException newMetaException(Exception p0){ return null; }
    public static MetaException newMetaException(String p0, Exception p1){ return null; }
    public static Path getOriginalLocation(Partition p0){ return null; }
    public static Properties getPartSchemaFromTableSchema(StorageDescriptor p0, Map<String, String> p1, Properties p2){ return null; }
    public static Properties getPartitionMetadata(Partition p0, Table p1){ return null; }
    public static Properties getSchema(Partition p0, Table p1){ return null; }
    public static Properties getSchema(StorageDescriptor p0, StorageDescriptor p1, Map<String, String> p2, String p3, String p4, List<FieldSchema> p5){ return null; }
    public static Properties getSchemaWithoutCols(StorageDescriptor p0, Map<String, String> p1, String p2, String p3, List<FieldSchema> p4){ return null; }
    public static Properties getTableMetadata(Table p0){ return null; }
    public static String CATALOG_DB_SEPARATOR = null;
    public static String DB_EMPTY_MARKER = null;
    public static String TYPE_FROM_DESERIALIZER = null;
    public static String encodeTableName(String p0){ return null; }
    public static String getColumnCommentsFromFieldSchema(List<FieldSchema> p0){ return null; }
    public static String getColumnNameDelimiter(List<FieldSchema> p0){ return null; }
    public static String getColumnNamesFromFieldSchema(List<FieldSchema> p0){ return null; }
    public static String getColumnTypesFromFieldSchema(List<FieldSchema> p0){ return null; }
    public static String getDDLFromFieldSchema(String p0, List<FieldSchema> p1){ return null; }
    public static String getDefaultCatalog(Configuration p0){ return null; }
    public static String getIndexTableName(String p0, String p1, String p2){ return null; }
    public static String makePartNameMatcher(Table p0, List<String> p1){ return null; }
    public static String prependCatalogToDbName(String p0, Configuration p1){ return null; }
    public static String prependCatalogToDbName(String p0, String p1, Configuration p2){ return null; }
    public static String prependNotNullCatToDbName(String p0, String p1){ return null; }
    public static String validateSkewedColNames(List<String> p0){ return null; }
    public static String validateSkewedColNamesSubsetCol(List<String> p0, List<FieldSchema> p1){ return null; }
    public static String validateTblColumns(List<FieldSchema> p0){ return null; }
    public static String[] parseDbName(String p0, Configuration p1){ return null; }
    public static ThreadLocal<DateFormat> PARTITION_DATE_FORMAT = null;
    public static WMPoolSchedulingPolicy parseSchedulingPolicy(String p0){ return null; }
    public static boolean areSameColumns(List<FieldSchema> p0, List<FieldSchema> p1){ return false; }
    public static boolean checkUserHasHostProxyPrivileges(String p0, Configuration p1, String p2){ return false; }
    public static boolean columnsIncludedByNameType(List<FieldSchema> p0, List<FieldSchema> p1){ return false; }
    public static boolean compareFieldColumns(List<FieldSchema> p0, List<FieldSchema> p1){ return false; }
    public static boolean isArchived(Partition p0){ return false; }
    public static boolean isExternal(Map<String, String> p0){ return false; }
    public static boolean isExternalTable(Table p0){ return false; }
    public static boolean isFastStatsSame(Partition p0, Partition p1){ return false; }
    public static boolean isInsertOnlyTableParam(Map<String, String> p0){ return false; }
    public static boolean isMaterializedViewTable(Table p0){ return false; }
    public static boolean isNonNativeTable(Table p0){ return false; }
    public static boolean isTransactionalTable(Map<String, String> p0){ return false; }
    public static boolean isValidSchedulingPolicy(String p0){ return false; }
    public static boolean isView(Table p0){ return false; }
    public static boolean partitionNameHasValidCharacters(List<String> p0, Pattern p1){ return false; }
    public static boolean requireCalStats(Partition p0, Partition p1, Table p2, EnvironmentContext p3){ return false; }
    public static boolean updatePartitionStatsFast(Partition p0, Table p1, Warehouse p2, boolean p3, boolean p4, EnvironmentContext p5, boolean p6){ return false; }
    public static boolean updatePartitionStatsFast(PartitionSpecProxy.PartitionIterator p0, Table p1, Warehouse p2, boolean p3, boolean p4, EnvironmentContext p5, boolean p6){ return false; }
    public static boolean validateColumnName(String p0){ return false; }
    public static boolean validateName(String p0, Configuration p1){ return false; }
    public static byte[] hashStorageDescriptor(StorageDescriptor p0, MessageDigest p1){ return null; }
    public static char CATALOG_DB_THRIFT_NAME_MARKER = '0';
    public static double decimalToDouble(Decimal p0){ return 0; }
    public static int CAT_NAME = 0;
    public static int DB_NAME = 0;
    public static int findFreePort(){ return 0; }
    public static int findFreePortExcepting(int p0){ return 0; }
    public static int getArchivingLevel(Partition p0){ return 0; }
    public static int startMetaStore(){ return 0; }
    public static int startMetaStore(Configuration p0){ return 0; }
    public static int startMetaStore(HadoopThriftAuthBridge p0, Configuration p1){ return 0; }
    public static void clearQuickStats(Map<String, String> p0){}
    public static void getMergableCols(ColumnStatistics p0, Map<String, String> p1){}
    public static void logAndThrowMetaException(Exception p0){}
    public static void mergeColStats(ColumnStatistics p0, ColumnStatistics p1){}
    public static void populateQuickStats(List<FileStatus> p0, Map<String, String> p1){}
    public static void startMetaStore(int p0, HadoopThriftAuthBridge p1){}
    public static void startMetaStore(int p0, HadoopThriftAuthBridge p1, Configuration p2){}
    public static void updateBasicState(EnvironmentContext p0, Map<String, String> p1){}
    public static void updateTableStatsSlow(Database p0, Table p1, Warehouse p2, boolean p3, boolean p4, EnvironmentContext p5){}
    public static void validatePartitionNameCharacters(List<String> p0, Pattern p1){}
    static public class ColStatsObjWithSourceInfo
    {
        protected ColStatsObjWithSourceInfo() {}
        public ColStatsObjWithSourceInfo(ColumnStatisticsObj p0, String p1, String p2, String p3, String p4){}
        public ColumnStatisticsObj getColStatsObj(){ return null; }
        public String getCatName(){ return null; }
        public String getDbName(){ return null; }
        public String getPartName(){ return null; }
        public String getTblName(){ return null; }
    }
    static public class FullTableName
    {
        protected FullTableName() {}
        public FullTableName(String p0, String p1, String p2){}
        public String toString(){ return null; }
        public boolean equals(Object p0){ return false; }
        public final String catalog = null;
        public final String db = null;
        public final String table = null;
        public int hashCode(){ return 0; }
    }
}
