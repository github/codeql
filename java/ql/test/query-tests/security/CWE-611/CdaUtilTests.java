import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.Socket;
import org.openhealthtools.mdht.uml.cda.util.CDAUtil;
import org.xml.sax.InputSource;

public class CdaUtilTests {

    public void test(Socket sock) throws Exception {
        InputStream is = sock.getInputStream();
        InputSource iSrc = new InputSource(new InputStreamReader(is));
        CDAUtil.load(is); // $ hasTaintFlow
        CDAUtil.load(iSrc); // $ hasTaintFlow
        CDAUtil.load(is, (CDAUtil.ValidationHandler) null); // $ hasTaintFlow
        CDAUtil.load(is, (CDAUtil.LoadHandler) null); // $ hasTaintFlow
        CDAUtil.load(null, null, is, null); // $ hasTaintFlow
        CDAUtil.load(iSrc, (CDAUtil.ValidationHandler) null); // $ hasTaintFlow
        CDAUtil.load(iSrc, (CDAUtil.LoadHandler) null); // $ hasTaintFlow
        CDAUtil.load(null, null, iSrc, null); // $ hasTaintFlow
        CDAUtil.loadAs(is, null); // $ hasTaintFlow
        CDAUtil.loadAs(is, null, null); // $ hasTaintFlow
    }
}
