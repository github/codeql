import java.util.regex.Pattern;

class SuspiciousRegexpRange {
    void test() {
        Pattern overlap1 = Pattern.compile("^[0-93-5]*$"); // $ Alert[java/overly-large-range] // NOT OK

        Pattern overlap2 = Pattern.compile("[A-ZA-z]*"); // $ Alert[java/overly-large-range] // NOT OK
        
        Pattern isEmpty = Pattern.compile("^[z-a]*$"); // $ Alert[java/overly-large-range] // NOT OK
        
        Pattern isAscii = Pattern.compile("^[\\x00-\\x7F]*$"); // OK
        
        Pattern printable = Pattern.compile("[!-~]*"); // OK - used to select most printable ASCII characters
        
        Pattern codePoints = Pattern.compile("[^\\x21-\\x7E]|[[\\](){}<>/%]*"); // OK
        
        Pattern NON_ALPHANUMERIC_REGEXP = Pattern.compile("([^\\#-~| |!])*"); // OK
        
        Pattern smallOverlap = Pattern.compile("[0-9a-fA-f]*"); // $ Alert[java/overly-large-range] // NOT OK
        
        Pattern weirdRange = Pattern.compile("[$-`]*"); // $ Alert[java/overly-large-range] // NOT OK
        
        Pattern keywordOperator = Pattern.compile("[!\\~\\*\\/%+-<>\\^|=&]*"); // $ Alert[java/overly-large-range] // NOT OK
        
        Pattern notYoutube = Pattern.compile("youtu.be/[a-z1-9.-_]+"); // $ Alert[java/overly-large-range] // NOT OK
        
        Pattern numberToLetter = Pattern.compile("[7-F]*"); // $ Alert[java/overly-large-range] // NOT OK
        
        Pattern overlapsWithClass1 = Pattern.compile("[0-9\\d]*"); // $ Alert[java/overly-large-range] // NOT OK
        
        Pattern overlapsWithClass2 = Pattern.compile("[\\w,.-?:*+]*"); // $ Alert[java/overly-large-range] // NOT OK

        Pattern nested = Pattern.compile("[[A-Za-z_][A-Za-z0-9._-]]*"); // OK, the dash it at the end

        Pattern octal = Pattern.compile("[\000-\037\040-\045]*"); // OK
    }
}
