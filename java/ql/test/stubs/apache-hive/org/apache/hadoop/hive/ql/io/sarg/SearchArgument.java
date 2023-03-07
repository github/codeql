// Generated automatically from org.apache.hadoop.hive.ql.io.sarg.SearchArgument for testing purposes

package org.apache.hadoop.hive.ql.io.sarg;

import java.util.List;
import org.apache.hadoop.hive.ql.io.sarg.ExpressionTree;
import org.apache.hadoop.hive.ql.io.sarg.PredicateLeaf;

public interface SearchArgument
{
    ExpressionTree getExpression();
    List<PredicateLeaf> getLeaves();
    SearchArgument.TruthValue evaluate(SearchArgument.TruthValue[] p0);
    static public enum TruthValue
    {
        NO, NO_NULL, NULL, YES, YES_NO, YES_NO_NULL, YES_NULL;
        private TruthValue() {}
        public SearchArgument.TruthValue and(SearchArgument.TruthValue p0){ return null; }
        public SearchArgument.TruthValue not(){ return null; }
        public SearchArgument.TruthValue or(SearchArgument.TruthValue p0){ return null; }
        public boolean isNeeded(){ return false; }
    }
}
