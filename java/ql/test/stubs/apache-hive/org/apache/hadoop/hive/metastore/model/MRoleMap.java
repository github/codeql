// Generated automatically from org.apache.hadoop.hive.metastore.model.MRoleMap for testing purposes

package org.apache.hadoop.hive.metastore.model;

import org.apache.hadoop.hive.metastore.model.MRole;
import org.datanucleus.enhancement.Detachable;
import org.datanucleus.enhancement.ExecutionContextReference;
import org.datanucleus.enhancement.Persistable;
import org.datanucleus.enhancement.StateManager;

public class MRoleMap implements Detachable, Persistable
{
    protected Object[] dnDetachedState = null;
    protected StateManager dnStateManager = null;
    protected byte dnFlags = 0;
    protected final void dnCopyField(MRoleMap p0, int p1){}
    protected final void dnPreSerialize(){}
    protected static int __dnGetInheritedFieldCount(){ return 0; }
    protected static int dnGetManagedFieldCount(){ return 0; }
    protected void dnCopyKeyFieldsFromObjectId(Object p0){}
    public MRole getRole(){ return null; }
    public MRoleMap(){}
    public MRoleMap(String p0, String p1, MRole p2, int p3, String p4, String p5, boolean p6){}
    public Object dnNewObjectIdInstance(){ return null; }
    public Object dnNewObjectIdInstance(Object p0){ return null; }
    public Persistable dnNewInstance(StateManager p0){ return null; }
    public Persistable dnNewInstance(StateManager p0, Object p1){ return null; }
    public String getGrantor(){ return null; }
    public String getGrantorType(){ return null; }
    public String getPrincipalName(){ return null; }
    public String getPrincipalType(){ return null; }
    public boolean dnIsDetached(){ return false; }
    public boolean getGrantOption(){ return false; }
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
    public int getAddTime(){ return 0; }
    public static Class ___dn$loadClass(String p0){ return null; }
    public void dnCopyFields(Object p0, int[] p1){}
    public void dnCopyKeyFieldsFromObjectId(Persistable.ObjectIdFieldConsumer p0, Object p1){}
    public void dnCopyKeyFieldsToObjectId(Object p0){}
    public void dnCopyKeyFieldsToObjectId(Persistable.ObjectIdFieldSupplier p0, Object p1){}
    public void dnMakeDirty(String p0){}
    public void dnProvideField(int p0){}
    public void dnReplaceField(int p0){}
    public void setAddTime(int p0){}
    public void setGrantOption(boolean p0){}
    public void setGrantor(String p0){}
    public void setGrantorType(String p0){}
    public void setPrincipalName(String p0){}
    public void setPrincipalType(String p0){}
    public void setRole(MRole p0){}
}
