// Generated automatically from org.jdbi.v3.core.Jdbi for testing purposes

package org.jdbi.v3.core;

import java.sql.Connection;
import java.util.Properties;
import javax.sql.DataSource;
import org.jdbi.v3.core.ConnectionFactory;
import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.HandleCallback;
import org.jdbi.v3.core.HandleConsumer;
import org.jdbi.v3.core.config.ConfigRegistry;
import org.jdbi.v3.core.config.Configurable;
import org.jdbi.v3.core.extension.ExtensionCallback;
import org.jdbi.v3.core.extension.ExtensionConsumer;
import org.jdbi.v3.core.spi.JdbiPlugin;
import org.jdbi.v3.core.statement.StatementBuilderFactory;
import org.jdbi.v3.core.transaction.TransactionHandler;
import org.jdbi.v3.core.transaction.TransactionIsolationLevel;

public class Jdbi implements Configurable<Jdbi>
{
    protected Jdbi() {}
    public <E, X extends Exception> void useExtension(java.lang.Class<E> p0, ExtensionConsumer<E, X> p1){}
    public <E> E onDemand(java.lang.Class<E> p0){ return null; }
    public <R, E, X extends Exception> R withExtension(java.lang.Class<E> p0, ExtensionCallback<R, E, X> p1){ return null; }
    public <R, X extends Exception> R inTransaction(TransactionIsolationLevel p0, org.jdbi.v3.core.HandleCallback<R, X> p1){ return null; }
    public <R, X extends Exception> R inTransaction(org.jdbi.v3.core.HandleCallback<R, X> p0){ return null; }
    public <R, X extends Exception> R withHandle(org.jdbi.v3.core.HandleCallback<R, X> p0){ return null; }
    public <X extends Exception> void useHandle(org.jdbi.v3.core.HandleConsumer<X> p0){}
    public <X extends Exception> void useTransaction(TransactionIsolationLevel p0, org.jdbi.v3.core.HandleConsumer<X> p1){}
    public <X extends Exception> void useTransaction(org.jdbi.v3.core.HandleConsumer<X> p0){}
    public ConfigRegistry getConfig(){ return null; }
    public Handle open(){ return null; }
    public Jdbi installPlugin(JdbiPlugin p0){ return null; }
    public Jdbi installPlugins(){ return null; }
    public Jdbi setStatementBuilderFactory(StatementBuilderFactory p0){ return null; }
    public Jdbi setTransactionHandler(TransactionHandler p0){ return null; }
    public StatementBuilderFactory getStatementBuilderFactory(){ return null; }
    public TransactionHandler getTransactionHandler(){ return null; }
    public static Handle open(Connection p0){ return null; }
    public static Handle open(ConnectionFactory p0){ return null; }
    public static Handle open(DataSource p0){ return null; }
    public static Handle open(String p0){ return null; }
    public static Handle open(String p0, Properties p1){ return null; }
    public static Handle open(String p0, String p1, String p2){ return null; }
    public static Jdbi create(Connection p0){ return null; }
    public static Jdbi create(ConnectionFactory p0){ return null; }
    public static Jdbi create(DataSource p0){ return null; }
    public static Jdbi create(String p0){ return null; }
    public static Jdbi create(String p0, Properties p1){ return null; }
    public static Jdbi create(String p0, String p1, String p2){ return null; }
}
