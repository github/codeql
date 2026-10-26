// Generated automatically from org.apache.commons.jelly.Tag for testing purposes

package org.apache.commons.jelly;

import org.apache.commons.jelly.JellyContext;
import org.apache.commons.jelly.Script;
import org.apache.commons.jelly.XMLOutput;

public interface Tag
{
    JellyContext getContext();
    Script getBody();
    Tag getParent();
    void doTag(XMLOutput p0);
    void invokeBody(XMLOutput p0);
    void setBody(Script p0);
    void setContext(JellyContext p0);
    void setParent(Tag p0);
}
