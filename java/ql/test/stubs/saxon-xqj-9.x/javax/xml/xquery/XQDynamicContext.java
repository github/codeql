package javax.xml.xquery;

import javax.xml.namespace.QName;

public interface XQDynamicContext {
    void bindString(QName var1, String var2, XQItemType var3) throws XQException;
}
