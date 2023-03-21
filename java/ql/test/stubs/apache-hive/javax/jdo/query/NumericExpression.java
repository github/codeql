// Generated automatically from javax.jdo.query.NumericExpression for testing purposes

package javax.jdo.query;

import javax.jdo.query.ComparableExpression;
import javax.jdo.query.Expression;

public interface NumericExpression<T> extends ComparableExpression<Number>
{
    NumericExpression abs();
    NumericExpression acos();
    NumericExpression add(Expression p0);
    NumericExpression add(Number p0);
    NumericExpression asin();
    NumericExpression atan();
    NumericExpression avg();
    NumericExpression bAnd(NumericExpression p0);
    NumericExpression bOr(NumericExpression p0);
    NumericExpression bXor(NumericExpression p0);
    NumericExpression ceil();
    NumericExpression com();
    NumericExpression cos();
    NumericExpression div(Expression p0);
    NumericExpression div(Number p0);
    NumericExpression exp();
    NumericExpression floor();
    NumericExpression log();
    NumericExpression mod(Expression p0);
    NumericExpression mod(Number p0);
    NumericExpression mul(Expression p0);
    NumericExpression mul(Number p0);
    NumericExpression neg();
    NumericExpression sin();
    NumericExpression sqrt();
    NumericExpression sub(Expression p0);
    NumericExpression sub(Number p0);
    NumericExpression sum();
    NumericExpression tan();
}
