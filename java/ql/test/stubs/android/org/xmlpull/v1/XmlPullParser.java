// Generated automatically from org.xmlpull.v1.XmlPullParser for testing purposes

package org.xmlpull.v1;

import java.io.InputStream;
import java.io.Reader;

public interface XmlPullParser
{
    Object getProperty(String p0);
    String getAttributeName(int p0);
    String getAttributeNamespace(int p0);
    String getAttributePrefix(int p0);
    String getAttributeType(int p0);
    String getAttributeValue(String p0, String p1);
    String getAttributeValue(int p0);
    String getInputEncoding();
    String getName();
    String getNamespace();
    String getNamespace(String p0);
    String getNamespacePrefix(int p0);
    String getNamespaceUri(int p0);
    String getPositionDescription();
    String getPrefix();
    String getText();
    String nextText();
    boolean getFeature(String p0);
    boolean isAttributeDefault(int p0);
    boolean isEmptyElementTag();
    boolean isWhitespace();
    char[] getTextCharacters(int[] p0);
    int getAttributeCount();
    int getColumnNumber();
    int getDepth();
    int getEventType();
    int getLineNumber();
    int getNamespaceCount(int p0);
    int next();
    int nextTag();
    int nextToken();
    static String FEATURE_PROCESS_DOCDECL = null;
    static String FEATURE_PROCESS_NAMESPACES = null;
    static String FEATURE_REPORT_NAMESPACE_ATTRIBUTES = null;
    static String FEATURE_VALIDATION = null;
    static String NO_NAMESPACE = null;
    static String[] TYPES = null;
    static int CDSECT = 0;
    static int COMMENT = 0;
    static int DOCDECL = 0;
    static int END_DOCUMENT = 0;
    static int END_TAG = 0;
    static int ENTITY_REF = 0;
    static int IGNORABLE_WHITESPACE = 0;
    static int PROCESSING_INSTRUCTION = 0;
    static int START_DOCUMENT = 0;
    static int START_TAG = 0;
    static int TEXT = 0;
    void defineEntityReplacementText(String p0, String p1);
    void require(int p0, String p1, String p2);
    void setFeature(String p0, boolean p1);
    void setInput(InputStream p0, String p1);
    void setInput(Reader p0);
    void setProperty(String p0, Object p1);
}
