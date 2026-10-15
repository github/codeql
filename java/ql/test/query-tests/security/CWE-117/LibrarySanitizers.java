package loginjection;

import com.google.common.base.CharMatcher;
import org.apache.logging.log4j.Logger;

public class LibrarySanitizers {
    public String source() {
        return null;
    }

    public void testJdkSanitizers() {
        String source = source(); // $ Source
        Logger logger = null;

        logger.debug(source.replace("\n", "")); // Safe
        logger.debug(source.replace("\n", "\n")); // $ Alert
        logger.debug(source.replace("\n", "\r")); // $ Alert
        logger.debug(source.replace("\r", "")); // Safe
        logger.debug(source.replace("\r", "\n")); // $ Alert
        logger.debug(source.replace("\r", "\r")); // $ Alert
        logger.debug(source.replace("something_else", "")); // $ Alert
        logger.debug("\n".replace("\n", source)); // $ Alert
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

    public void testSanitizers() {
        String source = source();
        Logger logger = null;

        logger.debug(org.apache.commons.text.StringEscapeUtils.escapeJava(source));
        logger.debug(org.apache.commons.lang3.StringEscapeUtils.escapeJava(source));
        logger.debug(org.owasp.encoder.Encode.forJava(source));

        logger.debug(CharMatcher.anyOf("\r\n").removeFrom(source));
        logger.debug(CharMatcher.anyOf("\r\n").replaceFrom(source, '_'));
        logger.debug(CharMatcher.anyOf("\r\n").replaceFrom(source, "_"));

        logger.debug(org.apache.commons.lang3.StringUtils.replaceChars(source, "\r\n", "__"));
        logger.debug(org.apache.commons.lang3.StringUtils.deleteWhitespace(source));
        logger.debug(org.apache.commons.lang3.StringUtils.normalizeSpace(source));
        logger.debug(org.springframework.util.StringUtils.trimAllWhitespace(source));
    }

    public void testAmbiguousGuavaMatcher(boolean condition) {
        String source = source(); // $ Source
        Logger logger = null;
        CharMatcher matcher;

        if (condition) {
            matcher = CharMatcher.anyOf("\r\n");
        } else {
            matcher = CharMatcher.anyOf("x");
        }

        logger.debug(matcher.removeFrom(source)); // $ Alert
    }

    public void testGuards() {
        String source = source(); // $ Source
        Logger logger = null;

        if (!source.contains("\n")) {
            logger.debug(source);
        }

        if (!org.apache.commons.lang3.StringUtils.contains(source, "\n")) {
            logger.debug(source); // $ SPURIOUS: Alert
        }

        if (!org.apache.commons.lang3.StringUtils.containsIgnoreCase(source, "\n")) {
            logger.debug(source); // $ SPURIOUS: Alert
        }

        if (!org.apache.commons.lang3.StringUtils.containsAny(source, "\r\n")) {
            logger.debug(source); // $ SPURIOUS: Alert
        }

        if (org.apache.commons.lang3.StringUtils.containsNone(source, "\r\n")) {
            logger.debug(source); // $ SPURIOUS: Alert
        }

        if (!CharMatcher.anyOf("\r\n").matchesAnyOf(source)) {
            logger.debug(source); // $ SPURIOUS: Alert
        }

        if (CharMatcher.anyOf("\r\n").matchesNoneOf(source)) {
            logger.debug(source); // $ SPURIOUS: Alert
        }

        if (CharMatcher.noneOf("\r\n").matchesAllOf(source)) {
            logger.debug(source); // $ SPURIOUS: Alert
        }
    }
}
