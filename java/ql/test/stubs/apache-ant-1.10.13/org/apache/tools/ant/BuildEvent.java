// Generated automatically from org.apache.tools.ant.BuildEvent for testing purposes

package org.apache.tools.ant;

import java.util.EventObject;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.Target;
import org.apache.tools.ant.Task;

public class BuildEvent extends EventObject {
    protected BuildEvent() {
        super(null);
    }

    public BuildEvent(Project p0) {
        super(null);
    }

    public BuildEvent(Target p0) {
        super(null);
    }

    public BuildEvent(Task p0) {
        super(null);
    }

    public Project getProject() {
        return null;
    }

    public String getMessage() {
        return null;
    }

    public Target getTarget() {
        return null;
    }

    public Task getTask() {
        return null;
    }

    public Throwable getException() {
        return null;
    }

    public int getPriority() {
        return 0;
    }

    public void setException(Throwable p0) {}

    public void setMessage(String p0, int p1) {}
}
