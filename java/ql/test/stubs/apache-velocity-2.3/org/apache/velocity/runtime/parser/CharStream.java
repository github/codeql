// Generated automatically from org.apache.velocity.runtime.parser.CharStream for testing purposes

package org.apache.velocity.runtime.parser;


public interface CharStream
{
    String GetImage();
    char BeginToken();
    char readChar();
    char[] GetSuffix(int p0);
    int getBeginColumn();
    int getBeginLine();
    int getEndColumn();
    int getEndLine();
    void Done();
    void backup(int p0);
}
