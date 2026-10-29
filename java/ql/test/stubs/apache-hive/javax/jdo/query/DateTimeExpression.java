// Generated automatically from javax.jdo.query.DateTimeExpression for testing purposes

package javax.jdo.query;

import java.util.Date;
import javax.jdo.query.ComparableExpression;
import javax.jdo.query.NumericExpression;

public interface DateTimeExpression extends javax.jdo.query.ComparableExpression<Date>
{
    NumericExpression<Integer> getDay();
    NumericExpression<Integer> getHour();
    NumericExpression<Integer> getMinute();
    NumericExpression<Integer> getMonth();
    NumericExpression<Integer> getSecond();
    NumericExpression<Integer> getYear();
}
