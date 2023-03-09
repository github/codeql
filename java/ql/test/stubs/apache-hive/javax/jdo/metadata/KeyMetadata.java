// Generated automatically from javax.jdo.metadata.KeyMetadata for testing purposes

package javax.jdo.metadata;

import javax.jdo.AttributeConverter;
import javax.jdo.annotations.ForeignKeyAction;
import javax.jdo.metadata.ColumnMetadata;
import javax.jdo.metadata.EmbeddedMetadata;
import javax.jdo.metadata.ForeignKeyMetadata;
import javax.jdo.metadata.IndexMetadata;
import javax.jdo.metadata.Metadata;
import javax.jdo.metadata.UniqueMetadata;

public interface KeyMetadata extends Metadata
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
    KeyMetadata setColumn(String p0);
    KeyMetadata setConverter(AttributeConverter<? extends Object, ? extends Object> p0);
    KeyMetadata setDeleteAction(ForeignKeyAction p0);
    KeyMetadata setTable(String p0);
    KeyMetadata setUpdateAction(ForeignKeyAction p0);
    KeyMetadata setUseDefaultConversion(Boolean p0);
    String getColumn();
    String getTable();
    UniqueMetadata getUniqueMetadata();
    UniqueMetadata newUniqueMetadata();
    int getNumberOfColumns();
}
