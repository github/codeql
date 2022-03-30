import java.util.*;

public class Main {

    public static void arrays(String[] args) {

        // NOT OK: always true
        if (args.length >= 0) {
            System.out.println("At least zero arguments!!");
        }
        
        // NOT OK: always true
        if (0 <= args.length) {
            System.out.println("At least zero arguments!!");
        }

        // NOT OK: always false
        if (args.length < 0) {
            System.out.println("At least zero arguments!!");
        }

        // NOT OK: always false
        if (0 > args.length) {
            System.out.println("At least zero arguments!!");
        }

        // OK: sometimes could be false
        if (args.length > 0) {
            System.out.println("Greater than zero arguments!!");
        }

        // OK: sometimes could be false
        if (0 < args.length) {
            System.out.println("Greater than zero arguments!!");
        }

        // OK: sometimes could be true
        if (args.length <= 0) {
            System.out.println("Greater than zero arguments!!");
        }

        // OK: sometimes could be true
        if (0 >= args.length) {
            System.out.println("Greater than zero arguments!!");
        }

    }

    public static void containers(ArrayList<String> xs,
                                  Vector<String> ys) {
        Boolean b;
        
        // NOT OK
        b = xs.size() >= 0;
        b = 0 <= xs.size();
        b = 0 <= ys.size();

        b = xs.size() < 0;
        b = 0 > ys.size();

        // OK
        b = xs.size() >= -1;
        
        // OK
        b = 0 < xs.size();
    }

    // Slight obfuscations that the query doesn't match currently
    public static void missedCases(ArrayList<String> xs) {
        Boolean b;

        // OK: not currently matched
        b = xs.size() >= (short)0;
        b = xs.size() >= (byte)0;
        b = xs.size() >= 0 + 0;
        b = xs.size() >= 0 - 0;
    }

    public static void nestedContainers(Vector<ArrayList<String>> xs) {
        Boolean b;

        // NOT OK
        b = xs.size() >= 0;
        b = xs.size() < 0;

        // NOT OK
        b = xs.get(0).size() >= 0;

        // NOT OK
        b = xs.get(0).get(0).length() >= 0;
    }

    public static void mapTests(TreeMap<String, String> xs) {
        Boolean b;

        // NOT OK: Always true        
        b = xs.size() >= 0;
        
        // NOT OK: Always true
        b = 0 <= xs.size();

        // OK: can be false
        b = xs.size() >= -1;
        
        // OK: can be false
        b = 0 < xs.size();
    }

    public static void rawTypes(Set s, ArrayList a, HashMap m) {
        Boolean b;

        // NOT OK
        b = s.size() >= 0;
        b = a.size() >= 0;
        b = 0 <= m.size();
    }

}
