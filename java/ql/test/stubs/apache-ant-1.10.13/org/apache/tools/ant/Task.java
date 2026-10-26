// Generated automatically from org.apache.tools.ant.Task for testing purposes

package org.apache.tools.ant;

import org.apache.tools.ant.ProjectComponent;
import org.apache.tools.ant.RuntimeConfigurable;
import org.apache.tools.ant.Target;

abstract public class Task extends ProjectComponent
{
    protected RuntimeConfigurable getWrapper(){ return null; }
    protected RuntimeConfigurable wrapper = null;
    protected String taskName = null;
    protected String taskType = null;
    protected Target target = null;
    protected final boolean isInvalid(){ return false; }
    protected int handleInput(byte[] p0, int p1, int p2){ return 0; }
    protected void handleErrorFlush(String p0){}
    protected void handleErrorOutput(String p0){}
    protected void handleFlush(String p0){}
    protected void handleOutput(String p0){}
    public RuntimeConfigurable getRuntimeConfigurableWrapper(){ return null; }
    public String getTaskName(){ return null; }
    public String getTaskType(){ return null; }
    public Target getOwningTarget(){ return null; }
    public Task(){}
    public final void bindToOwner(Task p0){}
    public final void perform(){}
    public void execute(){}
    public void init(){}
    public void log(String p0){}
    public void log(String p0, Throwable p1, int p2){}
    public void log(String p0, int p1){}
    public void log(Throwable p0, int p1){}
    public void maybeConfigure(){}
    public void reconfigure(){}
    public void setOwningTarget(Target p0){}
    public void setRuntimeConfigurableWrapper(RuntimeConfigurable p0){}
    public void setTaskName(String p0){}
    public void setTaskType(String p0){}
}
