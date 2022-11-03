// Generated automatically from android.database.sqlite.SQLiteClosable for testing purposes

package android.database.sqlite;

import java.io.Closeable;

abstract public class SQLiteClosable implements Closeable
{
    protected abstract void onAllReferencesReleased();
    protected void onAllReferencesReleasedFromContainer(){}
    public SQLiteClosable(){}
    public void acquireReference(){}
    public void close(){}
    public void releaseReference(){}
    public void releaseReferenceFromContainer(){}
}
