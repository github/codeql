package net.sf.saxon.xqj;

import javax.xml.xquery.XQException;
import javax.xml.xquery.XQDataFactory;
import javax.xml.xquery.XQItemType;

public abstract class SaxonXQDataFactory extends Closable implements XQDataFactory { 
    public XQItemType createAtomicType(int baseType) throws XQException {
        return null;
    }
}
