package loginjection;

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
        String source = (String) source(); // $ Source
        Logger logger = null;
        logger.debug(source.replace("\n", "")); // Safe
        logger.debug(source.replace("\n", "\n")); // $ Alert
        logger.debug(source.replace("\n", "\r")); // $ Alert
        logger.debug(source.replace("\r", "")); // Safe
        logger.debug(source.replace("\r", "\n")); // $ Alert
        logger.debug(source.replace("\r", "\r")); // $ Alert
        logger.debug(source.replace("something_else", "")); // $ Alert
        logger.debug(source.replace('\n', '_')); // Safe
        logger.debug(source.replace('\n', '\n')); // $ Alert
        logger.debug(source.replace('\n', '\r')); // $ Alert
        logger.debug(source.replace('\r', '_')); // Safe
        logger.debug(source.replace('\r', '\n')); // $ Alert
        logger.debug(source.replace('\r', '\r')); // $ Alert
        logger.debug(source.replace('-', '_')); // $ Alert
        logger.debug(source.replaceAll("\n", "")); // Safe
        logger.debug(source.replaceAll("\n", "\n")); // $ Alert
        logger.debug(source.replaceAll("\n", "\r")); // $ Alert
        logger.debug(source.replaceAll("\r", "")); // Safe
        logger.debug(source.replaceAll("\r", "\n")); // $ Alert
        logger.debug(source.replaceAll("\r", "\r")); // $ Alert
        logger.debug(source.replaceAll("\\n", "")); // Safe
        logger.debug(source.replaceAll("\\n", "\n")); // $ Alert
        logger.debug(source.replaceAll("\\n", "\r")); // $ Alert
        logger.debug(source.replaceAll("\\r", "")); // Safe
        logger.debug(source.replaceAll("\\r", "\n")); // $ Alert
        logger.debug(source.replaceAll("\\r", "\r")); // $ Alert
        logger.debug(source.replaceAll("\\R", "")); // Safe
        logger.debug(source.replaceAll("\\R", "\n")); // $ Alert
        logger.debug(source.replaceAll("\\R", "\r")); // $ Alert
        logger.debug(source.replaceAll("[^a-zA-Z]", "")); // Safe
        logger.debug(source.replaceAll("[^a-zA-Z]", "\n")); // $ Alert
        logger.debug(source.replaceAll("[^a-zA-Z]", "\r")); // $ Alert
        logger.debug(source.replaceAll("[^a-zA-Z\n]", "")); // $ Alert
        logger.debug(source.replaceAll("[^a-zA-Z\r]", "")); // $ Alert
        logger.debug(source.replaceAll("[^a-zA-Z\\R]", "")); // $ Alert
    }

    public void testGuards() {
        String source = (String) source(); // $ Source
        Logger logger = null;

        if (source.matches(".*\n.*")) {
            logger.debug(source); // $ Alert
        } else {
            logger.debug(source); // Safe
        }

        if (Pattern.matches(".*\n.*", source)) {
            logger.debug(source); // $ Alert
        } else {
            logger.debug(source); // Safe
        }

        if (source.matches(".*\\n.*")) {
            logger.debug(source); // $ Alert
        } else {
            logger.debug(source); // Safe
        }

        if (Pattern.matches(".*\\n.*", source)) {
            logger.debug(source); // $ Alert
        } else {
            logger.debug(source); // Safe
        }

        if (source.matches(".*\r.*")) {
            logger.debug(source); // $ Alert
        } else {
            logger.debug(source); // Safe
        }

        if (Pattern.matches(".*\r.*", source)) {
            logger.debug(source); // $ Alert
        } else {
            logger.debug(source); // Safe
        }

        if (source.matches(".*\\r.*")) {
            logger.debug(source); // $ Alert
        } else {
            logger.debug(source); // Safe
        }

        if (Pattern.matches(".*\\r.*", source)) {
            logger.debug(source); // $ Alert
        } else {
            logger.debug(source); // Safe
        }

        if (source.matches(".*\\R.*")) {
            logger.debug(source); // $ Alert
        } else {
            logger.debug(source); // Safe
        }

        if (Pattern.matches(".*\\R.*", source)) {
            logger.debug(source); // $ Alert
        } else {
            logger.debug(source); // Safe
        }

        if (source.matches(".*")) {
            logger.debug(source); // Safe (assuming not DOTALL)
        } else {
            logger.debug(source); // $ Alert
        }

        if (Pattern.matches(".*", source)) {
            logger.debug(source); // Safe (assuming not DOTALL)
        } else {
            logger.debug(source); // $ Alert
        }

        if (source.matches("[^\n\r]*")) {
            logger.debug(source); // Safe
        } else {
            logger.debug(source); // $ Alert
        }

        if (Pattern.matches("[^\n\r]*", source)) {
            logger.debug(source); // Safe
        } else {
            logger.debug(source); // $ Alert
        }

        if (source.matches("[^\\R]*")) {
            logger.debug(source); // Safe
        } else {
            logger.debug(source); // $ Alert
        }

        if (Pattern.matches("[^\\R]*", source)) {
            logger.debug(source); // Safe
        } else {
            logger.debug(source); // $ Alert
        }

        if (source.matches("[^a-zA-Z]*")) {
            logger.debug(source); // $ Alert
        } else {
            logger.debug(source); // $ Alert
        }

        if (Pattern.matches("[^a-zA-Z]*", source)) {
            logger.debug(source); // $ Alert
        } else {
            logger.debug(source); // $ Alert
        }

        if (source.matches("[\n]*")) {
            logger.debug(source); // $ Alert
        } else {
            logger.debug(source); // $ MISSING: $ Alert
        }

        if (Pattern.matches("[\n]*", source)) {
            logger.debug(source); // $ Alert
        } else {
            logger.debug(source); // $ MISSING: $ Alert
        }

    }

    public void test() {
        {
            Category category = null;
            category.assertLog(false, (String) source()); // $ Alert
            category.debug(source()); // $ Alert
            category.debug(source(), null); // $ Alert
            category.error(source()); // $ Alert
            category.error(source(), null); // $ Alert
            category.fatal(source()); // $ Alert
            category.fatal(source(), null); // $ Alert
            category.forcedLog(null, null, source(), null); // $ Alert
            category.info(source()); // $ Alert
            category.info(source(), null); // $ Alert
            category.l7dlog(null, null, new Object[] {source()}, null); // $ Alert
            category.log(null, source()); // $ Alert
            category.log(null, source(), null); // $ Alert
            category.log(null, null, source(), null); // $ Alert
            category.warn(source()); // $ Alert
            category.warn(source(), null); // $ Alert
        }
        {
            Logger logger = null;
            // @formatter:off
            logger.debug((CharSequence) source()); // $ Alert
            logger.debug((CharSequence) source(), (Throwable) null); // $ Alert
            logger.debug((Marker) null, (CharSequence) source()); // $ Alert
            logger.debug((Marker) null, (CharSequence) source(), null); // $ Alert
            logger.debug((Marker) null, (Message) source()); // $ Alert
            logger.debug((Marker) null, (MessageSupplier) source()); // $ Alert
            logger.debug((Marker) null, (MessageSupplier) source(), null); // $ Alert
            logger.debug((Marker) null, source()); // $ Alert
            logger.debug((Marker) null, (String) source()); // $ Alert
            logger.debug((Marker) null, (String) source(), new Object[] {}); // $ Alert
            logger.debug((Marker) null, (String) null, new Object[] {source()}); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) source()); // $ Alert
            logger.debug((Marker) null, (String) source(), (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) source()); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) source(), (Object) null); // $ Alert
            logger.debug((Marker) null, (String) source(), (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((Marker) null, (String) source(), (Supplier<?>) null); // $ Alert
            logger.debug((Marker) null, (String) null, (Supplier<?>) source()); // $ Alert
            logger.debug((Marker) null, (String) source(), (Throwable) null); // $ Alert
            logger.debug((Marker) null, (Supplier<?>) source()); // $ Alert
            logger.debug((Marker) null, (Supplier<?>) source(), (Throwable) null); // $ Alert
            logger.debug((MessageSupplier) source()); // $ Alert
            logger.debug((MessageSupplier) source(), (Throwable) null); // $ Alert
            logger.debug((Message) source()); // $ Alert
            logger.debug((Message) source(), (Throwable) null); // $ Alert
            logger.debug(source()); // $ Alert
            logger.debug(source(), (Throwable) null); // $ Alert
            logger.debug((String) source()); // $ Alert
            logger.debug((String) source(), (Object[]) null); // $ Alert
            logger.debug((String) null, new Object[] {source()}); // $ Alert
            logger.debug((String) null, (Object) source()); // $ Alert
            logger.debug((String) source(), (Object) null); // $ Alert
            logger.debug((String) null, (Object) null, (Object) source()); // $ Alert
            logger.debug((String) null, (Object) source(), (Object) null); // $ Alert
            logger.debug((String) source(), (Object) null, (Object) null); // $ Alert
            logger.debug((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.debug((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.debug((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.debug((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.debug((String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.debug((String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.debug((String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.debug((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.debug((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.debug((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((String) source(), (Supplier<?>) null); // $ Alert
            logger.debug((String) null, (Supplier<?>) source()); // $ Alert
            logger.debug((String) source(), (Throwable) null); // $ Alert
            logger.debug((Supplier<?>) source()); // $ Alert
            logger.debug((Supplier<?>) source(), (Throwable) null); // $ Alert
            logger.error((CharSequence) source()); // $ Alert
            logger.error((CharSequence) source(), (Throwable) null); // $ Alert
            logger.error((Marker) null, (CharSequence) source()); // $ Alert
            logger.error((Marker) null, (CharSequence) source(), null); // $ Alert
            logger.error((Marker) null, (Message) source()); // $ Alert
            logger.error((Marker) null, (MessageSupplier) source()); // $ Alert
            logger.error((Marker) null, (MessageSupplier) source(), null); // $ Alert
            logger.error((Marker) null, source()); // $ Alert
            logger.error((Marker) null, (String) source()); // $ Alert
            logger.error((Marker) null, (String) source(), new Object[] {}); // $ Alert
            logger.error((Marker) null, (String) null, new Object[] {source()}); // $ Alert
            logger.error((Marker) null, (String) null, (Object) source()); // $ Alert
            logger.error((Marker) null, (String) source(), (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) source()); // $ Alert
            logger.error((Marker) null, (String) null, (Object) source(), (Object) null); // $ Alert
            logger.error((Marker) null, (String) source(), (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((Marker) null, (String) source(), (Supplier<?>) null); // $ Alert
            logger.error((Marker) null, (String) null, (Supplier<?>) source()); // $ Alert
            logger.error((Marker) null, (String) source(), (Throwable) null); // $ Alert
            logger.error((Marker) null, (Supplier<?>) source()); // $ Alert
            logger.error((Marker) null, (Supplier<?>) source(), (Throwable) null); // $ Alert
            logger.error((MessageSupplier) source()); // $ Alert
            logger.error((MessageSupplier) source(), (Throwable) null); // $ Alert
            logger.error((Message) source()); // $ Alert
            logger.error((Message) source(), (Throwable) null); // $ Alert
            logger.error(source()); // $ Alert
            logger.error(source(), (Throwable) null); // $ Alert
            logger.error((String) source()); // $ Alert
            logger.error((String) source(), (Object[]) null); // $ Alert
            logger.error((String) null, new Object[] {source()}); // $ Alert
            logger.error((String) null, (Object) source()); // $ Alert
            logger.error((String) source(), (Object) null); // $ Alert
            logger.error((String) null, (Object) null, (Object) source()); // $ Alert
            logger.error((String) null, (Object) source(), (Object) null); // $ Alert
            logger.error((String) source(), (Object) null, (Object) null); // $ Alert
            logger.error((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.error((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.error((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.error((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.error((String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.error((String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.error((String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.error((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.error((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.error((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((String) source(), (Supplier<?>) null); // $ Alert
            logger.error((String) null, (Supplier<?>) source()); // $ Alert
            logger.error((String) source(), (Throwable) null); // $ Alert
            logger.error((Supplier<?>) source()); // $ Alert
            logger.error((Supplier<?>) source(), (Throwable) null); // $ Alert
            logger.fatal((CharSequence) source()); // $ Alert
            logger.fatal((CharSequence) source(), (Throwable) null); // $ Alert
            logger.fatal((Marker) null, (CharSequence) source()); // $ Alert
            logger.fatal((Marker) null, (CharSequence) source(), null); // $ Alert
            logger.fatal((Marker) null, (Message) source()); // $ Alert
            logger.fatal((Marker) null, (MessageSupplier) source()); // $ Alert
            logger.fatal((Marker) null, (MessageSupplier) source(), null); // $ Alert
            logger.fatal((Marker) null, source()); // $ Alert
            logger.fatal((Marker) null, (String) source()); // $ Alert
            logger.fatal((Marker) null, (String) source(), new Object[] {}); // $ Alert
            logger.fatal((Marker) null, (String) null, new Object[] {source()}); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) source()); // $ Alert
            logger.fatal((Marker) null, (String) source(), (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) source()); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) source(), (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) source(), (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((Marker) null, (String) source(), (Supplier<?>) null); // $ Alert
            logger.fatal((Marker) null, (String) null, (Supplier<?>) source()); // $ Alert
            logger.fatal((Marker) null, (String) source(), (Throwable) null); // $ Alert
            logger.fatal((Marker) null, (Supplier<?>) source()); // $ Alert
            logger.fatal((Marker) null, (Supplier<?>) source(), (Throwable) null); // $ Alert
            logger.fatal((MessageSupplier) source()); // $ Alert
            logger.fatal((MessageSupplier) source(), (Throwable) null); // $ Alert
            logger.fatal((Message) source()); // $ Alert
            logger.fatal((Message) source(), (Throwable) null); // $ Alert
            logger.fatal(source()); // $ Alert
            logger.fatal(source(), (Throwable) null); // $ Alert
            logger.fatal((String) source()); // $ Alert
            logger.fatal((String) source(), (Object[]) null); // $ Alert
            logger.fatal((String) null, new Object[] {source()}); // $ Alert
            logger.fatal((String) null, (Object) source()); // $ Alert
            logger.fatal((String) source(), (Object) null); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) source()); // $ Alert
            logger.fatal((String) null, (Object) source(), (Object) null); // $ Alert
            logger.fatal((String) source(), (Object) null, (Object) null); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.fatal((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.fatal((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.fatal((String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatal((String) source(), (Supplier<?>) null); // $ Alert
            logger.fatal((String) null, (Supplier<?>) source()); // $ Alert
            logger.fatal((String) source(), (Throwable) null); // $ Alert
            logger.fatal((Supplier<?>) source()); // $ Alert
            logger.fatal((Supplier<?>) source(), (Throwable) null); // $ Alert
            logger.info((CharSequence) source()); // $ Alert
            logger.info((CharSequence) source(), (Throwable) null); // $ Alert
            logger.info((Marker) null, (CharSequence) source()); // $ Alert
            logger.info((Marker) null, (CharSequence) source(), null); // $ Alert
            logger.info((Marker) null, (Message) source()); // $ Alert
            logger.info((Marker) null, (MessageSupplier) source()); // $ Alert
            logger.info((Marker) null, (MessageSupplier) source(), null); // $ Alert
            logger.info((Marker) null, source()); // $ Alert
            logger.info((Marker) null, (String) source()); // $ Alert
            logger.info((Marker) null, (String) source(), new Object[] {}); // $ Alert
            logger.info((Marker) null, (String) null, new Object[] {source()}); // $ Alert
            logger.info((Marker) null, (String) null, (Object) source()); // $ Alert
            logger.info((Marker) null, (String) source(), (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) source()); // $ Alert
            logger.info((Marker) null, (String) null, (Object) source(), (Object) null); // $ Alert
            logger.info((Marker) null, (String) source(), (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((Marker) null, (String) source(), (Supplier<?>) null); // $ Alert
            logger.info((Marker) null, (String) null, (Supplier<?>) source()); // $ Alert
            logger.info((Marker) null, (String) source(), (Throwable) null); // $ Alert
            logger.info((Marker) null, (Supplier<?>) source()); // $ Alert
            logger.info((Marker) null, (Supplier<?>) source(), (Throwable) null); // $ Alert
            logger.info((MessageSupplier) source()); // $ Alert
            logger.info((MessageSupplier) source(), (Throwable) null); // $ Alert
            logger.info((Message) source()); // $ Alert
            logger.info((Message) source(), (Throwable) null); // $ Alert
            logger.info(source()); // $ Alert
            logger.info(source(), (Throwable) null); // $ Alert
            logger.info((String) source()); // $ Alert
            logger.info((String) source(), (Object[]) null); // $ Alert
            logger.info((String) null, new Object[] {source()}); // $ Alert
            logger.info((String) null, (Object) source()); // $ Alert
            logger.info((String) source(), (Object) null); // $ Alert
            logger.info((String) null, (Object) null, (Object) source()); // $ Alert
            logger.info((String) null, (Object) source(), (Object) null); // $ Alert
            logger.info((String) source(), (Object) null, (Object) null); // $ Alert
            logger.info((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.info((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.info((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.info((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.info((String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.info((String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.info((String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.info((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.info((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.info((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((String) source(), (Supplier<?>) null); // $ Alert
            logger.info((String) null, (Supplier<?>) source()); // $ Alert
            logger.info((String) source(), (Throwable) null); // $ Alert
            logger.info((Supplier<?>) source()); // $ Alert
            logger.info((Supplier<?>) source(), (Throwable) null); // $ Alert
            logger.log((Level) null, (CharSequence) source()); // $ Alert
            logger.log((Level) null, (CharSequence) source(), (Throwable) null); // $ Alert
            logger.log((Level) null, (Marker) null, (CharSequence) source()); // $ Alert
            logger.log((Level) null, (Marker) null, (CharSequence) source(), null); // $ Alert
            logger.log((Level) null, (Marker) null, (Message) source()); // $ Alert
            logger.log((Level) null, (Marker) null, (MessageSupplier) source()); // $ Alert
            logger.log((Level) null, (Marker) null, (MessageSupplier) source(), null); // $ Alert
            logger.log((Level) null, (Marker) null, source()); // $ Alert
            logger.log((Level) null, (Marker) null, (String) source()); // $ Alert
            logger.log((Level) null, (Marker) null, (String) source(), new Object[] {}); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, new Object[] {source()}); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) source()); // $ Alert
            logger.log((Level) null, (Marker) null, (String) source(), (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) source()); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) source(), (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) source(), (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) source(), (Supplier<?>) null); // $ Alert
            logger.log((Level) null, (Marker) null, (String) null, (Supplier<?>) source()); // $ Alert
            logger.log((Level) null, (Marker) null, (String) source(), (Throwable) null); // $ Alert
            logger.log((Level) null, (Marker) null, (Supplier<?>) source()); // $ Alert
            logger.log((Level) null, (Marker) null, (Supplier<?>) source(), (Throwable) null); // $ Alert
            logger.log((Level) null, (MessageSupplier) source()); // $ Alert
            logger.log((Level) null, (MessageSupplier) source(), (Throwable) null); // $ Alert
            logger.log((Level) null, (Message) source()); // $ Alert
            logger.log((Level) null, (Message) source(), (Throwable) null); // $ Alert
            logger.log((Level) null, source()); // $ Alert
            logger.log((Level) null, source(), (Throwable) null); // $ Alert
            logger.log((Level) null, (String) source()); // $ Alert
            logger.log((Level) null, (String) source(), (Object[]) null); // $ Alert
            logger.log((Level) null, (String) null, new Object[] {source()}); // $ Alert
            logger.log((Level) null, (String) null, (Object) source()); // $ Alert
            logger.log((Level) null, (String) source(), (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) source()); // $ Alert
            logger.log((Level) null, (String) null, (Object) source(), (Object) null); // $ Alert
            logger.log((Level) null, (String) source(), (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.log((Level) null, (String) source(), (Supplier<?>) null); // $ Alert
            logger.log((Level) null, (String) null, (Supplier<?>) source()); // $ Alert
            logger.log((Level) null, (String) source(), (Throwable) null); // $ Alert
            logger.log((Level) null, (Supplier<?>) source()); // $ Alert
            logger.log((Level) null, (Supplier<?>) source(), (Throwable) null); // $ Alert
            logger.trace((CharSequence) source()); // $ Alert
            logger.trace((CharSequence) source(), (Throwable) null); // $ Alert
            logger.trace((Marker) null, (CharSequence) source()); // $ Alert
            logger.trace((Marker) null, (CharSequence) source(), null); // $ Alert
            logger.trace((Marker) null, (Message) source()); // $ Alert
            logger.trace((Marker) null, (MessageSupplier) source()); // $ Alert
            logger.trace((Marker) null, (MessageSupplier) source(), null); // $ Alert
            logger.trace((Marker) null, source()); // $ Alert
            logger.trace((Marker) null, (String) source()); // $ Alert
            logger.trace((Marker) null, (String) source(), new Object[] {}); // $ Alert
            logger.trace((Marker) null, (String) null, new Object[] {source()}); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) source()); // $ Alert
            logger.trace((Marker) null, (String) source(), (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) source()); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) source(), (Object) null); // $ Alert
            logger.trace((Marker) null, (String) source(), (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((Marker) null, (String) source(), (Supplier<?>) null); // $ Alert
            logger.trace((Marker) null, (String) null, (Supplier<?>) source()); // $ Alert
            logger.trace((Marker) null, (String) source(), (Throwable) null); // $ Alert
            logger.trace((Marker) null, (Supplier<?>) source()); // $ Alert
            logger.trace((Marker) null, (Supplier<?>) source(), (Throwable) null); // $ Alert
            logger.trace((MessageSupplier) source()); // $ Alert
            logger.trace((MessageSupplier) source(), (Throwable) null); // $ Alert
            logger.trace((Message) source()); // $ Alert
            logger.trace((Message) source(), (Throwable) null); // $ Alert
            logger.trace(source()); // $ Alert
            logger.trace(source(), (Throwable) null); // $ Alert
            logger.trace((String) source()); // $ Alert
            logger.trace((String) source(), (Object[]) null); // $ Alert
            logger.trace((String) null, new Object[] {source()}); // $ Alert
            logger.trace((String) null, (Object) source()); // $ Alert
            logger.trace((String) source(), (Object) null); // $ Alert
            logger.trace((String) null, (Object) null, (Object) source()); // $ Alert
            logger.trace((String) null, (Object) source(), (Object) null); // $ Alert
            logger.trace((String) source(), (Object) null, (Object) null); // $ Alert
            logger.trace((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.trace((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.trace((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.trace((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.trace((String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.trace((String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.trace((String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.trace((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.trace((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.trace((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((String) source(), (Supplier<?>) null); // $ Alert
            logger.trace((String) null, (Supplier<?>) source()); // $ Alert
            logger.trace((String) source(), (Throwable) null); // $ Alert
            logger.trace((Supplier<?>) source()); // $ Alert
            logger.trace((Supplier<?>) source(), (Throwable) null); // $ Alert
            logger.warn((CharSequence) source()); // $ Alert
            logger.warn((CharSequence) source(), (Throwable) null); // $ Alert
            logger.warn((Marker) null, (CharSequence) source()); // $ Alert
            logger.warn((Marker) null, (CharSequence) source(), null); // $ Alert
            logger.warn((Marker) null, (Message) source()); // $ Alert
            logger.warn((Marker) null, (MessageSupplier) source()); // $ Alert
            logger.warn((Marker) null, (MessageSupplier) source(), null); // $ Alert
            logger.warn((Marker) null, source()); // $ Alert
            logger.warn((Marker) null, (String) source()); // $ Alert
            logger.warn((Marker) null, (String) source(), new Object[] {}); // $ Alert
            logger.warn((Marker) null, (String) null, new Object[] {source()}); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) source()); // $ Alert
            logger.warn((Marker) null, (String) source(), (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) source()); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) source(), (Object) null); // $ Alert
            logger.warn((Marker) null, (String) source(), (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((Marker) null, (String) source(), (Supplier<?>) null); // $ Alert
            logger.warn((Marker) null, (String) null, (Supplier<?>) source()); // $ Alert
            logger.warn((Marker) null, (String) source(), (Throwable) null); // $ Alert
            logger.warn((Marker) null, (Supplier<?>) source()); // $ Alert
            logger.warn((Marker) null, (Supplier<?>) source(), (Throwable) null); // $ Alert
            logger.warn((MessageSupplier) source()); // $ Alert
            logger.warn((MessageSupplier) source(), (Throwable) null); // $ Alert
            logger.warn((Message) source()); // $ Alert
            logger.warn((Message) source(), (Throwable) null); // $ Alert
            logger.warn(source()); // $ Alert
            logger.warn(source(), (Throwable) null); // $ Alert
            logger.warn((String) source()); // $ Alert
            logger.warn((String) source(), (Object[]) null); // $ Alert
            logger.warn((String) null, new Object[] {source()}); // $ Alert
            logger.warn((String) null, (Object) source()); // $ Alert
            logger.warn((String) source(), (Object) null); // $ Alert
            logger.warn((String) null, (Object) null, (Object) source()); // $ Alert
            logger.warn((String) null, (Object) source(), (Object) null); // $ Alert
            logger.warn((String) source(), (Object) null, (Object) null); // $ Alert
            logger.warn((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.warn((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.warn((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.warn((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.warn((String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.warn((String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.warn((String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.warn((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.warn((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.warn((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((String) source(), (Supplier<?>) null); // $ Alert
            logger.warn((String) null, (Supplier<?>) source()); // $ Alert
            logger.warn((String) source(), (Throwable) null); // $ Alert
            logger.warn((Supplier<?>) source()); // $ Alert
            logger.warn((Supplier<?>) source(), (Throwable) null); // $ Alert
            // @formatter:on
            logger.logMessage(null, null, null, null, (Message) source(), null); // $ Alert
            logger.printf(null, null, (String) source(), (Object[]) null); // $ Alert
            logger.printf(null, null, null, new Object[] {source()}); // $ Alert
            logger.printf(null, (String) source(), (Object[]) null); // $ Alert
            logger.printf(null, null, new Object[] {source()}); // $ Alert
            logger.traceEntry((Message) source()); // $ Alert
            logger.traceEntry((String) source(), (Object[]) null); // $ Alert
            logger.traceEntry((String) null, new Object[] {source()}); // $ Alert
            logger.traceEntry((String) source(), (Supplier<?>) null); // $ Alert
            logger.traceEntry((String) null, (Supplier<?>) source()); // $ Alert
            logger.traceEntry((Supplier<?>) source()); // $ Alert
            logger.traceExit((EntryMessage) source()); // $ Alert
            logger.traceExit((EntryMessage) source(), null); // $ Alert
            logger.traceExit((EntryMessage) null, source()); // $ Alert
            logger.traceExit((Message) source(), null); // $ Alert
            logger.traceExit((Message) null, source()); // $ Alert
            logger.traceExit(source()); // $ Alert
            logger.traceExit((String) source(), null); // $ Alert
            logger.traceExit((String) null, source()); // $ Alert
        }
        {
            LogBuilder builder = null;
            builder.log((CharSequence) source()); // $ Alert
            builder.log((Message) source()); // $ Alert
            builder.log(source()); // $ Alert
            builder.log((String) source()); // $ Alert
            builder.log((String) source(), (Object[]) null); // $ Alert
            builder.log((String) null, new Object[] {source()}); // $ Alert
            builder.log((String) null, source()); // $ Alert
            // @formatter:off
            builder.log((String) null, (Object) source()); // $ Alert
            builder.log((String) source(), (Object) null); // $ Alert
            builder.log((String) null, (Object) null, (Object) source()); // $ Alert
            builder.log((String) null, (Object) source(), (Object) null); // $ Alert
            builder.log((String) source(), (Object) null, (Object) null); // $ Alert
            builder.log((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            builder.log((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            builder.log((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            builder.log((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            builder.log((String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            builder.log((String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            builder.log((String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            builder.log((String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            builder.log((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            builder.log((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            builder.log((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            builder.log((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            builder.log((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            builder.log((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            builder.log((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            builder.log((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            builder.log((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            builder.log((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            builder.log((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            builder.log((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            builder.log((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            builder.log((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            builder.log((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            builder.log((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            builder.log((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            builder.log((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            builder.log((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            builder.log((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            builder.log((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            // @formatter:on
            builder.log((String) source(), (Supplier<?>) null); // $ Alert
            builder.log((String) null, (Supplier<?>) source()); // $ Alert
            builder.log((Supplier<?>) source()); // $ Alert
        }
        {
            Log log = null;
            log.debug(source()); // $ Alert
            log.error(source()); // $ Alert
            log.fatal(source()); // $ Alert
            log.info(source()); // $ Alert
            log.trace(source()); // $ Alert
            log.warn(source()); // $ Alert
        }
        {
            BasicLogger bLogger = null;
            // @formatter:off
            bLogger.debug(source()); // $ Alert
            bLogger.debug(source(), null); // $ Alert
            // Deprecated: bLogger.debug(source(), (Object[]) null); // $ Alert
            // Deprecated: bLogger.debug((Object) null, new Object[] {source()}); // $ Alert
            // Deprecated: bLogger.debug((Object) null, new Object[] {source()}, (Throwable) null); // $ Alert
            bLogger.debug((String) null, source(), (Object[]) null, (Throwable) null); // $ Alert
            bLogger.debug((String) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ Alert
            bLogger.debug((String) null, source(), (Throwable) null); // $ Alert
            bLogger.error(source()); // $ Alert
            bLogger.error(source(), null); // $ Alert
            // Deprecated: bLogger.error(source(), (Object[]) null); // $ Alert
            // Deprecated: bLogger.error((Object) null, new Object[] {source()}); // $ Alert
            // Deprecated: bLogger.error((Object) null, new Object[] {source()}, (Throwable) null); // $ Alert
            bLogger.error((String) null, source(), (Object[]) null, (Throwable) null); // $ Alert
            bLogger.error((String) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ Alert
            bLogger.error((String) null, source(), (Throwable) null); // $ Alert
            bLogger.fatal(source()); // $ Alert
            bLogger.fatal(source(), null); // $ Alert
            // Deprecated: bLogger.fatal(source(), (Object[]) null); // $ Alert
            // Deprecated: bLogger.fatal((Object) null, new Object[] {source()}); // $ Alert
            // Deprecated: bLogger.fatal((Object) null, new Object[] {source()}, (Throwable) null); // $ Alert
            bLogger.fatal((String) null, source(), (Object[]) null, (Throwable) null); // $ Alert
            bLogger.fatal((String) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ Alert
            bLogger.fatal((String) null, source(), (Throwable) null); // $ Alert
            bLogger.info(source()); // $ Alert
            bLogger.info(source(), null); // $ Alert
            // Deprecated: bLogger.info(source(), (Object[]) null); // $ Alert
            // Deprecated: bLogger.info((Object) null, new Object[] {source()}); // $ Alert
            // Deprecated: bLogger.info((Object) null, new Object[] {source()}, (Throwable) null); // $ Alert
            bLogger.info((String) null, source(), (Object[]) null, (Throwable) null); // $ Alert
            bLogger.info((String) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ Alert
            bLogger.info((String) null, source(), (Throwable) null); // $ Alert
            bLogger.trace(source()); // $ Alert
            bLogger.trace(source(), null); // $ Alert
            // Deprecated: bLogger.trace(source(), (Object[]) null); // $ Alert
            // Deprecated: bLogger.trace((Object) null, new Object[] {source()}); // $ Alert
            // Deprecated: bLogger.trace((Object) null, new Object[] {source()}, (Throwable) null); // $ Alert
            bLogger.trace((String) null, source(), (Object[]) null, (Throwable) null); // $ Alert
            bLogger.trace((String) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ Alert
            bLogger.trace((String) null, source(), (Throwable) null); // $ Alert
            bLogger.warn(source()); // $ Alert
            bLogger.warn(source(), null); // $ Alert
            // Deprecated: bLogger.warn(source(), (Object[]) null); // $ Alert
            // Deprecated: bLogger.warn((Object) null, new Object[] {source()}); // $ Alert
            // Deprecated: bLogger.warn((Object) null, new Object[] {source()}, (Throwable) null); // $ Alert
            bLogger.warn((String) null, source(), (Object[]) null, (Throwable) null); // $ Alert
            bLogger.warn((String) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ Alert
            bLogger.warn((String) null, source(), (Throwable) null); // $ Alert
            bLogger.log((org.jboss.logging.Logger.Level) null, source()); // $ Alert
            bLogger.log((org.jboss.logging.Logger.Level) null, source(), null); // $ Alert
            // Deprecated: bLogger.log((org.jboss.logging.Logger.Level) null, source(), (Object[]) null); // $ Alert
            // Deprecated: bLogger.log((org.jboss.logging.Logger.Level) null, (Object) null, new Object[] {source()}); // $ Alert
            // Deprecated: bLogger.log((org.jboss.logging.Logger.Level) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ Alert
            bLogger.log((org.jboss.logging.Logger.Level) null, (String) null, source(), (Throwable) null); // $ Alert
            bLogger.log((String) null, (org.jboss.logging.Logger.Level) null, source(), (Object[]) null, (Throwable) null); // $ Alert
            bLogger.log((String) null, (org.jboss.logging.Logger.Level) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ Alert
            bLogger.debugf((String) null, (Object) source()); // $ Alert
            bLogger.debugf((String) source(), (Object) null); // $ Alert
            bLogger.debugv((String) null, (Object) source()); // $ Alert
            bLogger.debugv((String) source(), (Object) null); // $ Alert
            bLogger.debugf((String) source(), (Object[]) null); // $ Alert
            bLogger.debugv((String) source(), (Object[]) null); // $ Alert
            bLogger.debugf((String) null, new Object[] {source()}); // $ Alert
            bLogger.debugv((String) null, new Object[] {source()}); // $ Alert
            bLogger.debugf((String) null, (Object) null, (Object) source()); // $ Alert
            bLogger.debugf((String) null, (Object) source(), (Object) null); // $ Alert
            bLogger.debugf((String) source(), (Object) null, (Object) null); // $ Alert
            bLogger.debugv((String) null, (Object) null, (Object) source()); // $ Alert
            bLogger.debugv((String) null, (Object) source(), (Object) null); // $ Alert
            bLogger.debugv((String) source(), (Object) null, (Object) null); // $ Alert
            bLogger.debugf((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            bLogger.debugf((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            bLogger.debugf((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            bLogger.debugf((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            bLogger.debugv((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            bLogger.debugv((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            bLogger.debugv((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            bLogger.debugv((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            bLogger.errorf((String) null, (Object) source()); // $ Alert
            bLogger.errorf((String) source(), (Object) null); // $ Alert
            bLogger.errorv((String) null, (Object) source()); // $ Alert
            bLogger.errorv((String) source(), (Object) null); // $ Alert
            bLogger.errorf((String) source(), (Object[]) null); // $ Alert
            bLogger.errorv((String) source(), (Object[]) null); // $ Alert
            bLogger.errorf((String) null, new Object[] {source()}); // $ Alert
            bLogger.errorv((String) null, new Object[] {source()}); // $ Alert
            bLogger.errorf((String) null, (Object) null, (Object) source()); // $ Alert
            bLogger.errorf((String) null, (Object) source(), (Object) null); // $ Alert
            bLogger.errorf((String) source(), (Object) null, (Object) null); // $ Alert
            bLogger.errorv((String) null, (Object) null, (Object) source()); // $ Alert
            bLogger.errorv((String) null, (Object) source(), (Object) null); // $ Alert
            bLogger.errorv((String) source(), (Object) null, (Object) null); // $ Alert
            bLogger.errorf((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            bLogger.errorf((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            bLogger.errorf((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            bLogger.errorf((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            bLogger.errorv((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            bLogger.errorv((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            bLogger.errorv((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            bLogger.errorv((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            bLogger.fatalf((String) null, (Object) source()); // $ Alert
            bLogger.fatalf((String) source(), (Object) null); // $ Alert
            bLogger.fatalv((String) null, (Object) source()); // $ Alert
            bLogger.fatalv((String) source(), (Object) null); // $ Alert
            bLogger.fatalf((String) source(), (Object[]) null); // $ Alert
            bLogger.fatalv((String) source(), (Object[]) null); // $ Alert
            bLogger.fatalf((String) null, new Object[] {source()}); // $ Alert
            bLogger.fatalv((String) null, new Object[] {source()}); // $ Alert
            bLogger.fatalf((String) null, (Object) null, (Object) source()); // $ Alert
            bLogger.fatalf((String) null, (Object) source(), (Object) null); // $ Alert
            bLogger.fatalf((String) source(), (Object) null, (Object) null); // $ Alert
            bLogger.fatalv((String) null, (Object) null, (Object) source()); // $ Alert
            bLogger.fatalv((String) null, (Object) source(), (Object) null); // $ Alert
            bLogger.fatalv((String) source(), (Object) null, (Object) null); // $ Alert
            bLogger.fatalf((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            bLogger.fatalf((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            bLogger.fatalf((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            bLogger.fatalf((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            bLogger.fatalv((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            bLogger.fatalv((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            bLogger.fatalv((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            bLogger.fatalv((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            bLogger.infof((String) null, (Object) source()); // $ Alert
            bLogger.infof((String) source(), (Object) null); // $ Alert
            bLogger.infov((String) null, (Object) source()); // $ Alert
            bLogger.infov((String) source(), (Object) null); // $ Alert
            bLogger.infof((String) source(), (Object[]) null); // $ Alert
            bLogger.infov((String) source(), (Object[]) null); // $ Alert
            bLogger.infof((String) null, new Object[] {source()}); // $ Alert
            bLogger.infov((String) null, new Object[] {source()}); // $ Alert
            bLogger.infof((String) null, (Object) null, (Object) source()); // $ Alert
            bLogger.infof((String) null, (Object) source(), (Object) null); // $ Alert
            bLogger.infof((String) source(), (Object) null, (Object) null); // $ Alert
            bLogger.infov((String) null, (Object) null, (Object) source()); // $ Alert
            bLogger.infov((String) null, (Object) source(), (Object) null); // $ Alert
            bLogger.infov((String) source(), (Object) null, (Object) null); // $ Alert
            bLogger.infof((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            bLogger.infof((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            bLogger.infof((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            bLogger.infof((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            bLogger.infov((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            bLogger.infov((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            bLogger.infov((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            bLogger.infov((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            bLogger.logf((org.jboss.logging.Logger.Level) null, (String) null, (Object) source()); // $ Alert
            bLogger.logf((org.jboss.logging.Logger.Level) null, (String) source(), (Object) null); // $ Alert
            bLogger.logv((org.jboss.logging.Logger.Level) null, (String) null, (Object) source()); // $ Alert
            bLogger.logv((org.jboss.logging.Logger.Level) null, (String) source(), (Object) null); // $ Alert
            bLogger.logf((org.jboss.logging.Logger.Level) null, (String) source(), (Object[]) null); // $ Alert
            bLogger.logv((org.jboss.logging.Logger.Level) null, (String) source(), (Object[]) null); // $ Alert
            bLogger.logf((org.jboss.logging.Logger.Level) null, (String) null, new Object[] {source()}); // $ Alert
            bLogger.logv((org.jboss.logging.Logger.Level) null, (String) null, new Object[] {source()}); // $ Alert
            bLogger.logf((org.jboss.logging.Logger.Level) null, (String) null, (Object) null, (Object) source()); // $ Alert
            bLogger.logf((org.jboss.logging.Logger.Level) null, (String) null, (Object) source(), (Object) null); // $ Alert
            bLogger.logf((org.jboss.logging.Logger.Level) null, (String) source(), (Object) null, (Object) null); // $ Alert
            bLogger.logv((org.jboss.logging.Logger.Level) null, (String) null, (Object) null, (Object) source()); // $ Alert
            bLogger.logv((org.jboss.logging.Logger.Level) null, (String) null, (Object) source(), (Object) null); // $ Alert
            bLogger.logv((org.jboss.logging.Logger.Level) null, (String) source(), (Object) null, (Object) null); // $ Alert
            bLogger.logf((org.jboss.logging.Logger.Level) null, (String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            bLogger.logf((org.jboss.logging.Logger.Level) null, (String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            bLogger.logf((org.jboss.logging.Logger.Level) null, (String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            bLogger.logf((org.jboss.logging.Logger.Level) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            bLogger.logv((org.jboss.logging.Logger.Level) null, (String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            bLogger.logv((org.jboss.logging.Logger.Level) null, (String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            bLogger.logv((org.jboss.logging.Logger.Level) null, (String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            bLogger.logv((org.jboss.logging.Logger.Level) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            bLogger.tracef((String) null, (Object) source()); // $ Alert
            bLogger.tracef((String) source(), (Object) null); // $ Alert
            bLogger.tracev((String) null, (Object) source()); // $ Alert
            bLogger.tracev((String) source(), (Object) null); // $ Alert
            bLogger.tracef((String) source(), (Object[]) null); // $ Alert
            bLogger.tracev((String) source(), (Object[]) null); // $ Alert
            bLogger.tracef((String) null, new Object[] {source()}); // $ Alert
            bLogger.tracev((String) null, new Object[] {source()}); // $ Alert
            bLogger.tracef((String) null, (Object) null, (Object) source()); // $ Alert
            bLogger.tracef((String) null, (Object) source(), (Object) null); // $ Alert
            bLogger.tracef((String) source(), (Object) null, (Object) null); // $ Alert
            bLogger.tracev((String) null, (Object) null, (Object) source()); // $ Alert
            bLogger.tracev((String) null, (Object) source(), (Object) null); // $ Alert
            bLogger.tracev((String) source(), (Object) null, (Object) null); // $ Alert
            bLogger.tracef((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            bLogger.tracef((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            bLogger.tracef((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            bLogger.tracef((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            bLogger.tracev((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            bLogger.tracev((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            bLogger.tracev((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            bLogger.tracev((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            bLogger.warnf((String) null, (Object) source()); // $ Alert
            bLogger.warnf((String) source(), (Object) null); // $ Alert
            bLogger.warnv((String) null, (Object) source()); // $ Alert
            bLogger.warnv((String) source(), (Object) null); // $ Alert
            bLogger.warnf((String) source(), (Object[]) null); // $ Alert
            bLogger.warnv((String) source(), (Object[]) null); // $ Alert
            bLogger.warnf((String) null, new Object[] {source()}); // $ Alert
            bLogger.warnv((String) null, new Object[] {source()}); // $ Alert
            bLogger.warnf((String) null, (Object) null, (Object) source()); // $ Alert
            bLogger.warnf((String) null, (Object) source(), (Object) null); // $ Alert
            bLogger.warnf((String) source(), (Object) null, (Object) null); // $ Alert
            bLogger.warnv((String) null, (Object) null, (Object) source()); // $ Alert
            bLogger.warnv((String) null, (Object) source(), (Object) null); // $ Alert
            bLogger.warnv((String) source(), (Object) null, (Object) null); // $ Alert
            bLogger.warnf((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            bLogger.warnf((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            bLogger.warnf((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            bLogger.warnf((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            bLogger.warnv((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            bLogger.warnv((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            bLogger.warnv((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            bLogger.warnv((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            // @formatter:on
        }
        {
            org.jboss.logging.Logger logger = null;
            // @formatter:off
            logger.debug(source()); // $ Alert
            logger.debug(source(), (Throwable) null); // $ Alert
            // Deprecated: logger.debug(source(), (Object[]) null); // $ Alert
            // Deprecated: logger.debug((Object) null, new Object[] {source()}); // $ Alert
            // Deprecated: logger.debug((Object) null, new Object[] {source()}, (Throwable) null); // $ Alert
            logger.debug((String) null, source(), (Object[]) null, (Throwable) null); // $ Alert
            logger.debug((String) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ Alert
            logger.debug((String) null, source(), (Throwable) null); // $ Alert
            logger.error(source()); // $ Alert
            logger.error(source(), (Throwable) null); // $ Alert
            // Deprecated: logger.error(source(), (Object[]) null); // $ Alert
            // Deprecated: logger.error((Object) null, new Object[] {source()}); // $ Alert
            // Deprecated: logger.error((Object) null, new Object[] {source()}, (Throwable) null); // $ Alert
            logger.error((String) null, source(), (Object[]) null, (Throwable) null); // $ Alert
            logger.error((String) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ Alert
            logger.error((String) null, source(), (Throwable) null); // $ Alert
            logger.fatal(source()); // $ Alert
            logger.fatal(source(), (Throwable) null); // $ Alert
            // Deprecated: logger.fatal(source(), (Object[]) null); // $ Alert
            // Deprecated: logger.fatal((Object) null, new Object[] {source()}); // $ Alert
            // Deprecated: logger.fatal((Object) null, new Object[] {source()}, (Throwable) null); // $ Alert
            logger.fatal((String) null, source(), (Object[]) null, (Throwable) null); // $ Alert
            logger.fatal((String) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ Alert
            logger.fatal((String) null, source(), (Throwable) null); // $ Alert
            logger.info(source()); // $ Alert
            logger.info(source(), (Throwable) null); // $ Alert
            // Deprecated: logger.info(source(), (Object[]) null); // $ Alert
            // Deprecated: logger.info((Object) null, new Object[] {source()}); // $ Alert
            // Deprecated: logger.info((Object) null, new Object[] {source()}, (Throwable) null); // $ Alert
            logger.info((String) null, source(), (Object[]) null, (Throwable) null); // $ Alert
            logger.info((String) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ Alert
            logger.info((String) null, source(), (Throwable) null); // $ Alert
            logger.trace(source()); // $ Alert
            logger.trace(source(), (Throwable) null); // $ Alert
            // Deprecated: logger.trace(source(), (Object[]) null); // $ Alert
            // Deprecated: logger.trace((Object) null, new Object[] {source()}); // $ Alert
            // Deprecated: logger.trace((Object) null, new Object[] {source()}, (Throwable) null); // $ Alert
            logger.trace((String) null, source(), (Object[]) null, (Throwable) null); // $ Alert
            logger.trace((String) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ Alert
            logger.trace((String) null, source(), (Throwable) null); // $ Alert
            logger.warn(source()); // $ Alert
            logger.warn(source(), (Throwable) null); // $ Alert
            // Deprecated: logger.warn(source(), (Object[]) null); // $ Alert
            // Deprecated: logger.warn((Object) null, new Object[] {source()}); // $ Alert
            // Deprecated: logger.warn((Object) null, new Object[] {source()}, (Throwable) null); // $ Alert
            logger.warn((String) null, source(), (Object[]) null, (Throwable) null); // $ Alert
            logger.warn((String) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ Alert
            logger.warn((String) null, source(), (Throwable) null); // $ Alert
            logger.log((org.jboss.logging.Logger.Level) null, source()); // $ Alert
            logger.log((org.jboss.logging.Logger.Level) null, source(), (Throwable) null); // $ Alert
            // Deprecated: logger.log((org.jboss.logging.Logger.Level) null, source(), (Object[]) null); // $ Alert
            // Deprecated: logger.log((org.jboss.logging.Logger.Level) null, (Object) null, new Object[] {source()}); // $ Alert
            // Deprecated: logger.log((org.jboss.logging.Logger.Level) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ Alert
            logger.log((org.jboss.logging.Logger.Level) null, (String) null, source(), (Throwable) null); // $ Alert
            logger.log((String) null, (org.jboss.logging.Logger.Level) null, source(), (Object[]) null, (Throwable) null); // $ Alert
            logger.log((String) null, (org.jboss.logging.Logger.Level) null, (Object) null, new Object[] {source()}, (Throwable) null); // $ Alert
            logger.debugf((String) null, (Object) source()); // $ Alert
            logger.debugf((String) source(), (Object) null); // $ Alert
            logger.debugv((String) null, (Object) source()); // $ Alert
            logger.debugv((String) source(), (Object) null); // $ Alert
            logger.debugf((String) source(), (Object[]) null); // $ Alert
            logger.debugv((String) source(), (Object[]) null); // $ Alert
            logger.debugf((String) null, new Object[] {source()}); // $ Alert
            logger.debugv((String) null, new Object[] {source()}); // $ Alert
            logger.debugf((String) null, (Object) null, (Object) source()); // $ Alert
            logger.debugf((String) null, (Object) source(), (Object) null); // $ Alert
            logger.debugf((String) source(), (Object) null, (Object) null); // $ Alert
            logger.debugv((String) null, (Object) null, (Object) source()); // $ Alert
            logger.debugv((String) null, (Object) source(), (Object) null); // $ Alert
            logger.debugv((String) source(), (Object) null, (Object) null); // $ Alert
            logger.debugf((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.debugf((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.debugf((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.debugf((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debugv((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.debugv((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.debugv((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.debugv((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.errorf((String) null, (Object) source()); // $ Alert
            logger.errorf((String) source(), (Object) null); // $ Alert
            logger.errorv((String) null, (Object) source()); // $ Alert
            logger.errorv((String) source(), (Object) null); // $ Alert
            logger.errorf((String) source(), (Object[]) null); // $ Alert
            logger.errorv((String) source(), (Object[]) null); // $ Alert
            logger.errorf((String) null, new Object[] {source()}); // $ Alert
            logger.errorv((String) null, new Object[] {source()}); // $ Alert
            logger.errorf((String) null, (Object) null, (Object) source()); // $ Alert
            logger.errorf((String) null, (Object) source(), (Object) null); // $ Alert
            logger.errorf((String) source(), (Object) null, (Object) null); // $ Alert
            logger.errorv((String) null, (Object) null, (Object) source()); // $ Alert
            logger.errorv((String) null, (Object) source(), (Object) null); // $ Alert
            logger.errorv((String) source(), (Object) null, (Object) null); // $ Alert
            logger.errorf((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.errorf((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.errorf((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.errorf((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.errorv((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.errorv((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.errorv((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.errorv((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatalf((String) null, (Object) source()); // $ Alert
            logger.fatalf((String) source(), (Object) null); // $ Alert
            logger.fatalv((String) null, (Object) source()); // $ Alert
            logger.fatalv((String) source(), (Object) null); // $ Alert
            logger.fatalf((String) source(), (Object[]) null); // $ Alert
            logger.fatalv((String) source(), (Object[]) null); // $ Alert
            logger.fatalf((String) null, new Object[] {source()}); // $ Alert
            logger.fatalv((String) null, new Object[] {source()}); // $ Alert
            logger.fatalf((String) null, (Object) null, (Object) source()); // $ Alert
            logger.fatalf((String) null, (Object) source(), (Object) null); // $ Alert
            logger.fatalf((String) source(), (Object) null, (Object) null); // $ Alert
            logger.fatalv((String) null, (Object) null, (Object) source()); // $ Alert
            logger.fatalv((String) null, (Object) source(), (Object) null); // $ Alert
            logger.fatalv((String) source(), (Object) null, (Object) null); // $ Alert
            logger.fatalf((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.fatalf((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.fatalf((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.fatalf((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.fatalv((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.fatalv((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.fatalv((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.fatalv((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.infof((String) null, (Object) source()); // $ Alert
            logger.infof((String) source(), (Object) null); // $ Alert
            logger.infov((String) null, (Object) source()); // $ Alert
            logger.infov((String) source(), (Object) null); // $ Alert
            logger.infof((String) source(), (Object[]) null); // $ Alert
            logger.infov((String) source(), (Object[]) null); // $ Alert
            logger.infof((String) null, new Object[] {source()}); // $ Alert
            logger.infov((String) null, new Object[] {source()}); // $ Alert
            logger.infof((String) null, (Object) null, (Object) source()); // $ Alert
            logger.infof((String) null, (Object) source(), (Object) null); // $ Alert
            logger.infof((String) source(), (Object) null, (Object) null); // $ Alert
            logger.infov((String) null, (Object) null, (Object) source()); // $ Alert
            logger.infov((String) null, (Object) source(), (Object) null); // $ Alert
            logger.infov((String) source(), (Object) null, (Object) null); // $ Alert
            logger.infof((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.infof((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.infof((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.infof((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.infov((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.infov((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.infov((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.infov((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.logf((org.jboss.logging.Logger.Level) null, (String) null, (Object) source()); // $ Alert
            logger.logf((org.jboss.logging.Logger.Level) null, (String) source(), (Object) null); // $ Alert
            logger.logv((org.jboss.logging.Logger.Level) null, (String) null, (Object) source()); // $ Alert
            logger.logv((org.jboss.logging.Logger.Level) null, (String) source(), (Object) null); // $ Alert
            logger.logf((org.jboss.logging.Logger.Level) null, (String) source(), (Object[]) null); // $ Alert
            logger.logv((org.jboss.logging.Logger.Level) null, (String) source(), (Object[]) null); // $ Alert
            logger.logf((org.jboss.logging.Logger.Level) null, (String) null, new Object[] {source()}); // $ Alert
            logger.logv((org.jboss.logging.Logger.Level) null, (String) null, new Object[] {source()}); // $ Alert
            logger.logf((org.jboss.logging.Logger.Level) null, (String) null, (Object) null, (Object) source()); // $ Alert
            logger.logf((org.jboss.logging.Logger.Level) null, (String) null, (Object) source(), (Object) null); // $ Alert
            logger.logf((org.jboss.logging.Logger.Level) null, (String) source(), (Object) null, (Object) null); // $ Alert
            logger.logv((org.jboss.logging.Logger.Level) null, (String) null, (Object) null, (Object) source()); // $ Alert
            logger.logv((org.jboss.logging.Logger.Level) null, (String) null, (Object) source(), (Object) null); // $ Alert
            logger.logv((org.jboss.logging.Logger.Level) null, (String) source(), (Object) null, (Object) null); // $ Alert
            logger.logf((org.jboss.logging.Logger.Level) null, (String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.logf((org.jboss.logging.Logger.Level) null, (String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.logf((org.jboss.logging.Logger.Level) null, (String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.logf((org.jboss.logging.Logger.Level) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.logv((org.jboss.logging.Logger.Level) null, (String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.logv((org.jboss.logging.Logger.Level) null, (String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.logv((org.jboss.logging.Logger.Level) null, (String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.logv((org.jboss.logging.Logger.Level) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.tracef((String) null, (Object) source()); // $ Alert
            logger.tracef((String) source(), (Object) null); // $ Alert
            logger.tracev((String) null, (Object) source()); // $ Alert
            logger.tracev((String) source(), (Object) null); // $ Alert
            logger.tracef((String) source(), (Object[]) null); // $ Alert
            logger.tracev((String) source(), (Object[]) null); // $ Alert
            logger.tracef((String) null, new Object[] {source()}); // $ Alert
            logger.tracev((String) null, new Object[] {source()}); // $ Alert
            logger.tracef((String) null, (Object) null, (Object) source()); // $ Alert
            logger.tracef((String) null, (Object) source(), (Object) null); // $ Alert
            logger.tracef((String) source(), (Object) null, (Object) null); // $ Alert
            logger.tracev((String) null, (Object) null, (Object) source()); // $ Alert
            logger.tracev((String) null, (Object) source(), (Object) null); // $ Alert
            logger.tracev((String) source(), (Object) null, (Object) null); // $ Alert
            logger.tracef((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.tracef((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.tracef((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.tracef((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.tracev((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.tracev((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.tracev((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.tracev((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warnf((String) null, (Object) source()); // $ Alert
            logger.warnf((String) source(), (Object) null); // $ Alert
            logger.warnv((String) null, (Object) source()); // $ Alert
            logger.warnv((String) source(), (Object) null); // $ Alert
            logger.warnf((String) source(), (Object[]) null); // $ Alert
            logger.warnv((String) source(), (Object[]) null); // $ Alert
            logger.warnf((String) null, new Object[] {source()}); // $ Alert
            logger.warnv((String) null, new Object[] {source()}); // $ Alert
            logger.warnf((String) null, (Object) null, (Object) source()); // $ Alert
            logger.warnf((String) null, (Object) source(), (Object) null); // $ Alert
            logger.warnf((String) source(), (Object) null, (Object) null); // $ Alert
            logger.warnv((String) null, (Object) null, (Object) source()); // $ Alert
            logger.warnv((String) null, (Object) source(), (Object) null); // $ Alert
            logger.warnv((String) source(), (Object) null, (Object) null); // $ Alert
            logger.warnf((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.warnf((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.warnf((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.warnf((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warnv((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            logger.warnv((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            logger.warnv((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            logger.warnv((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            // @formatter:on
        }
        {
            LoggingEventBuilder builder = null;
            builder.log((String) source()); // $ Alert
            builder.log((String) source(), (Object) null); // $ Alert
            builder.log((String) null, source()); // $ Alert
            builder.log((String) source(), (Object[]) null); // $ Alert
            builder.log((String) null, new Object[] {source()}); // $ Alert
            builder.log((String) source(), (Object) null, (Object) null); // $ Alert
            builder.log((String) null, source(), (Object) null); // $ Alert
            builder.log((String) null, (Object) null, source()); // $ Alert
            builder.log((java.util.function.Supplier) source()); // $ Alert
        }
        {
            org.slf4j.Logger logger = null;
            // @formatter:off
            logger.debug((String) source()); // $ Alert
            logger.debug((String) source(), (Object) null); // $ Alert
            logger.debug((String) null, source()); // $ Alert
            logger.debug((String) source(), (Object[]) null); // $ Alert
            logger.debug((String) null, new Object[] {source()}); // $ Alert
            logger.debug((String) source(), (Object) null, (Object) null); // $ Alert
            logger.debug((String) null, source(), (Object) null); // $ Alert
            logger.debug((String) null, (Object) null, source()); // $ Alert
            logger.debug((String) source(), (Throwable) null); // $ Alert
            logger.debug((org.slf4j.Marker) null, (String) source()); // $ Alert
            logger.debug((org.slf4j.Marker) null, (String) source(), (Object) null); // $ Alert
            logger.debug((org.slf4j.Marker) null, (String) null, source()); // $ Alert
            logger.debug((org.slf4j.Marker) null, (String) source(), (Object[]) null); // $ Alert
            logger.debug((org.slf4j.Marker) null, (String) null, new Object[] {source()}); // $ Alert
            logger.debug((org.slf4j.Marker) null, (String) source(), (Object) null, (Object) null); // $ Alert
            logger.debug((org.slf4j.Marker) null, (String) null, source(), (Object) null); // $ Alert
            logger.debug((org.slf4j.Marker) null, (String) null, (Object) null, source()); // $ Alert
            logger.debug((org.slf4j.Marker) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.debug((org.slf4j.Marker) null, (String) null, source(), (Object) null, (Object) null); // $ Alert
            logger.debug((org.slf4j.Marker) null, (String) null, (Object) null, source(), (Object) null); // $ Alert
            logger.debug((org.slf4j.Marker) null, (String) null, (Object) null, (Object) null, source()); // $ Alert
            logger.error((String) source()); // $ Alert
            logger.error((String) source(), (Object) null); // $ Alert
            logger.error((String) null, source()); // $ Alert
            logger.error((String) source(), (Object[]) null); // $ Alert
            logger.error((String) null, new Object[] {source()}); // $ Alert
            logger.error((String) source(), (Object) null, (Object) null); // $ Alert
            logger.error((String) null, source(), (Object) null); // $ Alert
            logger.error((String) null, (Object) null, source()); // $ Alert
            logger.error((String) source(), (Throwable) null); // $ Alert
            logger.error((org.slf4j.Marker) null, (String) source()); // $ Alert
            logger.error((org.slf4j.Marker) null, (String) source(), (Object) null); // $ Alert
            logger.error((org.slf4j.Marker) null, (String) null, source()); // $ Alert
            logger.error((org.slf4j.Marker) null, (String) source(), (Object[]) null); // $ Alert
            logger.error((org.slf4j.Marker) null, (String) null, new Object[] {source()}); // $ Alert
            logger.error((org.slf4j.Marker) null, (String) source(), (Object) null, (Object) null); // $ Alert
            logger.error((org.slf4j.Marker) null, (String) null, source(), (Object) null); // $ Alert
            logger.error((org.slf4j.Marker) null, (String) null, (Object) null, source()); // $ Alert
            logger.error((org.slf4j.Marker) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.error((org.slf4j.Marker) null, (String) null, source(), (Object) null, (Object) null); // $ Alert
            logger.error((org.slf4j.Marker) null, (String) null, (Object) null, source(), (Object) null); // $ Alert
            logger.error((org.slf4j.Marker) null, (String) null, (Object) null, (Object) null, source()); // $ Alert
            logger.info((String) source()); // $ Alert
            logger.info((String) source(), (Object) null); // $ Alert
            logger.info((String) null, source()); // $ Alert
            logger.info((String) source(), (Object[]) null); // $ Alert
            logger.info((String) null, new Object[] {source()}); // $ Alert
            logger.info((String) source(), (Object) null, (Object) null); // $ Alert
            logger.info((String) null, source(), (Object) null); // $ Alert
            logger.info((String) null, (Object) null, source()); // $ Alert
            logger.info((String) source(), (Throwable) null); // $ Alert
            logger.info((org.slf4j.Marker) null, (String) source()); // $ Alert
            logger.info((org.slf4j.Marker) null, (String) source(), (Object) null); // $ Alert
            logger.info((org.slf4j.Marker) null, (String) null, source()); // $ Alert
            logger.info((org.slf4j.Marker) null, (String) source(), (Object[]) null); // $ Alert
            logger.info((org.slf4j.Marker) null, (String) null, new Object[] {source()}); // $ Alert
            logger.info((org.slf4j.Marker) null, (String) source(), (Object) null, (Object) null); // $ Alert
            logger.info((org.slf4j.Marker) null, (String) null, source(), (Object) null); // $ Alert
            logger.info((org.slf4j.Marker) null, (String) null, (Object) null, source()); // $ Alert
            logger.info((org.slf4j.Marker) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.info((org.slf4j.Marker) null, (String) null, source(), (Object) null, (Object) null); // $ Alert
            logger.info((org.slf4j.Marker) null, (String) null, (Object) null, source(), (Object) null); // $ Alert
            logger.info((org.slf4j.Marker) null, (String) null, (Object) null, (Object) null, source()); // $ Alert
            logger.trace((String) source()); // $ Alert
            logger.trace((String) source(), (Object) null); // $ Alert
            logger.trace((String) null, source()); // $ Alert
            logger.trace((String) source(), (Object[]) null); // $ Alert
            logger.trace((String) null, new Object[] {source()}); // $ Alert
            logger.trace((String) source(), (Object) null, (Object) null); // $ Alert
            logger.trace((String) null, source(), (Object) null); // $ Alert
            logger.trace((String) null, (Object) null, source()); // $ Alert
            logger.trace((String) source(), (Throwable) null); // $ Alert
            logger.trace((org.slf4j.Marker) null, (String) source()); // $ Alert
            logger.trace((org.slf4j.Marker) null, (String) source(), (Object) null); // $ Alert
            logger.trace((org.slf4j.Marker) null, (String) null, source()); // $ Alert
            logger.trace((org.slf4j.Marker) null, (String) source(), (Object[]) null); // $ Alert
            logger.trace((org.slf4j.Marker) null, (String) null, new Object[] {source()}); // $ Alert
            logger.trace((org.slf4j.Marker) null, (String) source(), (Object) null, (Object) null); // $ Alert
            logger.trace((org.slf4j.Marker) null, (String) null, source(), (Object) null); // $ Alert
            logger.trace((org.slf4j.Marker) null, (String) null, (Object) null, source()); // $ Alert
            logger.trace((org.slf4j.Marker) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.trace((org.slf4j.Marker) null, (String) null, source(), (Object) null, (Object) null); // $ Alert
            logger.trace((org.slf4j.Marker) null, (String) null, (Object) null, source(), (Object) null); // $ Alert
            logger.trace((org.slf4j.Marker) null, (String) null, (Object) null, (Object) null, source()); // $ Alert
            logger.warn((String) source()); // $ Alert
            logger.warn((String) source(), (Object) null); // $ Alert
            logger.warn((String) null, source()); // $ Alert
            logger.warn((String) source(), (Object[]) null); // $ Alert
            logger.warn((String) null, new Object[] {source()}); // $ Alert
            logger.warn((String) source(), (Object) null, (Object) null); // $ Alert
            logger.warn((String) null, source(), (Object) null); // $ Alert
            logger.warn((String) null, (Object) null, source()); // $ Alert
            logger.warn((String) source(), (Throwable) null); // $ Alert
            logger.warn((org.slf4j.Marker) null, (String) source()); // $ Alert
            logger.warn((org.slf4j.Marker) null, (String) source(), (Object) null); // $ Alert
            logger.warn((org.slf4j.Marker) null, (String) null, source()); // $ Alert
            logger.warn((org.slf4j.Marker) null, (String) source(), (Object[]) null); // $ Alert
            logger.warn((org.slf4j.Marker) null, (String) null, new Object[] {source()}); // $ Alert
            logger.warn((org.slf4j.Marker) null, (String) source(), (Object) null, (Object) null); // $ Alert
            logger.warn((org.slf4j.Marker) null, (String) null, source(), (Object) null); // $ Alert
            logger.warn((org.slf4j.Marker) null, (String) null, (Object) null, source()); // $ Alert
            logger.warn((org.slf4j.Marker) null, (String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            logger.warn((org.slf4j.Marker) null, (String) null, source(), (Object) null, (Object) null); // $ Alert
            logger.warn((org.slf4j.Marker) null, (String) null, (Object) null, source(), (Object) null); // $ Alert
            logger.warn((org.slf4j.Marker) null, (String) null, (Object) null, (Object) null, source()); // $ Alert
            // @formatter:on
        }
        {
            org.scijava.log.Logger logger = null;
            logger.alwaysLog(0, source(), null); // $ Alert
            logger.debug(source()); // $ Alert
            logger.debug(source(), null); // $ Alert
            logger.error(source()); // $ Alert
            logger.error(source(), null); // $ Alert
            logger.info(source()); // $ Alert
            logger.info(source(), null); // $ Alert
            logger.trace(source()); // $ Alert
            logger.trace(source(), null); // $ Alert
            logger.warn(source()); // $ Alert
            logger.warn(source(), null); // $ Alert
            logger.log(0, source()); // $ Alert
            logger.log(0, source(), null); // $ Alert
        }
        {
            LoggingApi api = null;
            api.logVarargs((String) source(), (Object[]) null); // $ Alert
            api.logVarargs((String) null, new Object[] {source()}); // $ Alert
            // @formatter:off
            api.log((String) source()); // $ Alert
            api.log((String) null, (Object) source()); // $ Alert
            api.log((String) source(), (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) source()); // $ Alert
            api.log((String) null, (Object) source(), (Object) null); // $ Alert
            api.log((String) source(), (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            api.log((String) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            api.log((String) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            api.log((String) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source()); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, new Object[]{source()}); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object[]) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object[]) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object[]) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object[]) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object[]) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object[]) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object[]) null); // $ Alert
            api.log((String) null, (Object) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object[]) null); // $ Alert
            api.log((String) null, (Object) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object[]) null); // $ Alert
            api.log((String) null, (Object) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object[]) null); // $ Alert
            api.log((String) source(), (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object) null, (Object[]) null); // $ Alert
            // @formatter:on
            api.log((String) source(), 'a'); // $ Alert
            api.log((String) source(), (byte) 0); // $ Alert
            api.log((String) source(), (short) 0); // $ Alert
            api.log((String) source(), 0); // $ Alert
            api.log((String) source(), 0L); // $ Alert
            api.log((String) source(), (Object) null, false); // $ Alert
            api.log((String) null, source(), false); // $ Alert
            api.log((String) source(), (Object) null, 'a'); // $ Alert
            api.log((String) null, source(), 'a'); // $ Alert
            api.log((String) source(), (Object) null, (byte) 0); // $ Alert
            api.log((String) null, source(), (byte) 0); // $ Alert
            api.log((String) source(), (Object) null, (short) 0); // $ Alert
            api.log((String) null, source(), (short) 0); // $ Alert
            api.log((String) source(), (Object) null, 0); // $ Alert
            api.log((String) null, source(), 0); // $ Alert
            api.log((String) source(), (Object) null, 0L); // $ Alert
            api.log((String) null, source(), 0L); // $ Alert
            api.log((String) source(), (Object) null, (float) 0); // $ Alert
            api.log((String) null, source(), (float) 0); // $ Alert
            api.log((String) source(), (Object) null, (double) 0); // $ Alert
            api.log((String) null, source(), (double) 0); // $ Alert
            api.log((String) source(), false, (Object) null); // $ Alert
            api.log((String) null, false, source()); // $ Alert
            api.log((String) source(), 'a', (Object) null); // $ Alert
            api.log((String) null, 'a', source()); // $ Alert
            api.log((String) source(), (byte) 0, (Object) null); // $ Alert
            api.log((String) null, (byte) 0, source()); // $ Alert
            api.log((String) source(), (short) 0, (Object) null); // $ Alert
            api.log((String) null, (short) 0, source()); // $ Alert
            api.log((String) source(), 0, (Object) null); // $ Alert
            api.log((String) null, 0, source()); // $ Alert
            api.log((String) source(), 0L, (Object) null); // $ Alert
            api.log((String) null, 0L, source()); // $ Alert
            api.log((String) source(), (float) 0, (Object) null); // $ Alert
            api.log((String) null, (float) 0, source()); // $ Alert
            api.log((String) source(), (double) 0, (Object) null); // $ Alert
            api.log((String) null, (double) 0, source()); // $ Alert
            api.log((String) source(), false, false); // $ Alert
            api.log((String) source(), 'a', false); // $ Alert
            api.log((String) source(), (byte) 0, false); // $ Alert
            api.log((String) source(), (short) 0, false); // $ Alert
            api.log((String) source(), (int) 0, false); // $ Alert
            api.log((String) source(), (long) 0, false); // $ Alert
            api.log((String) source(), (float) 0, false); // $ Alert
            api.log((String) source(), (double) 0, false); // $ Alert
            api.log((String) source(), false, 'a'); // $ Alert
            api.log((String) source(), 'a', 'a'); // $ Alert
            api.log((String) source(), (byte) 0, 'a'); // $ Alert
            api.log((String) source(), (short) 0, 'a'); // $ Alert
            api.log((String) source(), (int) 0, 'a'); // $ Alert
            api.log((String) source(), (long) 0, 'a'); // $ Alert
            api.log((String) source(), (float) 0, 'a'); // $ Alert
            api.log((String) source(), (double) 0, 'a'); // $ Alert
            api.log((String) source(), false, (byte) 0); // $ Alert
            api.log((String) source(), 'a', (byte) 0); // $ Alert
            api.log((String) source(), (byte) 0, (byte) 0); // $ Alert
            api.log((String) source(), (short) 0, (byte) 0); // $ Alert
            api.log((String) source(), (int) 0, (byte) 0); // $ Alert
            api.log((String) source(), (long) 0, (byte) 0); // $ Alert
            api.log((String) source(), (float) 0, (byte) 0); // $ Alert
            api.log((String) source(), (double) 0, (byte) 0); // $ Alert
            api.log((String) source(), false, (short) 0); // $ Alert
            api.log((String) source(), 'a', (short) 0); // $ Alert
            api.log((String) source(), (byte) 0, (short) 0); // $ Alert
            api.log((String) source(), (short) 0, (short) 0); // $ Alert
            api.log((String) source(), (int) 0, (short) 0); // $ Alert
            api.log((String) source(), (long) 0, (short) 0); // $ Alert
            api.log((String) source(), (float) 0, (short) 0); // $ Alert
            api.log((String) source(), (double) 0, (short) 0); // $ Alert
            api.log((String) source(), false, (int) 0); // $ Alert
            api.log((String) source(), 'a', (int) 0); // $ Alert
            api.log((String) source(), (byte) 0, (int) 0); // $ Alert
            api.log((String) source(), (short) 0, (int) 0); // $ Alert
            api.log((String) source(), (int) 0, (int) 0); // $ Alert
            api.log((String) source(), (long) 0, (int) 0); // $ Alert
            api.log((String) source(), (float) 0, (int) 0); // $ Alert
            api.log((String) source(), (double) 0, (int) 0); // $ Alert
            api.log((String) source(), false, (long) 0); // $ Alert
            api.log((String) source(), 'a', (long) 0); // $ Alert
            api.log((String) source(), (byte) 0, (long) 0); // $ Alert
            api.log((String) source(), (short) 0, (long) 0); // $ Alert
            api.log((String) source(), (int) 0, (long) 0); // $ Alert
            api.log((String) source(), (long) 0, (long) 0); // $ Alert
            api.log((String) source(), (float) 0, (long) 0); // $ Alert
            api.log((String) source(), (double) 0, (long) 0); // $ Alert
            api.log((String) source(), false, (float) 0); // $ Alert
            api.log((String) source(), 'a', (float) 0); // $ Alert
            api.log((String) source(), (byte) 0, (float) 0); // $ Alert
            api.log((String) source(), (short) 0, (float) 0); // $ Alert
            api.log((String) source(), (int) 0, (float) 0); // $ Alert
            api.log((String) source(), (long) 0, (float) 0); // $ Alert
            api.log((String) source(), (float) 0, (float) 0); // $ Alert
            api.log((String) source(), (double) 0, (float) 0); // $ Alert
            api.log((String) source(), false, (double) 0); // $ Alert
            api.log((String) source(), 'a', (double) 0); // $ Alert
            api.log((String) source(), (byte) 0, (double) 0); // $ Alert
            api.log((String) source(), (short) 0, (double) 0); // $ Alert
            api.log((String) source(), (int) 0, (double) 0); // $ Alert
            api.log((String) source(), (long) 0, (double) 0); // $ Alert
            api.log((String) source(), (float) 0, (double) 0); // $ Alert
            api.log((String) source(), (double) 0, (double) 0); // $ Alert
        }
        {
            java.util.logging.Logger logger = null;
            // @formatter:off
            logger.config((String) source()); // $ Alert
            logger.config((java.util.function.Supplier) source()); // $ Alert
            logger.fine((String) source()); // $ Alert
            logger.fine((java.util.function.Supplier) source()); // $ Alert
            logger.finer((String) source()); // $ Alert
            logger.finer((java.util.function.Supplier) source()); // $ Alert
            logger.finest((String) source()); // $ Alert
            logger.finest((java.util.function.Supplier) source()); // $ Alert
            logger.info((String) source()); // $ Alert
            logger.info((java.util.function.Supplier) source()); // $ Alert
            logger.severe((String) source()); // $ Alert
            logger.severe((java.util.function.Supplier) source()); // $ Alert
            logger.warning((String) source()); // $ Alert
            logger.warning((java.util.function.Supplier) source()); // $ Alert
            logger.entering((String) source(), (String) null); // $ Alert
            logger.entering((String) null, (String) source()); // $ Alert
            logger.entering((String) source(), (String) null, (Object) null); // $ Alert
            logger.entering((String) null, (String) source(), (Object) null); // $ Alert
            logger.entering((String) null, (String) null, (Object) source()); // $ Alert
            logger.entering((String) source(), (String) null, (Object[]) null); // $ Alert
            logger.entering((String) null, (String) source(), (Object[]) null); // $ Alert
            logger.entering((String) null, (String) null, new Object[] {source()}); // $ Alert
            logger.exiting((String) source(), (String) null); // $ Alert
            logger.exiting((String) null, (String) source()); // $ Alert
            logger.exiting((String) source(), (String) null, (Object) null); // $ Alert
            logger.exiting((String) null, (String) source(), (Object) null); // $ Alert
            logger.exiting((String) null, (String) null, (Object) source()); // $ Alert
            logger.log((java.util.logging.Level) null, (String) source()); // $ Alert
            logger.log((java.util.logging.Level) null, (String) source(), (Object) null); // $ Alert
            logger.log((java.util.logging.Level) null, (String) null, source()); // $ Alert
            logger.log((java.util.logging.Level) null, (String) source(), (Object[]) null); // $ Alert
            logger.log((java.util.logging.Level) null, (String) null, new Object[]{source()}); // $ Alert
            logger.log((java.util.logging.Level) null, (String) source(), (Throwable) null); // $ Alert
            logger.log((java.util.logging.Level) null, (java.util.function.Supplier) source()); // $ Alert
            logger.log((java.util.logging.Level) null, (Throwable) null, (java.util.function.Supplier) source()); // $ Alert
            logger.log((LogRecord) source()); // $ Alert
            logger.logp((java.util.logging.Level) null, (String) source(), (String) null, (String) null); // $ Alert
            logger.logp((java.util.logging.Level) null, (String) null, (String) source(), (String) null); // $ Alert
            logger.logp((java.util.logging.Level) null, (String) null, (String) null, (String) source()); // $ Alert
            logger.logp((java.util.logging.Level) null, (String) source(), (String) null, (String) null, (Object) null); // $ Alert
            logger.logp((java.util.logging.Level) null, (String) null, (String) source(), (String) null, (Object) null); // $ Alert
            logger.logp((java.util.logging.Level) null, (String) null, (String) null, (String) source(), (Object) null); // $ Alert
            logger.logp((java.util.logging.Level) null, (String) null, (String) null, (String) null, source()); // $ Alert
            logger.logp((java.util.logging.Level) null, (String) source(), (String) null, (String) null, (Object[]) null); // $ Alert
            logger.logp((java.util.logging.Level) null, (String) null, (String) source(), (String) null, (Object[]) null); // $ Alert
            logger.logp((java.util.logging.Level) null, (String) null, (String) null, (String) source(), (Object[]) null); // $ Alert
            logger.logp((java.util.logging.Level) null, (String) null, (String) null, (String) null, new Object[] {source()}); // $ Alert
            logger.logp((java.util.logging.Level) null, (String) source(), (String) null, (String) null, (Throwable) null); // $ Alert
            logger.logp((java.util.logging.Level) null, (String) null, (String) source(), (String) null, (Throwable) null); // $ Alert
            logger.logp((java.util.logging.Level) null, (String) null, (String) null, (String) source(), (Throwable) null); // $ Alert
            logger.logp((java.util.logging.Level) null, (String) source(), (String) null, (java.util.function.Supplier) null); // $ Alert
            logger.logp((java.util.logging.Level) null, (String) null, (String) source(), (java.util.function.Supplier) null); // $ Alert
            logger.logp((java.util.logging.Level) null, (String) null, (String) null, (java.util.function.Supplier) source()); // $ Alert
            logger.logp((java.util.logging.Level) null, (String) source(), (String) null, (Throwable) null, (java.util.function.Supplier) null); // $ Alert
            logger.logp((java.util.logging.Level) null, (String) null, (String) source(), (Throwable) null, (java.util.function.Supplier) null); // $ Alert
            logger.logp((java.util.logging.Level) null, (String) null, (String) null, (Throwable) null, (java.util.function.Supplier) source()); // $ Alert
            logger.logrb((java.util.logging.Level) null, (String) source(), (String) null, (ResourceBundle) null, (String) null, (Object[]) null); // $ Alert
            logger.logrb((java.util.logging.Level) null, (String) null, (String) source(), (ResourceBundle) null, (String) null, (Object[]) null); // $ Alert
            logger.logrb((java.util.logging.Level) null, (String) null, (String) null, (ResourceBundle) null, (String) source(), (Object[]) null); // $ Alert
            logger.logrb((java.util.logging.Level) null, (String) null, (String) null, (ResourceBundle) null, (String) null, new Object[] {source()}); // $ Alert
            logger.logrb((java.util.logging.Level) null, (String) source(), (String) null, (ResourceBundle) null, (String) null, (Throwable) null); // $ Alert
            logger.logrb((java.util.logging.Level) null, (String) null, (String) source(), (ResourceBundle) null, (String) null, (Throwable) null); // $ Alert
            logger.logrb((java.util.logging.Level) null, (String) null, (String) null, (ResourceBundle) null, (String) source(), (Throwable) null); // $ Alert
            logger.logrb((java.util.logging.Level) null, (String) source(), (String) null, (String) null, (String) null); // $ Alert
            logger.logrb((java.util.logging.Level) null, (String) null, (String) source(), (String) null, (String) null); // $ Alert
            logger.logrb((java.util.logging.Level) null, (String) null, (String) null, (String) source(), (String) null); // $ Alert
            logger.logrb((java.util.logging.Level) null, (String) null, (String) null, (String) null, (String) source()); // $ Alert
            logger.logrb((java.util.logging.Level) null, (String) source(), (String) null, (String) null, (String) null, (Object) null); // $ Alert
            logger.logrb((java.util.logging.Level) null, (String) null, (String) source(), (String) null, (String) null, (Object) null); // $ Alert
            logger.logrb((java.util.logging.Level) null, (String) null, (String) null, (String) source(), (String) null, (Object) null); // $ Alert
            logger.logrb((java.util.logging.Level) null, (String) null, (String) null, (String) null, (String) source(), (Object) null); // $ Alert
            logger.logrb((java.util.logging.Level) null, (String) null, (String) null, (String) null, (String) null, source()); // $ Alert
            logger.logrb((java.util.logging.Level) null, (String) source(), (String) null, (String) null, (String) null, (Object[]) null); // $ Alert
            logger.logrb((java.util.logging.Level) null, (String) null, (String) source(), (String) null, (String) null, (Object[]) null); // $ Alert
            logger.logrb((java.util.logging.Level) null, (String) null, (String) null, (String) source(), (String) null, (Object[]) null); // $ Alert
            logger.logrb((java.util.logging.Level) null, (String) null, (String) null, (String) null, (String) source(), (Object[]) null); // $ Alert
            logger.logrb((java.util.logging.Level) null, (String) null, (String) null, (String) null, (String) null, new Object[] {source()}); // $ Alert
            logger.logrb((java.util.logging.Level) null, (String) source(), (String) null, (String) null, (String) null, (Throwable) null); // $ Alert
            logger.logrb((java.util.logging.Level) null, (String) null, (String) source(), (String) null, (String) null, (Throwable) null); // $ Alert
            logger.logrb((java.util.logging.Level) null, (String) null, (String) null, (String) source(), (String) null, (Throwable) null); // $ Alert
            logger.logrb((java.util.logging.Level) null, (String) null, (String) null, (String) null, (String) source(), (Throwable) null); // $ Alert
            // @formatter:on
        }
        {
            android.util.Log.d("", (String) source()); // $ Alert
            android.util.Log.v("", (String) source()); // $ Alert
            android.util.Log.i("", (String) source()); // $ Alert
            android.util.Log.w("", (String) source()); // $ Alert
            android.util.Log.e("", (String) source()); // $ Alert
            android.util.Log.wtf("", (String) source()); // $ Alert
        }
        {
            // @formatter:off
            // "org.apache.cxf.common.logging;LogUtils;true;log;(Logger,Level,String);;Argument[2];log-injection;manual"
            LogUtils.log(null, null, (String) source()); // $ Alert
            // "org.apache.cxf.common.logging;LogUtils;true;log;(Logger,Level,String,Object);;Argument[2];log-injection;manual"
            LogUtils.log(null, null, (String) source(), (Object) null); // $ Alert
            // "org.apache.cxf.common.logging;LogUtils;true;log;(Logger,Level,String,Object[]);;Argument[2];log-injection;manual"
            LogUtils.log(null, null, (String) source(), (Object[]) null); // $ Alert
            // "org.apache.cxf.common.logging;LogUtils;true;log;(Logger,Level,String,Throwable);;Argument[2];log-injection;manual"
            LogUtils.log(null, null, (String) source(), (Throwable) null); // $ Alert
            // "org.apache.cxf.common.logging;LogUtils;true;log;(Logger,Level,String,Throwable,Object);;Argument[2];log-injection;manual"
            LogUtils.log(null, null, (String) source(), (Throwable) null, (Object) null); // $ Alert
            // "org.apache.cxf.common.logging;LogUtils;true;log;(Logger,Level,String,Throwable,Object[]);;Argument[2];log-injection;manual"
            LogUtils.log(null, null, (String) source(), (Throwable) null, (Object) null, (Object) null); // $ Alert
            // @formatter:on
        }
    }
}
