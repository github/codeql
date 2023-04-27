// Generated automatically from org.datanucleus.enhancement.StateManager for testing purposes

package org.datanucleus.enhancement;

import org.datanucleus.enhancement.Detachable;
import org.datanucleus.enhancement.ExecutionContextReference;
import org.datanucleus.enhancement.Persistable;

public interface StateManager
{
    ExecutionContextReference getExecutionContext(Persistable p0);
    Object getObjectField(Persistable p0, int p1, Object p2);
    Object getObjectId(Persistable p0);
    Object getTransactionalObjectId(Persistable p0);
    Object getVersion(Persistable p0);
    Object replacingObjectField(Persistable p0, int p1);
    Object[] replacingDetachedState(Detachable p0, Object[] p1);
    StateManager replacingStateManager(Persistable p0, StateManager p1);
    String getStringField(Persistable p0, int p1, String p2);
    String replacingStringField(Persistable p0, int p1);
    boolean getBooleanField(Persistable p0, int p1, boolean p2);
    boolean isDeleted(Persistable p0);
    boolean isDirty(Persistable p0);
    boolean isLoaded(Persistable p0, int p1);
    boolean isNew(Persistable p0);
    boolean isPersistent(Persistable p0);
    boolean isTransactional(Persistable p0);
    boolean replacingBooleanField(Persistable p0, int p1);
    byte getByteField(Persistable p0, int p1, byte p2);
    byte replacingByteField(Persistable p0, int p1);
    byte replacingFlags(Persistable p0);
    char getCharField(Persistable p0, int p1, char p2);
    char replacingCharField(Persistable p0, int p1);
    double getDoubleField(Persistable p0, int p1, double p2);
    double replacingDoubleField(Persistable p0, int p1);
    float getFloatField(Persistable p0, int p1, float p2);
    float replacingFloatField(Persistable p0, int p1);
    int getIntField(Persistable p0, int p1, int p2);
    int replacingIntField(Persistable p0, int p1);
    long getLongField(Persistable p0, int p1, long p2);
    long replacingLongField(Persistable p0, int p1);
    short getShortField(Persistable p0, int p1, short p2);
    short replacingShortField(Persistable p0, int p1);
    void makeDirty(Persistable p0, String p1);
    void preSerialize(Persistable p0);
    void providedBooleanField(Persistable p0, int p1, boolean p2);
    void providedByteField(Persistable p0, int p1, byte p2);
    void providedCharField(Persistable p0, int p1, char p2);
    void providedDoubleField(Persistable p0, int p1, double p2);
    void providedFloatField(Persistable p0, int p1, float p2);
    void providedIntField(Persistable p0, int p1, int p2);
    void providedLongField(Persistable p0, int p1, long p2);
    void providedObjectField(Persistable p0, int p1, Object p2);
    void providedShortField(Persistable p0, int p1, short p2);
    void providedStringField(Persistable p0, int p1, String p2);
    void setBooleanField(Persistable p0, int p1, boolean p2, boolean p3);
    void setByteField(Persistable p0, int p1, byte p2, byte p3);
    void setCharField(Persistable p0, int p1, char p2, char p3);
    void setDoubleField(Persistable p0, int p1, double p2, double p3);
    void setFloatField(Persistable p0, int p1, float p2, float p3);
    void setIntField(Persistable p0, int p1, int p2, int p3);
    void setLongField(Persistable p0, int p1, long p2, long p3);
    void setObjectField(Persistable p0, int p1, Object p2, Object p3);
    void setShortField(Persistable p0, int p1, short p2, short p3);
    void setStringField(Persistable p0, int p1, String p2, String p3);
}
