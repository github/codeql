// Generated automatically from javax.jdo.query.Expression for testing purposes

package javax.jdo.query;

import javax.jdo.query.BooleanExpression;
import javax.jdo.query.NumericExpression;

public interface Expression<T>
{
    BooleanExpression eq(Expression p0);
    BooleanExpression eq(T p0);
    BooleanExpression instanceOf(Class p0);
    BooleanExpression ne(Expression p0);
    BooleanExpression ne(T p0);
    Expression cast(Class p0);
    NumericExpression<Long> count();
    NumericExpression<Long> countDistinct();
}
