// Generated automatically from javax.jdo.query.OrderExpression for testing purposes

package javax.jdo.query;

import javax.jdo.query.Expression;

public interface OrderExpression<T>
{
    OrderExpression.OrderDirection getDirection();
    javax.jdo.query.Expression<T> getExpression();
    static public enum OrderDirection
    {
        ASC, DESC;
        private OrderDirection() {}
    }
}
