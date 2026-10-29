// Generated automatically from org.apache.tools.ant.BuildListener for testing purposes

package org.apache.tools.ant;

import java.util.EventListener;
import org.apache.tools.ant.BuildEvent;

public interface BuildListener extends EventListener
{
    void buildFinished(BuildEvent p0);
    void buildStarted(BuildEvent p0);
    void messageLogged(BuildEvent p0);
    void targetFinished(BuildEvent p0);
    void targetStarted(BuildEvent p0);
    void taskFinished(BuildEvent p0);
    void taskStarted(BuildEvent p0);
}
