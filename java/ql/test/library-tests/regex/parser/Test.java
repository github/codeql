import java.util.regex.Pattern;

class Test {
    static String[] regs = {
        "[A-Z\\d]++",
        "\\Q hello world [ *** \\Q ) ( \\E+",
        "[\\Q hi ] \\E]+",
        "[]]+",
        "[^]]+",
        "[abc[defg]]+",
        "[abc&&[\\W\\p{Lower}\\P{Space}\\N{degree sign}]]\\b7\\b{g}8+",
        "\\cA+",
        "\\c(+",
        "\\c\\(ab)+",
        "(?>hi)(?<name>hell*?o*+)123\\k<name>",
        "a+b*c?d{2}e{3,4}f{,5}g{6,}h+?i*?j??k{7}?l{8,9}?m{,10}?n{11,}?o++p*+q?+r{12}+s{13,14}+t{,15}+u{16,}+",
        "(?i)(?=a)(?!b)(?<=c)(?<!d)+",
        "a||b|c(d|e|)f|g+",
        "\\018\\033\\0377\\0777\u1337+",
        "[|]+",
        "(a(a(a(a(a(a((((c))))a))))))((((((b(((((d)))))b)b)b)b)b)b)+",
        "(?idmsuxU-idmsuxU)a+(?-idmsuxU)b+(?idmsuxU:c)d+(?-idmsuxU:e)f+(?idmsuxU:)g+",
        "(?idms-iuxU)a+",
    };

    void test() {
        for (int i = 0; i < regs.length; i++) {
            Pattern.compile(regs[i]);
        }
    }
}
