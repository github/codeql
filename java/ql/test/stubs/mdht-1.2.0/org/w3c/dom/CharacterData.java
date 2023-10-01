// Generated automatically from org.w3c.dom.CharacterData for testing purposes

package org.w3c.dom;

import org.w3c.dom.Node;

public interface CharacterData extends Node
{
    String getData();
    String substringData(int p0, int p1);
    int getLength();
    void appendData(String p0);
    void deleteData(int p0, int p1);
    void insertData(int p0, String p1);
    void replaceData(int p0, int p1, String p2);
    void setData(String p0);
}
