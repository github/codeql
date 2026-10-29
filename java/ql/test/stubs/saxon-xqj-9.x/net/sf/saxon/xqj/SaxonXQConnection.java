package net.sf.saxon.xqj;

import java.io.Reader;
import net.sf.saxon.Configuration;
import javax.xml.xquery.XQConnection;
import javax.xml.xquery.XQPreparedExpression;
import javax.xml.xquery.XQException;
import javax.xml.xquery.XQExpression;
import javax.xml.xquery.XQStaticContext;
import java.io.InputStream;

public class SaxonXQConnection extends SaxonXQDataFactory  implements XQConnection {
    
    private SaxonXQStaticContext staticContext;
   
    SaxonXQConnection(SaxonXQDataSource dataSource) {
    }

    public XQExpression createExpression() throws XQException {
        return null;
    }

    public XQPreparedExpression prepareExpression(InputStream xquery) throws XQException {
        return null;
    }
    
    public XQPreparedExpression prepareExpression(InputStream xquery, XQStaticContext properties) throws XQException {
        return null;
    }

    public XQPreparedExpression prepareExpression(Reader xquery) throws XQException {
        return null;
    }

    public XQPreparedExpression prepareExpression(Reader xquery, XQStaticContext properties){
        return null;
    }

    public XQPreparedExpression prepareExpression(String xquery) throws XQException {
        return null;
    }

    public XQPreparedExpression prepareExpression(String xquery, XQStaticContext properties) throws XQException {
        return null;
    }
}
