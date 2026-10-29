// Generated automatically from org.apache.hadoop.hive.metastore.model.MRole for testing purposes

package org.apache.hadoop.hive.metastore.model;

import org.datanucleus.enhancement.Detachable;
import org.datanucleus.enhancement.ExecutionContextReference;
import org.datanucleus.enhancement.Persistable;
import org.datanucleus.enhancement.StateManager;

public class MRole implements Detachable, Persistable
{
    protected Object[] dnDetachedState = null;
    protected StateManager dnStateManager = null;
    protected byte dnFlags = 0;
    protected final void dnCopyField(MRole p0, int p1){}
    protected final void dnPreSerialize(){}
    protected static int __dnGetInheritedFieldCount(){ return 0; }
    protected static int dnGetManagedFieldCount(){ return 0; }
    protected void dnCopyKeyFieldsFromObjectId(Object p0){}
    public MRole(){}
    public MRole(String p0, int p1, String p2){}
    public Object dnNewObjectIdInstance(){ return null; }
    public Object dnNewObjectIdInstance(Object p0){ return null; }
    public Persistable dnNewInstance(StateManager p0){ return null; }
    public Persistable dnNewInstance(StateManager p0, Object p1){ return null; }
    public String getOwnerName(){ return null; }
    public String getRoleName(){ return null; }
    public boolean dnIsDetached(){ return false; }
    public final ExecutionContextReference dnGetExecutionContext(){ return null; }
    public final Object dnGetObjectId(){ return null; }
    public final Object dnGetTransactionalObjectId(){ return null; }
    public final Object dnGetVersion(){ return null; }
    public final boolean dnIsDeleted(){ return false; }
    public final boolean dnIsDirty(){ return false; }
    public final boolean dnIsNew(){ return false; }
    public final boolean dnIsPersistent(){ return false; }
    public final boolean dnIsTransactional(){ return false; }
    public final void dnProvideFields(int[] p0){}
    public final void dnReplaceDetachedState(){}
    public final void dnReplaceFields(int[] p0){}
    public final void dnReplaceFlags(){}
    public final void dnReplaceStateManager(StateManager p0){}
    public int getCreateTime(){ return 0; }
    public static Class ___dn$loadClass(String p0){ return null; }
    public void dnCopyFields(Object p0, int[] p1){}
    public void dnCopyKeyFieldsFromObjectId(Persistable.ObjectIdFieldConsumer p0, Object p1){}
    public void dnCopyKeyFieldsToObjectId(Object p0){}
    public void dnCopyKeyFieldsToObjectId(Persistable.ObjectIdFieldSupplier p0, Object p1){}
    public void dnMakeDirty(String p0){}
    public void dnProvideField(int p0){}
    public void dnReplaceField(int p0){}
    public void setCreateTime(int p0){}
    public void setOwnerName(String p0){}
    public void setRoleName(String p0){}
}
