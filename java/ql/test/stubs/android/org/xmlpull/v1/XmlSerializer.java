// Generated automatically from org.xmlpull.v1.XmlSerializer for testing purposes

package org.xmlpull.v1;

import java.io.OutputStream;
import java.io.Writer;

public interface XmlSerializer
{
    Object getProperty(String p0);
    String getName();
    String getNamespace();
    String getPrefix(String p0, boolean p1);
    XmlSerializer attribute(String p0, String p1, String p2);
    XmlSerializer endTag(String p0, String p1);
    XmlSerializer startTag(String p0, String p1);
    XmlSerializer text(String p0);
    XmlSerializer text(char[] p0, int p1, int p2);
    boolean getFeature(String p0);
    int getDepth();
    void cdsect(String p0);
    void comment(String p0);
    void docdecl(String p0);
    void endDocument();
    void entityRef(String p0);
    void flush();
    void ignorableWhitespace(String p0);
    void processingInstruction(String p0);
    void setFeature(String p0, boolean p1);
    void setOutput(OutputStream p0, String p1);
    void setOutput(Writer p0);
    void setPrefix(String p0, String p1);
    void setProperty(String p0, Object p1);
    void startDocument(String p0, Boolean p1);
}
