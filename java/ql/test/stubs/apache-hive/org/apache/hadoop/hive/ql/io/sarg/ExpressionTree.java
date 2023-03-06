// Generated automatically from org.apache.hadoop.hive.ql.io.sarg.ExpressionTree for testing purposes

package org.apache.hadoop.hive.ql.io.sarg;

import java.util.List;
import org.apache.hadoop.hive.ql.io.sarg.SearchArgument;

public class ExpressionTree
{
    public ExpressionTree.Operator getOperator(){ return null; }
    public List<ExpressionTree> getChildren(){ return null; }
    public SearchArgument.TruthValue evaluate(SearchArgument.TruthValue[] p0){ return null; }
    public SearchArgument.TruthValue getConstant(){ return null; }
    public String toString(){ return null; }
    public int getLeaf(){ return 0; }
    public void setLeaf(int p0){}
    static public enum Operator
    {
        AND, CONSTANT, LEAF, NOT, OR;
        private Operator() {}
    }
}
