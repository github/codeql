// Generated automatically from org.jdbi.v3.core.argument.internal.NamedArgumentFinderFactory for testing purposes

package org.jdbi.v3.core.argument.internal;

import java.lang.reflect.Type;
import java.util.Optional;
import java.util.function.Function;
import org.jdbi.v3.core.argument.Argument;
import org.jdbi.v3.core.config.ConfigRegistry;
import org.jdbi.v3.core.qualifier.QualifiedType;

public interface NamedArgumentFinderFactory
{
    Function<String, Optional<Function<Object, Argument>>> prepareFor(ConfigRegistry p0, Function<QualifiedType<? extends Object>, Function<Object, Argument>> p1, String p2, Object p3, Type p4);
    NamedArgumentFinderFactory.PrepareKey keyFor(String p0, Object p1);
    static NamedArgumentFinderFactory BEAN = null;
    static NamedArgumentFinderFactory FIELDS = null;
    static NamedArgumentFinderFactory METHODS = null;
    static NamedArgumentFinderFactory POJO = null;
    static public class PrepareKey
    {
        protected PrepareKey() {}
        public boolean equals(Object p0){ return false; }
        public int hashCode(){ return 0; }
    }
}
