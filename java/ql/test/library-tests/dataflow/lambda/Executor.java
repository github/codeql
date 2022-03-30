import java.lang.Runtime;
import java.util.function.Function;

public class Executor {

    private static final Processor<String> processor = new Processor<String>();

    private static String source() { return "taint"; }

    public static void main(String[] args) {
        exec1(source());
        exec2(source());
        exec3(source());
        exec4(source());
        exec5(source());
    }

    private static void exec1(String command){
        command = process(s->s.toUpperCase(),command);
        exec(command);
    }

    private static void exec2(String command){
        command = process(s->"Taint stops here.",command);
        exec(command);
    }

    private static void exec3(String command){
        command = processor.process(s->s.toUpperCase(),command);
        exec(command);
    }

    private static void exec4(String command){
        command = processor.process(s->"Taint stops here.",command);
        exec_b(command);
    }

    private static void exec5(String command){
        command = processor.process(s->s.toUpperCase(),command);
        exec_b(command);
    }

    public static String process(Function<String, String> fun, String command){
        return processor.process(fun, command);
    }

    private static void exec(String command){
        command = process(s->s.trim(),command);
        try {
            Runtime.getRuntime().exec(command);
        }
        catch(Exception e) {}
    }

    private static void exec_b(String command){
        command = processor.process(s->s.trim(),command);
        try {
            Runtime.getRuntime().exec(command);
        }
        catch(Exception e) {}
    }
}

