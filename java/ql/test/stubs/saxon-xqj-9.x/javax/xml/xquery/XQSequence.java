package javax.xml.xquery;

public interface XQSequence extends XQItemAccessor {
    boolean next() throws XQException;
}
