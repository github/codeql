import javax.servlet.http.HttpServletRequest;
import javax.xml.namespace.QName;
import javax.xml.xquery.XQConnection;
import javax.xml.xquery.XQDataSource;
import javax.xml.xquery.XQException;
import javax.xml.xquery.XQItemType;
import javax.xml.xquery.XQPreparedExpression;
import javax.xml.xquery.XQResultSequence;
import net.sf.saxon.xqj.SaxonXQDataSource;

public void bad(HttpServletRequest request) throws XQException {
    String name = request.getParameter("name");
    XQDataSource ds = new SaxonXQDataSource();
    XQConnection conn = ds.getConnection();
    String query = "for $user in doc(\"users.xml\")/Users/User[name='" + name + "'] return $user/password";
    XQPreparedExpression xqpe = conn.prepareExpression(query);
    XQResultSequence result = xqpe.executeQuery();
    while (result.next()){
        System.out.println(result.getItemAsString(null));
    }
}

public void good(HttpServletRequest request) throws XQException {
    String name = request.getParameter("name");
    XQDataSource ds = new SaxonXQDataSource();
    XQConnection conn = ds.getConnection();
    String query = "declare variable $name as xs:string external;"
            + " for $user in doc(\"users.xml\")/Users/User[name=$name] return $user/password";
    XQPreparedExpression xqpe = conn.prepareExpression(query);
    xqpe.bindString(new QName("name"), name, conn.createAtomicType(XQItemType.XQBASETYPE_STRING));
    XQResultSequence result = xqpe.executeQuery();
    while (result.next()){
        System.out.println(result.getItemAsString(null));
    }
}