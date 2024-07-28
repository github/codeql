import java.util.ResourceBundle;
import java.util.logging.LogRecord;
import java.util.regex.Pattern;
import com.google.common.flogger.LoggingApi;
import org.apache.commons.logging.Log;
import org.apache.cxf.common.logging.LogUtils;
import org.apache.log4j.Category;
import org.apache.logging.log4j.Level;
import org.apache.logging.log4j.LogBuilder;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.Marker;
import org.apache.logging.log4j.message.EntryMessage;
import org.apache.logging.log4j.message.Message;
import org.apache.logging.log4j.util.MessageSupplier;
import org.apache.logging.log4j.util.Supplier;
import org.jboss.logging.BasicLogger;
import org.slf4j.spi.LoggingEventBuilder;

public class LogInjectionTest {
    public Object source() {
        return null;
    }

    public void testSanitizers() {
        String source = (String) source();
        Logger logger = null;
        logger.debug(source.replace("\n", "")); // Safe
        logger.debug(source.replace("\n", "\n")); // $ hasTaintFlow
        logger.debug(source.replace("\n", "\r")); // $ hasTaintFlow
        logger.debug(source.replace("\r", "")); // Safe
        logger.debug(source.replace("\r", "\n")); // $ hasTaintFlow
        logger.debug(source.replace("\r", "\r")); // $ hasTaintFlow
        logger.debug(source.replace("something_else", "")); // $ hasTaintFlow
        logger.debug(source.replace('\n', '_')); // Safe
        logger.debug(source.replace('\n', '\n')); // $ hasTaintFlow
        logger.debug(source.replace('\n', '\r')); // $ hasTaintFlow
        logger.debug(source.replace('\r', '_')); // Safe
        logger.debug(source.replace('\r', '\n')); // $ hasTaintFlow
        logger.debug(source.replace('\r', '\r')); // $ hasTaintFlow
        logger.debug(source.replace('-', '_')); // $ hasTaintFlow
        logger.debug(source.replaceAll("\n", "")); // Safe
        logger.debug(source.replaceAll("\n", "\n")); // $ hasTaintFlow
        logger.debug(source.replaceAll("\n", "\r")); // $ hasTaintFlow
        logger.debug(source.replaceAll("\r", "")); // Safe
        logger.debug(source.replaceAll("\r", "\n")); // $ hasTaintFlow
        logger.debug(source.replaceAll("\r", "\r")); // $ hasTaintFlow
        logger.debug(source.replaceAll("\\n", "")); // Safe
        logger.debug(source.replaceAll("\\n", "\n")); // $ hasTaintFlow
        logger.debug(source.replaceAll("\\n", "\r")); // $ hasTaintFlow
        logger.debug(source.replaceAll("\\r", "")); // Safe
        logger.debug(source.replaceAll("\\r", "\n")); // $ hasTaintFlow
        logger.debug(source.replaceAll("\\r", "\r")); // $ hasTaintFlow
        logger.debug(source.replaceAll("\\R", "")); // Safe
        logger.debug(source.replaceAll("\\R", "\n")); // $ hasTaintFlow
        logger.debug(source.replaceAll("\\R", "\r")); // $ hasTaintFlow
        logger.debug(source.replaceAll("[^a-zA-Z]", "")); // Safe
        logger.debug(source.replaceAll("[^a-zA-Z]", "\n")); // $ hasTaintFlow
        logger.debug(source.replaceAll("[^a-zA-Z]", "\r")); // $ hasTaintFlow
        logger.debug(source.replaceAll("[^a-zA-Z\n]", "")); // $ hasTaintFlow
        logger.debug(source.replaceAll("[^a-zA-Z\r]", "")); // $ hasTaintFlow
        logger.debug(source.replaceAll("[^a-zA-Z\\R]", "")); // $ hasTaintFlow
    }

    public void testGuards() {
        String source = (String) source();
        Logger logger = null;

        if (source.matches(".*\n.*")) {
            logger.debug(source); // $ hasTaintFlow
        } else {
            logger.debug(source); // Safe
        }

        if (Pattern.matches(".*\n.*", source)) {
            logger.debug(source); // $ hasTaintFlow
        } else {
            logger.debug(source); // Safe
        }

        if (source.matches(".*\\n.*")) {
            logger.debug(source); // $ hasTaintFlow
        } else {
            logger.debug(source); // Safe
        }

        if (Pattern.matches(".*\\n.*", source)) {
            logger.debug(source); // $ hasTaintFlow
        } else {
            logger.debug(source); // Safe
        }

        if (source.matches(".*\r.*")) {
            logger.debug(source); // $ hasTaintFlow
        } else {
            logger.debug(source); // Safe
        }

        if (Pattern.matches(".*\r.*", source)) {
            logger.debug(source); // $ hasTaintFlow
        } else {
            logger.debug(source); // Safe
        }

        if (source.matches(".*\\r.*")) {
            logger.debug(source); // $ hasTaintFlow
        } else {
            logger.debug(source); // Safe
        }

        if (Pattern.matches(".*\\r.*", source)) {
            logger.debug(source); // $ hasTaintFlow
        } else {
            logger.debug(source); // Safe
        }

        if (source.matches(".*\\R.*")) {
            logger.debug(source); // $ hasTaintFlow
        } else {
            logger.debug(source); // Safe
        }

        if (Pattern.matches(".*\\R.*", source)) {
            logger.debug(source); // $ hasTaintFlow
        } else {
            logger.debug(source); // Safe
        }

        if (source.matches(".*")) {
            logger.debug(source); // Safe (assuming not DOTALL)
        } else {
            logger.debug(source); // $ hasTaintFlow
        }

        if (Pattern.matches(".*", source)) {
            logger.debug(source); // Safe (assuming not DOTALL)
        } else {
            logger.debug(source); // $ hasTaintFlow
        }

        if (source.matches("[^\n\r]*")) {
            logger.debug(source); // Safe
        } else {
            logger.debug(source); // $ hasTaintFlow
        }

        if (Pattern.matches("[^\n\r]*", source)) {
            logger.debug(source); // Safe
        } else {
            logger.debug(source); // $ hasTaintFlow
        }

        if (source.matches("[^\\R]*")) {
            logger.debug(source); // Safe
        } else {
            logger.debug(source); // $ hasTaintFlow
        }

        if (Pattern.matches("[^\\R]*", source)) {
            logger.debug(source); // Safe
        } else {
            logger.debug(source); // $ hasTaintFlow
        }

        if (source.matches("[^a-zA-Z]*")) {
            logger.debug(source); // $ hasTaintFlow
        } else {
            logger.debug(source); // $ hasTaintFlow
        }

        if (Pattern.matches("[^a-zA-Z]*", source)) {
            logger.debug(source); // $ hasTaintFlow
        } else {
            logger.debug(source); // $ hasTaintFlow
        }

        if (source.matches("[\n]*")) {
            logger.debug(source); // $ hasTaintFlow
        } else {
            logger.debug(source); // $ MISSING: $ hasTaintFlow
        }

        if (Pattern.matches("[\n]*", source)) {
            logger.debug(source); // $ hasTaintFlow
        } else {
            logger.debug(source); // $ MISSING: $ hasTaintFlow
        }

    }

    public void test() {
        {
            Category category = null;
            category.assertLog(false, (String) source()); // $ hasTaintFlow
            category.debug(source()); // $ hasTaintFlow
            category.debug(source(), null); // $ hasTaintFlow
            category.error(source()); // $ hasTaintFlow
            category.error(source(), null); // $ hasTaintFlow
            category.fatal(source()); // $ hasTaintFlow
            category.fatal(source(), null); // $ hasTaintFlow
            category.forcedLog(null, null, source(), null); // $ hasTaintFlow
            category.info(source()); // $ hasTaintFlow
            category.info(source(), null); // $ hasTaintFlow
            category.l7dlog(null, null, new Object[] {source()}, null); // $ hasTaintFlow
            category.log(null, source()); // $ hasTaintFlow
            category.log(null, source(), null); // $ hasTaintFlow
            category.log(null, null, source(), null); // $ hasTaintFlow
            category.warn(source()); // $ hasTaintFlow
            category.warn(source(), null); // $ hasTaintFlow
        }
        {
            Logger logger = null;
            // @formatter:off
            logger.debug((CharSequence) source()); // $ hasTaintFlow
            logger.debug((CharSequence) source(), (Throwable) null); // $ hasTaintFlow
            logger.debug((Marker) null, (CharSequence) source()); // $ hasTaintFlow
            logger.debug((Marker) null, (CharSequence) source(), null); // $ hasTaintFlow
            logger.debug((Marker) null, (Message) source()); // $ hasTaintFlow
            logger.debug((Marker) null, (MessageSupplier) source()); // $ hasTaintFlow
            logger.debug((Marker) null, (MessageSupplier) source(), null); // $ hasTaintFlow
            logger.debug((Marker) null, source()); // $ hasTaintFlow
            logger.debug((Marker) null, (String) source()); // $ hasTaintFlow
            logger.debug((Marker) null, (String) source(), new Object[] {}); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) source()); // $ hasTaintFlow
            logger.debug((Marker) null, (String) source(), (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) source(), (Supplier<?>) null); // $ hasTaintFlow
            logger.debug((Marker) null, (String) null, (Supplier<?>) source()); // $ hasTaintFlow
            logger.debug((Marker) null, (String) source(), (Throwable) null); // $ hasTaintFlow
            logger.debug((Marker) null, (Supplier<?>) source()); // $ hasTaintFlow
            logger.debug((Marker) null, (Supplier<?>) source(), (Throwable) null); // $ hasTaintFlow
            logger.debug((MessageSupplier) source()); // $ hasTaintFlow
            logger.debug((MessageSupplier) source(), (Throwable) null); // $ hasTaintFlow
            logger.debug((Message) source()); // $ hasTaintFlow
            logger.debug((Message) source(), (Throwable) null); // $ hasTaintFlow
            logger.debug(source()); // $ hasTaintFlow
            logger.debug(source(), (Throwable) null); // $ hasTaintFlow
            logger.debug((String) source()); // $ hasTaintFlow
            logger.debug((String) source(), (Object[]) null); // $ hasTaintFlow
            logger.debug((String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.debug((String) null, (Object) source()); // $ hasTaintFlow
            logger.debug((String) source(), (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.debug((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.debug((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) source(), (Supplier<?>) null); // $ hasTaintFlow
            logger.debug((String) null, (Supplier<?>) source()); // $ hasTaintFlow
            logger.debug((String) source(), (Throwable) null); // $ hasTaintFlow
            logger.debug((Supplier<?>) source()); // $ hasTaintFlow
            logger.debug((Supplier<?>) source(), (Throwable) null); // $ hasTaintFlow
            logger.error((CharSequence) source()); // $ hasTaintFlow
            logger.error((CharSequence) source(), (Throwable) null); // $ hasTaintFlow
            logger.error((Marker) null, (CharSequence) source()); // $ hasTaintFlow
            logger.error((Marker) null, (CharSequence) source(), null); // $ hasTaintFlow
            logger.error((Marker) null, (Message) source()); // $ hasTaintFlow
            logger.error((Marker) null, (MessageSupplier) source()); // $ hasTaintFlow
            logger.error((Marker) null, (MessageSupplier) source(), null); // $ hasTaintFlow
            logger.error((Marker) null, source()); // $ hasTaintFlow
            logger.error((Marker) null, (String) source()); // $ hasTaintFlow
            logger.error((Marker) null, (String) source(), new Object[] {}); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) source()); // $ hasTaintFlow
            logger.error((Marker) null, (String) source(), (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) source(), (Supplier<?>) null); // $ hasTaintFlow
            logger.error((Marker) null, (String) null, (Supplier<?>) source()); // $ hasTaintFlow
            logger.error((Marker) null, (String) source(), (Throwable) null); // $ hasTaintFlow
            logger.error((Marker) null, (Supplier<?>) source()); // $ hasTaintFlow
            logger.error((Marker) null, (Supplier<?>) source(), (Throwable) null); // $ hasTaintFlow
            logger.error((MessageSupplier) source()); // $ hasTaintFlow
            logger.error((MessageSupplier) source(), (Throwable) null); // $ hasTaintFlow
            logger.error((Message) source()); // $ hasTaintFlow
            logger.error((Message) source(), (Throwable) null); // $ hasTaintFlow
            logger.error(source()); // $ hasTaintFlow
            logger.error(source(), (Throwable) null); // $ hasTaintFlow
            logger.error((String) source()); // $ hasTaintFlow
            logger.error((String) source(), (Object[]) null); // $ hasTaintFlow
            logger.error((String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.error((String) null, (Object) source()); // $ hasTaintFlow
            logger.error((String) source(), (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.error((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.error((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) source(), (Supplier<?>) null); // $ hasTaintFlow
            logger.error((String) null, (Supplier<?>) source()); // $ hasTaintFlow
            logger.error((String) source(), (Throwable) null); // $ hasTaintFlow
            logger.error((Supplier<?>) source()); // $ hasTaintFlow
            logger.error((Supplier<?>) source(), (Throwable) null); // $ hasTaintFlow
            logger.fatal((CharSequence) source()); // $ hasTaintFlow
            logger.fatal((CharSequence) source(), (Throwable) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (CharSequence) source()); // $ hasTaintFlow
            logger.fatal((Marker) null, (CharSequence) source(), null); // $ hasTaintFlow
            logger.fatal((Marker) null, (Message) source()); // $ hasTaintFlow
            logger.fatal((Marker) null, (MessageSupplier) source()); // $ hasTaintFlow
            logger.fatal((Marker) null, (MessageSupplier) source(), null); // $ hasTaintFlow
            logger.fatal((Marker) null, source()); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) source()); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) source(), new Object[] {}); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) source()); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) source(), (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) source(), (Supplier<?>) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) null, (Supplier<?>) source()); // $ hasTaintFlow
            logger.fatal((Marker) null, (String) source(), (Throwable) null); // $ hasTaintFlow
            logger.fatal((Marker) null, (Supplier<?>) source()); // $ hasTaintFlow
            logger.fatal((Marker) null, (Supplier<?>) source(), (Throwable) null); // $ hasTaintFlow
            logger.fatal((MessageSupplier) source()); // $ hasTaintFlow
            logger.fatal((MessageSupplier) source(), (Throwable) null); // $ hasTaintFlow
            logger.fatal((Message) source()); // $ hasTaintFlow
            logger.fatal((Message) source(), (Throwable) null); // $ hasTaintFlow
            logger.fatal(source()); // $ hasTaintFlow
            logger.fatal(source(), (Throwable) null); // $ hasTaintFlow
            logger.fatal((String) source()); // $ hasTaintFlow
            logger.fatal((String) source(), (Object[]) null); // $ hasTaintFlow
            logger.fatal((String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.fatal((String) null, (Object) source()); // $ hasTaintFlow
            logger.fatal((String) source(), (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.fatal((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.fatal((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatal((String) source(), (Supplier<?>) null); // $ hasTaintFlow
            logger.fatal((String) null, (Supplier<?>) source()); // $ hasTaintFlow
            logger.fatal((String) source(), (Throwable) null); // $ hasTaintFlow
            logger.fatal((Supplier<?>) source()); // $ hasTaintFlow
            logger.fatal((Supplier<?>) source(), (Throwable) null); // $ hasTaintFlow
            logger.info((CharSequence) source()); // $ hasTaintFlow
            logger.info((CharSequence) source(), (Throwable) null); // $ hasTaintFlow
            logger.info((Marker) null, (CharSequence) source()); // $ hasTaintFlow
            logger.info((Marker) null, (CharSequence) source(), null); // $ hasTaintFlow
            logger.info((Marker) null, (Message) source()); // $ hasTaintFlow
            logger.info((Marker) null, (MessageSupplier) source()); // $ hasTaintFlow
            logger.info((Marker) null, (MessageSupplier) source(), null); // $ hasTaintFlow
            logger.info((Marker) null, source()); // $ hasTaintFlow
            logger.info((Marker) null, (String) source()); // $ hasTaintFlow
            logger.info((Marker) null, (String) source(), new Object[] {}); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) source()); // $ hasTaintFlow
            logger.info((Marker) null, (String) source(), (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) source(), (Supplier<?>) null); // $ hasTaintFlow
            logger.info((Marker) null, (String) null, (Supplier<?>) source()); // $ hasTaintFlow
            logger.info((Marker) null, (String) source(), (Throwable) null); // $ hasTaintFlow
            logger.info((Marker) null, (Supplier<?>) source()); // $ hasTaintFlow
            logger.info((Marker) null, (Supplier<?>) source(), (Throwable) null); // $ hasTaintFlow
            logger.info((MessageSupplier) source()); // $ hasTaintFlow
            logger.info((MessageSupplier) source(), (Throwable) null); // $ hasTaintFlow
            logger.info((Message) source()); // $ hasTaintFlow
            logger.info((Message) source(), (Throwable) null); // $ hasTaintFlow
            logger.info(source()); // $ hasTaintFlow
            logger.info(source(), (Throwable) null); // $ hasTaintFlow
            logger.info((String) source()); // $ hasTaintFlow
            logger.info((String) source(), (Object[]) null); // $ hasTaintFlow
            logger.info((String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.info((String) null, (Object) source()); // $ hasTaintFlow
            logger.info((String) source(), (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.info((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.info((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) source(), (Supplier<?>) null); // $ hasTaintFlow
            logger.info((String) null, (Supplier<?>) source()); // $ hasTaintFlow
            logger.info((String) source(), (Throwable) null); // $ hasTaintFlow
            logger.info((Supplier<?>) source()); // $ hasTaintFlow
            logger.info((Supplier<?>) source(), (Throwable) null); // $ hasTaintFlow
            logger.log((Level) null, (CharSequence) source()); // $ hasTaintFlow
            logger.log((Level) null, (CharSequence) source(), (Throwable) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (CharSequence) source()); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (CharSequence) source(), null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (Message) source()); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (MessageSupplier) source()); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (MessageSupplier) source(), null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, source()); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) source()); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) source(), new Object[] {}); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) source()); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) source(), (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) source(), (Supplier<?>) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) null, (Supplier<?>) source()); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (String) source(), (Throwable) null); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (Supplier<?>) source()); // $ hasTaintFlow
            logger.log((Level) null, (Marker) null, (Supplier<?>) source(), (Throwable) null); // $ hasTaintFlow
            logger.log((Level) null, (MessageSupplier) source()); // $ hasTaintFlow
            logger.log((Level) null, (MessageSupplier) source(), (Throwable) null); // $ hasTaintFlow
            logger.log((Level) null, (Message) source()); // $ hasTaintFlow
            logger.log((Level) null, (Message) source(), (Throwable) null); // $ hasTaintFlow
            logger.log((Level) null, source()); // $ hasTaintFlow
            logger.log((Level) null, source(), (Throwable) null); // $ hasTaintFlow
            logger.log((Level) null, (String) source()); // $ hasTaintFlow
            logger.log((Level) null, (String) source(), (Object[]) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) source()); // $ hasTaintFlow
            logger.log((Level) null, (String) source(), (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.log((Level) null, (String) source(), (Supplier<?>) null); // $ hasTaintFlow
            logger.log((Level) null, (String) null, (Supplier<?>) source()); // $ hasTaintFlow
            logger.log((Level) null, (String) source(), (Throwable) null); // $ hasTaintFlow
            logger.log((Level) null, (Supplier<?>) source()); // $ hasTaintFlow
            logger.log((Level) null, (Supplier<?>) source(), (Throwable) null); // $ hasTaintFlow
            logger.trace((CharSequence) source()); // $ hasTaintFlow
            logger.trace((CharSequence) source(), (Throwable) null); // $ hasTaintFlow
            logger.trace((Marker) null, (CharSequence) source()); // $ hasTaintFlow
            logger.trace((Marker) null, (CharSequence) source(), null); // $ hasTaintFlow
            logger.trace((Marker) null, (Message) source()); // $ hasTaintFlow
            logger.trace((Marker) null, (MessageSupplier) source()); // $ hasTaintFlow
            logger.trace((Marker) null, (MessageSupplier) source(), null); // $ hasTaintFlow
            logger.trace((Marker) null, source()); // $ hasTaintFlow
            logger.trace((Marker) null, (String) source()); // $ hasTaintFlow
            logger.trace((Marker) null, (String) source(), new Object[] {}); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) source()); // $ hasTaintFlow
            logger.trace((Marker) null, (String) source(), (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) source(), (Supplier<?>) null); // $ hasTaintFlow
            logger.trace((Marker) null, (String) null, (Supplier<?>) source()); // $ hasTaintFlow
            logger.trace((Marker) null, (String) source(), (Throwable) null); // $ hasTaintFlow
            logger.trace((Marker) null, (Supplier<?>) source()); // $ hasTaintFlow
            logger.trace((Marker) null, (Supplier<?>) source(), (Throwable) null); // $ hasTaintFlow
            logger.trace((MessageSupplier) source()); // $ hasTaintFlow
            logger.trace((MessageSupplier) source(), (Throwable) null); // $ hasTaintFlow
            logger.trace((Message) source()); // $ hasTaintFlow
            logger.trace((Message) source(), (Throwable) null); // $ hasTaintFlow
            logger.trace(source()); // $ hasTaintFlow
            logger.trace(source(), (Throwable) null); // $ hasTaintFlow
            logger.trace((String) source()); // $ hasTaintFlow
            logger.trace((String) source(), (Object[]) null); // $ hasTaintFlow
            logger.trace((String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.trace((String) null, (Object) source()); // $ hasTaintFlow
            logger.trace((String) source(), (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.trace((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.trace((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) source(), (Supplier<?>) null); // $ hasTaintFlow
            logger.trace((String) null, (Supplier<?>) source()); // $ hasTaintFlow
            logger.trace((String) source(), (Throwable) null); // $ hasTaintFlow
            logger.trace((Supplier<?>) source()); // $ hasTaintFlow
            logger.trace((Supplier<?>) source(), (Throwable) null); // $ hasTaintFlow
            logger.warn((CharSequence) source()); // $ hasTaintFlow
            logger.warn((CharSequence) source(), (Throwable) null); // $ hasTaintFlow
            logger.warn((Marker) null, (CharSequence) source()); // $ hasTaintFlow
            logger.warn((Marker) null, (CharSequence) source(), null); // $ hasTaintFlow
            logger.warn((Marker) null, (Message) source()); // $ hasTaintFlow
            logger.warn((Marker) null, (MessageSupplier) source()); // $ hasTaintFlow
            logger.warn((Marker) null, (MessageSupplier) source(), null); // $ hasTaintFlow
            logger.warn((Marker) null, source()); // $ hasTaintFlow
            logger.warn((Marker) null, (String) source()); // $ hasTaintFlow
            logger.warn((Marker) null, (String) source(), new Object[] {}); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) source()); // $ hasTaintFlow
            logger.warn((Marker) null, (String) source(), (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) source(), (Supplier<?>) null); // $ hasTaintFlow
            logger.warn((Marker) null, (String) null, (Supplier<?>) source()); // $ hasTaintFlow
            logger.warn((Marker) null, (String) source(), (Throwable) null); // $ hasTaintFlow
            logger.warn((Marker) null, (Supplier<?>) source()); // $ hasTaintFlow
            logger.warn((Marker) null, (Supplier<?>) source(), (Throwable) null); // $ hasTaintFlow
            logger.warn((MessageSupplier) source()); // $ hasTaintFlow
            logger.warn((MessageSupplier) source(), (Throwable) null); // $ hasTaintFlow
            logger.warn((Message) source()); // $ hasTaintFlow
            logger.warn((Message) source(), (Throwable) null); // $ hasTaintFlow
            logger.warn(source()); // $ hasTaintFlow
            logger.warn(source(), (Throwable) null); // $ hasTaintFlow
            logger.warn((String) source()); // $ hasTaintFlow
            logger.warn((String) source(), (Object[]) null); // $ hasTaintFlow
            logger.warn((String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.warn((String) null, (Object) source()); // $ hasTaintFlow
            logger.warn((String) source(), (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.warn((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.warn((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) source(), (Supplier<?>) null); // $ hasTaintFlow
            logger.warn((String) null, (Supplier<?>) source()); // $ hasTaintFlow
            logger.warn((String) source(), (Throwable) null); // $ hasTaintFlow
            logger.warn((Supplier<?>) source()); // $ hasTaintFlow
            logger.warn((Supplier<?>) source(), (Throwable) null); // $ hasTaintFlow
            // @formatter:on
            logger.logMessage(null, null, null, null, (Message) source(), null); // $ hasTaintFlow
            logger.printf(null, null, (String) source(), (Object[]) null); // $ hasTaintFlow
            logger.printf(null, null, null, new Object[] {source()}); // $ hasTaintFlow
            logger.printf(null, (String) source(), (Object[]) null); // $ hasTaintFlow
            logger.printf(null, null, new Object[] {source()}); // $ hasTaintFlow
            logger.traceEntry((Message) source()); // $ hasTaintFlow
            logger.traceEntry((String) source(), (Object[]) null); // $ hasTaintFlow
            logger.traceEntry((String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.traceEntry((String) source(), (Supplier<?>) null); // $ hasTaintFlow
            logger.traceEntry((String) null, (Supplier<?>) source()); // $ hasTaintFlow
            logger.traceEntry((Supplier<?>) source()); // $ hasTaintFlow
            logger.traceExit((EntryMessage) source()); // $ hasTaintFlow
            logger.traceExit((EntryMessage) source(), null); // $ hasTaintFlow
            logger.traceExit((EntryMessage) null, source()); // $ hasTaintFlow
            logger.traceExit((Message) source(), null); // $ hasTaintFlow
            logger.traceExit((Message) null, source()); // $ hasTaintFlow
            logger.traceExit(source()); // $ hasTaintFlow
            logger.traceExit((String) source(), null); // $ hasTaintFlow
            logger.traceExit((String) null, source()); // $ hasTaintFlow
        }
        {
            LogBuilder builder = null;
            builder.log((CharSequence) source()); // $ hasTaintFlow
            builder.log((Message) source()); // $ hasTaintFlow
            builder.log(source()); // $ hasTaintFlow
            builder.log((String) source()); // $ hasTaintFlow
            builder.log((String) source(), (Object[]) null); // $ hasTaintFlow
            builder.log((String) null, new Object[] {source()}); // $ hasTaintFlow
            builder.log((String) null, source()); // $ hasTaintFlow
            // @formatter:off
            builder.log((String) null, (Object) source()); // $ hasTaintFlow
            builder.log((String) source(), (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            builder.log((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            builder.log((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            // @formatter:on
            builder.log((String) source(), (Supplier<?>) null); // $ hasTaintFlow
            builder.log((String) null, (Supplier<?>) source()); // $ hasTaintFlow
            builder.log((Supplier<?>) source()); // $ hasTaintFlow
        }
        {
            Log log = null;
            log.debug(source()); // $ hasTaintFlow
            log.error(source()); // $ hasTaintFlow
            log.fatal(source()); // $ hasTaintFlow
            log.info(source()); // $ hasTaintFlow
            log.trace(source()); // $ hasTaintFlow
            log.warn(source()); // $ hasTaintFlow
        }
        {
            BasicLogger bLogger = null;
            // @formatter:off
            bLogger.debug(source()); // $ hasTaintFlow
            bLogger.debug(source(), null); // $ hasTaintFlow
            // Deprecated: bLogger.debug(source(), (Object[]) null); // $ hasTaintFlow
            // Deprecated: bLogger.debug((Object) null, new Object[] {source()}); // $ hasTaintFlow
            // Deprecated: bLogger.debug((Object) null, new Object[] {source()}, (Throwable) null); // $ hasTaintFlow
            bLogger.debug((String) null, source(), (Object[]) null, (Throwable) null); // $ hasTaintFlow
            bLogger.debug((String) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ hasTaintFlow
            bLogger.debug((String) null, source(), (Throwable) null); // $ hasTaintFlow
            bLogger.error(source()); // $ hasTaintFlow
            bLogger.error(source(), null); // $ hasTaintFlow
            // Deprecated: bLogger.error(source(), (Object[]) null); // $ hasTaintFlow
            // Deprecated: bLogger.error((Object) null, new Object[] {source()}); // $ hasTaintFlow
            // Deprecated: bLogger.error((Object) null, new Object[] {source()}, (Throwable) null); // $ hasTaintFlow
            bLogger.error((String) null, source(), (Object[]) null, (Throwable) null); // $ hasTaintFlow
            bLogger.error((String) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ hasTaintFlow
            bLogger.error((String) null, source(), (Throwable) null); // $ hasTaintFlow
            bLogger.fatal(source()); // $ hasTaintFlow
            bLogger.fatal(source(), null); // $ hasTaintFlow
            // Deprecated: bLogger.fatal(source(), (Object[]) null); // $ hasTaintFlow
            // Deprecated: bLogger.fatal((Object) null, new Object[] {source()}); // $ hasTaintFlow
            // Deprecated: bLogger.fatal((Object) null, new Object[] {source()}, (Throwable) null); // $ hasTaintFlow
            bLogger.fatal((String) null, source(), (Object[]) null, (Throwable) null); // $ hasTaintFlow
            bLogger.fatal((String) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ hasTaintFlow
            bLogger.fatal((String) null, source(), (Throwable) null); // $ hasTaintFlow
            bLogger.info(source()); // $ hasTaintFlow
            bLogger.info(source(), null); // $ hasTaintFlow
            // Deprecated: bLogger.info(source(), (Object[]) null); // $ hasTaintFlow
            // Deprecated: bLogger.info((Object) null, new Object[] {source()}); // $ hasTaintFlow
            // Deprecated: bLogger.info((Object) null, new Object[] {source()}, (Throwable) null); // $ hasTaintFlow
            bLogger.info((String) null, source(), (Object[]) null, (Throwable) null); // $ hasTaintFlow
            bLogger.info((String) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ hasTaintFlow
            bLogger.info((String) null, source(), (Throwable) null); // $ hasTaintFlow
            bLogger.trace(source()); // $ hasTaintFlow
            bLogger.trace(source(), null); // $ hasTaintFlow
            // Deprecated: bLogger.trace(source(), (Object[]) null); // $ hasTaintFlow
            // Deprecated: bLogger.trace((Object) null, new Object[] {source()}); // $ hasTaintFlow
            // Deprecated: bLogger.trace((Object) null, new Object[] {source()}, (Throwable) null); // $ hasTaintFlow
            bLogger.trace((String) null, source(), (Object[]) null, (Throwable) null); // $ hasTaintFlow
            bLogger.trace((String) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ hasTaintFlow
            bLogger.trace((String) null, source(), (Throwable) null); // $ hasTaintFlow
            bLogger.warn(source()); // $ hasTaintFlow
            bLogger.warn(source(), null); // $ hasTaintFlow
            // Deprecated: bLogger.warn(source(), (Object[]) null); // $ hasTaintFlow
            // Deprecated: bLogger.warn((Object) null, new Object[] {source()}); // $ hasTaintFlow
            // Deprecated: bLogger.warn((Object) null, new Object[] {source()}, (Throwable) null); // $ hasTaintFlow
            bLogger.warn((String) null, source(), (Object[]) null, (Throwable) null); // $ hasTaintFlow
            bLogger.warn((String) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ hasTaintFlow
            bLogger.warn((String) null, source(), (Throwable) null); // $ hasTaintFlow
            bLogger.log((org.jboss.logging.Logger.Level) null, source()); // $ hasTaintFlow
            bLogger.log((org.jboss.logging.Logger.Level) null, source(), null); // $ hasTaintFlow
            // Deprecated: bLogger.log((org.jboss.logging.Logger.Level) null, source(), (Object[]) null); // $ hasTaintFlow
            // Deprecated: bLogger.log((org.jboss.logging.Logger.Level) null, (Object) null, new Object[] {source()}); // $ hasTaintFlow
            // Deprecated: bLogger.log((org.jboss.logging.Logger.Level) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ hasTaintFlow
            bLogger.log((org.jboss.logging.Logger.Level) null, (String) null, source(), (Throwable) null); // $ hasTaintFlow
            bLogger.log((String) null, (org.jboss.logging.Logger.Level) null, source(), (Object[]) null, (Throwable) null); // $ hasTaintFlow
            bLogger.log((String) null, (org.jboss.logging.Logger.Level) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ hasTaintFlow
            bLogger.debugf((String) null, (Object) source()); // $ hasTaintFlow
            bLogger.debugf((String) source(), (Object) null); // $ hasTaintFlow
            bLogger.debugv((String) null, (Object) source()); // $ hasTaintFlow
            bLogger.debugv((String) source(), (Object) null); // $ hasTaintFlow
            bLogger.debugf((String) source(), (Object[]) null); // $ hasTaintFlow
            bLogger.debugv((String) source(), (Object[]) null); // $ hasTaintFlow
            bLogger.debugf((String) null, new Object[] {source()}); // $ hasTaintFlow
            bLogger.debugv((String) null, new Object[] {source()}); // $ hasTaintFlow
            bLogger.debugf((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            bLogger.debugf((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            bLogger.debugf((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.debugv((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            bLogger.debugv((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            bLogger.debugv((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.debugf((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            bLogger.debugf((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            bLogger.debugf((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.debugf((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.debugv((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            bLogger.debugv((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            bLogger.debugv((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.debugv((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.errorf((String) null, (Object) source()); // $ hasTaintFlow
            bLogger.errorf((String) source(), (Object) null); // $ hasTaintFlow
            bLogger.errorv((String) null, (Object) source()); // $ hasTaintFlow
            bLogger.errorv((String) source(), (Object) null); // $ hasTaintFlow
            bLogger.errorf((String) source(), (Object[]) null); // $ hasTaintFlow
            bLogger.errorv((String) source(), (Object[]) null); // $ hasTaintFlow
            bLogger.errorf((String) null, new Object[] {source()}); // $ hasTaintFlow
            bLogger.errorv((String) null, new Object[] {source()}); // $ hasTaintFlow
            bLogger.errorf((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            bLogger.errorf((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            bLogger.errorf((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.errorv((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            bLogger.errorv((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            bLogger.errorv((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.errorf((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            bLogger.errorf((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            bLogger.errorf((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.errorf((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.errorv((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            bLogger.errorv((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            bLogger.errorv((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.errorv((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.fatalf((String) null, (Object) source()); // $ hasTaintFlow
            bLogger.fatalf((String) source(), (Object) null); // $ hasTaintFlow
            bLogger.fatalv((String) null, (Object) source()); // $ hasTaintFlow
            bLogger.fatalv((String) source(), (Object) null); // $ hasTaintFlow
            bLogger.fatalf((String) source(), (Object[]) null); // $ hasTaintFlow
            bLogger.fatalv((String) source(), (Object[]) null); // $ hasTaintFlow
            bLogger.fatalf((String) null, new Object[] {source()}); // $ hasTaintFlow
            bLogger.fatalv((String) null, new Object[] {source()}); // $ hasTaintFlow
            bLogger.fatalf((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            bLogger.fatalf((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            bLogger.fatalf((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.fatalv((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            bLogger.fatalv((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            bLogger.fatalv((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.fatalf((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            bLogger.fatalf((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            bLogger.fatalf((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.fatalf((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.fatalv((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            bLogger.fatalv((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            bLogger.fatalv((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.fatalv((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.infof((String) null, (Object) source()); // $ hasTaintFlow
            bLogger.infof((String) source(), (Object) null); // $ hasTaintFlow
            bLogger.infov((String) null, (Object) source()); // $ hasTaintFlow
            bLogger.infov((String) source(), (Object) null); // $ hasTaintFlow
            bLogger.infof((String) source(), (Object[]) null); // $ hasTaintFlow
            bLogger.infov((String) source(), (Object[]) null); // $ hasTaintFlow
            bLogger.infof((String) null, new Object[] {source()}); // $ hasTaintFlow
            bLogger.infov((String) null, new Object[] {source()}); // $ hasTaintFlow
            bLogger.infof((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            bLogger.infof((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            bLogger.infof((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.infov((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            bLogger.infov((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            bLogger.infov((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.infof((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            bLogger.infof((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            bLogger.infof((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.infof((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.infov((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            bLogger.infov((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            bLogger.infov((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.infov((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.logf((org.jboss.logging.Logger.Level) null, (String) null, (Object) source()); // $ hasTaintFlow
            bLogger.logf((org.jboss.logging.Logger.Level) null, (String) source(), (Object) null); // $ hasTaintFlow
            bLogger.logv((org.jboss.logging.Logger.Level) null, (String) null, (Object) source()); // $ hasTaintFlow
            bLogger.logv((org.jboss.logging.Logger.Level) null, (String) source(), (Object) null); // $ hasTaintFlow
            bLogger.logf((org.jboss.logging.Logger.Level) null, (String) source(), (Object[]) null); // $ hasTaintFlow
            bLogger.logv((org.jboss.logging.Logger.Level) null, (String) source(), (Object[]) null); // $ hasTaintFlow
            bLogger.logf((org.jboss.logging.Logger.Level) null, (String) null, new Object[] {source()}); // $ hasTaintFlow
            bLogger.logv((org.jboss.logging.Logger.Level) null, (String) null, new Object[] {source()}); // $ hasTaintFlow
            bLogger.logf((org.jboss.logging.Logger.Level) null, (String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            bLogger.logf((org.jboss.logging.Logger.Level) null, (String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            bLogger.logf((org.jboss.logging.Logger.Level) null, (String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.logv((org.jboss.logging.Logger.Level) null, (String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            bLogger.logv((org.jboss.logging.Logger.Level) null, (String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            bLogger.logv((org.jboss.logging.Logger.Level) null, (String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.logf((org.jboss.logging.Logger.Level) null, (String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            bLogger.logf((org.jboss.logging.Logger.Level) null, (String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            bLogger.logf((org.jboss.logging.Logger.Level) null, (String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.logf((org.jboss.logging.Logger.Level) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.logv((org.jboss.logging.Logger.Level) null, (String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            bLogger.logv((org.jboss.logging.Logger.Level) null, (String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            bLogger.logv((org.jboss.logging.Logger.Level) null, (String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.logv((org.jboss.logging.Logger.Level) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.tracef((String) null, (Object) source()); // $ hasTaintFlow
            bLogger.tracef((String) source(), (Object) null); // $ hasTaintFlow
            bLogger.tracev((String) null, (Object) source()); // $ hasTaintFlow
            bLogger.tracev((String) source(), (Object) null); // $ hasTaintFlow
            bLogger.tracef((String) source(), (Object[]) null); // $ hasTaintFlow
            bLogger.tracev((String) source(), (Object[]) null); // $ hasTaintFlow
            bLogger.tracef((String) null, new Object[] {source()}); // $ hasTaintFlow
            bLogger.tracev((String) null, new Object[] {source()}); // $ hasTaintFlow
            bLogger.tracef((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            bLogger.tracef((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            bLogger.tracef((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.tracev((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            bLogger.tracev((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            bLogger.tracev((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.tracef((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            bLogger.tracef((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            bLogger.tracef((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.tracef((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.tracev((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            bLogger.tracev((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            bLogger.tracev((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.tracev((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.warnf((String) null, (Object) source()); // $ hasTaintFlow
            bLogger.warnf((String) source(), (Object) null); // $ hasTaintFlow
            bLogger.warnv((String) null, (Object) source()); // $ hasTaintFlow
            bLogger.warnv((String) source(), (Object) null); // $ hasTaintFlow
            bLogger.warnf((String) source(), (Object[]) null); // $ hasTaintFlow
            bLogger.warnv((String) source(), (Object[]) null); // $ hasTaintFlow
            bLogger.warnf((String) null, new Object[] {source()}); // $ hasTaintFlow
            bLogger.warnv((String) null, new Object[] {source()}); // $ hasTaintFlow
            bLogger.warnf((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            bLogger.warnf((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            bLogger.warnf((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.warnv((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            bLogger.warnv((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            bLogger.warnv((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.warnf((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            bLogger.warnf((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            bLogger.warnf((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.warnf((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.warnv((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            bLogger.warnv((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            bLogger.warnv((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            bLogger.warnv((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            // @formatter:on
        }
        {
            org.jboss.logging.Logger logger = null;
            // @formatter:off
            logger.debug(source()); // $ hasTaintFlow
            logger.debug(source(), (Throwable) null); // $ hasTaintFlow
            // Deprecated: logger.debug(source(), (Object[]) null); // $ hasTaintFlow
            // Deprecated: logger.debug((Object) null, new Object[] {source()}); // $ hasTaintFlow
            // Deprecated: logger.debug((Object) null, new Object[] {source()}, (Throwable) null); // $ hasTaintFlow
            logger.debug((String) null, source(), (Object[]) null, (Throwable) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ hasTaintFlow
            logger.debug((String) null, source(), (Throwable) null); // $ hasTaintFlow
            logger.error(source()); // $ hasTaintFlow
            logger.error(source(), (Throwable) null); // $ hasTaintFlow
            // Deprecated: logger.error(source(), (Object[]) null); // $ hasTaintFlow
            // Deprecated: logger.error((Object) null, new Object[] {source()}); // $ hasTaintFlow
            // Deprecated: logger.error((Object) null, new Object[] {source()}, (Throwable) null); // $ hasTaintFlow
            logger.error((String) null, source(), (Object[]) null, (Throwable) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ hasTaintFlow
            logger.error((String) null, source(), (Throwable) null); // $ hasTaintFlow
            logger.fatal(source()); // $ hasTaintFlow
            logger.fatal(source(), (Throwable) null); // $ hasTaintFlow
            // Deprecated: logger.fatal(source(), (Object[]) null); // $ hasTaintFlow
            // Deprecated: logger.fatal((Object) null, new Object[] {source()}); // $ hasTaintFlow
            // Deprecated: logger.fatal((Object) null, new Object[] {source()}, (Throwable) null); // $ hasTaintFlow
            logger.fatal((String) null, source(), (Object[]) null, (Throwable) null); // $ hasTaintFlow
            logger.fatal((String) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ hasTaintFlow
            logger.fatal((String) null, source(), (Throwable) null); // $ hasTaintFlow
            logger.info(source()); // $ hasTaintFlow
            logger.info(source(), (Throwable) null); // $ hasTaintFlow
            // Deprecated: logger.info(source(), (Object[]) null); // $ hasTaintFlow
            // Deprecated: logger.info((Object) null, new Object[] {source()}); // $ hasTaintFlow
            // Deprecated: logger.info((Object) null, new Object[] {source()}, (Throwable) null); // $ hasTaintFlow
            logger.info((String) null, source(), (Object[]) null, (Throwable) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ hasTaintFlow
            logger.info((String) null, source(), (Throwable) null); // $ hasTaintFlow
            logger.trace(source()); // $ hasTaintFlow
            logger.trace(source(), (Throwable) null); // $ hasTaintFlow
            // Deprecated: logger.trace(source(), (Object[]) null); // $ hasTaintFlow
            // Deprecated: logger.trace((Object) null, new Object[] {source()}); // $ hasTaintFlow
            // Deprecated: logger.trace((Object) null, new Object[] {source()}, (Throwable) null); // $ hasTaintFlow
            logger.trace((String) null, source(), (Object[]) null, (Throwable) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ hasTaintFlow
            logger.trace((String) null, source(), (Throwable) null); // $ hasTaintFlow
            logger.warn(source()); // $ hasTaintFlow
            logger.warn(source(), (Throwable) null); // $ hasTaintFlow
            // Deprecated: logger.warn(source(), (Object[]) null); // $ hasTaintFlow
            // Deprecated: logger.warn((Object) null, new Object[] {source()}); // $ hasTaintFlow
            // Deprecated: logger.warn((Object) null, new Object[] {source()}, (Throwable) null); // $ hasTaintFlow
            logger.warn((String) null, source(), (Object[]) null, (Throwable) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ hasTaintFlow
            logger.warn((String) null, source(), (Throwable) null); // $ hasTaintFlow
            logger.log((org.jboss.logging.Logger.Level) null, source()); // $ hasTaintFlow
            logger.log((org.jboss.logging.Logger.Level) null, source(), (Throwable) null); // $ hasTaintFlow
            // Deprecated: logger.log((org.jboss.logging.Logger.Level) null, source(), (Object[]) null); // $ hasTaintFlow
            // Deprecated: logger.log((org.jboss.logging.Logger.Level) null, (Object) null, new Object[] {source()}); // $ hasTaintFlow
            // Deprecated: logger.log((org.jboss.logging.Logger.Level) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ hasTaintFlow
            logger.log((org.jboss.logging.Logger.Level) null, (String) null, source(), (Throwable) null); // $ hasTaintFlow
            logger.log((String) null, (org.jboss.logging.Logger.Level) null, source(), (Object[]) null, (Throwable) null); // $ hasTaintFlow
            logger.log((String) null, (org.jboss.logging.Logger.Level) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ hasTaintFlow
            logger.debugf((String) null, (Object) source()); // $ hasTaintFlow
            logger.debugf((String) source(), (Object) null); // $ hasTaintFlow
            logger.debugv((String) null, (Object) source()); // $ hasTaintFlow
            logger.debugv((String) source(), (Object) null); // $ hasTaintFlow
            logger.debugf((String) source(), (Object[]) null); // $ hasTaintFlow
            logger.debugv((String) source(), (Object[]) null); // $ hasTaintFlow
            logger.debugf((String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.debugv((String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.debugf((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.debugf((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.debugf((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.debugv((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.debugv((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.debugv((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.debugf((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.debugf((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.debugf((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.debugf((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debugv((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.debugv((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.debugv((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.debugv((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.errorf((String) null, (Object) source()); // $ hasTaintFlow
            logger.errorf((String) source(), (Object) null); // $ hasTaintFlow
            logger.errorv((String) null, (Object) source()); // $ hasTaintFlow
            logger.errorv((String) source(), (Object) null); // $ hasTaintFlow
            logger.errorf((String) source(), (Object[]) null); // $ hasTaintFlow
            logger.errorv((String) source(), (Object[]) null); // $ hasTaintFlow
            logger.errorf((String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.errorv((String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.errorf((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.errorf((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.errorf((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.errorv((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.errorv((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.errorv((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.errorf((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.errorf((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.errorf((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.errorf((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.errorv((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.errorv((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.errorv((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.errorv((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatalf((String) null, (Object) source()); // $ hasTaintFlow
            logger.fatalf((String) source(), (Object) null); // $ hasTaintFlow
            logger.fatalv((String) null, (Object) source()); // $ hasTaintFlow
            logger.fatalv((String) source(), (Object) null); // $ hasTaintFlow
            logger.fatalf((String) source(), (Object[]) null); // $ hasTaintFlow
            logger.fatalv((String) source(), (Object[]) null); // $ hasTaintFlow
            logger.fatalf((String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.fatalv((String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.fatalf((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.fatalf((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.fatalf((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatalv((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.fatalv((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.fatalv((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatalf((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.fatalf((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.fatalf((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatalf((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatalv((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.fatalv((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.fatalv((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.fatalv((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.infof((String) null, (Object) source()); // $ hasTaintFlow
            logger.infof((String) source(), (Object) null); // $ hasTaintFlow
            logger.infov((String) null, (Object) source()); // $ hasTaintFlow
            logger.infov((String) source(), (Object) null); // $ hasTaintFlow
            logger.infof((String) source(), (Object[]) null); // $ hasTaintFlow
            logger.infov((String) source(), (Object[]) null); // $ hasTaintFlow
            logger.infof((String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.infov((String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.infof((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.infof((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.infof((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.infov((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.infov((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.infov((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.infof((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.infof((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.infof((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.infof((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.infov((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.infov((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.infov((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.infov((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.logf((org.jboss.logging.Logger.Level) null, (String) null, (Object) source()); // $ hasTaintFlow
            logger.logf((org.jboss.logging.Logger.Level) null, (String) source(), (Object) null); // $ hasTaintFlow
            logger.logv((org.jboss.logging.Logger.Level) null, (String) null, (Object) source()); // $ hasTaintFlow
            logger.logv((org.jboss.logging.Logger.Level) null, (String) source(), (Object) null); // $ hasTaintFlow
            logger.logf((org.jboss.logging.Logger.Level) null, (String) source(), (Object[]) null); // $ hasTaintFlow
            logger.logv((org.jboss.logging.Logger.Level) null, (String) source(), (Object[]) null); // $ hasTaintFlow
            logger.logf((org.jboss.logging.Logger.Level) null, (String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.logv((org.jboss.logging.Logger.Level) null, (String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.logf((org.jboss.logging.Logger.Level) null, (String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.logf((org.jboss.logging.Logger.Level) null, (String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.logf((org.jboss.logging.Logger.Level) null, (String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.logv((org.jboss.logging.Logger.Level) null, (String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.logv((org.jboss.logging.Logger.Level) null, (String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.logv((org.jboss.logging.Logger.Level) null, (String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.logf((org.jboss.logging.Logger.Level) null, (String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.logf((org.jboss.logging.Logger.Level) null, (String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.logf((org.jboss.logging.Logger.Level) null, (String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.logf((org.jboss.logging.Logger.Level) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.logv((org.jboss.logging.Logger.Level) null, (String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.logv((org.jboss.logging.Logger.Level) null, (String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.logv((org.jboss.logging.Logger.Level) null, (String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.logv((org.jboss.logging.Logger.Level) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.tracef((String) null, (Object) source()); // $ hasTaintFlow
            logger.tracef((String) source(), (Object) null); // $ hasTaintFlow
            logger.tracev((String) null, (Object) source()); // $ hasTaintFlow
            logger.tracev((String) source(), (Object) null); // $ hasTaintFlow
            logger.tracef((String) source(), (Object[]) null); // $ hasTaintFlow
            logger.tracev((String) source(), (Object[]) null); // $ hasTaintFlow
            logger.tracef((String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.tracev((String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.tracef((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.tracef((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.tracef((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.tracev((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.tracev((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.tracev((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.tracef((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.tracef((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.tracef((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.tracef((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.tracev((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.tracev((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.tracev((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.tracev((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warnf((String) null, (Object) source()); // $ hasTaintFlow
            logger.warnf((String) source(), (Object) null); // $ hasTaintFlow
            logger.warnv((String) null, (Object) source()); // $ hasTaintFlow
            logger.warnv((String) source(), (Object) null); // $ hasTaintFlow
            logger.warnf((String) source(), (Object[]) null); // $ hasTaintFlow
            logger.warnv((String) source(), (Object[]) null); // $ hasTaintFlow
            logger.warnf((String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.warnv((String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.warnf((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.warnf((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.warnf((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.warnv((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.warnv((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.warnv((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.warnf((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.warnf((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.warnf((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.warnf((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warnv((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            logger.warnv((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            logger.warnv((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.warnv((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            // @formatter:on
        }
        {
            LoggingEventBuilder builder = null;
            builder.log((String) source()); // $ hasTaintFlow
            builder.log((String) source(), (Object) null); // $ hasTaintFlow
            builder.log((String) null, source()); // $ hasTaintFlow
            builder.log((String) source(), (Object[]) null); // $ hasTaintFlow
            builder.log((String) null, new Object[] {source()}); // $ hasTaintFlow
            builder.log((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            builder.log((String) null, source(), (Object) null); // $ hasTaintFlow
            builder.log((String) null, (Object) null, source()); // $ hasTaintFlow
            builder.log((java.util.function.Supplier) source()); // $ hasTaintFlow
        }
        {
            org.slf4j.Logger logger = null;
            // @formatter:off
            logger.debug((String) source()); // $ hasTaintFlow
            logger.debug((String) source(), (Object) null); // $ hasTaintFlow
            logger.debug((String) null, source()); // $ hasTaintFlow
            logger.debug((String) source(), (Object[]) null); // $ hasTaintFlow
            logger.debug((String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.debug((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((String) null, source(), (Object) null); // $ hasTaintFlow
            logger.debug((String) null, (Object) null, source()); // $ hasTaintFlow
            logger.debug((String) source(), (Throwable) null); // $ hasTaintFlow
            logger.debug((org.slf4j.Marker) null, (String) source()); // $ hasTaintFlow
            logger.debug((org.slf4j.Marker) null, (String) source(), (Object) null); // $ hasTaintFlow
            logger.debug((org.slf4j.Marker) null, (String) null, source()); // $ hasTaintFlow
            logger.debug((org.slf4j.Marker) null, (String) source(), (Object[]) null); // $ hasTaintFlow
            logger.debug((org.slf4j.Marker) null, (String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.debug((org.slf4j.Marker) null, (String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((org.slf4j.Marker) null, (String) null, source(), (Object) null); // $ hasTaintFlow
            logger.debug((org.slf4j.Marker) null, (String) null, (Object) null, source()); // $ hasTaintFlow
            logger.debug((org.slf4j.Marker) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((org.slf4j.Marker) null, (String) null, source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.debug((org.slf4j.Marker) null, (String) null, (Object) null, source(), (Object) null); // $ hasTaintFlow
            logger.debug((org.slf4j.Marker) null, (String) null, (Object) null, (Object) null, source()); // $ hasTaintFlow
            logger.error((String) source()); // $ hasTaintFlow
            logger.error((String) source(), (Object) null); // $ hasTaintFlow
            logger.error((String) null, source()); // $ hasTaintFlow
            logger.error((String) source(), (Object[]) null); // $ hasTaintFlow
            logger.error((String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.error((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((String) null, source(), (Object) null); // $ hasTaintFlow
            logger.error((String) null, (Object) null, source()); // $ hasTaintFlow
            logger.error((String) source(), (Throwable) null); // $ hasTaintFlow
            logger.error((org.slf4j.Marker) null, (String) source()); // $ hasTaintFlow
            logger.error((org.slf4j.Marker) null, (String) source(), (Object) null); // $ hasTaintFlow
            logger.error((org.slf4j.Marker) null, (String) null, source()); // $ hasTaintFlow
            logger.error((org.slf4j.Marker) null, (String) source(), (Object[]) null); // $ hasTaintFlow
            logger.error((org.slf4j.Marker) null, (String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.error((org.slf4j.Marker) null, (String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((org.slf4j.Marker) null, (String) null, source(), (Object) null); // $ hasTaintFlow
            logger.error((org.slf4j.Marker) null, (String) null, (Object) null, source()); // $ hasTaintFlow
            logger.error((org.slf4j.Marker) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((org.slf4j.Marker) null, (String) null, source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.error((org.slf4j.Marker) null, (String) null, (Object) null, source(), (Object) null); // $ hasTaintFlow
            logger.error((org.slf4j.Marker) null, (String) null, (Object) null, (Object) null, source()); // $ hasTaintFlow
            logger.info((String) source()); // $ hasTaintFlow
            logger.info((String) source(), (Object) null); // $ hasTaintFlow
            logger.info((String) null, source()); // $ hasTaintFlow
            logger.info((String) source(), (Object[]) null); // $ hasTaintFlow
            logger.info((String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.info((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((String) null, source(), (Object) null); // $ hasTaintFlow
            logger.info((String) null, (Object) null, source()); // $ hasTaintFlow
            logger.info((String) source(), (Throwable) null); // $ hasTaintFlow
            logger.info((org.slf4j.Marker) null, (String) source()); // $ hasTaintFlow
            logger.info((org.slf4j.Marker) null, (String) source(), (Object) null); // $ hasTaintFlow
            logger.info((org.slf4j.Marker) null, (String) null, source()); // $ hasTaintFlow
            logger.info((org.slf4j.Marker) null, (String) source(), (Object[]) null); // $ hasTaintFlow
            logger.info((org.slf4j.Marker) null, (String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.info((org.slf4j.Marker) null, (String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((org.slf4j.Marker) null, (String) null, source(), (Object) null); // $ hasTaintFlow
            logger.info((org.slf4j.Marker) null, (String) null, (Object) null, source()); // $ hasTaintFlow
            logger.info((org.slf4j.Marker) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((org.slf4j.Marker) null, (String) null, source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.info((org.slf4j.Marker) null, (String) null, (Object) null, source(), (Object) null); // $ hasTaintFlow
            logger.info((org.slf4j.Marker) null, (String) null, (Object) null, (Object) null, source()); // $ hasTaintFlow
            logger.trace((String) source()); // $ hasTaintFlow
            logger.trace((String) source(), (Object) null); // $ hasTaintFlow
            logger.trace((String) null, source()); // $ hasTaintFlow
            logger.trace((String) source(), (Object[]) null); // $ hasTaintFlow
            logger.trace((String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.trace((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((String) null, source(), (Object) null); // $ hasTaintFlow
            logger.trace((String) null, (Object) null, source()); // $ hasTaintFlow
            logger.trace((String) source(), (Throwable) null); // $ hasTaintFlow
            logger.trace((org.slf4j.Marker) null, (String) source()); // $ hasTaintFlow
            logger.trace((org.slf4j.Marker) null, (String) source(), (Object) null); // $ hasTaintFlow
            logger.trace((org.slf4j.Marker) null, (String) null, source()); // $ hasTaintFlow
            logger.trace((org.slf4j.Marker) null, (String) source(), (Object[]) null); // $ hasTaintFlow
            logger.trace((org.slf4j.Marker) null, (String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.trace((org.slf4j.Marker) null, (String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((org.slf4j.Marker) null, (String) null, source(), (Object) null); // $ hasTaintFlow
            logger.trace((org.slf4j.Marker) null, (String) null, (Object) null, source()); // $ hasTaintFlow
            logger.trace((org.slf4j.Marker) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((org.slf4j.Marker) null, (String) null, source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.trace((org.slf4j.Marker) null, (String) null, (Object) null, source(), (Object) null); // $ hasTaintFlow
            logger.trace((org.slf4j.Marker) null, (String) null, (Object) null, (Object) null, source()); // $ hasTaintFlow
            logger.warn((String) source()); // $ hasTaintFlow
            logger.warn((String) source(), (Object) null); // $ hasTaintFlow
            logger.warn((String) null, source()); // $ hasTaintFlow
            logger.warn((String) source(), (Object[]) null); // $ hasTaintFlow
            logger.warn((String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.warn((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((String) null, source(), (Object) null); // $ hasTaintFlow
            logger.warn((String) null, (Object) null, source()); // $ hasTaintFlow
            logger.warn((String) source(), (Throwable) null); // $ hasTaintFlow
            logger.warn((org.slf4j.Marker) null, (String) source()); // $ hasTaintFlow
            logger.warn((org.slf4j.Marker) null, (String) source(), (Object) null); // $ hasTaintFlow
            logger.warn((org.slf4j.Marker) null, (String) null, source()); // $ hasTaintFlow
            logger.warn((org.slf4j.Marker) null, (String) source(), (Object[]) null); // $ hasTaintFlow
            logger.warn((org.slf4j.Marker) null, (String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.warn((org.slf4j.Marker) null, (String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((org.slf4j.Marker) null, (String) null, source(), (Object) null); // $ hasTaintFlow
            logger.warn((org.slf4j.Marker) null, (String) null, (Object) null, source()); // $ hasTaintFlow
            logger.warn((org.slf4j.Marker) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((org.slf4j.Marker) null, (String) null, source(), (Object) null, (Object) null); // $ hasTaintFlow
            logger.warn((org.slf4j.Marker) null, (String) null, (Object) null, source(), (Object) null); // $ hasTaintFlow
            logger.warn((org.slf4j.Marker) null, (String) null, (Object) null, (Object) null, source()); // $ hasTaintFlow
            // @formatter:on
        }
        {
            org.scijava.log.Logger logger = null;
            logger.alwaysLog(0, source(), null); // $ hasTaintFlow
            logger.debug(source()); // $ hasTaintFlow
            logger.debug(source(), null); // $ hasTaintFlow
            logger.error(source()); // $ hasTaintFlow
            logger.error(source(), null); // $ hasTaintFlow
            logger.info(source()); // $ hasTaintFlow
            logger.info(source(), null); // $ hasTaintFlow
            logger.trace(source()); // $ hasTaintFlow
            logger.trace(source(), null); // $ hasTaintFlow
            logger.warn(source()); // $ hasTaintFlow
            logger.warn(source(), null); // $ hasTaintFlow
            logger.log(0, source()); // $ hasTaintFlow
            logger.log(0, source(), null); // $ hasTaintFlow
        }
        {
            LoggingApi api = null;
            api.logVarargs((String) source(), (Object[]) null); // $ hasTaintFlow
            api.logVarargs((String) null, new Object[] {source()}); // $ hasTaintFlow
            // @formatter:off
            api.log((String) source()); // $ hasTaintFlow
            api.log((String) null, (Object) source()); // $ hasTaintFlow
            api.log((String) source(), (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) source()); // $ hasTaintFlow
            api.log((String) null, (Object) source(), (Object) null); // $ hasTaintFlow
            api.log((String) source(), (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, new Object[]{source()}); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object[]) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object[]) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object[]) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object[]) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object[]) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object[]) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object[]) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object[]) null); // $ hasTaintFlow
            api.log((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object[]) null); // $ hasTaintFlow
            api.log((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object[]) null); // $ hasTaintFlow
            api.log((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object[]) null); // $ hasTaintFlow
            // @formatter:on
            api.log((String) source(), 'a'); // $ hasTaintFlow
            api.log((String) source(), (byte) 0); // $ hasTaintFlow
            api.log((String) source(), (short) 0); // $ hasTaintFlow
            api.log((String) source(), 0); // $ hasTaintFlow
            api.log((String) source(), 0L); // $ hasTaintFlow
            api.log((String) source(), (Object) null, false); // $ hasTaintFlow
            api.log((String) null, source(), false); // $ hasTaintFlow
            api.log((String) source(), (Object) null, 'a'); // $ hasTaintFlow
            api.log((String) null, source(), 'a'); // $ hasTaintFlow
            api.log((String) source(), (Object) null, (byte) 0); // $ hasTaintFlow
            api.log((String) null, source(), (byte) 0); // $ hasTaintFlow
            api.log((String) source(), (Object) null, (short) 0); // $ hasTaintFlow
            api.log((String) null, source(), (short) 0); // $ hasTaintFlow
            api.log((String) source(), (Object) null, 0); // $ hasTaintFlow
            api.log((String) null, source(), 0); // $ hasTaintFlow
            api.log((String) source(), (Object) null, 0L); // $ hasTaintFlow
            api.log((String) null, source(), 0L); // $ hasTaintFlow
            api.log((String) source(), (Object) null, (float) 0); // $ hasTaintFlow
            api.log((String) null, source(), (float) 0); // $ hasTaintFlow
            api.log((String) source(), (Object) null, (double) 0); // $ hasTaintFlow
            api.log((String) null, source(), (double) 0); // $ hasTaintFlow
            api.log((String) source(), false, (Object) null); // $ hasTaintFlow
            api.log((String) null, false, source()); // $ hasTaintFlow
            api.log((String) source(), 'a', (Object) null); // $ hasTaintFlow
            api.log((String) null, 'a', source()); // $ hasTaintFlow
            api.log((String) source(), (byte) 0, (Object) null); // $ hasTaintFlow
            api.log((String) null, (byte) 0, source()); // $ hasTaintFlow
            api.log((String) source(), (short) 0, (Object) null); // $ hasTaintFlow
            api.log((String) null, (short) 0, source()); // $ hasTaintFlow
            api.log((String) source(), 0, (Object) null); // $ hasTaintFlow
            api.log((String) null, 0, source()); // $ hasTaintFlow
            api.log((String) source(), 0L, (Object) null); // $ hasTaintFlow
            api.log((String) null, 0L, source()); // $ hasTaintFlow
            api.log((String) source(), (float) 0, (Object) null); // $ hasTaintFlow
            api.log((String) null, (float) 0, source()); // $ hasTaintFlow
            api.log((String) source(), (double) 0, (Object) null); // $ hasTaintFlow
            api.log((String) null, (double) 0, source()); // $ hasTaintFlow
            api.log((String) source(), false, false); // $ hasTaintFlow
            api.log((String) source(), 'a', false); // $ hasTaintFlow
            api.log((String) source(), (byte) 0, false); // $ hasTaintFlow
            api.log((String) source(), (short) 0, false); // $ hasTaintFlow
            api.log((String) source(), (int) 0, false); // $ hasTaintFlow
            api.log((String) source(), (long) 0, false); // $ hasTaintFlow
            api.log((String) source(), (float) 0, false); // $ hasTaintFlow
            api.log((String) source(), (double) 0, false); // $ hasTaintFlow
            api.log((String) source(), false, 'a'); // $ hasTaintFlow
            api.log((String) source(), 'a', 'a'); // $ hasTaintFlow
            api.log((String) source(), (byte) 0, 'a'); // $ hasTaintFlow
            api.log((String) source(), (short) 0, 'a'); // $ hasTaintFlow
            api.log((String) source(), (int) 0, 'a'); // $ hasTaintFlow
            api.log((String) source(), (long) 0, 'a'); // $ hasTaintFlow
            api.log((String) source(), (float) 0, 'a'); // $ hasTaintFlow
            api.log((String) source(), (double) 0, 'a'); // $ hasTaintFlow
            api.log((String) source(), false, (byte) 0); // $ hasTaintFlow
            api.log((String) source(), 'a', (byte) 0); // $ hasTaintFlow
            api.log((String) source(), (byte) 0, (byte) 0); // $ hasTaintFlow
            api.log((String) source(), (short) 0, (byte) 0); // $ hasTaintFlow
            api.log((String) source(), (int) 0, (byte) 0); // $ hasTaintFlow
            api.log((String) source(), (long) 0, (byte) 0); // $ hasTaintFlow
            api.log((String) source(), (float) 0, (byte) 0); // $ hasTaintFlow
            api.log((String) source(), (double) 0, (byte) 0); // $ hasTaintFlow
            api.log((String) source(), false, (short) 0); // $ hasTaintFlow
            api.log((String) source(), 'a', (short) 0); // $ hasTaintFlow
            api.log((String) source(), (byte) 0, (short) 0); // $ hasTaintFlow
            api.log((String) source(), (short) 0, (short) 0); // $ hasTaintFlow
            api.log((String) source(), (int) 0, (short) 0); // $ hasTaintFlow
            api.log((String) source(), (long) 0, (short) 0); // $ hasTaintFlow
            api.log((String) source(), (float) 0, (short) 0); // $ hasTaintFlow
            api.log((String) source(), (double) 0, (short) 0); // $ hasTaintFlow
            api.log((String) source(), false, (int) 0); // $ hasTaintFlow
            api.log((String) source(), 'a', (int) 0); // $ hasTaintFlow
            api.log((String) source(), (byte) 0, (int) 0); // $ hasTaintFlow
            api.log((String) source(), (short) 0, (int) 0); // $ hasTaintFlow
            api.log((String) source(), (int) 0, (int) 0); // $ hasTaintFlow
            api.log((String) source(), (long) 0, (int) 0); // $ hasTaintFlow
            api.log((String) source(), (float) 0, (int) 0); // $ hasTaintFlow
            api.log((String) source(), (double) 0, (int) 0); // $ hasTaintFlow
            api.log((String) source(), false, (long) 0); // $ hasTaintFlow
            api.log((String) source(), 'a', (long) 0); // $ hasTaintFlow
            api.log((String) source(), (byte) 0, (long) 0); // $ hasTaintFlow
            api.log((String) source(), (short) 0, (long) 0); // $ hasTaintFlow
            api.log((String) source(), (int) 0, (long) 0); // $ hasTaintFlow
            api.log((String) source(), (long) 0, (long) 0); // $ hasTaintFlow
            api.log((String) source(), (float) 0, (long) 0); // $ hasTaintFlow
            api.log((String) source(), (double) 0, (long) 0); // $ hasTaintFlow
            api.log((String) source(), false, (float) 0); // $ hasTaintFlow
            api.log((String) source(), 'a', (float) 0); // $ hasTaintFlow
            api.log((String) source(), (byte) 0, (float) 0); // $ hasTaintFlow
            api.log((String) source(), (short) 0, (float) 0); // $ hasTaintFlow
            api.log((String) source(), (int) 0, (float) 0); // $ hasTaintFlow
            api.log((String) source(), (long) 0, (float) 0); // $ hasTaintFlow
            api.log((String) source(), (float) 0, (float) 0); // $ hasTaintFlow
            api.log((String) source(), (double) 0, (float) 0); // $ hasTaintFlow
            api.log((String) source(), false, (double) 0); // $ hasTaintFlow
            api.log((String) source(), 'a', (double) 0); // $ hasTaintFlow
            api.log((String) source(), (byte) 0, (double) 0); // $ hasTaintFlow
            api.log((String) source(), (short) 0, (double) 0); // $ hasTaintFlow
            api.log((String) source(), (int) 0, (double) 0); // $ hasTaintFlow
            api.log((String) source(), (long) 0, (double) 0); // $ hasTaintFlow
            api.log((String) source(), (float) 0, (double) 0); // $ hasTaintFlow
            api.log((String) source(), (double) 0, (double) 0); // $ hasTaintFlow
        }
        {
            java.util.logging.Logger logger = null;
            // @formatter:off
            logger.config((String) source()); // $ hasTaintFlow
            logger.config((java.util.function.Supplier) source()); // $ hasTaintFlow
            logger.fine((String) source()); // $ hasTaintFlow
            logger.fine((java.util.function.Supplier) source()); // $ hasTaintFlow
            logger.finer((String) source()); // $ hasTaintFlow
            logger.finer((java.util.function.Supplier) source()); // $ hasTaintFlow
            logger.finest((String) source()); // $ hasTaintFlow
            logger.finest((java.util.function.Supplier) source()); // $ hasTaintFlow
            logger.info((String) source()); // $ hasTaintFlow
            logger.info((java.util.function.Supplier) source()); // $ hasTaintFlow
            logger.severe((String) source()); // $ hasTaintFlow
            logger.severe((java.util.function.Supplier) source()); // $ hasTaintFlow
            logger.warning((String) source()); // $ hasTaintFlow
            logger.warning((java.util.function.Supplier) source()); // $ hasTaintFlow
            logger.entering((String) source(), (String) null); // $ hasTaintFlow
            logger.entering((String) null, (String) source()); // $ hasTaintFlow
            logger.entering((String) source(), (String) null, (Object) null); // $ hasTaintFlow
            logger.entering((String) null, (String) source(), (Object) null); // $ hasTaintFlow
            logger.entering((String) null, (String) null, (Object) source()); // $ hasTaintFlow
            logger.entering((String) source(), (String) null, (Object[]) null); // $ hasTaintFlow
            logger.entering((String) null, (String) source(), (Object[]) null); // $ hasTaintFlow
            logger.entering((String) null, (String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.exiting((String) source(), (String) null); // $ hasTaintFlow
            logger.exiting((String) null, (String) source()); // $ hasTaintFlow
            logger.exiting((String) source(), (String) null, (Object) null); // $ hasTaintFlow
            logger.exiting((String) null, (String) source(), (Object) null); // $ hasTaintFlow
            logger.exiting((String) null, (String) null, (Object) source()); // $ hasTaintFlow
            logger.log((java.util.logging.Level) null, (String) source()); // $ hasTaintFlow
            logger.log((java.util.logging.Level) null, (String) source(), (Object) null); // $ hasTaintFlow
            logger.log((java.util.logging.Level) null, (String) null, source()); // $ hasTaintFlow
            logger.log((java.util.logging.Level) null, (String) source(), (Object[]) null); // $ hasTaintFlow
            logger.log((java.util.logging.Level) null, (String) null, new Object[]{source()}); // $ hasTaintFlow
            logger.log((java.util.logging.Level) null, (String) source(), (Throwable) null); // $ hasTaintFlow
            logger.log((java.util.logging.Level) null, (java.util.function.Supplier) source()); // $ hasTaintFlow
            logger.log((java.util.logging.Level) null, (Throwable) null, (java.util.function.Supplier) source()); // $ hasTaintFlow
            logger.log((LogRecord) source()); // $ hasTaintFlow
            logger.logp((java.util.logging.Level) null, (String) source(), (String) null, (String) null); // $ hasTaintFlow
            logger.logp((java.util.logging.Level) null, (String) null, (String) source(), (String) null); // $ hasTaintFlow
            logger.logp((java.util.logging.Level) null, (String) null, (String) null, (String) source()); // $ hasTaintFlow
            logger.logp((java.util.logging.Level) null, (String) source(), (String) null, (String) null, (Object) null); // $ hasTaintFlow
            logger.logp((java.util.logging.Level) null, (String) null, (String) source(), (String) null, (Object) null); // $ hasTaintFlow
            logger.logp((java.util.logging.Level) null, (String) null, (String) null, (String) source(), (Object) null); // $ hasTaintFlow
            logger.logp((java.util.logging.Level) null, (String) null, (String) null, (String) null, source()); // $ hasTaintFlow
            logger.logp((java.util.logging.Level) null, (String) source(), (String) null, (String) null, (Object[]) null); // $ hasTaintFlow
            logger.logp((java.util.logging.Level) null, (String) null, (String) source(), (String) null, (Object[]) null); // $ hasTaintFlow
            logger.logp((java.util.logging.Level) null, (String) null, (String) null, (String) source(), (Object[]) null); // $ hasTaintFlow
            logger.logp((java.util.logging.Level) null, (String) null, (String) null, (String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.logp((java.util.logging.Level) null, (String) source(), (String) null, (String) null, (Throwable) null); // $ hasTaintFlow
            logger.logp((java.util.logging.Level) null, (String) null, (String) source(), (String) null, (Throwable) null); // $ hasTaintFlow
            logger.logp((java.util.logging.Level) null, (String) null, (String) null, (String) source(), (Throwable) null); // $ hasTaintFlow
            logger.logp((java.util.logging.Level) null, (String) source(), (String) null, (java.util.function.Supplier) null); // $ hasTaintFlow
            logger.logp((java.util.logging.Level) null, (String) null, (String) source(), (java.util.function.Supplier) null); // $ hasTaintFlow
            logger.logp((java.util.logging.Level) null, (String) null, (String) null, (java.util.function.Supplier) source()); // $ hasTaintFlow
            logger.logp((java.util.logging.Level) null, (String) source(), (String) null, (Throwable) null, (java.util.function.Supplier) null); // $ hasTaintFlow
            logger.logp((java.util.logging.Level) null, (String) null, (String) source(), (Throwable) null, (java.util.function.Supplier) null); // $ hasTaintFlow
            logger.logp((java.util.logging.Level) null, (String) null, (String) null, (Throwable) null, (java.util.function.Supplier) source()); // $ hasTaintFlow
            logger.logrb((java.util.logging.Level) null, (String) source(), (String) null, (ResourceBundle) null, (String) null, (Object[]) null); // $ hasTaintFlow
            logger.logrb((java.util.logging.Level) null, (String) null, (String) source(), (ResourceBundle) null, (String) null, (Object[]) null); // $ hasTaintFlow
            logger.logrb((java.util.logging.Level) null, (String) null, (String) null, (ResourceBundle) null, (String) source(), (Object[]) null); // $ hasTaintFlow
            logger.logrb((java.util.logging.Level) null, (String) null, (String) null, (ResourceBundle) null, (String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.logrb((java.util.logging.Level) null, (String) source(), (String) null, (ResourceBundle) null, (String) null, (Throwable) null); // $ hasTaintFlow
            logger.logrb((java.util.logging.Level) null, (String) null, (String) source(), (ResourceBundle) null, (String) null, (Throwable) null); // $ hasTaintFlow
            logger.logrb((java.util.logging.Level) null, (String) null, (String) null, (ResourceBundle) null, (String) source(), (Throwable) null); // $ hasTaintFlow
            logger.logrb((java.util.logging.Level) null, (String) source(), (String) null, (String) null, (String) null); // $ hasTaintFlow
            logger.logrb((java.util.logging.Level) null, (String) null, (String) source(), (String) null, (String) null); // $ hasTaintFlow
            logger.logrb((java.util.logging.Level) null, (String) null, (String) null, (String) source(), (String) null); // $ hasTaintFlow
            logger.logrb((java.util.logging.Level) null, (String) null, (String) null, (String) null, (String) source()); // $ hasTaintFlow
            logger.logrb((java.util.logging.Level) null, (String) source(), (String) null, (String) null, (String) null, (Object) null); // $ hasTaintFlow
            logger.logrb((java.util.logging.Level) null, (String) null, (String) source(), (String) null, (String) null, (Object) null); // $ hasTaintFlow
            logger.logrb((java.util.logging.Level) null, (String) null, (String) null, (String) source(), (String) null, (Object) null); // $ hasTaintFlow
            logger.logrb((java.util.logging.Level) null, (String) null, (String) null, (String) null, (String) source(), (Object) null); // $ hasTaintFlow
            logger.logrb((java.util.logging.Level) null, (String) null, (String) null, (String) null, (String) null, source()); // $ hasTaintFlow
            logger.logrb((java.util.logging.Level) null, (String) source(), (String) null, (String) null, (String) null, (Object[]) null); // $ hasTaintFlow
            logger.logrb((java.util.logging.Level) null, (String) null, (String) source(), (String) null, (String) null, (Object[]) null); // $ hasTaintFlow
            logger.logrb((java.util.logging.Level) null, (String) null, (String) null, (String) source(), (String) null, (Object[]) null); // $ hasTaintFlow
            logger.logrb((java.util.logging.Level) null, (String) null, (String) null, (String) null, (String) source(), (Object[]) null); // $ hasTaintFlow
            logger.logrb((java.util.logging.Level) null, (String) null, (String) null, (String) null, (String) null, new Object[] {source()}); // $ hasTaintFlow
            logger.logrb((java.util.logging.Level) null, (String) source(), (String) null, (String) null, (String) null, (Throwable) null); // $ hasTaintFlow
            logger.logrb((java.util.logging.Level) null, (String) null, (String) source(), (String) null, (String) null, (Throwable) null); // $ hasTaintFlow
            logger.logrb((java.util.logging.Level) null, (String) null, (String) null, (String) source(), (String) null, (Throwable) null); // $ hasTaintFlow
            logger.logrb((java.util.logging.Level) null, (String) null, (String) null, (String) null, (String) source(), (Throwable) null); // $ hasTaintFlow
            // @formatter:on
        }
        {
            android.util.Log.d("", (String) source()); // $ hasTaintFlow
            android.util.Log.v("", (String) source()); // $ hasTaintFlow
            android.util.Log.i("", (String) source()); // $ hasTaintFlow
            android.util.Log.w("", (String) source()); // $ hasTaintFlow
            android.util.Log.e("", (String) source()); // $ hasTaintFlow
            android.util.Log.wtf("", (String) source()); // $ hasTaintFlow
        }
        {
            // @formatter:off
            // "org.apache.cxf.common.logging;LogUtils;true;log;(Logger,Level,String);;Argument[2];log-injection;manual"
            LogUtils.log(null, null, (String) source()); // $ hasTaintFlow
            // "org.apache.cxf.common.logging;LogUtils;true;log;(Logger,Level,String,Object);;Argument[2];log-injection;manual"
            LogUtils.log(null, null, (String) source(), (Object) null); // $ hasTaintFlow
            // "org.apache.cxf.common.logging;LogUtils;true;log;(Logger,Level,String,Object[]);;Argument[2];log-injection;manual"
            LogUtils.log(null, null, (String) source(), (Object[]) null); // $ hasTaintFlow
            // "org.apache.cxf.common.logging;LogUtils;true;log;(Logger,Level,String,Throwable);;Argument[2];log-injection;manual"
            LogUtils.log(null, null, (String) source(), (Throwable) null); // $ hasTaintFlow
            // "org.apache.cxf.common.logging;LogUtils;true;log;(Logger,Level,String,Throwable,Object);;Argument[2];log-injection;manual"
            LogUtils.log(null, null, (String) source(), (Throwable) null, (Object) null); // $ hasTaintFlow
            // "org.apache.cxf.common.logging;LogUtils;true;log;(Logger,Level,String,Throwable,Object[]);;Argument[2];log-injection;manual"
            LogUtils.log(null, null, (String) source(), (Throwable) null, (Object) null, (Object) null); // $ hasTaintFlow
            // @formatter:on
        }
    }
}
