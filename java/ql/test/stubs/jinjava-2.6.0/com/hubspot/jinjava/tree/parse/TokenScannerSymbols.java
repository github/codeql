// Generated automatically from com.hubspot.jinjava.tree.parse.TokenScannerSymbols for testing purposes

package com.hubspot.jinjava.tree.parse;

import java.io.Serializable;

abstract public class TokenScannerSymbols implements Serializable
{
    public String getClosingComment(){ return null; }
    public String getExpressionEnd(){ return null; }
    public String getExpressionEndWithTag(){ return null; }
    public String getExpressionStart(){ return null; }
    public String getExpressionStartWithTag(){ return null; }
    public TokenScannerSymbols(){}
    public abstract char getExprEndChar();
    public abstract char getExprStartChar();
    public abstract char getFixedChar();
    public abstract char getNewlineChar();
    public abstract char getNoteChar();
    public abstract char getPostfixChar();
    public abstract char getPrefixChar();
    public abstract char getTagChar();
    public abstract char getTrimChar();
    public int getExprEnd(){ return 0; }
    public int getExprStart(){ return 0; }
    public int getFixed(){ return 0; }
    public int getNewline(){ return 0; }
    public int getNote(){ return 0; }
    public int getPostfix(){ return 0; }
    public int getPrefix(){ return 0; }
    public int getTag(){ return 0; }
    public int getTrim(){ return 0; }
}
