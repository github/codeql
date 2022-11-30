// Generated automatically from org.apache.velocity.runtime.parser.node.Node for testing purposes

package org.apache.velocity.runtime.parser.node;

import java.io.Writer;
import org.apache.velocity.Template;
import org.apache.velocity.context.InternalContextAdapter;
import org.apache.velocity.runtime.Renderable;
import org.apache.velocity.runtime.parser.Parser;
import org.apache.velocity.runtime.parser.Token;
import org.apache.velocity.runtime.parser.node.ParserVisitor;

public interface Node extends Renderable
{
    Node jjtGetChild(int p0);
    Node jjtGetParent();
    Object childrenAccept(ParserVisitor p0, Object p1);
    Object execute(Object p0, InternalContextAdapter p1);
    Object init(InternalContextAdapter p0, Object p1);
    Object jjtAccept(ParserVisitor p0, Object p1);
    Object value(InternalContextAdapter p0);
    Parser getParser();
    String getFirstTokenImage();
    String getLastTokenImage();
    String getTemplateName();
    String literal();
    Template getTemplate();
    Token getFirstToken();
    Token getLastToken();
    boolean evaluate(InternalContextAdapter p0);
    boolean isInvalid();
    boolean render(InternalContextAdapter p0, Writer p1);
    int getColumn();
    int getInfo();
    int getLine();
    int getType();
    int jjtGetNumChildren();
    void jjtAddChild(Node p0, int p1);
    void jjtClose();
    void jjtOpen();
    void jjtSetParent(Node p0);
    void setInfo(int p0);
    void setInvalid();
}
