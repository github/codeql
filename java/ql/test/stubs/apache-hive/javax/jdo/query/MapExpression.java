// Generated automatically from javax.jdo.query.MapExpression for testing purposes

package javax.jdo.query;

import java.util.Map;
import javax.jdo.query.BooleanExpression;
import javax.jdo.query.Expression;
import javax.jdo.query.NumericExpression;

public interface MapExpression<T extends java.util.Map<K, V>, K, V> extends javax.jdo.query.Expression<T>
{
    BooleanExpression containsEntry(Expression<Map.Entry<K, V>> p0);
    BooleanExpression containsEntry(Map.Entry<K, V> p0);
    BooleanExpression containsKey(Expression<K> p0);
    BooleanExpression containsKey(K p0);
    BooleanExpression containsValue(V p0);
    BooleanExpression containsValue(javax.jdo.query.Expression<V> p0);
    BooleanExpression isEmpty();
    NumericExpression<Integer> size();
}
