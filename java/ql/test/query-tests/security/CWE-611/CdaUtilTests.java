import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.Socket;
import org.openhealthtools.mdht.uml.cda.util.CDAUtil;
import org.xml.sax.InputSource;

public class CdaUtilTests {

    public void test(Socket sock) throws Exception {
        InputStream is = sock.getInputStream(); // $ Source
        InputSource iSrc = new InputSource(new InputStreamReader(is));
        CDAUtil.load(is); // $ Alert
        CDAUtil.load(iSrc); // $ Alert
        CDAUtil.load(is, (CDAUtil.ValidationHandler) null); // $ Alert
        CDAUtil.load(is, (CDAUtil.LoadHandler) null); // $ Alert
        CDAUtil.load(null, null, is, null); // $ Alert
        CDAUtil.load(iSrc, (CDAUtil.ValidationHandler) null); // $ Alert
        CDAUtil.load(iSrc, (CDAUtil.LoadHandler) null); // $ Alert
        CDAUtil.load(null, null, iSrc, null); // $ Alert
        CDAUtil.loadAs(is, null); // $ Alert
        CDAUtil.loadAs(is, null, null); // $ Alert
    }
}
