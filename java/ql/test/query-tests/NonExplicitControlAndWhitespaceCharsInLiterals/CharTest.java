import java.util.List;
import java.util.ArrayList;

public class CharTest {

    public static void main(String[] args) {
        CharTest charTest = new CharTest();
        NonCompliantStringLiterals nonCompliant = charTest.new NonCompliantStringLiterals();
        CompliantStringLiterals compliant = charTest.new CompliantStringLiterals();
        CompliantCharLiterals compliantChar = charTest.new CompliantCharLiterals();

        List<String> nonCompliantStrings = nonCompliant.getNonCompliantStrings();
        List<String> compliantStrings = compliant.getCompliantStrings();
        List<Character> compliantChars = compliantChar.getCompliantChars();

        System.out.println("");
        System.out.println("Non-compliant strings:");
        for (String s : nonCompliantStrings) {
            System.out.println(s);
            System.out.println("");
        }

        System.out.println("");
        System.out.println("Compliant strings:");
        for (String s : compliantStrings) {
            System.out.println(s);
            System.out.println("");
        }
        System.out.println("");

        System.out.println("");
        System.out.println("Compliant character literals:");
        System.out.println("");
        for (Character c : compliantChars) {
            System.out.println("\\u" + String.format("%04X", (int) c));
        }
        System.out.println("");
    }

    class CompliantCharLiterals {
        private List<Character> compliantChars;

        public CompliantCharLiterals() {
            compliantChars = new ArrayList<>();
            compliantChars.add('A'); // COMPLIANT
            compliantChars.add('a'); // COMPLIANT
            compliantChars.add('\b'); // COMPLIANT
            compliantChars.add('\t'); // COMPLIANT
            compliantChars.add('\n'); // COMPLIANT
            compliantChars.add('\f'); // COMPLIANT
            compliantChars.add('\r'); // COMPLIANT
            compliantChars.add('\u0000'); // COMPLIANT
            compliantChars.add('\u0007'); // COMPLIANT
            compliantChars.add('\u001B'); // COMPLIANT
            compliantChars.add(' '); // COMPLIANT
            compliantChars.add('\u0020'); // COMPLIANT
            compliantChars.add('\u200B'); // COMPLIANT
            compliantChars.add('\u200C'); // COMPLIANT
            compliantChars.add('\u200D'); // COMPLIANT
            compliantChars.add('\u2028'); // COMPLIANT
            compliantChars.add('\u2029'); // COMPLIANT
            compliantChars.add('\u2060'); // COMPLIANT
            compliantChars.add('\uFEFF'); // COMPLIANT
        }

        public List<Character> getCompliantChars() {
            return compliantChars;
        }
    }

    class CompliantStringLiterals {
        private List<String> compliantStrings;
    
        public CompliantStringLiterals() {
            compliantStrings = new ArrayList<>();
            compliantStrings.add(""); // COMPLIANT
            compliantStrings.add("X__Y"); // COMPLIANT
            compliantStrings.add("X_ _Y"); // COMPLIANT
            compliantStrings.add("X_\u0020_Y"); // COMPLIANT
            compliantStrings.add("X_  _Y"); // COMPLIANT
            compliantStrings.add("X_\u0020\u0020_Y"); // COMPLIANT
            compliantStrings.add("X_   _Y"); // COMPLIANT
            compliantStrings.add("X_    _Y"); // COMPLIANT
            compliantStrings.add("X_     _Y"); // COMPLIANT
            compliantStrings.add("X_      _Y"); // COMPLIANT
            compliantStrings.add("X_\b_Y"); // COMPLIANT
            compliantStrings.add("X_\u0000_Y"); // COMPLIANT
            compliantStrings.add("X_\u0001_Y"); // COMPLIANT
            compliantStrings.add("X_\u0002_Y"); // COMPLIANT
            compliantStrings.add("X_\u0003_Y"); // COMPLIANT
            compliantStrings.add("X_\u0004_Y"); // COMPLIANT
            compliantStrings.add("X_\u0005_Y"); // COMPLIANT
            compliantStrings.add("X_\u0006_Y"); // COMPLIANT
            compliantStrings.add("X_\u0007_Y"); // COMPLIANT
            compliantStrings.add("X_\u0008_Y"); // COMPLIANT
            compliantStrings.add("X_\u0009_Y"); // COMPLIANT
            compliantStrings.add("X_\u0010_Y"); // COMPLIANT
            compliantStrings.add("X_\u0011_Y"); // COMPLIANT
            compliantStrings.add("X_\u0012_Y"); // COMPLIANT
            compliantStrings.add("X_\u0013_Y"); // COMPLIANT
            compliantStrings.add("X_\u0014_Y"); // COMPLIANT
            compliantStrings.add("X_\u0015_Y"); // COMPLIANT
            compliantStrings.add("X_\u0016_Y"); // COMPLIANT
            compliantStrings.add("X_\u0017_Y"); // COMPLIANT
            compliantStrings.add("X_\u0018_Y"); // COMPLIANT
            compliantStrings.add("X_\u0019_Y"); // COMPLIANT
            compliantStrings.add("X_\u001A_Y"); // COMPLIANT
            compliantStrings.add("X_\u001B_Y"); // COMPLIANT
            compliantStrings.add("X_\u001C_Y"); // COMPLIANT
            compliantStrings.add("X_\u001D_Y"); // COMPLIANT
            compliantStrings.add("X_\u001E_Y"); // COMPLIANT
            compliantStrings.add("X_\u001F_Y"); // COMPLIANT
            compliantStrings.add("X_\u007F_Y"); // COMPLIANT
            compliantStrings.add("X_\u200B_Y"); // COMPLIANT
            compliantStrings.add("X_\u200C_Y"); // COMPLIANT
            compliantStrings.add("X_\u200D_Y"); // COMPLIANT
            compliantStrings.add("X_\u2028_Y"); // COMPLIANT
            compliantStrings.add("X_\u2029_Y"); // COMPLIANT
            compliantStrings.add("X_\u2060_Y"); // COMPLIANT
            compliantStrings.add("X_\uFEFF_Y"); // COMPLIANT
            compliantStrings.add("X_\uFEFF_Y_\u0020_Z"); // COMPLIANT
            compliantStrings.add("X_\uFEFF_Y_\uFEFF_Z"); // COMPLIANT
            compliantStrings.add("X_\u0020_Y_\uFEFF_Z"); // COMPLIANT
            compliantStrings.add("X_\t_Y"); // COMPLIANT
            compliantStrings.add("X_\t\t_Y"); // COMPLIANT
            compliantStrings.add("X_\\b_Y"); // COMPLIANT
            compliantStrings.add("X_\f_Y"); // COMPLIANT
            compliantStrings.add("X_\\f_Y"); // COMPLIANT
            compliantStrings.add("X_\n_Y"); // COMPLIANT
            compliantStrings.add("X_\n\t_Y"); // COMPLIANT
            compliantStrings.add("X_\\n_Y"); // COMPLIANT
            compliantStrings.add("X_\r_Y"); // COMPLIANT
            compliantStrings.add("X_\\r_Y"); // COMPLIANT
            compliantStrings.add("X_\t_Y"); // COMPLIANT
            compliantStrings.add("X_\\t_Y"); // COMPLIANT
            compliantStrings.add("X_\\u0000_Y"); // COMPLIANT
            compliantStrings.add("X_\\u0007_Y"); // COMPLIANT
            compliantStrings.add("X_\\u001B_Y"); // COMPLIANT
            compliantStrings.add("X_\\u200B_Y"); // COMPLIANT
            compliantStrings.add("X_\\u200C_Y"); // COMPLIANT
            compliantStrings.add("X_\\u200D_Y"); // COMPLIANT
            compliantStrings.add("X_\\u2028_Y"); // COMPLIANT
            compliantStrings.add("X_\\u2029_Y"); // COMPLIANT
            compliantStrings.add("X_\\u2060_Y"); // COMPLIANT
            compliantStrings.add("X_\\uFEFF_Y"); // COMPLIANT
            compliantStrings.add("lorem ipsum dolor "+"sit amet"); // COMPLIANT
            compliantStrings.add("lorem ipsum dolor " + "sit amet"); // COMPLIANT
            compliantStrings.add("lorem ipsum dolor sit amet, consectetur adipiscing elit, " + // COMPLIANT
            "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.");
            compliantStrings.add("lorem ipsum dolor sit amet, consectetur adipiscing elit, " + // COMPLIANT
            "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad "
            + "minim veniam, quis nostrud exercitation ullamco "+"laboris nisi ut aliquip ex " +
            "ea commodo consequat.");
            compliantStrings.add("""
                lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
                Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
            """); // COMPLIANT
        }
    
        public List<String> getCompliantStrings() {
            return compliantStrings;
        }
    }

    class NonCompliantStringLiterals {
        private List<String> nonCompliantStrings;
    
        public NonCompliantStringLiterals() {
            nonCompliantStrings = new ArrayList<>();
            nonCompliantStrings.add("X_​_Y"); // NON_COMPLIANT
            nonCompliantStrings.add("X_​_Y_​_Z"); // NON_COMPLIANT
            nonCompliantStrings.add("lorem​ipsum dolor sit amet,​consectetur adipiscing elit, " + // NON_COMPLIANT
            "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.");
            nonCompliantStrings.add("""
                lorem​ipsum dolor sit amet,​consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
                Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
            """); // NON_COMPLIANT
        }
    
        public List<String> getNonCompliantStrings() {
            return nonCompliantStrings;
        }
    }
}
