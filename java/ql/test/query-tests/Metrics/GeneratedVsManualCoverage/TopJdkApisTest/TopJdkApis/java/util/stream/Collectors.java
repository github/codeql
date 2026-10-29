// Generated automatically from java.util.stream.Collectors for testing purposes

package java.util.stream;

import java.util.Collection;
import java.util.Comparator;
import java.util.DoubleSummaryStatistics;
import java.util.IntSummaryStatistics;
import java.util.List;
import java.util.LongSummaryStatistics;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.concurrent.ConcurrentMap;
import java.util.function.BinaryOperator;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.function.Supplier;
import java.util.function.ToDoubleFunction;
import java.util.function.ToIntFunction;
import java.util.function.ToLongFunction;
import java.util.stream.Collector;

public class Collectors
{
    protected Collectors() {}
    public static <T, K, U> java.util.stream.Collector<T, ? extends Object, java.util.Map<K, U>> toMap(java.util.function.Function<? super T, ? extends K> p0, java.util.function.Function<? super T, ? extends U> p1){ return null; } // NOT MODELED
    public static <T> Collector<T, ? extends Object, java.util.List<T>> toList(){ return null; } // manual neutral
    public static <T> Collector<T, ? extends Object, java.util.Set<T>> toSet(){ return null; } // manual neutral
    public static Collector<CharSequence, ? extends Object, String> joining(CharSequence p0){ return null; } // NOT MODELED
}
