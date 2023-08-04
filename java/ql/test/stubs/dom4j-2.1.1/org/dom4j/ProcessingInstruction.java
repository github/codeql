// Generated automatically from org.dom4j.ProcessingInstruction for testing purposes

package org.dom4j;

import java.util.Map;
import org.dom4j.Node;

public interface ProcessingInstruction extends Node
{
    Map getValues();
    String getTarget();
    String getText();
    String getValue(String p0);
    boolean removeValue(String p0);
    void setTarget(String p0);
    void setValue(String p0, String p1);
    void setValues(Map p0);
}
