package javax.xml.xquery;

public interface XQPreparedExpression extends XQDynamicContext {
    XQResultSequence executeQuery() throws XQException;
}
