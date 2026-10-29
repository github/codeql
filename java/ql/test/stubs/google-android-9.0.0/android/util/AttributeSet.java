// Generated automatically from android.util.AttributeSet for testing purposes

package android.util;


public interface AttributeSet
{
    String getAttributeName(int p0);
    String getAttributeValue(String p0, String p1);
    String getAttributeValue(int p0);
    String getClassAttribute();
    String getIdAttribute();
    String getPositionDescription();
    boolean getAttributeBooleanValue(String p0, String p1, boolean p2);
    boolean getAttributeBooleanValue(int p0, boolean p1);
    default String getAttributeNamespace(int p0){ return null; }
    float getAttributeFloatValue(String p0, String p1, float p2);
    float getAttributeFloatValue(int p0, float p1);
    int getAttributeCount();
    int getAttributeIntValue(String p0, String p1, int p2);
    int getAttributeIntValue(int p0, int p1);
    int getAttributeListValue(String p0, String p1, String[] p2, int p3);
    int getAttributeListValue(int p0, String[] p1, int p2);
    int getAttributeNameResource(int p0);
    int getAttributeResourceValue(String p0, String p1, int p2);
    int getAttributeResourceValue(int p0, int p1);
    int getAttributeUnsignedIntValue(String p0, String p1, int p2);
    int getAttributeUnsignedIntValue(int p0, int p1);
    int getIdAttributeResourceValue(int p0);
    int getStyleAttribute();
}
