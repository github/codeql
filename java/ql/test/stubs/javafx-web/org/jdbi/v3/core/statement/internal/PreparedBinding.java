// Generated automatically from org.jdbi.v3.core.statement.internal.PreparedBinding for testing purposes

package org.jdbi.v3.core.statement.internal;

import java.util.List;
import java.util.Map;
import java.util.function.Supplier;
import org.jdbi.v3.core.argument.NamedArgumentFinder;
import org.jdbi.v3.core.argument.internal.NamedArgumentFinderFactory;
import org.jdbi.v3.core.statement.Binding;
import org.jdbi.v3.core.statement.StatementContext;

public class PreparedBinding extends Binding
{
    protected PreparedBinding() {}
    public PreparedBinding(StatementContext p0){}
    public boolean isEmpty(){ return false; }
    public final List<Supplier<NamedArgumentFinder>> backupArgumentFinders = null;
    public final Map<NamedArgumentFinderFactory.PrepareKey, Object> prepareKeys = null;
    public final Supplier<List<NamedArgumentFinder>> realizedBackupArgumentFinders = null;
    public void clear(){}
}
