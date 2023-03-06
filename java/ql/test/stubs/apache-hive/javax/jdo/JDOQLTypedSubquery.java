// Generated automatically from javax.jdo.JDOQLTypedSubquery for testing purposes

package javax.jdo;

import java.io.Serializable;
import java.util.Collection;
import javax.jdo.query.BooleanExpression;
import javax.jdo.query.CharacterExpression;
import javax.jdo.query.CollectionExpression;
import javax.jdo.query.DateExpression;
import javax.jdo.query.DateTimeExpression;
import javax.jdo.query.Expression;
import javax.jdo.query.NumericExpression;
import javax.jdo.query.PersistableExpression;
import javax.jdo.query.StringExpression;
import javax.jdo.query.TimeExpression;

public interface JDOQLTypedSubquery<T> extends Serializable
{
    <S> NumericExpression<S> selectUnique(NumericExpression<S> p0);
    CharacterExpression selectUnique(CharacterExpression p0);
    CollectionExpression<? extends Object, ? extends Object> select(CollectionExpression<? extends Object, ? extends Object> p0);
    DateExpression selectUnique(DateExpression p0);
    DateTimeExpression selectUnique(DateTimeExpression p0);
    JDOQLTypedSubquery<T> filter(BooleanExpression p0);
    JDOQLTypedSubquery<T> groupBy(Expression<? extends Object>... p0);
    JDOQLTypedSubquery<T> having(Expression<? extends Object> p0);
    StringExpression selectUnique(StringExpression p0);
    TimeExpression selectUnique(TimeExpression p0);
    javax.jdo.query.PersistableExpression<T> candidate();
}
