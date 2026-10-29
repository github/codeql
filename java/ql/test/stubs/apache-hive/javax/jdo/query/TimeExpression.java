// Generated automatically from javax.jdo.query.TimeExpression for testing purposes

package javax.jdo.query;

import java.sql.Time;
import javax.jdo.query.ComparableExpression;
import javax.jdo.query.NumericExpression;

public interface TimeExpression extends ComparableExpression<Time>
{
    NumericExpression<Integer> getHour();
    NumericExpression<Integer> getMinute();
    NumericExpression<Integer> getSecond();
}
