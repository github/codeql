package p;

import java.util.*;
import java.util.function.*;
import java.util.stream.Collector;
import java.util.stream.DoubleStream;
import java.util.stream.IntStream;
import java.util.stream.LongStream;

/** This is a stub implementation of the Java Stream API. */
public class Stream<T> {

  // summary=p;Stream;true;iterator;();;Argument[this].Element;ReturnValue.Element;value;tb-generated
  public Iterator<T> iterator() {
    return null;
  }

  // summary=p;Stream;true;allMatch;(Predicate);;Argument[this].Element;Argument[0].Parameter[0];value;tb-generated
  public boolean allMatch(Predicate<? super T> predicate) {
    return false;
  }

  // summary=p;Stream;true;collect;(Supplier,BiConsumer,BiConsumer);;Argument[this].Element;Argument[1].Parameter[1];value;tb-generated
  // summary=p;Stream;true;collect;(Supplier,BiConsumer,BiConsumer);;Argument[0].ReturnValue;Argument[1].Parameter[0];value;tb-generated
  // summary=p;Stream;true;collect;(Supplier,BiConsumer,BiConsumer);;Argument[0].ReturnValue;Argument[2].Parameter[0];value;tb-generated
  // summary=p;Stream;true;collect;(Supplier,BiConsumer,BiConsumer);;Argument[0].ReturnValue;Argument[2].Parameter[1];value;tb-generated
  // summary=p;Stream;true;collect;(Supplier,BiConsumer,BiConsumer);;Argument[0].ReturnValue;ReturnValue;value;tb-generated
  public <R> R collect(
      Supplier<R> supplier, BiConsumer<R, ? super T> accumulator, BiConsumer<R, R> combiner) {
    return null;
  }

  // Collector is not a functional interface, so this is not supported
  public <R, A> R collect(Collector<? super T, A, R> collector) {
    return null;
  }

  // summary=p;Stream;true;concat;(Stream,Stream);;Argument[0].Element;ReturnValue.Element;value;tb-generated
  // summary=p;Stream;true;concat;(Stream,Stream);;Argument[1].Element;ReturnValue.Element;value;tb-generated
  public static <T> Stream<T> concat(Stream<? extends T> a, Stream<? extends T> b) {
    return null;
  }

  // summary=p;Stream;true;distinct;();;Argument[this].Element;ReturnValue.Element;value;tb-generated
  public Stream<T> distinct() {
    return null;
  }

  public static <T> Stream<T> empty() {
    return null;
  }

  // summary=p;Stream;true;filter;(Predicate);;Argument[this].Element;Argument[0].Parameter[0];value;tb-generated
  // summary=p;Stream;true;filter;(Predicate);;Argument[this].Element;ReturnValue.Element;value;tb-generated
  public Stream<T> filter(Predicate<? super T> predicate) {
    return null;
  }

  // summary=p;Stream;true;findAny;();;Argument[this].Element;ReturnValue.SyntheticField[ArgType0];value;tb-generated
  public Optional<T> findAny() {
    return null;
  }

  // summary=p;Stream;true;findFirst;();;Argument[this].Element;ReturnValue.SyntheticField[ArgType0];value;tb-generated
  public Optional<T> findFirst() {
    return null;
  }

  // summary=p;Stream;true;flatMap;(Function);;Argument[0].ReturnValue.Element;ReturnValue.Element;value;tb-generated
  // summary=p;Stream;true;flatMap;(Function);;Argument[this].Element;Argument[0].Parameter[0];value;tb-generated
  public <R> Stream<R> flatMap(Function<? super T, ? extends Stream<? extends R>> mapper) {
    return null;
  }

  // summary=p;Stream;true;flatMapToDouble;(Function);;Argument[this].Element;Argument[0].Parameter[0];value;tb-generated
  public DoubleStream flatMapToDouble(Function<? super T, ? extends DoubleStream> mapper) {
    return null;
  }

  // summary=p;Stream;true;flatMapToInt;(Function);;Argument[this].Element;Argument[0].Parameter[0];value;tb-generated
  public IntStream flatMapToInt(Function<? super T, ? extends IntStream> mapper) {
    return null;
  }

  // summary=p;Stream;true;flatMapToLong;(Function);;Argument[this].Element;Argument[0].Parameter[0];value;tb-generated
  public LongStream flatMapToLong(Function<? super T, ? extends LongStream> mapper) {
    return null;
  }

  // summary=p;Stream;true;forEach;(Consumer);;Argument[this].Element;Argument[0].Parameter[0];value;tb-generated
  public void forEach(Consumer<? super T> action) {}

  // summary=p;Stream;true;forEachOrdered;(Consumer);;Argument[this].Element;Argument[0].Parameter[0];value;tb-generated
  public void forEachOrdered(Consumer<? super T> action) {}

  // summary=p;Stream;true;generate;(Supplier);;Argument[0].ReturnValue;ReturnValue.Element;value;tb-generated
  public static <T> Stream<T> generate(Supplier<T> s) {
    return null;
  }

  // summary=p;Stream;true;iterate;(Object,UnaryOperator);;Argument[0];Argument[1].Parameter[0];value;tb-generated
  // summary=p;Stream;true;iterate;(Object,UnaryOperator);;Argument[0];ReturnValue.Element;value;tb-generated
  // summary=p;Stream;true;iterate;(Object,UnaryOperator);;Argument[1].ReturnValue;Argument[1].Parameter[0];value;tb-generated
  // summary=p;Stream;true;iterate;(Object,UnaryOperator);;Argument[1].ReturnValue;ReturnValue.Element;value;tb-generated
  public static <T> Stream<T> iterate(T seed, UnaryOperator<T> f) {
    return null;
  }

  // summary=p;Stream;true;limit;(long);;Argument[this].Element;ReturnValue.Element;value;tb-generated
  public Stream<T> limit(long maxSize) {
    return null;
  }

  // summary=p;Stream;true;map;(Function);;Argument[this].Element;Argument[0].Parameter[0];value;tb-generated
  // summary=p;Stream;true;map;(Function);;Argument[0].ReturnValue;ReturnValue.Element;value;tb-generated
  public <R> Stream<R> map(Function<? super T, ? extends R> mapper) {
    return null;
  }

  // summary=p;Stream;true;mapToDouble;(ToDoubleFunction);;Argument[this].Element;Argument[0].Parameter[0];value;tb-generated
  public DoubleStream mapToDouble(ToDoubleFunction<? super T> mapper) {
    return null;
  }

  // summary=p;Stream;true;mapToInt;(ToIntFunction);;Argument[this].Element;Argument[0].Parameter[0];value;tb-generated
  public IntStream mapToInt(ToIntFunction<? super T> mapper) {
    return null;
  }

  // summary=p;Stream;true;mapToLong;(ToLongFunction);;Argument[this].Element;Argument[0].Parameter[0];value;tb-generated
  public LongStream mapToLong(ToLongFunction<? super T> mapper) {
    return null;
  }

  // summary=p;Stream;true;max;(Comparator);;Argument[this].Element;Argument[0].Parameter[0];value;tb-generated
  // summary=p;Stream;true;max;(Comparator);;Argument[this].Element;Argument[0].Parameter[1];value;tb-generated
  // summary=p;Stream;true;max;(Comparator);;Argument[this].Element;ReturnValue.SyntheticField[ArgType0];value;tb-generated
  public Optional<T> max(Comparator<? super T> comparator) {
    return null;
  }

  // summary=p;Stream;true;min;(Comparator);;Argument[this].Element;Argument[0].Parameter[0];value;tb-generated
  // summary=p;Stream;true;min;(Comparator);;Argument[this].Element;Argument[0].Parameter[1];value;tb-generated
  // summary=p;Stream;true;min;(Comparator);;Argument[this].Element;ReturnValue.SyntheticField[ArgType0];value;tb-generated
  public Optional<T> min(Comparator<? super T> comparator) {
    return null;
  }

  // summary=p;Stream;true;noneMatch;(Predicate);;Argument[this].Element;Argument[0].Parameter[0];value;tb-generated
  public boolean noneMatch(Predicate<? super T> predicate) {
    return false;
  }

  // summary=p;Stream;true;of;(Object[]);;Argument[0].ArrayElement;ReturnValue.Element;value;tb-generated
  public static <T> Stream<T> of(T... t) {
    return null;
  }

  // summary=p;Stream;true;of;(Object);;Argument[0];ReturnValue.Element;value;tb-generated
  public static <T> Stream<T> of(T t) {
    return null;
  }

  // summary=p;Stream;true;peek;(Consumer);;Argument[this].Element;Argument[0].Parameter[0];value;tb-generated
  // summary=p;Stream;true;peek;(Consumer);;Argument[this].Element;ReturnValue.Element;value;tb-generated
  public Stream<T> peek(Consumer<? super T> action) {
    return null;
  }

  // The generated models are only partially correct.
  // summary=p;Stream;true;reduce;(BinaryOperator);;Argument[this].Element;Argument[0].Parameter[0];value;tb-generated
  // summary=p;Stream;true;reduce;(BinaryOperator);;Argument[this].Element;Argument[0].Parameter[1];value;tb-generated
  // summary=p;Stream;true;reduce;(BinaryOperator);;Argument[this].Element;ReturnValue.SyntheticField[ArgType0];value;tb-generated
  // summary=p;Stream;true;reduce;(BinaryOperator);;Argument[0].ReturnValue;Argument[0].Parameter[0];value;tb-generated
  // summary=p;Stream;true;reduce;(BinaryOperator);;Argument[0].ReturnValue;Argument[0].Parameter[1];value;tb-generated
  // summary=p;Stream;true;reduce;(BinaryOperator);;Argument[0].ReturnValue;ReturnValue.SyntheticField[ArgType0];value;tb-generated
  // SPURIOUS-summary=p;Stream;true;reduce;(BinaryOperator);;Argument[0].ReturnValue;Argument[this].Element;value;tb-generated
  public Optional<T> reduce(BinaryOperator<T> accumulator) {
    return null;
  }

  // The generated models are only partially correct.
  // summary=p;Stream;true;reduce;(Object,BinaryOperator);;Argument[this].Element;Argument[1].Parameter[0];value;tb-generated
  // summary=p;Stream;true;reduce;(Object,BinaryOperator);;Argument[this].Element;Argument[1].Parameter[1];value;tb-generated
  // summary=p;Stream;true;reduce;(Object,BinaryOperator);;Argument[0];Argument[1].Parameter[0];value;tb-generated
  // summary=p;Stream;true;reduce;(Object,BinaryOperator);;Argument[0];Argument[1].Parameter[1];value;tb-generated
  // summary=p;Stream;true;reduce;(Object,BinaryOperator);;Argument[0];ReturnValue;value;tb-generated
  // summary=p;Stream;true;reduce;(Object,BinaryOperator);;Argument[1].ReturnValue;Argument[1].Parameter[0];value;tb-generated
  // summary=p;Stream;true;reduce;(Object,BinaryOperator);;Argument[1].ReturnValue;Argument[1].Parameter[1];value;tb-generated
  // summary=p;Stream;true;reduce;(Object,BinaryOperator);;Argument[1].ReturnValue;ReturnValue;value;tb-generated
  // SPURIOUS-summary=p;Stream;true;reduce;(Object,BinaryOperator);;Argument[this].Element;ReturnValue;value;tb-generated
  // SPURIOUS-summary=p;Stream;true;reduce;(Object,BinaryOperator);;Argument[0];Argument[this].Element;value;tb-generated
  // SPURIOUS-summary=p;Stream;true;reduce;(Object,BinaryOperator);;Argument[1].ReturnValue;Argument[this].Element;value;tb-generated
  public T reduce(T identity, BinaryOperator<T> accumulator) {
    return null;
  }

  // summary=p;Stream;true;reduce;(Object,BiFunction,BinaryOperator);;Argument[this].Element;Argument[1].Parameter[1];value;tb-generated
  // summary=p;Stream;true;reduce;(Object,BiFunction,BinaryOperator);;Argument[0];Argument[1].Parameter[0];value;tb-generated
  // summary=p;Stream;true;reduce;(Object,BiFunction,BinaryOperator);;Argument[0];Argument[2].Parameter[0];value;tb-generated
  // summary=p;Stream;true;reduce;(Object,BiFunction,BinaryOperator);;Argument[0];Argument[2].Parameter[1];value;tb-generated
  // summary=p;Stream;true;reduce;(Object,BiFunction,BinaryOperator);;Argument[0];ReturnValue;value;tb-generated
  // summary=p;Stream;true;reduce;(Object,BiFunction,BinaryOperator);;Argument[1].ReturnValue;Argument[1].Parameter[0];value;tb-generated
  // summary=p;Stream;true;reduce;(Object,BiFunction,BinaryOperator);;Argument[1].ReturnValue;Argument[2].Parameter[0];value;tb-generated
  // summary=p;Stream;true;reduce;(Object,BiFunction,BinaryOperator);;Argument[1].ReturnValue;Argument[2].Parameter[1];value;tb-generated
  // summary=p;Stream;true;reduce;(Object,BiFunction,BinaryOperator);;Argument[1].ReturnValue;ReturnValue;value;tb-generated
  // summary=p;Stream;true;reduce;(Object,BiFunction,BinaryOperator);;Argument[2].ReturnValue;Argument[1].Parameter[0];value;tb-generated
  // summary=p;Stream;true;reduce;(Object,BiFunction,BinaryOperator);;Argument[2].ReturnValue;Argument[2].Parameter[0];value;tb-generated
  // summary=p;Stream;true;reduce;(Object,BiFunction,BinaryOperator);;Argument[2].ReturnValue;Argument[2].Parameter[1];value;tb-generated
  // summary=p;Stream;true;reduce;(Object,BiFunction,BinaryOperator);;Argument[2].ReturnValue;ReturnValue;value;tb-generated
  public <U> U reduce(
      U identity, BiFunction<U, ? super T, U> accumulator, BinaryOperator<U> combiner) {
    return null;
  }

  // summary=p;Stream;true;skip;(long);;Argument[this].Element;ReturnValue.Element;value;tb-generated
  public Stream<T> skip(long n) {
    return null;
  }

  // summary=p;Stream;true;sorted;();;Argument[this].Element;ReturnValue.Element;value;tb-generated
  public Stream<T> sorted() {
    return null;
  }

  // summary=p;Stream;true;sorted;(Comparator);;Argument[this].Element;Argument[0].Parameter[0];value;tb-generated
  // summary=p;Stream;true;sorted;(Comparator);;Argument[this].Element;Argument[0].Parameter[1];value;tb-generated
  // summary=p;Stream;true;sorted;(Comparator);;Argument[this].Element;ReturnValue.Element;value;tb-generated
  public Stream<T> sorted(Comparator<? super T> comparator) {
    return null;
  }

  // Models can never be generated correctly based on the type information
  // as it involves downcasting.
  public Object[] toArray() {
    return null;
  }

  // The generated result is only partially correct as there is no mentioning of
  // the type T in the method definition.
  // summary=p;Stream;true;toArray;(IntFunction);;Argument[0].ReturnValue.ArrayElement;ReturnValue.ArrayElement;value;tb-generated
  public <A> A[] toArray(IntFunction<A[]> generator) {
    return null;
  }
}
