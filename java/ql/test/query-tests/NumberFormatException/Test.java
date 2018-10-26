import java.io.*;

public class Test {
    public static void main(String[] args) {
        test1();
        test2();
        test3();
    }

    static void test1() {
        Byte.parseByte("123");
        Byte.decode("123");
        Byte.valueOf("123");
        Byte.valueOf("123", 10);
        Byte.valueOf("7f", 16);
        new Byte("123");
        new Byte((byte) 123); // don't flag: wrong constructor

        Short.parseShort("123");
        Short.decode("123");
        Short.valueOf("123");
        Short.valueOf("123", 10);
        Short.valueOf("7abc", 16);
        new Short("123");
        new Short((short) 123); // don't flag: wrong constructor

        Integer.parseInt("123");
        Integer.decode("123");
        Integer.valueOf("123");
        Integer.valueOf("123", 10);
        Integer.valueOf("1234beef", 16);
        new Integer("123");
        new Integer(123); // don't flag: wrong constructor

        Long.parseLong("123");
        Long.decode("123");
        Long.valueOf("123");
        Long.valueOf("123", 10);
        Long.valueOf("deadbeef", 16);
        new Long("123");
        new Long(123l); // don't flag: wrong constructor

        Float.parseFloat("2.7818281828");
        Float.valueOf("2.7818281828");
        new Float("2.7818281828");
        new Float(2.7818281828f); // don't flag: wrong constructor

        Double.parseDouble("2.7818281828");
        Double.valueOf("2.7818281828");
        new Double("2.7818281828");
        new Double(2.7818281828); // don't flag: wrong constructor
    }

    static void test2() {
        // Don't flag any of these. The exception is caught.
        try {
            Byte.parseByte("123");
            Byte.decode("123");
            Byte.valueOf("123");
            Byte.valueOf("123", 10);
            Byte.valueOf("7f", 16);
            new Byte("123");

            Short.parseShort("123");
            Short.decode("123");
            Short.valueOf("123");
            Short.valueOf("123", 10);
            Short.valueOf("7abc", 16);
            new Short("123");

            Integer.parseInt("123");
            Integer.decode("123");
            Integer.valueOf("123");
            Integer.valueOf("123", 10);
            Integer.valueOf("1234beef", 16);
            new Integer("123");

            Long.parseLong("123");
            Long.decode("123");
            Long.valueOf("123");
            Long.valueOf("123", 10);
            Long.valueOf("deadbeef", 16);
            new Long("123");

            Float.parseFloat("2.7818281828");
            Float.valueOf("2.7818281828");
            new Float("2.7818281828");

            Double.parseDouble("2.7818281828");
            Double.valueOf("2.7818281828");
            new Double("2.7818281828");
        }
        catch (NumberFormatException e) {
            // parse error
        }
    }

    static void test3() throws NumberFormatException {
        // Don't flag any of these: the exception is explcitly declared
        Byte.parseByte("123");
        Byte.decode("123");
        Byte.valueOf("123");
        Byte.valueOf("123", 10);
        Byte.valueOf("7f", 16);
        new Byte("123");

        Short.parseShort("123");
        Short.decode("123");
        Short.valueOf("123");
        Short.valueOf("123", 10);
        Short.valueOf("7abc", 16);
        new Short("123");

        Integer.parseInt("123");
        Integer.decode("123");
        Integer.valueOf("123");
        Integer.valueOf("123", 10);
        Integer.valueOf("1234beef", 16);
        new Integer("123");

        Long.parseLong("123");
        Long.decode("123");
        Long.valueOf("123");
        Long.valueOf("123", 10);
        Long.valueOf("deadbeef", 16);
        new Long("123");

        Float.parseFloat("2.7818281828");
        Float.valueOf("2.7818281828");
        new Float("2.7818281828");

        Double.parseDouble("2.7818281828");
        Double.valueOf("2.7818281828");
        new Double("2.7818281828");
    }
}
