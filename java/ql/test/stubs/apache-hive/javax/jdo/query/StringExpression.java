// Generated automatically from javax.jdo.query.StringExpression for testing purposes

package javax.jdo.query;

import javax.jdo.query.BooleanExpression;
import javax.jdo.query.CharacterExpression;
import javax.jdo.query.ComparableExpression;
import javax.jdo.query.Expression;
import javax.jdo.query.NumericExpression;

public interface StringExpression extends ComparableExpression<String>
{
    BooleanExpression endsWith(String p0);
    BooleanExpression endsWith(StringExpression p0);
    BooleanExpression equalsIgnoreCase(String p0);
    BooleanExpression equalsIgnoreCase(StringExpression p0);
    BooleanExpression matches(String p0);
    BooleanExpression matches(StringExpression p0);
    BooleanExpression startsWith(String p0);
    BooleanExpression startsWith(StringExpression p0);
    CharacterExpression charAt(NumericExpression<Integer> p0);
    CharacterExpression charAt(int p0);
    NumericExpression<Integer> indexOf(String p0);
    NumericExpression<Integer> indexOf(String p0, NumericExpression<Integer> p1);
    NumericExpression<Integer> indexOf(String p0, int p1);
    NumericExpression<Integer> indexOf(StringExpression p0);
    NumericExpression<Integer> indexOf(StringExpression p0, NumericExpression<Integer> p1);
    NumericExpression<Integer> indexOf(StringExpression p0, int p1);
    NumericExpression<Integer> length();
    StringExpression add(Expression p0);
    StringExpression substring(NumericExpression<Integer> p0);
    StringExpression substring(NumericExpression<Integer> p0, NumericExpression<Integer> p1);
    StringExpression substring(int p0);
    StringExpression substring(int p0, int p1);
    StringExpression toLowerCase();
    StringExpression toUpperCase();
    StringExpression trim();
}
