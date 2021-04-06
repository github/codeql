import java.util.function.Function;

public class Processor<T> {

    public <R> R process(Function<T,R> function, T arg) {
        return function.apply(arg);
    }
}

