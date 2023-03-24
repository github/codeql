// Generated automatically from org.jdbi.v3.core.argument.NamedArgumentFinder for testing purposes

package org.jdbi.v3.core.argument;

import java.util.Collection;
import java.util.Optional;
import org.jdbi.v3.core.argument.Argument;
import org.jdbi.v3.core.statement.StatementContext;

public interface NamedArgumentFinder
{
    Optional<Argument> find(String p0, StatementContext p1);
    default Collection<String> getNames(){ return null; }
}
