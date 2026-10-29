// Generated automatically from javax.jdo.metadata.ElementMetadata for testing purposes

package javax.jdo.metadata;

import javax.jdo.AttributeConverter;
import javax.jdo.annotations.ForeignKeyAction;
import javax.jdo.metadata.ColumnMetadata;
import javax.jdo.metadata.EmbeddedMetadata;
import javax.jdo.metadata.ForeignKeyMetadata;
import javax.jdo.metadata.IndexMetadata;
import javax.jdo.metadata.Metadata;
import javax.jdo.metadata.UniqueMetadata;

public interface ElementMetadata extends Metadata
{
    AttributeConverter<? extends Object, ? extends Object> getConverter();
    Boolean getUseDefaultConversion();
    ColumnMetadata newColumnMetadata();
    ColumnMetadata[] getColumns();
    ElementMetadata setColumn(String p0);
    ElementMetadata setConverter(AttributeConverter<? extends Object, ? extends Object> p0);
    ElementMetadata setDeleteAction(ForeignKeyAction p0);
    ElementMetadata setTable(String p0);
    ElementMetadata setUpdateAction(ForeignKeyAction p0);
    ElementMetadata setUseDefaultConversion(Boolean p0);
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
    int getNumberOfColumns();
}
