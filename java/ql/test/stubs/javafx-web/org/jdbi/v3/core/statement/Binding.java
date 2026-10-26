// Generated automatically from org.jdbi.v3.core.statement.Binding for testing purposes

package org.jdbi.v3.core.statement;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import org.jdbi.v3.core.argument.Argument;
import org.jdbi.v3.core.argument.NamedArgumentFinder;
import org.jdbi.v3.core.qualifier.QualifiedType;
import org.jdbi.v3.core.statement.StatementContext;

public class Binding
{
    protected Binding() {}
    protected Binding(StatementContext p0){}
    protected final List<NamedArgumentFinder> namedArgumentFinder = null;
    protected final Map<Integer, Object> positionals = null;
    protected final Map<String, Object> named = null;
    public Collection<String> getNames(){ return null; }
    public Optional<Argument> findForName(String p0, StatementContext p1){ return null; }
    public Optional<Argument> findForPosition(int p0){ return null; }
    public String toString(){ return null; }
    public boolean isEmpty(){ return false; }
    public void addNamed(String p0, Argument p1){}
    public void addNamed(String p0, Object p1){}
    public void addNamed(String p0, Object p1, QualifiedType<? extends Object> p2){}
    public void addNamedArgumentFinder(NamedArgumentFinder p0){}
    public void addPositional(int p0, Argument p1){}
    public void addPositional(int p0, Object p1){}
    public void addPositional(int p0, Object p1, QualifiedType<? extends Object> p2){}
    public void clear(){}
}
