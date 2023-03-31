// Generated automatically from java.util.Optional for testing purposes

package java.util;

import java.util.function.Consumer;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.function.Supplier;

public class Optional<T>
{
    protected Optional() {}
    public <U> java.util.Optional<U> map(java.util.function.Function<? super T, ? extends U> p0){ return null; } // manual summary
    public <X extends Throwable> T orElseThrow(Supplier<? extends X> p0){ return null; } // manual summary
    public Optional<T> filter(java.util.function.Predicate<? super T> p0){ return null; } // manual summary
    public T get(){ return null; } // manual summary
    public T orElse(T p0){ return null; } // manual summary
    public T orElseGet(Supplier<? extends T> p0){ return null; } // manual summary
    public boolean isPresent(){ return false; } // manual neutral
    public static <T> java.util.Optional<T> empty(){ return null; } // manual neutral
    public static <T> java.util.Optional<T> of(T p0){ return null; } // manual summary
    public static <T> java.util.Optional<T> ofNullable(T p0){ return null; } // manual summary
    public void ifPresent(java.util.function.Consumer<? super T> p0){} // manual summary

    public boolean isEmpty() { return false; } // manual neutral
    public T orElseThrow() { return null; } // manual summary

}
