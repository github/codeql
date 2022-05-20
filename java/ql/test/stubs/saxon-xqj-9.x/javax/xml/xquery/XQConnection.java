package javax.xml.xquery;

import java.io.InputStream;
import java.io.Reader;

public interface XQConnection extends XQDataFactory {

    XQExpression createExpression() throws XQException;
    
    XQPreparedExpression prepareExpression(String var1) throws XQException;

    XQPreparedExpression prepareExpression(String var1, XQStaticContext var2) throws XQException;

    XQPreparedExpression prepareExpression(Reader var1) throws XQException;

    XQPreparedExpression prepareExpression(Reader var1, XQStaticContext var2) throws XQException;

    XQPreparedExpression prepareExpression(InputStream var1) throws XQException;

    XQPreparedExpression prepareExpression(InputStream var1, XQStaticContext var2) throws XQException;
}
