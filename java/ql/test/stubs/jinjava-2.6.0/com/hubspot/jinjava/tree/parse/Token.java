// Generated automatically from com.hubspot.jinjava.tree.parse.Token for testing purposes

package com.hubspot.jinjava.tree.parse;

import com.hubspot.jinjava.tree.parse.TokenScannerSymbols;
import java.io.Serializable;

abstract public class Token implements Serializable
{
    protected Token() {}
    protected String content = null;
    protected String image = null;
    protected abstract void parse();
    protected final int lineNumber = 0;
    protected final int startPosition = 0;
    public String getImage(){ return null; }
    public String toString(){ return null; }
    public Token(String p0, int p1, int p2, TokenScannerSymbols p3){}
    public TokenScannerSymbols getSymbols(){ return null; }
    public abstract int getType();
    public boolean isLeftTrim(){ return false; }
    public boolean isRightTrim(){ return false; }
    public boolean isRightTrimAfterEnd(){ return false; }
    public int getLineNumber(){ return 0; }
    public int getStartPosition(){ return 0; }
    public void mergeImageAndContent(Token p0){}
    public void setLeftTrim(boolean p0){}
    public void setRightTrim(boolean p0){}
    public void setRightTrimAfterEnd(boolean p0){}
}
