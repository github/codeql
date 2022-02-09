import java.util.regex.Pattern;

class Test {
    static String[] regs = {
        "[A-Z\\d]++",
        "\\Q hello world [ *** \\Q ) ( \\E",
        "[\\Q hi ] \\E]",
        "[]]",
        "[^]]",
        "[abc[defg]]",
        "[abc&&[\\W\\p{Lower}\\P{Space}\\N{degree sign}]]\\b7\\b{g}8",
        "\\cA",
        "\\c(",
        "\\c\\(ab)",
        "(?>hi)(?<name>hell*?o*+)123\\k<name>"
    };

    void test() {
        for (int i = 0; i < regs.length; i++) {
            Pattern.compile(regs[i]);
        }
    }
}
