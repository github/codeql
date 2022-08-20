// Generated automatically from android.database.sqlite.SQLiteDatabase for testing purposes

package android.database.sqlite;

import android.content.ContentValues;
import android.database.Cursor;
import android.database.DatabaseErrorHandler;
import android.database.sqlite.SQLiteClosable;
import android.database.sqlite.SQLiteCursorDriver;
import android.database.sqlite.SQLiteQuery;
import android.database.sqlite.SQLiteStatement;
import android.database.sqlite.SQLiteTransactionListener;
import android.os.CancellationSignal;
import android.util.Pair;
import java.io.File;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.function.BinaryOperator;
import java.util.function.UnaryOperator;

public class SQLiteDatabase extends SQLiteClosable
{
    protected SQLiteDatabase() {}
    protected void finalize(){}
    protected void onAllReferencesReleased(){}
    public Cursor query(String p0, String[] p1, String p2, String[] p3, String p4, String p5, String p6){ return null; }
    public Cursor query(String p0, String[] p1, String p2, String[] p3, String p4, String p5, String p6, String p7){ return null; }
    public Cursor query(boolean p0, String p1, String[] p2, String p3, String[] p4, String p5, String p6, String p7, String p8){ return null; }
    public Cursor query(boolean p0, String p1, String[] p2, String p3, String[] p4, String p5, String p6, String p7, String p8, CancellationSignal p9){ return null; }
    public Cursor queryWithFactory(SQLiteDatabase.CursorFactory p0, boolean p1, String p2, String[] p3, String p4, String[] p5, String p6, String p7, String p8, String p9){ return null; }
    public Cursor queryWithFactory(SQLiteDatabase.CursorFactory p0, boolean p1, String p2, String[] p3, String p4, String[] p5, String p6, String p7, String p8, String p9, CancellationSignal p10){ return null; }
    public Cursor rawQuery(String p0, String[] p1){ return null; }
    public Cursor rawQuery(String p0, String[] p1, CancellationSignal p2){ return null; }
    public Cursor rawQueryWithFactory(SQLiteDatabase.CursorFactory p0, String p1, String[] p2, String p3){ return null; }
    public Cursor rawQueryWithFactory(SQLiteDatabase.CursorFactory p0, String p1, String[] p2, String p3, CancellationSignal p4){ return null; }
    public List<Pair<String, String>> getAttachedDbs(){ return null; }
    public Map<String, String> getSyncedTables(){ return null; }
    public SQLiteStatement compileStatement(String p0){ return null; }
    public String getPath(){ return null; }
    public String toString(){ return null; }
    public boolean enableWriteAheadLogging(){ return false; }
    public boolean inTransaction(){ return false; }
    public boolean isDatabaseIntegrityOk(){ return false; }
    public boolean isDbLockedByCurrentThread(){ return false; }
    public boolean isDbLockedByOtherThreads(){ return false; }
    public boolean isOpen(){ return false; }
    public boolean isReadOnly(){ return false; }
    public boolean isWriteAheadLoggingEnabled(){ return false; }
    public boolean needUpgrade(int p0){ return false; }
    public boolean yieldIfContended(){ return false; }
    public boolean yieldIfContendedSafely(){ return false; }
    public boolean yieldIfContendedSafely(long p0){ return false; }
    public int delete(String p0, String p1, String[] p2){ return 0; }
    public int getVersion(){ return 0; }
    public int update(String p0, ContentValues p1, String p2, String[] p3){ return 0; }
    public int updateWithOnConflict(String p0, ContentValues p1, String p2, String[] p3, int p4){ return 0; }
    public long getMaximumSize(){ return 0; }
    public long getPageSize(){ return 0; }
    public long insert(String p0, String p1, ContentValues p2){ return 0; }
    public long insertOrThrow(String p0, String p1, ContentValues p2){ return 0; }
    public long insertWithOnConflict(String p0, String p1, ContentValues p2, int p3){ return 0; }
    public long replace(String p0, String p1, ContentValues p2){ return 0; }
    public long replaceOrThrow(String p0, String p1, ContentValues p2){ return 0; }
    public long setMaximumSize(long p0){ return 0; }
    public static SQLiteDatabase create(SQLiteDatabase.CursorFactory p0){ return null; }
    public static SQLiteDatabase createInMemory(SQLiteDatabase.OpenParams p0){ return null; }
    public static SQLiteDatabase openDatabase(File p0, SQLiteDatabase.OpenParams p1){ return null; }
    public static SQLiteDatabase openDatabase(String p0, SQLiteDatabase.CursorFactory p1, int p2){ return null; }
    public static SQLiteDatabase openDatabase(String p0, SQLiteDatabase.CursorFactory p1, int p2, DatabaseErrorHandler p3){ return null; }
    public static SQLiteDatabase openOrCreateDatabase(File p0, SQLiteDatabase.CursorFactory p1){ return null; }
    public static SQLiteDatabase openOrCreateDatabase(String p0, SQLiteDatabase.CursorFactory p1){ return null; }
    public static SQLiteDatabase openOrCreateDatabase(String p0, SQLiteDatabase.CursorFactory p1, DatabaseErrorHandler p2){ return null; }
    public static String findEditTable(String p0){ return null; }
    public static boolean deleteDatabase(File p0){ return false; }
    public static int CONFLICT_ABORT = 0;
    public static int CONFLICT_FAIL = 0;
    public static int CONFLICT_IGNORE = 0;
    public static int CONFLICT_NONE = 0;
    public static int CONFLICT_REPLACE = 0;
    public static int CONFLICT_ROLLBACK = 0;
    public static int CREATE_IF_NECESSARY = 0;
    public static int ENABLE_WRITE_AHEAD_LOGGING = 0;
    public static int MAX_SQL_CACHE_SIZE = 0;
    public static int NO_LOCALIZED_COLLATORS = 0;
    public static int OPEN_READONLY = 0;
    public static int OPEN_READWRITE = 0;
    public static int SQLITE_MAX_LIKE_PATTERN_LENGTH = 0;
    public static int releaseMemory(){ return 0; }
    public void beginTransaction(){}
    public void beginTransactionNonExclusive(){}
    public void beginTransactionWithListener(SQLiteTransactionListener p0){}
    public void beginTransactionWithListenerNonExclusive(SQLiteTransactionListener p0){}
    public void disableWriteAheadLogging(){}
    public void endTransaction(){}
    public void execPerConnectionSQL(String p0, Object[] p1){}
    public void execSQL(String p0){}
    public void execSQL(String p0, Object[] p1){}
    public void markTableSyncable(String p0, String p1){}
    public void markTableSyncable(String p0, String p1, String p2){}
    public void setCustomAggregateFunction(String p0, BinaryOperator<String> p1){}
    public void setCustomScalarFunction(String p0, UnaryOperator<String> p1){}
    public void setForeignKeyConstraintsEnabled(boolean p0){}
    public void setLocale(Locale p0){}
    public void setLockingEnabled(boolean p0){}
    public void setMaxSqlCacheSize(int p0){}
    public void setPageSize(long p0){}
    public void setTransactionSuccessful(){}
    public void setVersion(int p0){}
    public void validateSql(String p0, CancellationSignal p1){}
    static public class OpenParams
    {
        protected OpenParams() {}
        public DatabaseErrorHandler getErrorHandler(){ return null; }
        public SQLiteDatabase.CursorFactory getCursorFactory(){ return null; }
        public String getJournalMode(){ return null; }
        public String getSynchronousMode(){ return null; }
        public int getLookasideSlotCount(){ return 0; }
        public int getLookasideSlotSize(){ return 0; }
        public int getOpenFlags(){ return 0; }
        public long getIdleConnectionTimeout(){ return 0; }
    }
    static public interface CursorFactory
    {
        Cursor newCursor(SQLiteDatabase p0, SQLiteCursorDriver p1, String p2, SQLiteQuery p3);
    }
}
