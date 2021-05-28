package javax.xml.xquery;

public interface XQDataSource {
  XQConnection getConnection() throws XQException;
}
