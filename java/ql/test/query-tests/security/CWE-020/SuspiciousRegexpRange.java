import java.util.regex.Pattern;

class SuspiciousRegexpRange {
    void test() {
        Pattern overlap1 = Pattern.compile("^[0-93-5]*$"); // NOT OK

        Pattern overlap2 = Pattern.compile("[A-ZA-z]*"); // NOT OK
        
        Pattern isEmpty = Pattern.compile("^[z-a]*$"); // NOT OK
        
        Pattern isAscii = Pattern.compile("^[\\x00-\\x7F]*$"); // OK
        
        Pattern printable = Pattern.compile("[!-~]*"); // OK - used to select most printable ASCII characters
        
        Pattern codePoints = Pattern.compile("[^\\x21-\\x7E]|[[\\](){}<>/%]*"); // OK
        
        Pattern NON_ALPHANUMERIC_REGEXP = Pattern.compile("([^\\#-~| |!])*"); // OK
        
        Pattern smallOverlap = Pattern.compile("[0-9a-fA-f]*"); // NOT OK
        
        Pattern weirdRange = Pattern.compile("[$-`]*"); // NOT OK
        
        Pattern keywordOperator = Pattern.compile("[!\\~\\*\\/%+-<>\\^|=&]*"); // NOT OK
        
        Pattern notYoutube = Pattern.compile("youtu.be/[a-z1-9.-_]+"); // NOT OK
        
        Pattern numberToLetter = Pattern.compile("[7-F]*"); // NOT OK
        
        Pattern overlapsWithClass1 = Pattern.compile("[0-9\\d]*"); // NOT OK
        
        Pattern overlapsWithClass2 = Pattern.compile("[\\w,.-?:*+]*"); // NOT OK

        Pattern nested = Pattern.compile("[[A-Za-z_][A-Za-z0-9._-]]*"); // OK, the dash it at the end

        Pattern octal = Pattern.compile("[\000-\037\040-\045]*"); // OK
    }
}
