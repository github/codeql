// Generated automatically from javax.jdo.metadata.TypeMetadata for testing purposes

package javax.jdo.metadata;

import java.lang.reflect.Method;
import javax.jdo.annotations.IdentityType;
import javax.jdo.metadata.ColumnMetadata;
import javax.jdo.metadata.DatastoreIdentityMetadata;
import javax.jdo.metadata.FetchGroupMetadata;
import javax.jdo.metadata.ForeignKeyMetadata;
import javax.jdo.metadata.IndexMetadata;
import javax.jdo.metadata.InheritanceMetadata;
import javax.jdo.metadata.JoinMetadata;
import javax.jdo.metadata.MemberMetadata;
import javax.jdo.metadata.Metadata;
import javax.jdo.metadata.PrimaryKeyMetadata;
import javax.jdo.metadata.PropertyMetadata;
import javax.jdo.metadata.QueryMetadata;
import javax.jdo.metadata.UniqueMetadata;
import javax.jdo.metadata.VersionMetadata;

public interface TypeMetadata extends Metadata
{
    Boolean getEmbeddedOnly();
    ColumnMetadata newColumnMetadata();
    ColumnMetadata[] getColumns();
    DatastoreIdentityMetadata getDatastoreIdentityMetadata();
    DatastoreIdentityMetadata newDatastoreIdentityMetadata();
    FetchGroupMetadata newFetchGroupMetadata(String p0);
    FetchGroupMetadata[] getFetchGroups();
    ForeignKeyMetadata newForeignKeyMetadata();
    ForeignKeyMetadata[] getForeignKeys();
    IdentityType getIdentityType();
    IndexMetadata newIndexMetadata();
    IndexMetadata[] getIndices();
    InheritanceMetadata getInheritanceMetadata();
    InheritanceMetadata newInheritanceMetadata();
    JoinMetadata newJoinMetadata();
    JoinMetadata[] getJoins();
    MemberMetadata[] getMembers();
    PrimaryKeyMetadata getPrimaryKeyMetadata();
    PrimaryKeyMetadata newPrimaryKeyMetadata();
    PropertyMetadata newPropertyMetadata(Method p0);
    PropertyMetadata newPropertyMetadata(String p0);
    QueryMetadata newQueryMetadata(String p0);
    QueryMetadata[] getQueries();
    String getCatalog();
    String getName();
    String getObjectIdClass();
    String getSchema();
    String getTable();
    TypeMetadata setCacheable(boolean p0);
    TypeMetadata setCatalog(String p0);
    TypeMetadata setDetachable(boolean p0);
    TypeMetadata setEmbeddedOnly(boolean p0);
    TypeMetadata setIdentityType(IdentityType p0);
    TypeMetadata setObjectIdClass(String p0);
    TypeMetadata setRequiresExtent(boolean p0);
    TypeMetadata setSchema(String p0);
    TypeMetadata setSerializeRead(boolean p0);
    TypeMetadata setTable(String p0);
    UniqueMetadata newUniqueMetadata();
    UniqueMetadata[] getUniques();
    VersionMetadata getVersionMetadata();
    VersionMetadata newVersionMetadata();
    boolean getCacheable();
    boolean getDetachable();
    boolean getRequiresExtent();
    boolean getSerializeRead();
    int getNumberOfColumns();
    int getNumberOfFetchGroups();
    int getNumberOfForeignKeys();
    int getNumberOfIndices();
    int getNumberOfJoins();
    int getNumberOfMembers();
    int getNumberOfQueries();
    int getNumberOfUniques();
}
