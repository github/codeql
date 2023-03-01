// Generated automatically from javax.jdo.query.DateExpression for testing purposes

package javax.jdo.query;

import java.sql.Date;
import javax.jdo.query.ComparableExpression;
import javax.jdo.query.NumericExpression;

public interface DateExpression extends javax.jdo.query.ComparableExpression<Date>
{
    NumericExpression<Integer> getDay();
    NumericExpression<Integer> getMonth();
    NumericExpression<Integer> getYear();
}
