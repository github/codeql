// Generated automatically from org.apache.velocity.runtime.parser.node.ASTMathNode for testing purposes

package org.apache.velocity.runtime.parser.node;

import org.apache.velocity.context.InternalContextAdapter;
import org.apache.velocity.runtime.parser.Parser;
import org.apache.velocity.runtime.parser.node.ASTBinaryOperator;
import org.apache.velocity.runtime.parser.node.ParserVisitor;

abstract public class ASTMathNode extends ASTBinaryOperator
{
    protected ASTMathNode() {}
    protected Object handleSpecial(Object p0, Object p1, InternalContextAdapter p2){ return null; }
    protected boolean strictMode = false;
    public ASTMathNode(Parser p0, int p1){}
    public ASTMathNode(int p0){}
    public Object init(InternalContextAdapter p0, Object p1){ return null; }
    public Object jjtAccept(ParserVisitor p0, Object p1){ return null; }
    public Object value(InternalContextAdapter p0){ return null; }
    public abstract Number perform(Number p0, Number p1, InternalContextAdapter p2);
}
