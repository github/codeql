// Generated automatically from org.apache.hadoop.hive.metastore.ObjectStore for testing purposes

package org.apache.hadoop.hive.metastore;

import java.net.URI;
import java.nio.ByteBuffer;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import org.apache.hadoop.conf.Configurable;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hive.metastore.FileMetadataHandler;
import org.apache.hadoop.hive.metastore.RawStore;
import org.apache.hadoop.hive.metastore.TableType;
import org.apache.hadoop.hive.metastore.api.AggrStats;
import org.apache.hadoop.hive.metastore.api.Catalog;
import org.apache.hadoop.hive.metastore.api.ColumnStatistics;
import org.apache.hadoop.hive.metastore.api.CreationMetadata;
import org.apache.hadoop.hive.metastore.api.CurrentNotificationEventId;
import org.apache.hadoop.hive.metastore.api.Database;
import org.apache.hadoop.hive.metastore.api.FieldSchema;
import org.apache.hadoop.hive.metastore.api.FileMetadataExprType;
import org.apache.hadoop.hive.metastore.api.Function;
import org.apache.hadoop.hive.metastore.api.HiveObjectPrivilege;
import org.apache.hadoop.hive.metastore.api.HiveObjectRef;
import org.apache.hadoop.hive.metastore.api.ISchema;
import org.apache.hadoop.hive.metastore.api.ISchemaName;
import org.apache.hadoop.hive.metastore.api.NotificationEvent;
import org.apache.hadoop.hive.metastore.api.NotificationEventRequest;
import org.apache.hadoop.hive.metastore.api.NotificationEventResponse;
import org.apache.hadoop.hive.metastore.api.NotificationEventsCountRequest;
import org.apache.hadoop.hive.metastore.api.NotificationEventsCountResponse;
import org.apache.hadoop.hive.metastore.api.Partition;
import org.apache.hadoop.hive.metastore.api.PartitionEventType;
import org.apache.hadoop.hive.metastore.api.PartitionValuesResponse;
import org.apache.hadoop.hive.metastore.api.PrincipalPrivilegeSet;
import org.apache.hadoop.hive.metastore.api.PrincipalType;
import org.apache.hadoop.hive.metastore.api.PrivilegeBag;
import org.apache.hadoop.hive.metastore.api.Role;
import org.apache.hadoop.hive.metastore.api.RolePrincipalGrant;
import org.apache.hadoop.hive.metastore.api.RuntimeStat;
import org.apache.hadoop.hive.metastore.api.SQLCheckConstraint;
import org.apache.hadoop.hive.metastore.api.SQLDefaultConstraint;
import org.apache.hadoop.hive.metastore.api.SQLForeignKey;
import org.apache.hadoop.hive.metastore.api.SQLNotNullConstraint;
import org.apache.hadoop.hive.metastore.api.SQLPrimaryKey;
import org.apache.hadoop.hive.metastore.api.SQLUniqueConstraint;
import org.apache.hadoop.hive.metastore.api.SchemaVersion;
import org.apache.hadoop.hive.metastore.api.SchemaVersionDescriptor;
import org.apache.hadoop.hive.metastore.api.SerDeInfo;
import org.apache.hadoop.hive.metastore.api.Table;
import org.apache.hadoop.hive.metastore.api.TableMeta;
import org.apache.hadoop.hive.metastore.api.Type;
import org.apache.hadoop.hive.metastore.api.WMFullResourcePlan;
import org.apache.hadoop.hive.metastore.api.WMMapping;
import org.apache.hadoop.hive.metastore.api.WMNullablePool;
import org.apache.hadoop.hive.metastore.api.WMNullableResourcePlan;
import org.apache.hadoop.hive.metastore.api.WMPool;
import org.apache.hadoop.hive.metastore.api.WMResourcePlan;
import org.apache.hadoop.hive.metastore.api.WMTrigger;
import org.apache.hadoop.hive.metastore.api.WMValidateResourcePlanResponse;
import org.apache.hadoop.hive.metastore.model.MRoleMap;
import org.apache.hadoop.hive.metastore.partition.spec.PartitionSpecProxy;
import org.apache.hadoop.hive.metastore.utils.MetaStoreUtils;

public class ObjectStore implements Configurable, RawStore
{
    protected ColumnStatistics getTableColumnStatisticsInternal(String p0, String p1, String p2, List<String> p3, boolean p4, boolean p5){ return null; }
    protected List<ColumnStatistics> getPartitionColumnStatisticsInternal(String p0, String p1, String p2, List<String> p3, List<String> p4, boolean p5, boolean p6){ return null; }
    protected List<Partition> getPartitionsByFilterInternal(String p0, String p1, String p2, String p3, short p4, boolean p5, boolean p6){ return null; }
    protected List<Partition> getPartitionsByNamesInternal(String p0, String p1, String p2, List<String> p3, boolean p4, boolean p5){ return null; }
    protected List<Partition> getPartitionsInternal(String p0, String p1, String p2, int p3, boolean p4, boolean p5){ return null; }
    protected List<SQLCheckConstraint> getCheckConstraintsInternal(String p0, String p1, String p2, boolean p3, boolean p4){ return null; }
    protected List<SQLNotNullConstraint> getNotNullConstraintsInternal(String p0, String p1, String p2, boolean p3, boolean p4){ return null; }
    protected List<String> getTablesInternal(String p0, String p1, String p2, TableType p3, boolean p4, boolean p5){ return null; }
    protected boolean getPartitionsByExprInternal(String p0, String p1, String p2, byte[] p3, String p4, short p5, List<Partition> p6, boolean p7, boolean p8){ return false; }
    public AggrStats get_aggr_stats_for(String p0, String p1, String p2, List<String> p3, List<String> p4){ return null; }
    public ByteBuffer[] getFileMetadata(List<Long> p0){ return null; }
    public Catalog getCatalog(String p0){ return null; }
    public Collection<? extends Object> executeJDOQLSelect(String p0, ObjectStore.QueryWrapper p1){ return null; }
    public ColumnStatistics getTableColumnStatistics(String p0, String p1, String p2, List<String> p3){ return null; }
    public Configuration getConf(){ return null; }
    public CurrentNotificationEventId getCurrentNotificationEventId(){ return null; }
    public Database getDatabase(String p0, String p1){ return null; }
    public Database getDatabaseInternal(String p0, String p1){ return null; }
    public Database getJDODatabase(String p0, String p1){ return null; }
    public FileMetadataHandler getFileMetadataHandler(FileMetadataExprType p0){ return null; }
    public Function getFunction(String p0, String p1, String p2){ return null; }
    public ISchema getISchema(ISchemaName p0){ return null; }
    public List<ColumnStatistics> getPartitionColumnStatistics(String p0, String p1, String p2, List<String> p3, List<String> p4){ return null; }
    public List<Function> getAllFunctions(String p0){ return null; }
    public List<HiveObjectPrivilege> listAllTableGrants(String p0, PrincipalType p1, String p2, String p3, String p4){ return null; }
    public List<HiveObjectPrivilege> listDBGrantsAll(String p0, String p1){ return null; }
    public List<HiveObjectPrivilege> listGlobalGrantsAll(){ return null; }
    public List<HiveObjectPrivilege> listPartitionColumnGrantsAll(String p0, String p1, String p2, String p3, String p4){ return null; }
    public List<HiveObjectPrivilege> listPartitionGrantsAll(String p0, String p1, String p2, String p3){ return null; }
    public List<HiveObjectPrivilege> listPrincipalDBGrants(String p0, PrincipalType p1, String p2, String p3){ return null; }
    public List<HiveObjectPrivilege> listPrincipalDBGrantsAll(String p0, PrincipalType p1){ return null; }
    public List<HiveObjectPrivilege> listPrincipalGlobalGrants(String p0, PrincipalType p1){ return null; }
    public List<HiveObjectPrivilege> listPrincipalPartitionColumnGrants(String p0, PrincipalType p1, String p2, String p3, String p4, List<String> p5, String p6, String p7){ return null; }
    public List<HiveObjectPrivilege> listPrincipalPartitionColumnGrantsAll(String p0, PrincipalType p1){ return null; }
    public List<HiveObjectPrivilege> listPrincipalPartitionGrants(String p0, PrincipalType p1, String p2, String p3, String p4, List<String> p5, String p6){ return null; }
    public List<HiveObjectPrivilege> listPrincipalPartitionGrantsAll(String p0, PrincipalType p1){ return null; }
    public List<HiveObjectPrivilege> listPrincipalTableColumnGrants(String p0, PrincipalType p1, String p2, String p3, String p4, String p5){ return null; }
    public List<HiveObjectPrivilege> listPrincipalTableColumnGrantsAll(String p0, PrincipalType p1){ return null; }
    public List<HiveObjectPrivilege> listPrincipalTableGrantsAll(String p0, PrincipalType p1){ return null; }
    public List<HiveObjectPrivilege> listTableColumnGrantsAll(String p0, String p1, String p2, String p3){ return null; }
    public List<HiveObjectPrivilege> listTableGrantsAll(String p0, String p1, String p2){ return null; }
    public List<MRoleMap> listMRoleMembers(String p0){ return null; }
    public List<MRoleMap> listMRoles(String p0, PrincipalType p1){ return null; }
    public List<MetaStoreUtils.ColStatsObjWithSourceInfo> getPartitionColStatsForDatabase(String p0, String p1){ return null; }
    public List<MetaStoreUtils.FullTableName> getAllTableNamesForStats(){ return null; }
    public List<MetaStoreUtils.FullTableName> getTableNamesWithStats(){ return null; }
    public List<Partition> getPartitions(String p0, String p1, String p2, int p3){ return null; }
    public List<Partition> getPartitionsByFilter(String p0, String p1, String p2, String p3, short p4){ return null; }
    public List<Partition> getPartitionsByNames(String p0, String p1, String p2, List<String> p3){ return null; }
    public List<Partition> getPartitionsWithAuth(String p0, String p1, String p2, short p3, String p4, List<String> p5){ return null; }
    public List<Partition> listPartitionsPsWithAuth(String p0, String p1, String p2, List<String> p3, short p4, String p5, List<String> p6){ return null; }
    public List<Role> listRoles(String p0, PrincipalType p1){ return null; }
    public List<RolePrincipalGrant> listRoleMembers(String p0){ return null; }
    public List<RolePrincipalGrant> listRolesWithGrants(String p0, PrincipalType p1){ return null; }
    public List<RuntimeStat> getRuntimeStats(int p0, int p1){ return null; }
    public List<SQLCheckConstraint> getCheckConstraints(String p0, String p1, String p2){ return null; }
    public List<SQLDefaultConstraint> getDefaultConstraints(String p0, String p1, String p2){ return null; }
    public List<SQLForeignKey> getForeignKeys(String p0, String p1, String p2, String p3, String p4){ return null; }
    public List<SQLNotNullConstraint> getNotNullConstraints(String p0, String p1, String p2){ return null; }
    public List<SQLPrimaryKey> getPrimaryKeys(String p0, String p1, String p2){ return null; }
    public List<SQLUniqueConstraint> getUniqueConstraints(String p0, String p1, String p2){ return null; }
    public List<SchemaVersion> getAllSchemaVersion(ISchemaName p0){ return null; }
    public List<SchemaVersion> getSchemaVersionsByColumns(String p0, String p1, String p2){ return null; }
    public List<String> addCheckConstraints(List<SQLCheckConstraint> p0){ return null; }
    public List<String> addDefaultConstraints(List<SQLDefaultConstraint> p0){ return null; }
    public List<String> addForeignKeys(List<SQLForeignKey> p0){ return null; }
    public List<String> addNotNullConstraints(List<SQLNotNullConstraint> p0){ return null; }
    public List<String> addPrimaryKeys(List<SQLPrimaryKey> p0){ return null; }
    public List<String> addUniqueConstraints(List<SQLUniqueConstraint> p0){ return null; }
    public List<String> createTableWithConstraints(Table p0, List<SQLPrimaryKey> p1, List<SQLForeignKey> p2, List<SQLUniqueConstraint> p3, List<SQLNotNullConstraint> p4, List<SQLDefaultConstraint> p5, List<SQLCheckConstraint> p6){ return null; }
    public List<String> getAllDatabases(String p0){ return null; }
    public List<String> getAllTables(String p0, String p1){ return null; }
    public List<String> getAllTokenIdentifiers(){ return null; }
    public List<String> getCatalogs(){ return null; }
    public List<String> getDatabases(String p0, String p1){ return null; }
    public List<String> getFunctions(String p0, String p1, String p2){ return null; }
    public List<String> getMaterializedViewsForRewriting(String p0, String p1){ return null; }
    public List<String> getTables(String p0, String p1, String p2){ return null; }
    public List<String> getTables(String p0, String p1, String p2, TableType p3){ return null; }
    public List<String> listPartitionNames(String p0, String p1, String p2, short p3){ return null; }
    public List<String> listPartitionNamesPs(String p0, String p1, String p2, List<String> p3, short p4){ return null; }
    public List<String> listRoleNames(){ return null; }
    public List<String> listTableNamesByFilter(String p0, String p1, String p2, short p3){ return null; }
    public List<Table> getTableObjectsByName(String p0, String p1, List<String> p2){ return null; }
    public List<TableMeta> getTableMeta(String p0, String p1, String p2, List<String> p3){ return null; }
    public List<WMResourcePlan> getAllResourcePlans(){ return null; }
    public List<WMTrigger> getTriggersForResourcePlan(String p0){ return null; }
    public Map<String, List<String>> getPartitionColsWithStats(String p0, String p1, String p2){ return null; }
    public NotificationEventResponse getNextNotification(NotificationEventRequest p0){ return null; }
    public NotificationEventsCountResponse getNotificationEventsCount(NotificationEventsCountRequest p0){ return null; }
    public ObjectStore(){}
    public ObjectStore.UpdateMDatabaseURIRetVal updateMDatabaseURI(URI p0, URI p1, boolean p2){ return null; }
    public ObjectStore.UpdateMStorageDescriptorTblURIRetVal updateMStorageDescriptorTblURI(URI p0, URI p1, boolean p2){ return null; }
    public ObjectStore.UpdatePropURIRetVal updateMStorageDescriptorTblPropURI(URI p0, URI p1, String p2, boolean p3){ return null; }
    public ObjectStore.UpdatePropURIRetVal updateTblPropURI(URI p0, URI p1, String p2, boolean p3){ return null; }
    public ObjectStore.UpdateSerdeURIRetVal updateSerdeURI(URI p0, URI p1, String p2, boolean p3){ return null; }
    public Partition getPartition(String p0, String p1, String p2, List<String> p3){ return null; }
    public Partition getPartitionWithAuth(String p0, String p1, String p2, List<String> p3, String p4, List<String> p5){ return null; }
    public PartitionValuesResponse listPartitionValues(String p0, String p1, String p2, List<FieldSchema> p3, boolean p4, String p5, boolean p6, List<FieldSchema> p7, long p8){ return null; }
    public PersistenceManager getPersistenceManager(){ return null; }
    public PrincipalPrivilegeSet getColumnPrivilegeSet(String p0, String p1, String p2, String p3, String p4, String p5, List<String> p6){ return null; }
    public PrincipalPrivilegeSet getDBPrivilegeSet(String p0, String p1, String p2, List<String> p3){ return null; }
    public PrincipalPrivilegeSet getPartitionPrivilegeSet(String p0, String p1, String p2, String p3, String p4, List<String> p5){ return null; }
    public PrincipalPrivilegeSet getTablePrivilegeSet(String p0, String p1, String p2, String p3, List<String> p4){ return null; }
    public PrincipalPrivilegeSet getUserPrivilegeSet(String p0, List<String> p1){ return null; }
    public Role getRole(String p0){ return null; }
    public SchemaVersion getLatestSchemaVersion(ISchemaName p0){ return null; }
    public SchemaVersion getSchemaVersion(SchemaVersionDescriptor p0){ return null; }
    public SerDeInfo getSerDeInfo(String p0){ return null; }
    public Set<String> listFSRoots(){ return null; }
    public String getMetaStoreSchemaVersion(){ return null; }
    public String getMetastoreDbUuid(){ return null; }
    public String getToken(String p0){ return null; }
    public String[] getMasterKeys(){ return null; }
    public Table getTable(String p0, String p1, String p2){ return null; }
    public Table markPartitionForEvent(String p0, String p1, String p2, Map<String, String> p3, PartitionEventType p4){ return null; }
    public Type getType(String p0){ return null; }
    public WMFullResourcePlan alterResourcePlan(String p0, WMNullableResourcePlan p1, boolean p2, boolean p3, boolean p4){ return null; }
    public WMFullResourcePlan getActiveResourcePlan(){ return null; }
    public WMFullResourcePlan getResourcePlan(String p0){ return null; }
    public WMValidateResourcePlanResponse validateResourcePlan(String p0){ return null; }
    public boolean addPartition(Partition p0){ return false; }
    public boolean addPartitions(String p0, String p1, String p2, List<Partition> p3){ return false; }
    public boolean addPartitions(String p0, String p1, String p2, PartitionSpecProxy p3, boolean p4){ return false; }
    public boolean addRole(String p0, String p1){ return false; }
    public boolean addToken(String p0, String p1){ return false; }
    public boolean alterDatabase(String p0, String p1, Database p2){ return false; }
    public boolean commitTransaction(){ return false; }
    public boolean createType(Type p0){ return false; }
    public boolean deletePartitionColumnStatistics(String p0, String p1, String p2, String p3, List<String> p4, String p5){ return false; }
    public boolean deleteTableColumnStatistics(String p0, String p1, String p2, String p3){ return false; }
    public boolean doesPartitionExist(String p0, String p1, String p2, List<String> p3){ return false; }
    public boolean dropDatabase(String p0, String p1){ return false; }
    public boolean dropPartition(String p0, String p1, String p2, List<String> p3){ return false; }
    public boolean dropTable(String p0, String p1, String p2){ return false; }
    public boolean dropType(String p0){ return false; }
    public boolean getPartitionsByExpr(String p0, String p1, String p2, byte[] p3, String p4, short p5, List<Partition> p6){ return false; }
    public boolean grantPrivileges(PrivilegeBag p0){ return false; }
    public boolean grantRole(Role p0, String p1, PrincipalType p2, String p3, PrincipalType p4, boolean p5){ return false; }
    public boolean isActiveTransaction(){ return false; }
    public boolean isFileMetadataSupported(){ return false; }
    public boolean isPartitionMarkedForEvent(String p0, String p1, String p2, Map<String, String> p3, PartitionEventType p4){ return false; }
    public boolean openTransaction(){ return false; }
    public boolean refreshPrivileges(HiveObjectRef p0, String p1, PrivilegeBag p2){ return false; }
    public boolean removeMasterKey(Integer p0){ return false; }
    public boolean removeRole(String p0){ return false; }
    public boolean removeToken(String p0){ return false; }
    public boolean revokePrivileges(PrivilegeBag p0, boolean p1){ return false; }
    public boolean revokeRole(Role p0, String p1, PrincipalType p2, boolean p3){ return false; }
    public boolean updatePartitionColumnStatistics(ColumnStatistics p0, List<String> p1){ return false; }
    public boolean updateTableColumnStatistics(ColumnStatistics p0){ return false; }
    public class UpdateMDatabaseURIRetVal
    {
        protected UpdateMDatabaseURIRetVal() {}
        public List<String> getBadRecords(){ return null; }
        public Map<String, String> getUpdateLocations(){ return null; }
        public void setBadRecords(List<String> p0){}
        public void setUpdateLocations(Map<String, String> p0){}
    }
    public class UpdateMStorageDescriptorTblURIRetVal
    {
        protected UpdateMStorageDescriptorTblURIRetVal() {}
        public List<String> getBadRecords(){ return null; }
        public Map<String, String> getUpdateLocations(){ return null; }
        public int getNumNullRecords(){ return 0; }
        public void setBadRecords(List<String> p0){}
        public void setNumNullRecords(int p0){}
        public void setUpdateLocations(Map<String, String> p0){}
    }
    public class UpdatePropURIRetVal
    {
        protected UpdatePropURIRetVal() {}
        public List<String> getBadRecords(){ return null; }
        public Map<String, String> getUpdateLocations(){ return null; }
        public void setBadRecords(List<String> p0){}
        public void setUpdateLocations(Map<String, String> p0){}
    }
    public class UpdateSerdeURIRetVal
    {
        protected UpdateSerdeURIRetVal() {}
        public List<String> getBadRecords(){ return null; }
        public Map<String, String> getUpdateLocations(){ return null; }
        public void setBadRecords(List<String> p0){}
        public void setUpdateLocations(Map<String, String> p0){}
    }
    public int addMasterKey(String p0){ return 0; }
    public int deleteRuntimeStats(int p0){ return 0; }
    public int getDatabaseCount(){ return 0; }
    public int getNumPartitionsByExpr(String p0, String p1, String p2, byte[] p3){ return 0; }
    public int getNumPartitionsByFilter(String p0, String p1, String p2, String p3){ return 0; }
    public int getPartitionCount(){ return 0; }
    public int getTableCount(){ return 0; }
    public long cleanupEvents(){ return 0; }
    public long executeJDOQLUpdate(String p0){ return 0; }
    public static void setSchemaVerified(boolean p0){}
    public static void setTwoMetastoreTesting(boolean p0){}
    public static void unCacheDataNucleusClassLoaders(){}
    public void addNotificationEvent(NotificationEvent p0){}
    public void addRuntimeStat(RuntimeStat p0){}
    public void addSchemaVersion(SchemaVersion p0){}
    public void addSerde(SerDeInfo p0){}
    public void alterCatalog(String p0, Catalog p1){}
    public void alterFunction(String p0, String p1, String p2, Function p3){}
    public void alterISchema(ISchemaName p0, ISchema p1){}
    public void alterPartition(String p0, String p1, String p2, List<String> p3, Partition p4){}
    public void alterPartitions(String p0, String p1, String p2, List<List<String>> p3, List<Partition> p4){}
    public void alterPool(WMNullablePool p0, String p1){}
    public void alterSchemaVersion(SchemaVersionDescriptor p0, SchemaVersion p1){}
    public void alterTable(String p0, String p1, String p2, Table p3){}
    public void alterWMTrigger(WMTrigger p0){}
    public void cleanNotificationEvents(int p0){}
    public void createCatalog(Catalog p0){}
    public void createDatabase(Database p0){}
    public void createFunction(Function p0){}
    public void createISchema(ISchema p0){}
    public void createOrUpdateWMMapping(WMMapping p0, boolean p1){}
    public void createPool(WMPool p0){}
    public void createResourcePlan(WMResourcePlan p0, String p1, int p2){}
    public void createTable(Table p0){}
    public void createWMTrigger(WMTrigger p0){}
    public void createWMTriggerToPoolMapping(String p0, String p1, String p2){}
    public void dropCatalog(String p0){}
    public void dropConstraint(String p0, String p1, String p2, String p3, boolean p4){}
    public void dropFunction(String p0, String p1, String p2){}
    public void dropISchema(ISchemaName p0){}
    public void dropPartitions(String p0, String p1, String p2, List<String> p3){}
    public void dropResourcePlan(String p0){}
    public void dropSchemaVersion(SchemaVersionDescriptor p0){}
    public void dropWMMapping(WMMapping p0){}
    public void dropWMPool(String p0, String p1){}
    public void dropWMTrigger(String p0, String p1){}
    public void dropWMTriggerToPoolMapping(String p0, String p1, String p2){}
    public void flushCache(){}
    public void getFileMetadataByExpr(List<Long> p0, FileMetadataExprType p1, byte[] p2, ByteBuffer[] p3, ByteBuffer[] p4, boolean[] p5){}
    public void putFileMetadata(List<Long> p0, List<ByteBuffer> p1, FileMetadataExprType p2){}
    public void rollbackTransaction(){}
    public void setConf(Configuration p0){}
    public void setMetaStoreSchemaVersion(String p0, String p1){}
    public void shutdown(){}
    public void updateCreationMetadata(String p0, String p1, String p2, CreationMetadata p3){}
    public void updateMasterKey(Integer p0, String p1){}
    public void validateTableCols(Table p0, List<String> p1){}
    public void verifySchema(){}
    static public class QueryWrapper implements AutoCloseable
    {
        public Query query = null;
        public QueryWrapper(){}
        public void close(){}
    }
}
