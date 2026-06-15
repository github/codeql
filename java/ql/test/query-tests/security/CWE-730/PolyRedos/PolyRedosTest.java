import java.util.regex.Pattern;
import java.util.function.Predicate;
import javax.servlet.http.HttpServletRequest;
import com.google.common.base.Splitter;

class PolyRedosTest {
    void test(HttpServletRequest request) {
        String tainted = request.getParameter("inp"); // $ Source
        String reg = "0\\.\\d+E?\\d+!";
        Predicate<String> dummyPred = (s -> s.length() % 7 == 0);

        tainted.matches(reg); // $ Alert
        tainted.split(reg); // $ Alert
        tainted.split(reg, 7); // $ Alert
        tainted.replaceAll(reg, "a"); // $ Alert
        tainted.replaceFirst(reg, "a"); // $ Alert
        Pattern.matches(reg, tainted); // $ Alert
        Pattern.compile(reg).matcher(tainted).matches(); // $ Alert
        Pattern.compile(reg).split(tainted); // $ Alert
        Pattern.compile(reg, Pattern.DOTALL).split(tainted); // $ Alert
        Pattern.compile(reg).split(tainted, 7); // $ Alert
        Pattern.compile(reg).splitAsStream(tainted); // $ Alert
        Pattern.compile(reg).asPredicate().test(tainted); // $ Alert
        Pattern.compile(reg).asMatchPredicate().negate().and(dummyPred).or(dummyPred).test(tainted); // $ Alert
        Predicate.not(dummyPred.and(dummyPred.or(Pattern.compile(reg).asPredicate()))).test(tainted); // $ Alert

        Splitter.on(Pattern.compile(reg)).split(tainted); // $ Alert
        Splitter.on(reg).split(tainted);
        Splitter.onPattern(reg).split(tainted); // $ Alert
        Splitter.onPattern(reg).splitToList(tainted); // $ Alert
        Splitter.onPattern(reg).limit(7).omitEmptyStrings().trimResults().split(tainted); // $ Alert
        Splitter.onPattern(reg).withKeyValueSeparator(" => ").split(tainted); // $ Alert
        Splitter.on(";").withKeyValueSeparator(reg).split(tainted);
        Splitter.on(";").withKeyValueSeparator(Splitter.onPattern(reg)).split(tainted); // $ Alert

    }

    void test2(HttpServletRequest request) {
        String tainted = request.getParameter("inp"); // $ Source

        Pattern p1 = Pattern.compile(".*a");
        Pattern p2 = Pattern.compile(".*b");

        p1.matcher(tainted).matches();
        p2.matcher(tainted).find(); // $ Alert
    }

    void test3(HttpServletRequest request) {
        String tainted = request.getParameter("inp"); // $ Source

        Pattern p1 = Pattern.compile("ab*b*");
        Pattern p2 = Pattern.compile("cd*d*");

        p1.matcher(tainted).matches(); // $ Alert
        p2.matcher(tainted).find();
    }

    void test4(HttpServletRequest request) {
        String tainted = request.getParameter("inp"); // $ Source

        tainted.matches(".*a");
        tainted.replaceAll(".*b", "c"); // $ Alert
    }

    static Pattern p3 = Pattern.compile(".*a");
    static Pattern p4 = Pattern.compile(".*b");


    void test5(HttpServletRequest request) {
        String tainted = request.getParameter("inp"); // $ Source

        p3.asMatchPredicate().test(tainted);
        p4.asPredicate().test(tainted); // $ Alert
    }

    void test6(HttpServletRequest request) {
        Pattern p = Pattern.compile("^a*a*$");

        p.matcher(request.getParameter("inp")).matches(); // $ Alert
        p.matcher(request.getHeader("If-None-Match")).matches();
        p.matcher(request.getRequestURI()).matches();
        p.matcher(request.getCookies()[0].getName()).matches();
    }
}
