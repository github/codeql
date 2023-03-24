package p;

import java.util.Iterator;
import java.util.List;
import java.io.IOException;
import java.io.OutputStream;


public class ParamFlow {

    public String returnsInput(String input) {
        return input;
    }

    public int ignorePrimitiveReturnValue(String input) {
        return input.length();
    }

    public String returnMultipleParameters(String one, String two) {
        if (System.currentTimeMillis() > 100) {
            return two;
        }
        return one;
    }

    public String returnArrayElement(String[] input) {
        return input[0];
    }

    public String returnVarArgElement(String... input) {
        return input[0];
    }

    public String returnCollectionElement(List<String> input) {
        return input.get(0);
    }

    public String returnIteratorElement(Iterator<String> input) {
        return input.next();
    }

    public String returnIterableElement(Iterable<String> input) {
        return input.iterator().next();
    }

    public Class<?> mapType(Class<?> input) {
        return input;
    }

    public void writeChunked(byte[] data, OutputStream output)
            throws IOException {
        output.write(data, 0, data.length);
    }
    
    public void writeChunked(char[] data, OutputStream output)
            throws IOException {
        output.write(String.valueOf(data).getBytes(), 0, data.length);
    }

    public void addTo(String data, List<String> target) {
        target.add(data);
    }

}