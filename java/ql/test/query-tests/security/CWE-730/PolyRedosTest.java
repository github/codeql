import java.util.regex.Pattern;
import java.util.function.Predicate;
import javax.servlet.http.HttpServletRequest;
import com.google.common.base.Splitter;

class PolyRedosTest {
    void test(HttpServletRequest request) {
        String tainted = request.getParameter("inp");
        String reg = "0\\.\\d+E?\\d+!";
        Predicate<String> dummyPred = (s -> s.length() % 7 == 0);
        
        tainted.matches(reg); // $ hasPolyRedos
        tainted.split(reg); // $ hasPolyRedos
        tainted.split(reg, 7); // $ hasPolyRedos
        tainted.replaceAll(reg, "a"); // $ hasPolyRedos
        tainted.replaceFirst(reg, "a"); // $ hasPolyRedos
        Pattern.matches(reg, tainted); // $ hasPolyRedos
        Pattern.compile(reg).matcher(tainted).matches(); // $ hasPolyRedos
        Pattern.compile(reg).split(tainted); // $ hasPolyRedos
        Pattern.compile(reg, Pattern.DOTALL).split(tainted); // $ hasPolyRedos
        Pattern.compile(reg).split(tainted, 7); // $ hasPolyRedos
        Pattern.compile(reg).splitAsStream(tainted); // $ hasPolyRedos
        Pattern.compile(reg).asPredicate().test(tainted); // $ hasPolyRedos
        Pattern.compile(reg).asMatchPredicate().negate().and(dummyPred).or(dummyPred).test(tainted); // $ hasPolyRedos
        Predicate.not(dummyPred.and(dummyPred.or(Pattern.compile(reg).asPredicate()))).test(tainted); // $ hasPolyRedos

        Splitter.on(Pattern.compile(reg)).split(tainted); // $ hasPolyRedos
        Splitter.on(reg).split(tainted); 
        Splitter.onPattern(reg).split(tainted); // $ hasPolyRedos
        Splitter.onPattern(reg).splitToList(tainted); // $ hasPolyRedos
        Splitter.onPattern(reg).limit(7).omitEmptyStrings().trimResults().split(tainted); // $ hasPolyRedos
        Splitter.onPattern(reg).withKeyValueSeparator(" => ").split(tainted); // $ hasPolyRedos
        Splitter.on(";").withKeyValueSeparator(reg).split(tainted);
        Splitter.on(";").withKeyValueSeparator(Splitter.onPattern(reg)).split(tainted); // $ hasPolyRedos

    }

    void test2(HttpServletRequest request) {
        String tainted = request.getParameter("inp");

        Pattern p1 = Pattern.compile(".*a");
        Pattern p2 = Pattern.compile(".*b");

        p1.matcher(tainted).matches(); 
        p2.matcher(tainted).find(); // $ hasPolyRedos
    }

    void test3(HttpServletRequest request) {
        String tainted = request.getParameter("inp");

        Pattern p1 = Pattern.compile("ab*b*");
        Pattern p2 = Pattern.compile("cd*d*");

        p1.matcher(tainted).matches(); // $ hasPolyRedos
        p2.matcher(tainted).find(); 
    }

    void test4(HttpServletRequest request) {
        String tainted = request.getParameter("inp");

        tainted.matches(".*a");
        tainted.replaceAll(".*b", "c"); // $ hasPolyRedos
    }

    static Pattern p3 = Pattern.compile(".*a");
    static Pattern p4 = Pattern.compile(".*b");
    

    void test5(HttpServletRequest request) {
        String tainted = request.getParameter("inp");

        p3.asMatchPredicate().test(tainted); 
        p4.asPredicate().test(tainted); // $ hasPolyRedos
    }

    void test6(HttpServletRequest request) {
        Pattern p = Pattern.compile("^a*a*$");

        p.matcher(request.getParameter("inp")).matches(); // $ hasPolyRedos
        p.matcher(request.getHeader("If-None-Match")).matches();
        p.matcher(request.getRequestURI()).matches();
        p.matcher(request.getCookies()[0].getName()).matches();
    }
}