package generatedtest;

import java.util.Iterator;
import java.util.List;
import java.util.Optional;
import java.util.PrimitiveIterator;
import java.util.Spliterator;
import java.util.stream.BaseStream;
import java.util.stream.DoubleStream;
import java.util.stream.IntStream;
import java.util.stream.LongStream;
import java.util.stream.Stream;

public class Test {

    <T> T getArrayElement(T[] array) { return array[0]; }
    <T> T getElement(BaseStream<T,?> s) { return s.iterator().next(); }
    <T> T getElement(Iterable<T> it) { return it.iterator().next(); }
    <T> T getElement(Iterator<T> it) { return it.next(); }
    <T> T getElement(Optional<T> o) { return o.get(); }
    <T> T getElementSpliterator(Spliterator<T> o) { return null; }
    Object source(String tag) { return null; }
    void sink(Object o) { }

    public void test() throws Exception {

        // *** Generated ***
        {
            // "java.util.stream;BaseStream;true;iterator;();;Element of Argument[this];Element of ReturnValue;value;manual"
            Iterator out = null;
            BaseStream in = (BaseStream)Stream.of(source("iterator_1"));
            out = in.iterator();
            sink(getElement(out)); // $ hasValueFlow=iterator_1
        }
        {
            // "java.util.stream;BaseStream;true;onClose;(Runnable);;Element of Argument[this];Element of ReturnValue;value;manual"
            BaseStream out = null;
            BaseStream in = (BaseStream)Stream.of(source("onClose_1"));
            out = in.onClose(null);
            sink(getElement(out)); // $ hasValueFlow=onClose_1
        }
        {
            // "java.util.stream;BaseStream;true;parallel;();;Element of Argument[this];Element of ReturnValue;value;manual"
            BaseStream out = null;
            BaseStream in = (BaseStream)Stream.of(source("parallel_1"));
            out = in.parallel();
            sink(getElement(out)); // $ hasValueFlow=parallel_1
        }
        {
            // "java.util.stream;BaseStream;true;sequential;();;Element of Argument[this];Element of ReturnValue;value;manual"
            BaseStream out = null;
            BaseStream in = (BaseStream)Stream.of(source("sequential_1"));
            out = in.sequential();
            sink(getElement(out)); // $ hasValueFlow=sequential_1
        }
        {
            // "java.util.stream;BaseStream;true;spliterator;();;Element of Argument[this];Element of ReturnValue;value;manual"
            Spliterator out = null;
            BaseStream in = (BaseStream)Stream.of(source("spliterator_1"));
            out = in.spliterator();
            sink(getElementSpliterator(out)); // $ hasValueFlow=spliterator_1
        }
        {
            // "java.util.stream;BaseStream;true;unordered;();;Element of Argument[this];Element of ReturnValue;value;manual"
            BaseStream out = null;
            BaseStream in = (BaseStream)Stream.of(source("unordered_1"));
            out = in.unordered();
            sink(getElement(out)); // $ hasValueFlow=unordered_1
        }
        {
            // "java.util.stream;Stream;true;concat;(Stream,Stream);;Element of Argument[0..1];Element of ReturnValue;value;manual"
            Stream out = null;
            Stream in = (Stream)Stream.of(source("concat_1"));
            out = Stream.concat(in, null);
            sink(getElement(out)); // $ hasValueFlow=concat_1
        }
        {
            // "java.util.stream;Stream;true;concat;(Stream,Stream);;Element of Argument[0..1];Element of ReturnValue;value;manual"
            Stream out = null;
            Stream in = (Stream)Stream.of(source("concat_2"));
            out = Stream.concat(null, in);
            sink(getElement(out)); // $ hasValueFlow=concat_2
        }
        {
            // "java.util.stream;Stream;true;distinct;();;Element of Argument[this];Element of ReturnValue;value;manual"
            Stream out = null;
            Stream in = (Stream)Stream.of(source("distinct_1"));
            out = in.distinct();
            sink(getElement(out)); // $ hasValueFlow=distinct_1
        }
        {
            // "java.util.stream;Stream;true;dropWhile;(Predicate);;Element of Argument[this];Element of ReturnValue;value;manual"
            Stream out = null;
            Stream in = (Stream)Stream.of(source("dropWhile_1"));
            out = in.dropWhile(null);
            sink(getElement(out)); // $ hasValueFlow=dropWhile_1
        }
        {
            // "java.util.stream;Stream;true;filter;(Predicate);;Element of Argument[this];Element of ReturnValue;value;manual"
            Stream out = null;
            Stream in = (Stream)Stream.of(source("filter_1"));
            out = in.filter(null);
            sink(getElement(out)); // $ hasValueFlow=filter_1
        }
        {
            // "java.util.stream;Stream;true;findAny;();;Element of Argument[this];Element of ReturnValue;value;manual"
            Optional out = null;
            Stream in = (Stream)Stream.of(source("findAny_1"));
            out = in.findAny();
            sink(getElement(out)); // $ hasValueFlow=findAny_1
        }
        {
            // "java.util.stream;Stream;true;findFirst;();;Element of Argument[this];Element of ReturnValue;value;manual"
            Optional out = null;
            Stream in = (Stream)Stream.of(source("findFirst_1"));
            out = in.findFirst();
            sink(getElement(out)); // $ hasValueFlow=findFirst_1
        }
        {
            // "java.util.stream;Stream;true;limit;(long);;Element of Argument[this];Element of ReturnValue;value;manual"
            Stream out = null;
            Stream in = (Stream)Stream.of(source("limit_1"));
            out = in.limit(0L);
            sink(getElement(out)); // $ hasValueFlow=limit_1
        }
        {
            // "java.util.stream;Stream;true;max;(Comparator);;Element of Argument[this];Element of ReturnValue;value;manual"
            Optional out = null;
            Stream in = (Stream)Stream.of(source("max_1"));
            out = in.max(null);
            sink(getElement(out)); // $ hasValueFlow=max_1
        }
        {
            // "java.util.stream;Stream;true;min;(Comparator);;Element of Argument[this];Element of ReturnValue;value;manual"
            Optional out = null;
            Stream in = (Stream)Stream.of(source("min_1"));
            out = in.min(null);
            sink(getElement(out)); // $ hasValueFlow=min_1
        }
        {
            // "java.util.stream;Stream;true;of;(Object);;Argument[0];Element of ReturnValue;value;manual"
            Stream out = null;
            Object in = (Object)source("of_1");
            out = Stream.of(in);
            sink(getElement(out)); // $ hasValueFlow=of_1
        }
        {
            // "java.util.stream;Stream;true;of;(Object[]);;ArrayElement of Argument[0];Element of ReturnValue;value;manual"
            Stream out = null;
            Object[] in = (Object[])new Object[]{source("of_2")};
            out = Stream.of(in);
            sink(getElement(out)); // $ hasValueFlow=of_2
        }
        {
            // "java.util.stream;Stream;true;ofNullable;(Object);;Argument[0];Element of ReturnValue;value;manual"
            Stream out = null;
            Object in = (Object)source("ofNullable_1");
            out = Stream.ofNullable(in);
            sink(getElement(out)); // $ hasValueFlow=ofNullable_1
        }
        {
            // "java.util.stream;Stream;true;peek;(Consumer);;Element of Argument[this];Element of ReturnValue;value;manual"
            Stream out = null;
            Stream in = (Stream)Stream.of(source("peek_1"));
            out = in.peek(null);
            sink(getElement(out)); // $ hasValueFlow=peek_1
        }
        {
            // "java.util.stream;Stream;true;skip;(long);;Element of Argument[this];Element of ReturnValue;value;manual"
            Stream out = null;
            Stream in = (Stream)Stream.of(source("skip_1"));
            out = in.skip(0L);
            sink(getElement(out)); // $ hasValueFlow=skip_1
        }
        {
            // "java.util.stream;Stream;true;sorted;;;Element of Argument[this];Element of ReturnValue;value;manual"
            Stream out = null;
            Stream in = (Stream)Stream.of(source("sorted_1"));
            out = in.sorted();
            sink(getElement(out)); // $ hasValueFlow=sorted_1
        }
        {
            // "java.util.stream;Stream;true;sorted;;;Element of Argument[this];Element of ReturnValue;value;manual"
            Stream out = null;
            Stream in = (Stream)Stream.of(source("sorted_2"));
            out = in.sorted(null);
            sink(getElement(out)); // $ hasValueFlow=sorted_2
        }
        {
            // "java.util.stream;Stream;true;takeWhile;(Predicate);;Element of Argument[this];Element of ReturnValue;value;manual"
            Stream out = null;
            Stream in = (Stream)Stream.of(source("takeWhile_1"));
            out = in.takeWhile(null);
            sink(getElement(out)); // $ hasValueFlow=takeWhile_1
        }
        {
            // "java.util.stream;Stream;true;toArray;;;Element of Argument[this];ArrayElement of ReturnValue;value;manual"
            Object[] out = null;
            Stream in = (Stream)Stream.of(source("toArray_1"));
            out = in.toArray();
            sink(getArrayElement(out)); // $ hasValueFlow=toArray_1
        }
        {
            // "java.util.stream;Stream;true;toArray;;;Element of Argument[this];ArrayElement of ReturnValue;value;manual"
            Object[] out = null;
            Stream in = (Stream)Stream.of(source("toArray_2"));
            out = in.toArray(null);
            sink(getArrayElement(out)); // $ hasValueFlow=toArray_2
        }
        {
            // "java.util.stream;Stream;true;toList;();;Element of Argument[this];Element of ReturnValue;value;manual"
            List out = null;
            Stream in = (Stream)Stream.of(source("toList_1"));
            out = in.toList();
            sink(getElement(out)); // $ hasValueFlow=toList_1
        }

        // *** Handwritten ***
        {
            //java.util.stream;Stream;true;allMatch;(Predicate);;Element of Argument[this];Parameter[0] of Argument[0];value
            Stream<Object> in = Stream.of(source("allMatch"));
            in.allMatch(x -> { sink(x); return true; }); // $ hasValueFlow=allMatch
        }
        {
            //java.util.stream;Stream;true;anyMatch;(Predicate);;Element of Argument[this];Parameter[0] of Argument[0];value
            Stream<Object> in = Stream.of(source("anyMatch"));
            in.anyMatch(x -> { sink(x); return true; }); // $ hasValueFlow=anyMatch
        }
        {
            //java.util.stream;Stream;true;collect;(Supplier,BiConsumer,BiConsumer);;Element of Argument[this];Parameter[1] of Argument[1];value
            Stream<Object> in = Stream.of(source("collect"));
            in.collect(null, (c,x) -> sink(x), null); // $ hasValueFlow=collect
        }
        {
            //java.util.stream;Stream;true;collect;(Supplier,BiConsumer,BiConsumer);;Parameter[0..1] of Argument[2];Parameter[0] of Argument[1];value
            Stream.of(new Object()).collect(
                () -> new Object[1],
                (a, x) -> sink(a[0]), // $ hasValueFlow=collect_2 hasValueFlow=collect_3 SPURIOUS: hasValueFlow=collect_4 hasValueFlow=collect_5
                (a1, a2) -> {
                    a1[0] = source("collect_2");
                    a2[0] = source("collect_3");
                });
        }
        {
            //java.util.stream;Stream;true;collect;(Supplier,BiConsumer,BiConsumer);;Parameter[0] of Argument[1];Parameter[0..1] of Argument[2];value
            //java.util.stream;Stream;true;collect;(Supplier,BiConsumer,BiConsumer);;Parameter[0] of Argument[1];ReturnValue;value
            //java.util.stream;Stream;true;collect;(Supplier,BiConsumer,BiConsumer);;ReturnValue of Argument[0];Parameter[0] of Argument[1];value
            Object[] out = Stream.of(new Object()).collect(
                () -> new Object[] { source("collect_5") },
                (a, x) -> {
                    sink(a[0]); // $ hasValueFlow=collect_4 hasValueFlow=collect_5 SPURIOUS: hasValueFlow=collect_2 hasValueFlow=collect_3
                    a[0] = source("collect_4");
                },
                (a1, a2) -> {
                    sink(a1[0]); // $ hasValueFlow=collect_4 hasValueFlow=collect_5 SPURIOUS: hasValueFlow=collect_2 hasValueFlow=collect_3
                    sink(a2[0]); // $ hasValueFlow=collect_4 hasValueFlow=collect_5 SPURIOUS: hasValueFlow=collect_2 hasValueFlow=collect_3
                });
            sink(out[0]); // $ hasValueFlow=collect_4 hasValueFlow=collect_5
        }
        {
            Stream<Object> in = Stream.of(source("collect_6"));
            Object[] out = in.collect(
                () -> new Object[1],
                (a, x) -> { a[0] = x; },
                (a1, a2) -> {
                    a1[0] = a2[0];
                    a2[0] = a1[0];
                });
            sink(out[0]); // $ hasValueFlow=collect_6
        }
        {
            //java.util.stream;Stream;true;dropWhile;(Predicate);;Element of Argument[this];Parameter[0] of Argument[0];value
            Stream<Object> in = Stream.of(source("dropWhile"));
            in.dropWhile(x -> { sink(x); return true; }); // $ hasValueFlow=dropWhile
        }
        {
            //java.util.stream;Stream;true;filter;(Predicate);;Element of Argument[this];Parameter[0] of Argument[0];value
            Stream<Object> in = Stream.of(source("filter"));
            in.filter(x -> { sink(x); return true; }); // $ hasValueFlow=filter
        }
        {
            //java.util.stream;Stream;true;flatMap;(Function);;Element of Argument[this];Parameter[0] of Argument[0];value
            Stream<Object> in = Stream.of(source("flatMap"));
            in.flatMap(x -> { sink(x); return Stream.empty(); }); // $ hasValueFlow=flatMap
        }
        {
            //java.util.stream;Stream;true;flatMap;(Function);;Element of ReturnValue of Argument[0];Element of ReturnValue;value
            Stream<Object> out = Stream.of(new Object()).flatMap(x -> Stream.of(source("flatMap_2")));
            sink(getElement(out)); // $ hasValueFlow=flatMap_2
        }
        {
            //java.util.stream;Stream;true;flatMapToDouble;(Function);;Element of Argument[this];Parameter[0] of Argument[0];value
            Stream<Object> in = Stream.of(source("flatMapToDouble"));
            in.flatMapToDouble(x -> { sink(x); return null; }); // $ hasValueFlow=flatMapToDouble
        }
        {
            //java.util.stream;Stream;true;flatMapToInt;(Function);;Element of Argument[this];Parameter[0] of Argument[0];value
            Stream<Object> in = Stream.of(source("flatMapToInt"));
            in.flatMapToInt(x -> { sink(x); return null; }); // $ hasValueFlow=flatMapToInt
        }
        {
            //java.util.stream;Stream;true;flatMapToLong;(Function);;Element of Argument[this];Parameter[0] of Argument[0];value
            Stream<Object> in = Stream.of(source("flatMapToLong"));
            in.flatMapToLong(x -> { sink(x); return null; }); // $ hasValueFlow=flatMapToLong
        }
        {
            //java.util.stream;Stream;true;forEach;(Consumer);;Element of Argument[this];Parameter[0] of Argument[0];value
            Stream<Object> in = Stream.of(source("forEach"));
            in.forEach(x -> sink(x)); // $ hasValueFlow=forEach
        }
        {
            //java.util.stream;Stream;true;forEachOrdered;(Consumer);;Element of Argument[this];Parameter[0] of Argument[0];value
            Stream<Object> in = Stream.of(source("forEachOrdered"));
            in.forEachOrdered(x -> sink(x)); // $ hasValueFlow=forEachOrdered
        }
        {
            //java.util.stream;Stream;true;generate;(Supplier);;ReturnValue of Argument[0];Element of ReturnValue;value
            Stream<Object> out = Stream.generate(() -> source("generate"));
            sink(getElement(out)); // $ hasValueFlow=generate
        }
        {
            // "java.util.stream;Stream;true;iterate;(Object,Predicate,UnaryOperator);;Argument[0];Element of ReturnValue;value;manual"
            //java.util.stream;Stream;true;iterate;(Object,Predicate,UnaryOperator);;Argument[0];Parameter[0] of Argument[1..2];value
            //java.util.stream;Stream;true;iterate;(Object,Predicate,UnaryOperator);;ReturnValue of Argument[2];Element of ReturnValue;value
            //java.util.stream;Stream;true;iterate;(Object,Predicate,UnaryOperator);;ReturnValue of Argument[2];Parameter[0] of Argument[1..2];value
            Stream<Object> out = null;
            Object in = (Object)source("iterate_1");
            out = Stream.iterate(in, x -> {
                  sink(x); // $ hasValueFlow=iterate_1 hasValueFlow=iterate_2
                  return true;
              }, x -> {
                  sink(x); // $ hasValueFlow=iterate_1 hasValueFlow=iterate_2
                  return source("iterate_2");
              });
            sink(getElement(out)); // $ hasValueFlow=iterate_1 hasValueFlow=iterate_2
        }
        {
            // "java.util.stream;Stream;true;iterate;(Object,UnaryOperator);;Argument[0];Element of ReturnValue;value;manual"
            //java.util.stream;Stream;true;iterate;(Object,UnaryOperator);;Argument[0];Parameter[0] of Argument[1];value
            //java.util.stream;Stream;true;iterate;(Object,UnaryOperator);;ReturnValue of Argument[1];Element of ReturnValue;value
            //java.util.stream;Stream;true;iterate;(Object,UnaryOperator);;ReturnValue of Argument[1];Parameter[0] of Argument[1];value
            Stream<Object> out = null;
            Object in = (Object)source("iterate_3");
            out = Stream.iterate(in, x -> {
                  sink(x); // $ hasValueFlow=iterate_3 hasValueFlow=iterate_4
                  return source("iterate_4");
              });
            sink(getElement(out)); // $ hasValueFlow=iterate_3 hasValueFlow=iterate_4
        }
        {
            //java.util.stream;Stream;true;map;(Function);;Element of Argument[this];Parameter[0] of Argument[0];value
            //java.util.stream;Stream;true;map;(Function);;ReturnValue of Argument[0];Element of ReturnValue;value
            Stream<Object> in = Stream.of(source("map_1"));
            Stream<Object> out = in.map(x -> { sink(x); return source("map_2"); }); // $ hasValueFlow=map_1
            sink(getElement(out)); // $ hasValueFlow=map_2
        }
        {
            //java.util.stream;Stream;true;mapMulti;(BiConsumer);;Element of Argument[this];Parameter[0] of Argument[0];value
            Stream<Object> in = Stream.of(source("mapMulti"));
            in.mapMulti((x, consumer) -> sink(x)); // $ hasValueFlow=mapMulti
        }
        {
            //java.util.stream;Stream;true;mapMultiToDouble;(BiConsumer);;Element of Argument[this];Parameter[0] of Argument[0];value
            Stream<Object> in = Stream.of(source("mapMultiToDouble"));
            in.mapMultiToDouble((x, consumer) -> sink(x)); // $ hasValueFlow=mapMultiToDouble
        }
        {
            //java.util.stream;Stream;true;mapMultiToInt;(BiConsumer);;Element of Argument[this];Parameter[0] of Argument[0];value
            Stream<Object> in = Stream.of(source("mapMultiToInt"));
            in.mapMultiToInt((x, consumer) -> sink(x)); // $ hasValueFlow=mapMultiToInt
        }
        {
            //java.util.stream;Stream;true;mapMultiToLong;(BiConsumer);;Element of Argument[this];Parameter[0] of Argument[0];value
            Stream<Object> in = Stream.of(source("mapMultiToLong"));
            in.mapMultiToLong((x, consumer) -> sink(x)); // $ hasValueFlow=mapMultiToLong
        }
        {
            //java.util.stream;Stream;true;mapToDouble;(ToDoubleFunction);;Element of Argument[this];Parameter[0] of Argument[0];value
            Stream<Object> in = Stream.of(source("mapToDouble"));
            in.mapToDouble(x -> { sink(x); return 0.0; }); // $ hasValueFlow=mapToDouble
        }
        {
            //java.util.stream;Stream;true;mapToInt;(ToIntFunction);;Element of Argument[this];Parameter[0] of Argument[0];value
            Stream<Object> in = Stream.of(source("mapToInt"));
            in.mapToInt(x -> { sink(x); return 0; }); // $ hasValueFlow=mapToInt
        }
        {
            //java.util.stream;Stream;true;mapToLong;(ToLongFunction);;Element of Argument[this];Parameter[0] of Argument[0];value
            Stream<Object> in = Stream.of(source("mapToLong"));
            in.mapToLong(x -> { sink(x); return 0; }); // $ hasValueFlow=mapToLong
        }
        {
            //java.util.stream;Stream;true;max;(Comparator);;Element of Argument[this];Parameter[0..1] of Argument[0];value
            Stream<Object> in = Stream.of(source("max"));
            in.max((x,y) -> { sink(x); return 0; }); // $ hasValueFlow=max
            in.max((x,y) -> { sink(y); return 0; }); // $ hasValueFlow=max
        }
        {
            //java.util.stream;Stream;true;min;(Comparator);;Element of Argument[this];Parameter[0..1] of Argument[0];value
            Stream<Object> in = Stream.of(source("min"));
            in.min((x,y) -> { sink(x); return 0; }); // $ hasValueFlow=min
            in.min((x,y) -> { sink(y); return 0; }); // $ hasValueFlow=min
        }
        {
            //java.util.stream;Stream;true;noneMatch;(Predicate);;Element of Argument[this];Parameter[0] of Argument[0];value
            Stream<Object> in = Stream.of(source("noneMatch"));
            in.noneMatch(x -> { sink(x); return true; }); // $ hasValueFlow=noneMatch
        }
        {
            //java.util.stream;Stream;true;peek;(Consumer);;Element of Argument[this];Parameter[0] of Argument[0];value
            Stream<Object> in = Stream.of(source("peek"));
            in.peek(x -> sink(x)); // $ hasValueFlow=peek
        }
        {
            // "java.util.stream;Stream;true;reduce;(BinaryOperator);;Element of Argument[this];Element of ReturnValue;value;manual"
            //java.util.stream;Stream;true;reduce;(BinaryOperator);;Element of Argument[this];Parameter[0..1] of Argument[0];value
            //java.util.stream;Stream;true;reduce;(BinaryOperator);;ReturnValue of Argument[0];Element of ReturnValue;value
            //java.util.stream;Stream;true;reduce;(BinaryOperator);;ReturnValue of Argument[0];Parameter[0..1] of Argument[0];value
            Stream<Object> in = Stream.of(source("reduce_1"));
            Optional<Object> out = in.reduce((x,y) -> {
                    sink(x); // $ hasValueFlow=reduce_1 hasValueFlow=reduce_2
                    sink(y); // $ hasValueFlow=reduce_1 hasValueFlow=reduce_2
                    return source("reduce_2");
                });
            sink(getElement(out)); // $ hasValueFlow=reduce_1 hasValueFlow=reduce_2
        }
        {
            // "java.util.stream;Stream;true;reduce;(Object,BinaryOperator);;Argument[0];ReturnValue;value;manual"
            //java.util.stream;Stream;true;reduce;(Object,BinaryOperator);;Argument[0];Parameter[0..1] of Argument[1];value
            //java.util.stream;Stream;true;reduce;(Object,BinaryOperator);;Element of Argument[this];Parameter[0..1] of Argument[1];value
            //java.util.stream;Stream;true;reduce;(Object,BinaryOperator);;ReturnValue of Argument[1];Parameter[0..1] of Argument[1];value
            //java.util.stream;Stream;true;reduce;(Object,BinaryOperator);;ReturnValue of Argument[1];ReturnValue;value
            Stream<Object> in = Stream.of(source("reduce_3"));
            Object out = in.reduce(source("reduce_4"), (x,y) -> {
                    sink(x); // $ hasValueFlow=reduce_3 hasValueFlow=reduce_4 hasValueFlow=reduce_5
                    sink(y); // $ hasValueFlow=reduce_3 hasValueFlow=reduce_4 hasValueFlow=reduce_5
                    return source("reduce_5");
                });
            sink(out); // $ hasValueFlow=reduce_4 hasValueFlow=reduce_5
        }
        {
            // "java.util.stream;Stream;true;reduce;(Object,BiFunction,BinaryOperator);;Argument[0];ReturnValue;value;manual"
            //java.util.stream;Stream;true;reduce;(Object,BiFunction,BinaryOperator);;Argument[0];Parameter[0..1] of Argument[2];value
            //java.util.stream;Stream;true;reduce;(Object,BiFunction,BinaryOperator);;Argument[0];Parameter[0] of Argument[1];value
            //java.util.stream;Stream;true;reduce;(Object,BiFunction,BinaryOperator);;Element of Argument[this];Parameter[1] of Argument[1];value
            //java.util.stream;Stream;true;reduce;(Object,BiFunction,BinaryOperator);;ReturnValue of Argument[1..2];Parameter[0..1] of Argument[2];value
            //java.util.stream;Stream;true;reduce;(Object,BiFunction,BinaryOperator);;ReturnValue of Argument[1..2];Parameter[0] of Argument[1];value
            //java.util.stream;Stream;true;reduce;(Object,BiFunction,BinaryOperator);;ReturnValue of Argument[1..2];ReturnValue;value
            Stream<Object> in = Stream.of(source("reduce_6"));
            Object out = in.reduce(source("reduce_7"), (x,y) -> {
                    sink(x); // $ hasValueFlow=reduce_7 hasValueFlow=reduce_8 hasValueFlow=reduce_9
                    sink(y); // $ hasValueFlow=reduce_6
                    return source("reduce_8");
                }, (x,y) -> {
                    sink(x); // $ hasValueFlow=reduce_7 hasValueFlow=reduce_8 hasValueFlow=reduce_9
                    sink(y); // $ hasValueFlow=reduce_7 hasValueFlow=reduce_8 hasValueFlow=reduce_9
                    return source("reduce_9");
                });
            sink(out); // $ hasValueFlow=reduce_7 hasValueFlow=reduce_8 hasValueFlow=reduce_9
        }
        {
            //java.util.stream;Stream;true;sorted;(Comparator);;Element of Argument[this];Parameter[0..1] of Argument[0];value
            Stream<Object> in = Stream.of(source("sorted"));
            in.sorted((x,y) -> { sink(x); return 0; }); // $ hasValueFlow=sorted
            in.sorted((x,y) -> { sink(y); return 0; }); // $ hasValueFlow=sorted
        }
        {
            //java.util.stream;Stream;true;takeWhile;(Predicate);;Element of Argument[this];Parameter[0] of Argument[0];value
            Stream<Object> in = Stream.of(source("takeWhile"));
            in.takeWhile(x -> { sink(x); return true; }); // $ hasValueFlow=takeWhile
        }

    }

}
