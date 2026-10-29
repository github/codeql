package net.sf.saxon.xqj;

import javax.xml.xquery.XQDataSource;
import javax.xml.xquery.XQException;
import javax.xml.xquery.XQConnection;

public class SaxonXQDataSource implements XQDataSource {

    public XQConnection getConnection() throws XQException {
        return new SaxonXQConnection(this);
    }
}
