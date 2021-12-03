package javax.xml.xquery;

import java.io.InputStream;
import java.io.Reader;

public interface XQExpression extends XQDynamicContext {

    void cancel() throws XQException;

    boolean isClosed();

    void close() throws XQException;

    void executeCommand(String var1) throws XQException;

    void executeCommand(Reader var1) throws XQException;

    XQResultSequence executeQuery(String var1) throws XQException;

    XQResultSequence executeQuery(Reader var1) throws XQException;

    XQResultSequence executeQuery(InputStream var1) throws XQException;

    XQStaticContext getStaticContext() throws XQException;
}