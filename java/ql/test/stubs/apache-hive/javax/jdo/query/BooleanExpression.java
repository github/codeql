// Generated automatically from javax.jdo.query.BooleanExpression for testing purposes

package javax.jdo.query;

import javax.jdo.query.ComparableExpression;

public interface BooleanExpression extends ComparableExpression<Boolean>
{
    BooleanExpression and(BooleanExpression p0);
    BooleanExpression neg();
    BooleanExpression not();
    BooleanExpression or(BooleanExpression p0);
}
