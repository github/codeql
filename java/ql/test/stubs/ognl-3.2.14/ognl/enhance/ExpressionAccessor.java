package ognl.enhance;

import ognl.Node;
import ognl.OgnlContext;

public interface ExpressionAccessor
{
    Object get( OgnlContext context, Object target );

    void set( OgnlContext context, Object target, Object value );

    void setExpression( Node expression );
}
