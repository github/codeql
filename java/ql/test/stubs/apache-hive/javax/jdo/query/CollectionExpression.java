// Generated automatically from javax.jdo.query.CollectionExpression for testing purposes

package javax.jdo.query;

import java.util.Collection;
import javax.jdo.query.BooleanExpression;
import javax.jdo.query.Expression;
import javax.jdo.query.NumericExpression;

public interface CollectionExpression<T extends java.util.Collection<E>, E> extends javax.jdo.query.Expression<T>
{
    BooleanExpression contains(E p0);
    BooleanExpression contains(javax.jdo.query.Expression<E> p0);
    BooleanExpression isEmpty();
    NumericExpression<Integer> size();
}
