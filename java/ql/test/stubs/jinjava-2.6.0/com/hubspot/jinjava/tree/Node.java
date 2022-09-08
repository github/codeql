// Generated automatically from com.hubspot.jinjava.tree.Node for testing purposes

package com.hubspot.jinjava.tree;

import com.hubspot.jinjava.interpret.JinjavaInterpreter;
import com.hubspot.jinjava.tree.output.OutputNode;
import com.hubspot.jinjava.tree.parse.Token;
import com.hubspot.jinjava.tree.parse.TokenScannerSymbols;
import java.io.Serializable;
import java.util.LinkedList;

abstract public class Node implements Serializable
{
    protected Node() {}
    public LinkedList<Node> getChildren(){ return null; }
    public Node getParent(){ return null; }
    public Node(Token p0, int p1, int p2){}
    public String reconstructImage(){ return null; }
    public String toTreeString(){ return null; }
    public String toTreeString(int p0){ return null; }
    public Token getMaster(){ return null; }
    public TokenScannerSymbols getSymbols(){ return null; }
    public abstract OutputNode render(JinjavaInterpreter p0);
    public abstract String getName();
    public int getLineNumber(){ return 0; }
    public int getStartPosition(){ return 0; }
    public void setChildren(LinkedList<Node> p0){}
    public void setParent(Node p0){}
}
