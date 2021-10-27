// Generated automatically from android.database.sqlite.SQLiteCursorDriver for testing purposes

package android.database.sqlite;

import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

public interface SQLiteCursorDriver
{
    Cursor query(SQLiteDatabase.CursorFactory p0, String[] p1);
    void cursorClosed();
    void cursorDeactivated();
    void cursorRequeried(Cursor p0);
    void setBindArguments(String[] p0);
}
