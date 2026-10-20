import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.Writer;
import org.apache.logging.log4j.Logger;

class CharacterFilteringTest {
    private final Logger logger = null;

    void testStringBuilder(String password) {
        logger.info(removeNewlines(password)); // $ MISSING: Alert
    }

    static String removeNewlines(String input) {
        StringBuilder result = new StringBuilder();
        for (int i = 0; i < input.length(); i++) {
            char current = input.charAt(i);
            if (current != '\n' && current != '\r') {
                result.append(current);
            }
        }
        return result.toString();
    }

    void testReplacement(String authToken) {
        logger.info(escapeControlCharacters(authToken)); // $ MISSING: Alert
    }

    static String escapeControlCharacters(String input) {
        StringBuilder result = new StringBuilder();
        for (char current : input.toCharArray()) {
            switch (current) {
                case '\n':
                    result.append("\\n");
                    break;
                case '\r':
                    result.append("\\r");
                    break;
                default:
                    result.append(current);
                    break;
            }
        }
        return result.toString();
    }

    void testWriterParameter(String accessToken) throws IOException {
        logger.info(copyPrintableCodePoints(accessToken)); // $ MISSING: Alert
    }

    static String copyPrintableCodePoints(String input) throws IOException {
        StringWriter output = new StringWriter();
        copyPrintableCodePoints(input, output);
        return output.toString();
    }

    static void copyPrintableCodePoints(CharSequence input, Writer output) throws IOException {
        int position = 0;
        while (position < input.length()) {
            int codePoint = Character.codePointAt(input, position);
            if (!Character.isISOControl(codePoint)) {
                char[] characters = Character.toChars(codePoint);
                output.write(characters, 0, characters.length);
            }
            position += Character.charCount(codePoint);
        }
    }

    void testOutputArray(String clientSecret) {
        logger.info(copyAsciiCharacters(clientSecret)); // $ MISSING: Alert
    }

    static String copyAsciiCharacters(String input) {
        char[] output = new char[input.length()];
        int outputPosition = 0;
        for (int inputPosition = 0; inputPosition < input.length(); inputPosition++) {
            char current = input.charAt(inputPosition);
            if (current >= 0x20 && current < 0x7f) {
                output[outputPosition++] = current;
            }
        }
        return new String(output, 0, outputPosition);
    }

    void testConcatenation(String apiSecret) {
        logger.info(removeWhitespace(apiSecret)); // $ MISSING: Alert
    }

    static String removeWhitespace(String input) {
        String result = "";
        for (int i = 0; i < input.length(); i++) {
            char current = input.charAt(i);
            if (!Character.isWhitespace(current)) {
                result += current;
            }
        }
        return result;
    }

    void testReaderWriter(String sessionToken) throws IOException {
        logger.info(copyWithoutLineBreaks(sessionToken)); // $ MISSING: Alert
    }

    static String copyWithoutLineBreaks(String input) throws IOException {
        StringReader reader = new StringReader(input);
        StringWriter writer = new StringWriter();
        int current;
        while ((current = reader.read()) != -1) {
            if (current != '\n' && current != '\r') {
                writer.write(current);
            }
        }
        return writer.toString();
    }

    void testNonPreservingTransformations(String password, String authToken) {
        logger.info(maskCharacters(password)); // Safe
        logger.info(sumCharacters(authToken)); // Safe
    }

    static String maskCharacters(String input) {
        StringBuilder result = new StringBuilder();
        for (int i = 0; i < input.length(); i++) {
            result.append('*');
        }
        return result.toString();
    }

    static String sumCharacters(String input) {
        int sum = 0;
        for (int i = 0; i < input.length(); i++) {
            sum += input.charAt(i);
        }
        return Integer.toString(sum);
    }
}
