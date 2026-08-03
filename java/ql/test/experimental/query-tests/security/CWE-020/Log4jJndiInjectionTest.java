import java.util.Map;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.CloseableThreadContext;
import org.apache.logging.log4j.Level;
import org.apache.logging.log4j.LogBuilder;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.Marker;
import org.apache.logging.log4j.ThreadContext;
import org.apache.logging.log4j.message.EntryMessage;
import org.apache.logging.log4j.message.MapMessage;
import org.apache.logging.log4j.message.StringMapMessage;
import org.apache.logging.log4j.message.Message;
import org.apache.logging.log4j.util.MessageSupplier;
import org.apache.logging.log4j.util.Supplier;

public class Log4jJndiInjectionTest {

    private HttpServletRequest request;

    public Object source() {
        return request.getParameter("source"); // $ Source
    }

    public void test() {
        Logger logger = null;
        {
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
            logger.traceEntry((Message) source());
            logger.traceEntry((String) source(), (Object[]) null);
            logger.traceEntry((String) null, new Object[] {source()});
            logger.traceEntry((String) source(), (Supplier<?>) null);
            logger.traceEntry((String) null, (Supplier<?>) source());
            logger.traceEntry((Supplier<?>) source());
            logger.traceExit((EntryMessage) source());
            logger.traceExit((EntryMessage) source(), null);
            logger.traceExit((EntryMessage) null, source());
            logger.traceExit((Message) source(), null);
            logger.traceExit((Message) null, source());
            logger.traceExit(source());
            logger.traceExit((String) source(), null);
            logger.traceExit((String) null, source());
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
            ThreadContext.put("key", (String) source()); // $ Alert
            ThreadContext.putIfNull("key", (String) source()); // $ Alert
            Map<String, String> map = new HashMap<String, String>();
            map.put("key", (String) source());
            ThreadContext.putAll(map); // $ Alert
        }
        {
            MapMessage mmsg = new StringMapMessage().with("username", (String) source());
            logger.error(mmsg); // $ Alert
        }
        {
            MapMessage mmsg = new StringMapMessage();
            mmsg.with("username", (String) source());
            logger.error(mmsg); // $ Alert
        }
        {
            MapMessage mmsg = new StringMapMessage();
            mmsg.put("username", (String) source());
            logger.error(mmsg); // $ Alert
        }
        {
            MapMessage mmsg = new StringMapMessage();
            Map<String, String> map = new HashMap<String, String>();
            map.put("username", (String) source());
            mmsg.putAll(map);
            logger.error(mmsg); // $ Alert
        }
        {
            CloseableThreadContext.put("username", (String) source()); // $ Alert
            CloseableThreadContext.put("safe", "safe").put("username", (String) source()); // $ Alert
            Map<String, String> map = new HashMap<String, String>();
            map.put("username", (String) source());
            CloseableThreadContext.putAll(map); // $ Alert
            CloseableThreadContext.put("safe", "safe").putAll(map); // $ Alert

        }
    }
}
