import org.test.SampleAnnotationType;
import org.test.SampleType;

public class Test {

    @SampleAnnotationType
    public void test() {
        new SampleType().sampleField = null;
        new SampleType().sampleMethod();
    }

}

