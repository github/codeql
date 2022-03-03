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
}