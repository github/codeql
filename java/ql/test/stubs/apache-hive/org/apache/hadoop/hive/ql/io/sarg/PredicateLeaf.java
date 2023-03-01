// Generated automatically from org.apache.hadoop.hive.ql.io.sarg.PredicateLeaf for testing purposes

package org.apache.hadoop.hive.ql.io.sarg;

import java.util.List;

public interface PredicateLeaf
{
    List<Object> getLiteralList();
    Object getLiteral();
    PredicateLeaf.Operator getOperator();
    PredicateLeaf.Type getType();
    String getColumnName();
    static public enum Operator
    {
        BETWEEN, EQUALS, IN, IS_NULL, LESS_THAN, LESS_THAN_EQUALS, NULL_SAFE_EQUALS;
        private Operator() {}
    }
    static public enum Type
    {
        BOOLEAN, DATE, DECIMAL, FLOAT, LONG, STRING, TIMESTAMP;
        private Type() {}
        public Class getValueClass(){ return null; }
    }
}
