// Generated automatically from javax.jdo.metadata.ValueMetadata for testing purposes

package javax.jdo.metadata;

import javax.jdo.AttributeConverter;
import javax.jdo.annotations.ForeignKeyAction;
import javax.jdo.metadata.ColumnMetadata;
import javax.jdo.metadata.EmbeddedMetadata;
import javax.jdo.metadata.ForeignKeyMetadata;
import javax.jdo.metadata.IndexMetadata;
import javax.jdo.metadata.Metadata;
import javax.jdo.metadata.UniqueMetadata;

public interface ValueMetadata extends Metadata
{
    AttributeConverter<? extends Object, ? extends Object> getConverter();
    Boolean getUseDefaultConversion();
    ColumnMetadata newColumnMetadata();
    ColumnMetadata[] getColumns();
    EmbeddedMetadata getEmbeddedMetadata();
    EmbeddedMetadata newEmbeddedMetadata();
    ForeignKeyAction getDeleteAction();
    ForeignKeyAction getUpdateAction();
    ForeignKeyMetadata getForeignKeyMetadata();
    ForeignKeyMetadata newForeignKeyMetadata();
    IndexMetadata getIndexMetadata();
    IndexMetadata newIndexMetadata();
    String getColumn();
    String getTable();
    UniqueMetadata getUniqueMetadata();
    UniqueMetadata newUniqueMetadata();
    ValueMetadata setColumn(String p0);
    ValueMetadata setConverter(AttributeConverter<? extends Object, ? extends Object> p0);
    ValueMetadata setDeleteAction(ForeignKeyAction p0);
    ValueMetadata setTable(String p0);
    ValueMetadata setUpdateAction(ForeignKeyAction p0);
    ValueMetadata setUseDefaultConversion(Boolean p0);
}
