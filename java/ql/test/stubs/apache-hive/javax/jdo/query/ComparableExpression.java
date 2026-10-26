// Generated automatically from javax.jdo.query.ComparableExpression for testing purposes

package javax.jdo.query;

import javax.jdo.query.BooleanExpression;
import javax.jdo.query.Expression;
import javax.jdo.query.NumericExpression;
import javax.jdo.query.OrderExpression;

public interface ComparableExpression<T> extends javax.jdo.query.Expression<T>
{
    BooleanExpression gt(ComparableExpression p0);
    BooleanExpression gt(T p0);
    BooleanExpression gteq(ComparableExpression p0);
    BooleanExpression gteq(T p0);
    BooleanExpression lt(ComparableExpression p0);
    BooleanExpression lt(T p0);
    BooleanExpression lteq(ComparableExpression p0);
    BooleanExpression lteq(T p0);
    NumericExpression max();
    NumericExpression min();
    OrderExpression asc();
    OrderExpression desc();
}
