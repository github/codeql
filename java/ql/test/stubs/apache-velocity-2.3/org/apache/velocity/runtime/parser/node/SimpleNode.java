// Generated automatically from org.apache.velocity.runtime.parser.node.SimpleNode for testing purposes

package org.apache.velocity.runtime.parser.node;

import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.Writer;
import org.apache.velocity.Template;
import org.apache.velocity.context.InternalContextAdapter;
import org.apache.velocity.runtime.RuntimeServices;
import org.apache.velocity.runtime.parser.Parser;
import org.apache.velocity.runtime.parser.Token;
import org.apache.velocity.runtime.parser.node.Node;
import org.apache.velocity.runtime.parser.node.ParserVisitor;
import org.slf4j.Logger;

public class SimpleNode implements Node
{
    protected SimpleNode() {}
    protected Logger log = null;
    protected Node parent = null;
    protected Node[] children = null;
    protected Parser parser = null;
    protected RuntimeServices rsvc = null;
    protected String firstImage = null;
    protected String getLocation(InternalContextAdapter p0){ return null; }
    protected String lastImage = null;
    protected String literal = null;
    protected Template template = null;
    protected Token first = null;
    protected Token last = null;
    protected boolean invalid = false;
    protected int column = 0;
    protected int id = 0;
    protected int info = 0;
    protected int line = 0;
    public Node jjtGetChild(int p0){ return null; }
    public Node jjtGetParent(){ return null; }
    public Object childrenAccept(ParserVisitor p0, Object p1){ return null; }
    public Object execute(Object p0, InternalContextAdapter p1){ return null; }
    public Object init(InternalContextAdapter p0, Object p1){ return null; }
    public Object jjtAccept(ParserVisitor p0, Object p1){ return null; }
    public Object value(InternalContextAdapter p0){ return null; }
    public Parser getParser(){ return null; }
    public RuntimeServices getRuntimeServices(){ return null; }
    public SimpleNode(Parser p0, int p1){}
    public SimpleNode(int p0){}
    public String getFirstTokenImage(){ return null; }
    public String getLastTokenImage(){ return null; }
    public String getTemplateName(){ return null; }
    public String literal(){ return null; }
    public String toString(){ return null; }
    public String toString(String p0){ return null; }
    public Template getTemplate(){ return null; }
    public Token getFirstToken(){ return null; }
    public Token getLastToken(){ return null; }
    public boolean evaluate(InternalContextAdapter p0){ return false; }
    public boolean isInvalid(){ return false; }
    public boolean render(InternalContextAdapter p0, Writer p1){ return false; }
    public boolean state = false;
    public final void dump(String p0){}
    public final void dump(String p0, PrintStream p1){}
    public int getColumn(){ return 0; }
    public int getInfo(){ return 0; }
    public int getLine(){ return 0; }
    public int getType(){ return 0; }
    public int jjtGetNumChildren(){ return 0; }
    public void cleanupParserAndTokens(){}
    public void dump(String p0, PrintWriter p1){}
    public void jjtAddChild(Node p0, int p1){}
    public void jjtClose(){}
    public void jjtOpen(){}
    public void jjtSetParent(Node p0){}
    public void saveTokenImages(){}
    public void setFirstToken(Token p0){}
    public void setInfo(int p0){}
    public void setInvalid(){}
}
