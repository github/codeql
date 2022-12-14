// Generated automatically from org.apache.velocity.runtime.parser.node.ASTComparisonNode for testing purposes

package org.apache.velocity.runtime.parser.node;

import org.apache.velocity.context.InternalContextAdapter;
import org.apache.velocity.runtime.parser.Parser;
import org.apache.velocity.runtime.parser.node.ASTBinaryOperator;
import org.apache.velocity.runtime.parser.node.ParserVisitor;

abstract public class ASTComparisonNode extends ASTBinaryOperator
{
    protected ASTComparisonNode() {}
    public ASTComparisonNode(Parser p0, int p1){}
    public ASTComparisonNode(int p0){}
    public Boolean compareNumbers(Object p0, Object p1){ return null; }
    public Object jjtAccept(ParserVisitor p0, Object p1){ return null; }
    public Object value(InternalContextAdapter p0){ return null; }
    public abstract String getLiteralOperator();
    public abstract boolean numberTest(int p0);
    public boolean compareNonNumber(Object p0, Object p1){ return false; }
    public boolean compareNull(Object p0, Object p1){ return false; }
    public boolean evaluate(InternalContextAdapter p0){ return false; }
}
