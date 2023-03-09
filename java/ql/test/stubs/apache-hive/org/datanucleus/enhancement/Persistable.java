// Generated automatically from org.datanucleus.enhancement.Persistable for testing purposes

package org.datanucleus.enhancement;

import org.datanucleus.enhancement.ExecutionContextReference;
import org.datanucleus.enhancement.StateManager;

public interface Persistable
{
    ExecutionContextReference dnGetExecutionContext();
    Object dnGetObjectId();
    Object dnGetTransactionalObjectId();
    Object dnGetVersion();
    Object dnNewObjectIdInstance();
    Object dnNewObjectIdInstance(Object p0);
    Persistable dnNewInstance(StateManager p0);
    Persistable dnNewInstance(StateManager p0, Object p1);
    boolean dnIsDeleted();
    boolean dnIsDetached();
    boolean dnIsDirty();
    boolean dnIsNew();
    boolean dnIsPersistent();
    boolean dnIsTransactional();
    static byte CHECK_READ = 0;
    static byte CHECK_WRITE = 0;
    static byte LOAD_REQUIRED = 0;
    static byte MEDIATE_READ = 0;
    static byte MEDIATE_WRITE = 0;
    static byte READ_OK = 0;
    static byte READ_WRITE_OK = 0;
    static byte SERIALIZABLE = 0;
    static public interface ObjectIdFieldConsumer
    {
        void storeBooleanField(int p0, boolean p1);
        void storeByteField(int p0, byte p1);
        void storeCharField(int p0, char p1);
        void storeDoubleField(int p0, double p1);
        void storeFloatField(int p0, float p1);
        void storeIntField(int p0, int p1);
        void storeLongField(int p0, long p1);
        void storeObjectField(int p0, Object p1);
        void storeShortField(int p0, short p1);
        void storeStringField(int p0, String p1);
    }
    static public interface ObjectIdFieldSupplier
    {
        Object fetchObjectField(int p0);
        String fetchStringField(int p0);
        boolean fetchBooleanField(int p0);
        byte fetchByteField(int p0);
        char fetchCharField(int p0);
        double fetchDoubleField(int p0);
        float fetchFloatField(int p0);
        int fetchIntField(int p0);
        long fetchLongField(int p0);
        short fetchShortField(int p0);
    }
    void dnCopyFields(Object p0, int[] p1);
    void dnCopyKeyFieldsFromObjectId(Persistable.ObjectIdFieldConsumer p0, Object p1);
    void dnCopyKeyFieldsToObjectId(Object p0);
    void dnCopyKeyFieldsToObjectId(Persistable.ObjectIdFieldSupplier p0, Object p1);
    void dnMakeDirty(String p0);
    void dnProvideField(int p0);
    void dnProvideFields(int[] p0);
    void dnReplaceField(int p0);
    void dnReplaceFields(int[] p0);
    void dnReplaceFlags();
    void dnReplaceStateManager(StateManager p0);
}
