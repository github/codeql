// Generated automatically from javax.jdo.query.ListExpression for testing purposes

package javax.jdo.query;

import java.util.Collection;
import java.util.List;
import javax.jdo.query.CollectionExpression;
import javax.jdo.query.Expression;
import javax.jdo.query.NumericExpression;

public interface ListExpression<T extends java.util.List<E>, E> extends CollectionExpression<T, E>
{
    javax.jdo.query.Expression<E> get(NumericExpression<Integer> p0);
    javax.jdo.query.Expression<E> get(int p0);
}
