// Generated automatically from android.database.Cursor for testing purposes

package android.database;

import android.content.ContentResolver;
import android.database.CharArrayBuffer;
import android.database.ContentObserver;
import android.database.DataSetObserver;
import android.net.Uri;
import android.os.Bundle;
import java.io.Closeable;
import java.util.List;

public interface Cursor extends Closeable
{
    Bundle getExtras();
    Bundle respond(Bundle p0);
    String getColumnName(int p0);
    String getString(int p0);
    String[] getColumnNames();
    Uri getNotificationUri();
    boolean getWantsAllOnMoveCalls();
    boolean isAfterLast();
    boolean isBeforeFirst();
    boolean isClosed();
    boolean isFirst();
    boolean isLast();
    boolean isNull(int p0);
    boolean move(int p0);
    boolean moveToFirst();
    boolean moveToLast();
    boolean moveToNext();
    boolean moveToPosition(int p0);
    boolean moveToPrevious();
    boolean requery();
    byte[] getBlob(int p0);
    default List<Uri> getNotificationUris(){ return null; }
    default void setNotificationUris(ContentResolver p0, List<Uri> p1){}
    double getDouble(int p0);
    float getFloat(int p0);
    int getColumnCount();
    int getColumnIndex(String p0);
    int getColumnIndexOrThrow(String p0);
    int getCount();
    int getInt(int p0);
    int getPosition();
    int getType(int p0);
    long getLong(int p0);
    short getShort(int p0);
    static int FIELD_TYPE_BLOB = 0;
    static int FIELD_TYPE_FLOAT = 0;
    static int FIELD_TYPE_INTEGER = 0;
    static int FIELD_TYPE_NULL = 0;
    static int FIELD_TYPE_STRING = 0;
    void close();
    void copyStringToBuffer(int p0, CharArrayBuffer p1);
    void deactivate();
    void registerContentObserver(ContentObserver p0);
    void registerDataSetObserver(DataSetObserver p0);
    void setExtras(Bundle p0);
    void setNotificationUri(ContentResolver p0, Uri p1);
    void unregisterContentObserver(ContentObserver p0);
    void unregisterDataSetObserver(DataSetObserver p0);
}
