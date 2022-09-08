// Generated automatically from com.mitchellbosecke.pebble.lexer.Token for testing purposes

package com.mitchellbosecke.pebble.lexer;


public class Token
{
    protected Token() {}
    public String getValue(){ return null; }
    public String toString(){ return null; }
    public Token(Token.Type p0, String p1, int p2){}
    public Token.Type getType(){ return null; }
    public boolean test(Token.Type p0){ return false; }
    public boolean test(Token.Type p0, String... p1){ return false; }
    public int getLineNumber(){ return 0; }
    public void setLineNumber(int p0){}
    public void setType(Token.Type p0){}
    public void setValue(String p0){}
    static public enum Type
    {
        EOF, EXECUTE_END, EXECUTE_START, LONG, NAME, NUMBER, OPERATOR, PRINT_END, PRINT_START, PUNCTUATION, STRING, STRING_INTERPOLATION_END, STRING_INTERPOLATION_START, TEXT;
        private Type() {}
    }
}
