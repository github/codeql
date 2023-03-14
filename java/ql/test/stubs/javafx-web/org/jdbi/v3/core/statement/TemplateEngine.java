// Generated automatically from org.jdbi.v3.core.statement.TemplateEngine for testing purposes

package org.jdbi.v3.core.statement;

import java.util.Optional;
import java.util.function.Function;
import org.jdbi.v3.core.config.ConfigRegistry;
import org.jdbi.v3.core.statement.StatementContext;

public interface TemplateEngine
{
    String render(String p0, StatementContext p1);
    default Optional<Function<StatementContext, String>> parse(String p0, ConfigRegistry p1){ return null; }
    static TemplateEngine NOP = null;
}
