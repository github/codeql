import java.util.regex.Pattern;
import java.util.function.Predicate;
import javax.servlet.http.HttpServletRequest;
import com.google.common.base.Splitter;

class PolyRedosTest {
    void test(HttpServletRequest request) {
        String tainted = request.getParameter("inp");
        String reg = "a\\.\\d+E?\\d+b";
        Predicate<String> dummyPred = (s -> s.length() % 7 == 0);
        
        tainted.matches(reg); // $ hasTaintFlow
        tainted.split(reg); // $ hasTaintFlow
        tainted.split(reg, 7); // $ hasTaintFlow
        Pattern.matches(reg, tainted); // $ hasTaintFlow
        Pattern.compile(reg).matcher(tainted).matches(); // $ hasTaintFlow
        Pattern.compile(reg).split(tainted); // $ hasTaintFlow
        Pattern.compile(reg, Pattern.DOTALL).split(tainted); // $ hasTaintFlow
        Pattern.compile(reg).split(tainted, 7); // $ hasTaintFlow
        Pattern.compile(reg).splitAsStream(tainted); // $ hasTaintFlow
        Pattern.compile(reg).asPredicate().test(tainted); // $ hasTaintFlow
        Pattern.compile(reg).asMatchPredicate().negate().and(dummyPred).or(dummyPred).test(tainted); // $ hasTaintFlow
        Predicate.not(dummyPred.and(dummyPred.or(Pattern.compile(reg).asPredicate()))).test(tainted); // $ hasTaintFlow

        Splitter.on(Pattern.compile(reg)).split(tainted); // $ hasTaintFlow
        Splitter.on(reg).split(tainted); 
        Splitter.onPattern(reg).split(tainted); // $ hasTaintFlow
        Splitter.onPattern(reg).splitToList(tainted); // $ hasTaintFlow
        Splitter.onPattern(reg).limit(7).omitEmptyStrings().trimResults().split(tainted); // $ hasTaintFlow
        Splitter.onPattern(reg).withKeyValueSeparator(" => ").split(tainted); // $ hasTaintFlow
        Splitter.on(";").withKeyValueSeparator(reg).split(tainted);
        Splitter.on(";").withKeyValueSeparator(Splitter.onPattern(reg)).split(tainted); // $ hasTaintFlow

    }
}