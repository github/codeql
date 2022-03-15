import java.io.File;
import java.util.Properties;
import org.apache.commons.lang3.SystemUtils;
import com.google.common.base.StandardSystemProperty;

public class SystemPropertyAccess {
    private static final Properties SYSTEM_PROPERTIES = System.getProperties();

    void test() {
        System.getProperty("os.name");
        System.getProperty("os.name", "default");
        System.getProperties().getProperty("os.name");
        System.getProperties().get("java.io.tmpdir");
        SYSTEM_PROPERTIES.getProperty("java.home");
        SYSTEM_PROPERTIES.get("file.encoding");
        System.lineSeparator();
        String awtToolkit = SystemUtils.AWT_TOOLKIT;
        String fileEncoding = SystemUtils.FILE_ENCODING;
        String tmpDir = SystemUtils.JAVA_IO_TMPDIR;
        String separator = File.separator;
        char separatorChar = File.separatorChar;
        String pathSeparator = File.pathSeparator;
        char pathSeparatorChar = File.pathSeparatorChar;
        StandardSystemProperty.JAVA_VERSION.value();
        StandardSystemProperty property = StandardSystemProperty.JAVA_VERSION;
        property.value();
        System.getProperty(StandardSystemProperty.JAVA_IO_TMPDIR.key());
    }
    
}
