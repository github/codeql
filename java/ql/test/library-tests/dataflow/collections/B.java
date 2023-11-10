import java.util.*;
import java.util.concurrent.*;
import java.util.regex.*;
import java.util.stream.*;

public class B {
  static Object source() { return null; }

  static void sink(Object obj) { }

  static Object[] storeArrayElement(Object obj) { return new Object[] {obj}; }
  static Set storeSetElement(Object obj) { return Set.of(obj); }

  static Object readArrayElement(Object[] obj) { return obj[0]; }
  static boolean readArrayElement(boolean[] obj) { return obj[0]; }
  static byte readArrayElement(byte[] obj) { return obj[0]; }
  static char readArrayElement(char[] obj) { return obj[0]; }
  static short readArrayElement(short[] obj) { return obj[0]; }
  static int readArrayElement(int[] obj) { return obj[0]; }
  static long readArrayElement(long[] obj) { return obj[0]; }
  static float readArrayElement(float[] obj) { return obj[0]; }
  static double readArrayElement(double[] obj) { return obj[0]; }

  static <T> List<T> storeElementList(T obj) { return List.of(obj); }
  static <T> Enumeration<T> storeElementEnumeration(T obj) { Vector<T> v = new Vector<>(); v.add(obj); return v.elements(); }
  static <T> NavigableSet<T> storeElementNavSet(T obj) { TreeSet<T> s = new TreeSet<>(); s.add(obj); return s; }
  static <T> Stack<T> storeElementStack(T obj) { Stack<T> s = new Stack<>(); s.push(obj); return s; }
  static <T> BlockingDeque<T> storeElementBlockingDeque(T obj) { LinkedBlockingDeque<T> q = new LinkedBlockingDeque<>(); q.add(obj); return q; }
  static <T> ListIterator<T> storeElementListIterator(T obj) { return List.of(obj).listIterator(); }

  static <T> T readElement(Iterable<T> obj) { return obj.iterator().next(); }
  static <T> T readElement(Iterator<T> obj) { return obj.next(); }
  static <T> T readElement(Spliterator<T> obj) { return null; }
  static <T> T readElement(Stream<T> obj) { return null; }
  static <T> T readElement(Enumeration<T> obj) { return obj.nextElement(); }

  static <K,V> Map.Entry<K,V> storeMapKeyEntry(K obj) { return Map.entry(obj,null); }
  static <K,V> Map<K,V> storeMapKey(K obj) { Map<K,V> m = new TreeMap<K,V>(); m.put(obj,null); return m; }

  static <K,V> Map.Entry<K,V> storeMapValueEntry(V obj) { return Map.entry(null,obj); }
  static <K,V> Map<K,V> storeMapValue(V obj) { Map<K,V> m = 1==1?new TreeMap<K,V>():new ConcurrentHashMap<K,V>(); m.put(null,obj); return m; }

  static <K,V> K readMapKey(Map.Entry<K,V> obj) { return obj.getKey(); }
  static <K,V> K readMapKey(Map<K,V> obj) { return obj.keySet().iterator().next(); }
  static <K,V> K readMapKey(Dictionary<K,V> obj) { return obj.keys().nextElement(); }

  static <K,V> V readMapValue(Map.Entry<K,V> obj) { return obj.getValue(); }
  static <K,V> V readMapValue(Map<K,V> obj) { return obj.get(null); }
  static <K,V> V readMapValue(Dictionary<K,V> obj) { return obj.get(null); }

  void foo() throws InterruptedException {
    {
      // "java.util;Map$Entry;true;getKey;;;Argument[this].MapKey;ReturnValue;value;manual",
      Object out = null;
      Object in = storeMapKeyEntry(source()); out = ((Map.Entry)in).getKey(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Map$Entry;true;getValue;;;Argument[this].MapValue;ReturnValue;value;manual",
      Object out = null;
      Object in = storeMapValueEntry(source()); out = ((Map.Entry)in).getValue(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Map$Entry;true;setValue;;;Argument[this].MapValue;ReturnValue;value;manual",
      Object out = null;
      Object in = storeMapValueEntry(source()); out = ((Map.Entry)in).setValue(null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Map$Entry;true;setValue;;;Argument[0];Argument[this].MapValue;value;manual",
      Map.Entry out = null;
      Object in = source(); out.setValue(in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.lang;Iterable;true;iterator;();;Argument[this].Element;ReturnValue.Element;value;manual",
      Iterator out = null;
      Iterable in = storeElementList(source()); out = in.iterator(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.lang;Iterable;true;spliterator;();;Argument[this].Element;ReturnValue.Element;value;manual",
      Spliterator out = null;
      Iterable in = storeElementList(source()); out = in.spliterator(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Iterator;true;next;;;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      Iterator in = storeElementListIterator(source()); out = in.next(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;ListIterator;true;previous;;;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      ListIterator in = storeElementListIterator(source()); out = in.previous(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;ListIterator;true;add;(Object);;Argument[0];Argument[this].Element;value;manual",
      ListIterator out = null;
      Object in = source(); out.add(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;ListIterator;true;set;(Object);;Argument[0];Argument[this].Element;value;manual",
      ListIterator out = null;
      Object in = source(); out.set(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Enumeration;true;asIterator;;;Argument[this].Element;ReturnValue.Element;value;manual",
      Iterator out = null;
      Enumeration in = storeElementEnumeration(source()); out = in.asIterator(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Enumeration;true;nextElement;;;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      Enumeration in = storeElementEnumeration(source()); out = in.nextElement(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;computeIfAbsent;;;Argument[this].MapValue;ReturnValue;value;manual",
      Object out = null;
      Object in = storeMapValue(source()); out = ((Map)in).computeIfAbsent(null,null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;computeIfAbsent;;;Argument[1].ReturnValue;ReturnValue;value;manual",
      Object out = ((Map)null).computeIfAbsent(null,k -> source()); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;computeIfAbsent;;;Argument[1].ReturnValue;Argument[this].MapValue;value;manual",
      Map out = null;
      out.computeIfAbsent(null,k -> source()); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;entrySet;;;Argument[this].MapValue;ReturnValue.Element.MapValue;value;manual",
      Set<Map.Entry> out = null;
      Object in = storeMapValue(source()); out = ((Map)in).entrySet(); sink(readMapValue(readElement(out))); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;entrySet;;;Argument[this].MapKey;ReturnValue.Element.MapKey;value;manual",
      Set<Map.Entry> out = null;
      Object in = storeMapKey(source()); out = ((Map)in).entrySet(); sink(readMapKey(readElement(out))); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;get;;;Argument[this].MapValue;ReturnValue;value;manual",
      Object out = null;
      Object in = storeMapValue(source()); out = ((Map)in).get(null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;getOrDefault;;;Argument[this].MapValue;ReturnValue;value;manual",
      Object out = null;
      Object in = storeMapValue(source()); out = ((Map)in).getOrDefault(null,null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;getOrDefault;;;Argument[1];ReturnValue;value;manual",
      Object out = null;
      Object in = source(); out = ((Map)null).getOrDefault(null,in); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;put;;;Argument[this].MapValue;ReturnValue;value;manual",
      Object out = null;
      Object in = storeMapValue(source()); out = ((Map)in).put(null,null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;put;;;Argument[0];Argument[this].MapKey;value;manual",
      Map out = null;
      Object in = source(); out.put(in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;put;;;Argument[1];Argument[this].MapValue;value;manual",
      Map out = null;
      Object in = source(); out.put(null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;putIfAbsent;;;Argument[this].MapValue;ReturnValue;value;manual",
      Object out = null;
      Object in = storeMapValue(source()); out = ((Map)in).putIfAbsent(null,null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;putIfAbsent;;;Argument[0];Argument[this].MapKey;value;manual",
      Map out = null;
      Object in = source(); out.putIfAbsent(in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;putIfAbsent;;;Argument[1];Argument[this].MapValue;value;manual",
      Map out = null;
      Object in = source(); out.putIfAbsent(null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;remove;(Object);;Argument[this].MapValue;ReturnValue;value;manual",
      Object out = null;
      Object in = storeMapValue(source()); out = ((Map)in).remove(null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;replace;(Object,Object);;Argument[this].MapValue;ReturnValue;value;manual",
      Object out = null;
      Object in = storeMapValue(source()); out = ((Map)in).replace(null,null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;replace;(Object,Object);;Argument[0];Argument[this].MapKey;value;manual",
      Map out = null;
      Object in = source(); out.replace(in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;replace;(Object,Object);;Argument[1];Argument[this].MapValue;value;manual",
      Map out = null;
      Object in = source(); out.replace(null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;replace;(Object,Object,Object);;Argument[0];Argument[this].MapKey;value;manual",
      Map out = null;
      Object in = source(); out.replace(in,null,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;replace;(Object,Object,Object);;Argument[2];Argument[this].MapValue;value;manual",
      Map out = null;
      Object in = source(); out.replace(null,null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;keySet;();;Argument[this].MapKey;ReturnValue.Element;value;manual",
      Set out = null;
      Object in = storeMapKey(source()); out = ((Map)in).keySet(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;values;();;Argument[this].MapValue;ReturnValue.Element;value;manual",
      Iterable out = null;
      Object in = storeMapValue(source()); out = ((Map)in).values(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;merge;(Object,Object,BiFunction);;Argument[1];Argument[this].MapValue;value;manual",
      Map out = null;
      Object in = source(); out.merge(null,in,null); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;putAll;(Map);;Argument[0].MapKey;Argument[this].MapKey;value;manual",
      Map out = null;
      Object in = storeMapKey(source()); out.putAll((Map)in); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;putAll;(Map);;Argument[0].MapValue;Argument[this].MapValue;value;manual",
      Map out = null;
      Object in = storeMapValue(source()); out.putAll((Map)in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collection;true;parallelStream;();;Argument[this].Element;ReturnValue.Element;value;manual",
      Stream out = null;
      Collection in = storeElementList(source()); out = in.parallelStream(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collection;true;stream;();;Argument[this].Element;ReturnValue.Element;value;manual",
      Stream out = null;
      Collection in = storeElementList(source()); out = in.stream(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collection;true;toArray;;;Argument[this].Element;ReturnValue.ArrayElement;value;manual",
      Object[] out = null;
      Collection in = storeElementList(source()); out = in.toArray(); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collection;true;toArray;;;Argument[this].Element;Argument[0].ArrayElement;value;manual",
      Object[] out = null;
      Collection in = storeElementList(source()); in.toArray(out); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collection;true;add;;;Argument[0];Argument[this].Element;value;manual",
      Collection out = null;
      Object in = source(); out.add(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collection;true;addAll;;;Argument[0].Element;Argument[this].Element;value;manual",
      Collection out = null;
      Collection in = storeElementList(source()); out.addAll(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;true;get;(int);;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      List in = storeElementList(source()); out = in.get(0); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;List;true;listIterator;;;Argument[this].Element;ReturnValue.Element;value;manual",
      ListIterator out = null;
      List in = storeElementList(source()); out = in.listIterator(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;true;remove;(int);;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      List in = storeElementList(source()); out = in.remove(0); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;List;true;set;(int,Object);;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      List in = storeElementList(source()); out = in.set(0,null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;List;true;set;(int,Object);;Argument[1];Argument[this].Element;value;manual",
      List out = null;
      Object in = source(); out.set(0,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;true;subList;;;Argument[this].Element;ReturnValue.Element;value;manual",
      List out = null;
      List in = storeElementList(source()); out = in.subList(0,0); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;true;add;(int,Object);;Argument[1];Argument[this].Element;value;manual",
      List out = null;
      Object in = source(); out.add(0,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;true;addAll;(int,Collection);;Argument[1].Element;Argument[this].Element;value;manual",
      List out = null;
      Collection in = storeElementList(source()); out.addAll(0,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;true;clear;;;Argument[this].WithoutElement;Argument[this];value;manual"
      List out = null;
      List in = storeElementList(source()); out = in; out.clear(); sink(readElement(out)); // No flow
    }
    {
      // "java.util;List;true;clear;;;Argument[this].WithoutElement;Argument[this];value;manual"
      List out = null;
      List in = (List)source(); out = in; out.clear(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Vector;true;elementAt;(int);;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      Vector in = storeElementStack(source()); out = in.elementAt(0); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Vector;true;elements;();;Argument[this].Element;ReturnValue.Element;value;manual",
      Enumeration out = null;
      Vector in = storeElementStack(source()); out = in.elements(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Vector;true;firstElement;();;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      Vector in = storeElementStack(source()); out = in.firstElement(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Vector;true;lastElement;();;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      Vector in = storeElementStack(source()); out = in.lastElement(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Vector;true;addElement;(Object);;Argument[0];Argument[this].Element;value;manual",
      Vector out = null;
      Object in = source(); out.addElement(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Vector;true;insertElementAt;(Object,int);;Argument[0];Argument[this].Element;value;manual",
      Vector out = null;
      Object in = source(); out.insertElementAt(in,0); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Vector;true;setElementAt;(Object,int);;Argument[0];Argument[this].Element;value;manual",
      Vector out = null;
      Object in = source(); out.setElementAt(in,0); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Vector;true;copyInto;(Object[]);;Argument[this].Element;Argument[0].ArrayElement;value;manual",
      Object[] out = null;
      Vector in = storeElementStack(source()); in.copyInto(out); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Stack;true;peek;();;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      Stack in = storeElementStack(source()); out = in.peek(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Stack;true;pop;();;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      Stack in = storeElementStack(source()); out = in.pop(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Stack;true;push;(Object);;Argument[0];Argument[this].Element;value;manual",
      Stack out = null;
      Object in = source(); out.push(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Queue;true;element;();;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      Queue in = storeElementBlockingDeque(source()); out = in.element(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Queue;true;peek;();;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      Queue in = storeElementBlockingDeque(source()); out = in.peek(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Queue;true;poll;();;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      Queue in = storeElementBlockingDeque(source()); out = in.poll(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Queue;true;remove;();;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      Queue in = storeElementBlockingDeque(source()); out = in.remove(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Queue;true;offer;(Object);;Argument[0];Argument[this].Element;value;manual",
      Queue out = null;
      Object in = source(); out.offer(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Deque;true;descendingIterator;();;Argument[this].Element;ReturnValue.Element;value;manual",
      Iterator out = null;
      Deque in = storeElementBlockingDeque(source()); out = in.descendingIterator(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Deque;true;getFirst;();;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      Deque in = storeElementBlockingDeque(source()); out = in.getFirst(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Deque;true;getLast;();;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      Deque in = storeElementBlockingDeque(source()); out = in.getLast(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Deque;true;peekFirst;();;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      Deque in = storeElementBlockingDeque(source()); out = in.peekFirst(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Deque;true;peekLast;();;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      Deque in = storeElementBlockingDeque(source()); out = in.peekLast(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Deque;true;pollFirst;();;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      Deque in = storeElementBlockingDeque(source()); out = in.pollFirst(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Deque;true;pollLast;();;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      Deque in = storeElementBlockingDeque(source()); out = in.pollLast(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Deque;true;pop;();;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      Deque in = storeElementBlockingDeque(source()); out = in.pop(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Deque;true;removeFirst;();;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      Deque in = storeElementBlockingDeque(source()); out = in.removeFirst(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Deque;true;removeLast;();;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      Deque in = storeElementBlockingDeque(source()); out = in.removeLast(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Deque;true;push;(Object);;Argument[0];Argument[this].Element;value;manual",
      Deque out = null;
      Object in = source(); out.push(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Deque;true;offerLast;(Object);;Argument[0];Argument[this].Element;value;manual",
      Deque out = null;
      Object in = source(); out.offerLast(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Deque;true;offerFirst;(Object);;Argument[0];Argument[this].Element;value;manual",
      Deque out = null;
      Object in = source(); out.offerFirst(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Deque;true;addLast;(Object);;Argument[0];Argument[this].Element;value;manual",
      Deque out = null;
      Object in = source(); out.addLast(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Deque;true;addFirst;(Object);;Argument[0];Argument[this].Element;value;manual",
      Deque out = null;
      Object in = source(); out.addFirst(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;BlockingDeque;true;pollFirst;(long,TimeUnit);;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      BlockingDeque in = storeElementBlockingDeque(source()); out = in.pollFirst(0,null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;BlockingDeque;true;pollLast;(long,TimeUnit);;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      BlockingDeque in = storeElementBlockingDeque(source()); out = in.pollLast(0,null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;BlockingDeque;true;takeFirst;();;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      BlockingDeque in = storeElementBlockingDeque(source()); out = in.takeFirst(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;BlockingDeque;true;takeLast;();;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      BlockingDeque in = storeElementBlockingDeque(source()); out = in.takeLast(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;BlockingQueue;true;poll;(long,TimeUnit);;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      BlockingQueue in = storeElementBlockingDeque(source()); out = in.poll(0,null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;BlockingQueue;true;take;();;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      BlockingQueue in = storeElementBlockingDeque(source()); out = in.take(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;BlockingQueue;true;offer;(Object,long,TimeUnit);;Argument[0];Argument[this].Element;value;manual",
      BlockingQueue out = null;
      Object in = source(); out.offer(in,0,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;BlockingQueue;true;put;(Object);;Argument[0];Argument[this].Element;value;manual",
      BlockingQueue out = null;
      Object in = source(); out.put(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;BlockingDeque;true;offerLast;(Object,long,TimeUnit);;Argument[0];Argument[this].Element;value;manual",
      BlockingDeque out = null;
      Object in = source(); out.offerLast(in,0,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;BlockingDeque;true;offerFirst;(Object,long,TimeUnit);;Argument[0];Argument[this].Element;value;manual",
      BlockingDeque out = null;
      Object in = source(); out.offerFirst(in,0,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;BlockingDeque;true;putLast;(Object);;Argument[0];Argument[this].Element;value;manual",
      BlockingDeque out = null;
      Object in = source(); out.putLast(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;BlockingDeque;true;putFirst;(Object);;Argument[0];Argument[this].Element;value;manual",
      BlockingDeque out = null;
      Object in = source(); out.putFirst(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;BlockingQueue;true;drainTo;(Collection,int);;Argument[this].Element;Argument[0].Element;value;manual",
      Collection out = null;
      BlockingQueue in = storeElementBlockingDeque(source()); in.drainTo(out,0); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;BlockingQueue;true;drainTo;(Collection);;Argument[this].Element;Argument[0].Element;value;manual",
      Collection out = null;
      BlockingQueue in = storeElementBlockingDeque(source()); in.drainTo(out); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;ConcurrentHashMap;true;elements;();;Argument[this].MapValue;ReturnValue.Element;value;manual",
      Enumeration out = null;
      Object in = storeMapValue(source()); out = ((ConcurrentHashMap)in).elements(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Dictionary;true;elements;();;Argument[this].MapValue;ReturnValue.Element;value;manual",
      Enumeration out = null;
      Object in = storeMapValue(source()); out = ((Dictionary)in).elements(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Dictionary;true;get;(Object);;Argument[this].MapValue;ReturnValue;value;manual",
      Object out = null;
      Object in = storeMapValue(source()); out = ((Dictionary)in).get(null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Dictionary;true;put;(Object,Object);;Argument[this].MapValue;ReturnValue;value;manual",
      Object out = null;
      Object in = storeMapValue(source()); out = ((Dictionary)in).put(null,null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Dictionary;true;put;(Object,Object);;Argument[0];Argument[this].MapKey;value;manual",
      Dictionary out = null;
      Object in = source(); out.put(in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Dictionary;true;put;(Object,Object);;Argument[1];Argument[this].MapValue;value;manual",
      Dictionary out = null;
      Object in = source(); out.put(null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Dictionary;true;remove;(Object);;Argument[this].MapValue;ReturnValue;value;manual",
      Object out = null;
      Object in = storeMapValue(source()); out = ((Dictionary)in).remove(null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;ceilingEntry;(Object);;Argument[this].MapKey;ReturnValue.MapKey;value;manual",
      Map.Entry out = null;
      Object in = storeMapKey(source()); out = ((NavigableMap)in).ceilingEntry(null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;ceilingEntry;(Object);;Argument[this].MapValue;ReturnValue.MapValue;value;manual",
      Map.Entry out = null;
      Object in = storeMapValue(source()); out = ((NavigableMap)in).ceilingEntry(null); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;descendingMap;();;Argument[this].MapKey;ReturnValue.MapKey;value;manual",
      Map out = null;
      Object in = storeMapKey(source()); out = ((NavigableMap)in).descendingMap(); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;descendingMap;();;Argument[this].MapValue;ReturnValue.MapValue;value;manual",
      Map out = null;
      Object in = storeMapValue(source()); out = ((NavigableMap)in).descendingMap(); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;firstEntry;();;Argument[this].MapKey;ReturnValue.MapKey;value;manual",
      Map.Entry out = null;
      Object in = storeMapKey(source()); out = ((NavigableMap)in).firstEntry(); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;firstEntry;();;Argument[this].MapValue;ReturnValue.MapValue;value;manual",
      Map.Entry out = null;
      Object in = storeMapValue(source()); out = ((NavigableMap)in).firstEntry(); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;floorEntry;(Object);;Argument[this].MapKey;ReturnValue.MapKey;value;manual",
      Map.Entry out = null;
      Object in = storeMapKey(source()); out = ((NavigableMap)in).floorEntry(null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;floorEntry;(Object);;Argument[this].MapValue;ReturnValue.MapValue;value;manual",
      Map.Entry out = null;
      Object in = storeMapValue(source()); out = ((NavigableMap)in).floorEntry(null); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;headMap;(Object,boolean);;Argument[this].MapKey;ReturnValue.MapKey;value;manual",
      Map out = null;
      Object in = storeMapKey(source()); out = ((NavigableMap)in).headMap(null,true); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;headMap;(Object,boolean);;Argument[this].MapValue;ReturnValue.MapValue;value;manual",
      Map out = null;
      Object in = storeMapValue(source()); out = ((NavigableMap)in).headMap(null,true); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;higherEntry;(Object);;Argument[this].MapKey;ReturnValue.MapKey;value;manual",
      Map.Entry out = null;
      Object in = storeMapKey(source()); out = ((NavigableMap)in).higherEntry(null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;higherEntry;(Object);;Argument[this].MapValue;ReturnValue.MapValue;value;manual",
      Map.Entry out = null;
      Object in = storeMapValue(source()); out = ((NavigableMap)in).higherEntry(null); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;lastEntry;();;Argument[this].MapKey;ReturnValue.MapKey;value;manual",
      Map.Entry out = null;
      Object in = storeMapKey(source()); out = ((NavigableMap)in).lastEntry(); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;lastEntry;();;Argument[this].MapValue;ReturnValue.MapValue;value;manual",
      Map.Entry out = null;
      Object in = storeMapValue(source()); out = ((NavigableMap)in).lastEntry(); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;lowerEntry;(Object);;Argument[this].MapKey;ReturnValue.MapKey;value;manual",
      Map.Entry out = null;
      Object in = storeMapKey(source()); out = ((NavigableMap)in).lowerEntry(null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;lowerEntry;(Object);;Argument[this].MapValue;ReturnValue.MapValue;value;manual",
      Map.Entry out = null;
      Object in = storeMapValue(source()); out = ((NavigableMap)in).lowerEntry(null); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;pollFirstEntry;();;Argument[this].MapKey;ReturnValue.MapKey;value;manual",
      Map.Entry out = null;
      Object in = storeMapKey(source()); out = ((NavigableMap)in).pollFirstEntry(); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;pollFirstEntry;();;Argument[this].MapValue;ReturnValue.MapValue;value;manual",
      Map.Entry out = null;
      Object in = storeMapValue(source()); out = ((NavigableMap)in).pollFirstEntry(); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;pollLastEntry;();;Argument[this].MapKey;ReturnValue.MapKey;value;manual",
      Map.Entry out = null;
      Object in = storeMapKey(source()); out = ((NavigableMap)in).pollLastEntry(); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;pollLastEntry;();;Argument[this].MapValue;ReturnValue.MapValue;value;manual",
      Map.Entry out = null;
      Object in = storeMapValue(source()); out = ((NavigableMap)in).pollLastEntry(); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;subMap;(Object,boolean,Object,boolean);;Argument[this].MapKey;ReturnValue.MapKey;value;manual",
      Map out = null;
      Object in = storeMapKey(source()); out = ((NavigableMap)in).subMap(null,true,null,true); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;subMap;(Object,boolean,Object,boolean);;Argument[this].MapValue;ReturnValue.MapValue;value;manual",
      Map out = null;
      Object in = storeMapValue(source()); out = ((NavigableMap)in).subMap(null,true,null,true); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;tailMap;(Object,boolean);;Argument[this].MapKey;ReturnValue.MapKey;value;manual",
      Map out = null;
      Object in = storeMapKey(source()); out = ((NavigableMap)in).tailMap(null,true); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;tailMap;(Object,boolean);;Argument[this].MapValue;ReturnValue.MapValue;value;manual",
      Map out = null;
      Object in = storeMapValue(source()); out = ((NavigableMap)in).tailMap(null,true); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableSet;true;ceiling;(Object);;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      NavigableSet in = storeElementNavSet(source()); out = in.ceiling(null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;NavigableSet;true;descendingIterator;();;Argument[this].Element;ReturnValue.Element;value;manual",
      Iterator out = null;
      NavigableSet in = storeElementNavSet(source()); out = in.descendingIterator(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableSet;true;descendingSet;();;Argument[this].Element;ReturnValue.Element;value;manual",
      Set out = null;
      NavigableSet in = storeElementNavSet(source()); out = in.descendingSet(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableSet;true;floor;(Object);;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      NavigableSet in = storeElementNavSet(source()); out = in.floor(null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;NavigableSet;true;headSet;(Object,boolean);;Argument[this].Element;ReturnValue.Element;value;manual",
      Set out = null;
      NavigableSet in = storeElementNavSet(source()); out = in.headSet(null,true); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableSet;true;higher;(Object);;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      NavigableSet in = storeElementNavSet(source()); out = in.higher(null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;NavigableSet;true;lower;(Object);;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      NavigableSet in = storeElementNavSet(source()); out = in.lower(null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;NavigableSet;true;pollFirst;();;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      NavigableSet in = storeElementNavSet(source()); out = in.pollFirst(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;NavigableSet;true;pollLast;();;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      NavigableSet in = storeElementNavSet(source()); out = in.pollLast(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;NavigableSet;true;subSet;(Object,boolean,Object,boolean);;Argument[this].Element;ReturnValue.Element;value;manual",
      Set out = null;
      NavigableSet in = storeElementNavSet(source()); out = in.subSet(null,true,null,true); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableSet;true;tailSet;(Object,boolean);;Argument[this].Element;ReturnValue.Element;value;manual",
      Set out = null;
      NavigableSet in = storeElementNavSet(source()); out = in.tailSet(null,true); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;SortedMap;true;headMap;(Object);;Argument[this].MapKey;ReturnValue.MapKey;value;manual",
      Map out = null;
      Object in = storeMapKey(source()); out = ((SortedMap)in).headMap(null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;SortedMap;true;headMap;(Object);;Argument[this].MapValue;ReturnValue.MapValue;value;manual",
      Map out = null;
      Object in = storeMapValue(source()); out = ((SortedMap)in).headMap(null); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;SortedMap;true;subMap;(Object,Object);;Argument[this].MapKey;ReturnValue.MapKey;value;manual",
      Map out = null;
      Object in = storeMapKey(source()); out = ((SortedMap)in).subMap(null,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;SortedMap;true;subMap;(Object,Object);;Argument[this].MapValue;ReturnValue.MapValue;value;manual",
      Map out = null;
      Object in = storeMapValue(source()); out = ((SortedMap)in).subMap(null,null); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;SortedMap;true;tailMap;(Object);;Argument[this].MapKey;ReturnValue.MapKey;value;manual",
      Map out = null;
      Object in = storeMapKey(source()); out = ((SortedMap)in).tailMap(null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;SortedMap;true;tailMap;(Object);;Argument[this].MapValue;ReturnValue.MapValue;value;manual",
      Map out = null;
      Object in = storeMapValue(source()); out = ((SortedMap)in).tailMap(null); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;SortedSet;true;first;();;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      SortedSet in = storeElementNavSet(source()); out = in.first(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;SortedSet;true;headSet;(Object);;Argument[this].Element;ReturnValue.Element;value;manual",
      Set out = null;
      SortedSet in = storeElementNavSet(source()); out = in.headSet(null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;SortedSet;true;last;();;Argument[this].Element;ReturnValue;value;manual",
      Object out = null;
      SortedSet in = storeElementNavSet(source()); out = in.last(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;SortedSet;true;subSet;(Object,Object);;Argument[this].Element;ReturnValue.Element;value;manual",
      Set out = null;
      SortedSet in = storeElementNavSet(source()); out = in.subSet(null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;SortedSet;true;tailSet;(Object);;Argument[this].Element;ReturnValue.Element;value;manual",
      Set out = null;
      SortedSet in = storeElementNavSet(source()); out = in.tailSet(null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;TransferQueue;true;tryTransfer;(Object,long,TimeUnit);;Argument[0];Argument[this].Element;value;manual",
      TransferQueue out = null;
      Object in = source(); out.tryTransfer(in,0,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;TransferQueue;true;transfer;(Object);;Argument[0];Argument[this].Element;value;manual",
      TransferQueue out = null;
      Object in = source(); out.transfer(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;TransferQueue;true;tryTransfer;(Object);;Argument[0];Argument[this].Element;value;manual",
      TransferQueue out = null;
      Object in = source(); out.tryTransfer(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;copyOf;(Collection);;Argument[0].Element;ReturnValue.Element;value;manual",
      List out = null;
      Collection in = storeElementList(source()); out = List.copyOf(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object[]);;Argument[0].ArrayElement;ReturnValue.Element;value;manual",
      List out = null;
      Object[] in = storeArrayElement(source()); out = List.of(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object);;Argument[0];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object);;Argument[0];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object);;Argument[1];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object);;Argument[0];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object);;Argument[1];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object);;Argument[2];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object);;Argument[0];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(in,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object);;Argument[1];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object);;Argument[2];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object);;Argument[3];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object);;Argument[0];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(in,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object);;Argument[1];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,in,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object);;Argument[2];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object);;Argument[3];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object);;Argument[4];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object);;Argument[0];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(in,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object);;Argument[1];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,in,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object);;Argument[2];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,in,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object);;Argument[3];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,null,in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object);;Argument[4];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object);;Argument[5];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object);;Argument[0];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(in,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object);;Argument[1];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,in,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object);;Argument[2];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,in,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object);;Argument[3];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,null,in,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object);;Argument[4];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object);;Argument[5];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object);;Argument[6];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[0];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(in,null,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,in,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[2];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,in,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[3];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,null,in,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[4];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,in,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[5];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,null,in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[6];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,null,null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[7];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,null,null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[0];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(in,null,null,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,in,null,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[2];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,in,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[3];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,null,in,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[4];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,in,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[5];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,null,in,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[6];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,null,null,in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[7];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,null,null,null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[8];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,null,null,null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[0];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(in,null,null,null,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,in,null,null,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[2];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,in,null,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[3];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,null,in,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[4];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,in,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[5];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,null,in,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[6];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,null,null,in,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[7];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,null,null,null,in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[8];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,null,null,null,null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[9];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,null,null,null,null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;copyOf;(Map);;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
      Map out = null;
      Object in = storeMapKey(source()); out = Map.copyOf((Map)in); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;copyOf;(Map);;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
      Map out = null;
      Object in = storeMapValue(source()); out = Map.copyOf((Map)in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;entry;(Object,Object);;Argument[0];ReturnValue.MapKey;value;manual",
      Map.Entry out = null;
      Object in = source(); out = Map.entry(in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;entry;(Object,Object);;Argument[1];ReturnValue.MapValue;value;manual",
      Map.Entry out = null;
      Object in = source(); out = Map.entry(null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[0];ReturnValue.MapKey;value;manual",
      Map out = null;
      Object in = source(); out = Map.of(in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[1];ReturnValue.MapValue;value;manual",
      Map out = null;
      Object in = source(); out = Map.of(null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[2];ReturnValue.MapKey;value;manual",
      Map out = null;
      Object in = source(); out = Map.of(null,null,in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[3];ReturnValue.MapValue;value;manual",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[4];ReturnValue.MapKey;value;manual",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[5];ReturnValue.MapValue;value;manual",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[6];ReturnValue.MapKey;value;manual",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,null,null,in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[7];ReturnValue.MapValue;value;manual",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,null,null,null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[8];ReturnValue.MapKey;value;manual",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,null,null,null,null,in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[9];ReturnValue.MapValue;value;manual",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,null,null,null,null,null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[10];ReturnValue.MapKey;value;manual",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,null,null,null,null,null,null,in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[11];ReturnValue.MapValue;value;manual",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,null,null,null,null,null,null,null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[12];ReturnValue.MapKey;value;manual",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,null,null,null,null,null,null,null,null,in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[13];ReturnValue.MapValue;value;manual",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,null,null,null,null,null,null,null,null,null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[14];ReturnValue.MapKey;value;manual",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,null,null,null,null,null,null,null,null,null,null,in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[15];ReturnValue.MapValue;value;manual",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[16];ReturnValue.MapKey;value;manual",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[17];ReturnValue.MapValue;value;manual",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[18];ReturnValue.MapKey;value;manual",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[19];ReturnValue.MapValue;value;manual",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;ofEntries;;;Argument[0].MapKey.ArrayElement;ReturnValue.MapKey;value;manual",
      Map out = null;
      Object[] in = storeArrayElement(storeMapKey(source())); out = Map.ofEntries((Map.Entry[])in); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;ofEntries;;;Argument[0].MapValue.ArrayElement;ReturnValue.MapValue;value;manual",
      Map out = null;
      Object[] in = storeArrayElement(storeMapValue(source())); out = Map.ofEntries((Map.Entry[])in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;true;clear;;;Argument[this].WithoutElement;Argument[this];value;manual"
      Set out = null;
      Set in = storeSetElement(source()); out = in; out.clear(); sink(readElement(out)); // No flow
    }
    {
      // "java.util;Set;true;clear;;;Argument[this].WithoutElement;Argument[this];value;manual"
      Set out = null;
      Set in = (Set)source(); out = in; out.clear(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;copyOf;(Collection);;Argument[0].Element;ReturnValue.Element;value;manual",
      Set out = null;
      Collection in = storeElementList(source()); out = Set.copyOf(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object[]);;Argument[0].ArrayElement;ReturnValue.Element;value;manual",
      Set out = null;
      Object[] in = storeArrayElement(source()); out = Set.of(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object);;Argument[0];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object);;Argument[0];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object);;Argument[1];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object);;Argument[0];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object);;Argument[1];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object);;Argument[2];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object);;Argument[0];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(in,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object);;Argument[1];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object);;Argument[2];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object);;Argument[3];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object);;Argument[0];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(in,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object);;Argument[1];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,in,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object);;Argument[2];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object);;Argument[3];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object);;Argument[4];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object);;Argument[0];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(in,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object);;Argument[1];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,in,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object);;Argument[2];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,in,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object);;Argument[3];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object);;Argument[4];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object);;Argument[5];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object);;Argument[0];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(in,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object);;Argument[1];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,in,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object);;Argument[2];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,in,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object);;Argument[3];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,in,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object);;Argument[4];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object);;Argument[5];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object);;Argument[6];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[0];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(in,null,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,in,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[2];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,in,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[3];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,in,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[4];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,in,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[5];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,null,in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[6];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,null,null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[7];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,null,null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[0];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(in,null,null,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,in,null,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[2];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,in,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[3];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,in,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[4];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,in,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[5];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,null,in,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[6];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,null,null,in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[7];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,null,null,null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[8];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,null,null,null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[0];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(in,null,null,null,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,in,null,null,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[2];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,in,null,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[3];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,in,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[4];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,in,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[5];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,null,in,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[6];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,null,null,in,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[7];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,null,null,null,in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[8];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,null,null,null,null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[9];ReturnValue.Element;value;manual",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,null,null,null,null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;stream;;;Argument[0].ArrayElement;ReturnValue.Element;value;manual",
      Stream out = null;
      Object[] in = storeArrayElement(source()); out = ((Arrays)null).stream(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;spliterator;;;Argument[0].ArrayElement;ReturnValue.Element;value;manual",
      Spliterator out = null;
      Object[] in = storeArrayElement(source()); out = ((Arrays)null).spliterator(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;copyOfRange;;;Argument[0].ArrayElement;ReturnValue.ArrayElement;value;manual",
      Object[] out = null;
      Object[] in = storeArrayElement(source()); out = ((Arrays)null).copyOfRange(in,0,0); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;copyOf;;;Argument[0].ArrayElement;ReturnValue.ArrayElement;value;manual",
      Object[] out = null;
      Object[] in = storeArrayElement(source()); out = ((Arrays)null).copyOf(in,0); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;list;(Enumeration);;Argument[0].Element;ReturnValue.Element;value;manual",
      List out = null;
      Enumeration in = storeElementEnumeration(source()); out = ((Collections)null).list(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;enumeration;(Collection);;Argument[0].Element;ReturnValue.Element;value;manual",
      Enumeration out = null;
      Collection in = storeElementList(source()); out = ((Collections)null).enumeration(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;nCopies;(int,Object);;Argument[1];ReturnValue.Element;value;manual",
      Collection out = null;
      Object in = source(); out = ((Collections)null).nCopies(0,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;singletonMap;(Object,Object);;Argument[0];ReturnValue.MapKey;value;manual",
      Map out = null;
      Object in = source(); out = ((Collections)null).singletonMap(in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;singletonMap;(Object,Object);;Argument[1];ReturnValue.MapValue;value;manual",
      Map out = null;
      Object in = source(); out = ((Collections)null).singletonMap(null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;singletonList;(Object);;Argument[0];ReturnValue.Element;value;manual",
      List out = null;
      Object in = source(); out = ((Collections)null).singletonList(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;singleton;(Object);;Argument[0];ReturnValue.Element;value;manual",
      Collection out = null;
      Object in = source(); out = ((Collections)null).singleton(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;checkedNavigableMap;(NavigableMap,Class,Class);;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
      Map out = null;
      Object in = storeMapKey(source()); out = ((Collections)null).checkedNavigableMap((NavigableMap)in,null,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;checkedNavigableMap;(NavigableMap,Class,Class);;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
      Map out = null;
      Object in = storeMapValue(source()); out = ((Collections)null).checkedNavigableMap((NavigableMap)in,null,null); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;checkedSortedMap;(SortedMap,Class,Class);;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
      Map out = null;
      Object in = storeMapKey(source()); out = ((Collections)null).checkedSortedMap((SortedMap)in,null,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;checkedSortedMap;(SortedMap,Class,Class);;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
      Map out = null;
      Object in = storeMapValue(source()); out = ((Collections)null).checkedSortedMap((SortedMap)in,null,null); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;checkedMap;(Map,Class,Class);;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
      Map out = null;
      Object in = storeMapKey(source()); out = ((Collections)null).checkedMap((Map)in,null,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;checkedMap;(Map,Class,Class);;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
      Map out = null;
      Object in = storeMapValue(source()); out = ((Collections)null).checkedMap((Map)in,null,null); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;checkedList;(List,Class);;Argument[0].Element;ReturnValue.Element;value;manual",
      List out = null;
      List in = storeElementList(source()); out = ((Collections)null).checkedList(in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;checkedNavigableSet;(NavigableSet,Class);;Argument[0].Element;ReturnValue.Element;value;manual",
      Set out = null;
      NavigableSet in = storeElementNavSet(source()); out = ((Collections)null).checkedNavigableSet(in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;checkedSortedSet;(SortedSet,Class);;Argument[0].Element;ReturnValue.Element;value;manual",
      Set out = null;
      SortedSet in = storeElementNavSet(source()); out = ((Collections)null).checkedSortedSet(in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;checkedSet;(Set,Class);;Argument[0].Element;ReturnValue.Element;value;manual",
      Set out = null;
      Set in = storeElementNavSet(source()); out = ((Collections)null).checkedSet(in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;checkedCollection;(Collection,Class);;Argument[0].Element;ReturnValue.Element;value;manual",
      Collection out = null;
      Collection in = storeElementList(source()); out = ((Collections)null).checkedCollection(in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;synchronizedNavigableMap;(NavigableMap);;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
      Map out = null;
      Object in = storeMapKey(source()); out = ((Collections)null).synchronizedNavigableMap((NavigableMap)in); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;synchronizedNavigableMap;(NavigableMap);;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
      Map out = null;
      Object in = storeMapValue(source()); out = ((Collections)null).synchronizedNavigableMap((NavigableMap)in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;synchronizedSortedMap;(SortedMap);;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
      Map out = null;
      Object in = storeMapKey(source()); out = ((Collections)null).synchronizedSortedMap((SortedMap)in); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;synchronizedSortedMap;(SortedMap);;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
      Map out = null;
      Object in = storeMapValue(source()); out = ((Collections)null).synchronizedSortedMap((SortedMap)in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;synchronizedMap;(Map);;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
      Map out = null;
      Object in = storeMapKey(source()); out = ((Collections)null).synchronizedMap((Map)in); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;synchronizedMap;(Map);;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
      Map out = null;
      Object in = storeMapValue(source()); out = ((Collections)null).synchronizedMap((Map)in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;synchronizedList;(List);;Argument[0].Element;ReturnValue.Element;value;manual",
      List out = null;
      List in = storeElementList(source()); out = ((Collections)null).synchronizedList(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;synchronizedNavigableSet;(NavigableSet);;Argument[0].Element;ReturnValue.Element;value;manual",
      Set out = null;
      NavigableSet in = storeElementNavSet(source()); out = ((Collections)null).synchronizedNavigableSet(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;synchronizedSortedSet;(SortedSet);;Argument[0].Element;ReturnValue.Element;value;manual",
      Set out = null;
      SortedSet in = storeElementNavSet(source()); out = ((Collections)null).synchronizedSortedSet(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;synchronizedSet;(Set);;Argument[0].Element;ReturnValue.Element;value;manual",
      Set out = null;
      Set in = storeElementNavSet(source()); out = ((Collections)null).synchronizedSet(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;synchronizedCollection;(Collection);;Argument[0].Element;ReturnValue.Element;value;manual",
      Collection out = null;
      Collection in = storeElementList(source()); out = ((Collections)null).synchronizedCollection(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;unmodifiableNavigableMap;(NavigableMap);;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
      Map out = null;
      Object in = storeMapKey(source()); out = ((Collections)null).unmodifiableNavigableMap((NavigableMap)in); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;unmodifiableNavigableMap;(NavigableMap);;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
      Map out = null;
      Object in = storeMapValue(source()); out = ((Collections)null).unmodifiableNavigableMap((NavigableMap)in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;unmodifiableSortedMap;(SortedMap);;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
      Map out = null;
      Object in = storeMapKey(source()); out = ((Collections)null).unmodifiableSortedMap((SortedMap)in); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;unmodifiableSortedMap;(SortedMap);;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
      Map out = null;
      Object in = storeMapValue(source()); out = ((Collections)null).unmodifiableSortedMap((SortedMap)in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;unmodifiableMap;(Map);;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
      Map out = null;
      Object in = storeMapKey(source()); out = ((Collections)null).unmodifiableMap((Map)in); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;unmodifiableMap;(Map);;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
      Map out = null;
      Object in = storeMapValue(source()); out = ((Collections)null).unmodifiableMap((Map)in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;unmodifiableList;(List);;Argument[0].Element;ReturnValue.Element;value;manual",
      List out = null;
      List in = storeElementList(source()); out = ((Collections)null).unmodifiableList(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;unmodifiableNavigableSet;(NavigableSet);;Argument[0].Element;ReturnValue.Element;value;manual",
      Set out = null;
      NavigableSet in = storeElementNavSet(source()); out = ((Collections)null).unmodifiableNavigableSet(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;unmodifiableSortedSet;(SortedSet);;Argument[0].Element;ReturnValue.Element;value;manual",
      Set out = null;
      SortedSet in = storeElementNavSet(source()); out = ((Collections)null).unmodifiableSortedSet(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;unmodifiableSet;(Set);;Argument[0].Element;ReturnValue.Element;value;manual",
      Set out = null;
      Set in = storeElementNavSet(source()); out = ((Collections)null).unmodifiableSet(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;unmodifiableCollection;(Collection);;Argument[0].Element;ReturnValue.Element;value;manual",
      Collection out = null;
      Collection in = storeElementList(source()); out = ((Collections)null).unmodifiableCollection(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;max;;;Argument[0].Element;ReturnValue;value;manual",
      Object out = null;
      Collection in = storeElementList(source()); out = ((Collections)null).max(in); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;min;;;Argument[0].Element;ReturnValue;value;manual",
      Object out = null;
      Collection in = storeElementList(source()); out = ((Collections)null).min(in); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(Object[],int,int,Object);;Argument[3];Argument[0].ArrayElement;value;manual",
      Object[] out = null;
      Object in = source(); ((Arrays)null).fill(out,0,0,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(Object[],Object);;Argument[1];Argument[0].ArrayElement;value;manual",
      Object[] out = null;
      Object in = source(); ((Arrays)null).fill(out,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(float[],int,int,float);;Argument[3];Argument[0].ArrayElement;value;manual",
      float[] out = null;
      float in = (Float)source(); ((Arrays)null).fill(out,0,0,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(float[],float);;Argument[1];Argument[0].ArrayElement;value;manual",
      float[] out = null;
      float in = (Float)source(); ((Arrays)null).fill(out,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(double[],int,int,double);;Argument[3];Argument[0].ArrayElement;value;manual",
      double[] out = null;
      double in = (Double)source(); ((Arrays)null).fill(out,0,0,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(double[],double);;Argument[1];Argument[0].ArrayElement;value;manual",
      double[] out = null;
      double in = (Double)source(); ((Arrays)null).fill(out,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(boolean[],int,int,boolean);;Argument[3];Argument[0].ArrayElement;value;manual",
      boolean[] out = null;
      boolean in = (Boolean)source(); ((Arrays)null).fill(out,0,0,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(boolean[],boolean);;Argument[1];Argument[0].ArrayElement;value;manual",
      boolean[] out = null;
      boolean in = (Boolean)source(); ((Arrays)null).fill(out,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(byte[],int,int,byte);;Argument[3];Argument[0].ArrayElement;value;manual",
      byte[] out = null;
      byte in = (Byte)source(); ((Arrays)null).fill(out,0,0,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(byte[],byte);;Argument[1];Argument[0].ArrayElement;value;manual",
      byte[] out = null;
      byte in = (Byte)source(); ((Arrays)null).fill(out,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(char[],int,int,char);;Argument[3];Argument[0].ArrayElement;value;manual",
      char[] out = null;
      char in = (Character)source(); ((Arrays)null).fill(out,0,0,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(char[],char);;Argument[1];Argument[0].ArrayElement;value;manual",
      char[] out = null;
      char in = (Character)source(); ((Arrays)null).fill(out,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(short[],int,int,short);;Argument[3];Argument[0].ArrayElement;value;manual",
      short[] out = null;
      short in = (Short)source(); ((Arrays)null).fill(out,0,0,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(short[],short);;Argument[1];Argument[0].ArrayElement;value;manual",
      short[] out = null;
      short in = (Short)source(); ((Arrays)null).fill(out,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(int[],int,int,int);;Argument[3];Argument[0].ArrayElement;value;manual",
      int[] out = null;
      int in = (Integer)source(); ((Arrays)null).fill(out,0,0,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(int[],int);;Argument[1];Argument[0].ArrayElement;value;manual",
      int[] out = null;
      int in = (Integer)source(); ((Arrays)null).fill(out,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(long[],int,int,long);;Argument[3];Argument[0].ArrayElement;value;manual",
      long[] out = null;
      long in = (Long)source(); ((Arrays)null).fill(out,0,0,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(long[],long);;Argument[1];Argument[0].ArrayElement;value;manual",
      long[] out = null;
      long in = (Long)source(); ((Arrays)null).fill(out,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;replaceAll;(List,Object,Object);;Argument[2];Argument[0].Element;value;manual",
      List out = null;
      Object in = source(); ((Collections)null).replaceAll(out,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;copy;(List,List);;Argument[1].Element;Argument[0].Element;value;manual",
      List out = null;
      List in = storeElementList(source()); ((Collections)null).copy(out,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;fill;(List,Object);;Argument[1];Argument[0].Element;value;manual",
      List out = null;
      Object in = source(); ((Collections)null).fill(out,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;asList;;;Argument[0].ArrayElement;ReturnValue.Element;value;manual",
      List out = null;
      Object[] in = storeArrayElement(source()); out = ((Arrays)null).asList(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;addAll;(Collection,Object[]);;Argument[1].ArrayElement;Argument[0].Element;value;manual"
      Collection out = null;
      Object[] in = storeArrayElement(source()); ((Collections)null).addAll(out,in); sink(readElement(out)); // $ hasValueFlow
    }
    // Java 21 sequenced collections tests:
    {
      // ["java.util", "SequencedCollection", True, "addFirst", "", "", "Argument[0]", "Argument[this].Element", "value", "manual"]
      SequencedCollection out = null;
      Object in = source(); out.addFirst(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // ["java.util", "SequencedCollection", True, "addLast", "", "", "Argument[0]", "Argument[this].Element", "value", "manual"]
      SequencedCollection out = null;
      Object in = source(); out.addLast(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // ["java.util", "SequencedCollection", True, "getFirst", "", "", "Argument[0]", "Argument[this].Element", "value", "manual"]
      Object out = null;
      SequencedCollection in = storeElementList(source()); out = in.getFirst(); sink(out); // $ hasValueFlow
    }
    {
      // ["java.util", "SequencedCollection", True, "getLast", "", "", "Argument[0]", "Argument[this].Element", "value", "manual"]
      Object out = null;
      SequencedCollection in = storeElementList(source()); out = in.getLast(); sink(out); // $ hasValueFlow
    }
    {
      // ["java.util", "SequencedCollection", True, "removeFirst", "", "", "Argument[0]", "Argument[this].Element", "value", "manual"]
      Object out = null;
      SequencedCollection in = storeElementList(source()); out = in.removeFirst(); sink(out); // $ hasValueFlow
    }
    {
      // ["java.util", "SequencedCollection", True, "removeLast", "", "", "Argument[0]", "Argument[this].Element", "value", "manual"]
      Object out = null;
      SequencedCollection in = storeElementList(source()); out = in.removeLast(); sink(out); // $ hasValueFlow
    }
    {
      // ["java.util", "SequencedCollection", True, "reversed", "", "", "Argument[this].Element", "ReturnValue.Element", "value", "manual"]
      SequencedCollection out = null;
      SequencedCollection in = storeElementList(source()); out = in.reversed(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // ["java.util", "SequencedMap", True, "firstEntry", "", "", "Argument[this].MapKey", "ReturnValue.MapKey", "value", "manual"]
      Map.Entry out = null;
      SequencedMap in = (SequencedMap)storeMapKey(source()); out = in.firstEntry(); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // ["java.util", "SequencedMap", True, "lastEntry", "", "", "Argument[this].MapKey", "ReturnValue.MapKey", "value", "manual"]
      Map.Entry out = null;
      SequencedMap in = (SequencedMap)storeMapKey(source()); out = in.lastEntry(); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // - ["java.util", "SequencedMap", True, "pollFirstEntry", "", "", "Argument[this].MapKey", "ReturnValue.MapKey", "value", "manual"]
      Map.Entry out = null;
      SequencedMap in = (SequencedMap)storeMapKey(source()); out = in.pollFirstEntry(); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // ["java.util", "SequencedMap", True, "pollLastEntry", "", "", "Argument[this].MapKey", "ReturnValue.MapKey", "value", "manual"]
      Map.Entry out = null;
      SequencedMap in = (SequencedMap)storeMapKey(source()); out = in.pollLastEntry(); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // ["java.util", "SequencedMap", True, "putFirst", "", "", "Argument[this].MapValue", "ReturnValue", "value", "manual"]
      Object out = null;
      SequencedMap in = (SequencedMap)storeMapValue(source()); out = in.putFirst(null, null); sink(out); // $ hasValueFlow
    }
    {
      // ["java.util", "SequencedMap", True, "putFirst", "", "", "Argument[0]", "Argument[this].MapKey", "value", "manual"]
      SequencedMap out = null;
      Object in = source(); out.putFirst(in, null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // ["java.util", "SequencedMap", True, "putLast", "", "", "Argument[this].MapValue", "ReturnValue", "value", "manual"]
      Object out = null;
      SequencedMap in = (SequencedMap)storeMapValue(source()); out = in.putLast(null, null); sink(out); // $ hasValueFlow
    }
    {
      // ["java.util", "SequencedMap", True, "putLast", "", "", "Argument[0]", "Argument[this].MapKey", "value", "manual"]
      SequencedMap out = null;
      Object in = source(); out.putLast(in, null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // ["java.util", "SequencedMap", True, "reversed", "", "", "Argument[this].MapKey", "ReturnValue.MapKey", "value", "manual"]
      SequencedMap out = null;
      SequencedMap in = (SequencedMap)storeMapKey(source()); out = in.reversed(); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // ["java.util", "SequencedMap", True, "sequencedEntrySet", "", "", "Argument[this].MapKey", "ReturnValue.Element.MapKey", "value", "manual"]
      Set<Map.Entry> out = null;
      SequencedMap in = (SequencedMap)storeMapKey(source()); out = in.sequencedEntrySet(); sink(readMapKey(readElement(out))); // $ hasValueFlow
    }
    {
      // ["java.util", "SequencedMap", True, "firstEntry", "", "", "Argument[this].MapValue", "ReturnValue.MapValue", "value", "manual"]
      Map.Entry out = null;
      SequencedMap in = (SequencedMap)storeMapValue(source()); out = in.firstEntry(); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // ["java.util", "SequencedMap", True, "lastEntry", "", "", "Argument[this].MapValue", "ReturnValue.MapValue", "value", "manual"]
      Map.Entry out = null;
      SequencedMap in = (SequencedMap)storeMapValue(source()); out = in.lastEntry(); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // - ["java.util", "SequencedMap", True, "pollFirstEntry", "", "", "Argument[this].MapValue", "ReturnValue.MapValue", "value", "manual"]
      Map.Entry out = null;
      SequencedMap in = (SequencedMap)storeMapValue(source()); out = in.pollFirstEntry(); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // ["java.util", "SequencedMap", True, "pollLastEntry", "", "", "Argument[this].MapValue", "ReturnValue.MapValue", "value", "manual"]
      Map.Entry out = null;
      SequencedMap in = (SequencedMap)storeMapValue(source()); out = in.pollLastEntry(); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // ["java.util", "SequencedMap", True, "putFirst", "", "", "Argument[0]", "Argument[this].MapValue", "value", "manual"]
      SequencedMap out = null;
      Object in = source(); out.putFirst(null, in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // ["java.util", "SequencedMap", True, "putLast", "", "", "Argument[0]", "Argument[this].MapValue", "value", "manual"]
      SequencedMap out = null;
      Object in = source(); out.putLast(null, in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // ["java.util", "SequencedMap", True, "reversed", "", "", "Argument[this].MapValue", "ReturnValue.MapValue", "value", "manual"]
      SequencedMap out = null;
      SequencedMap in = (SequencedMap)storeMapValue(source()); out = in.reversed(); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // ["java.util", "SequencedMap", True, "sequencedEntrySet", "", "", "Argument[this].MapValue", "ReturnValue.Element.MapValue", "value", "manual"]
      Set<Map.Entry> out = null;
      SequencedMap in = (SequencedMap)storeMapValue(source()); out = in.sequencedEntrySet(); sink(readMapValue(readElement(out))); // $ hasValueFlow
    }
    {
      // ["java.util", "SequencedMap", True, "sequencedKeySet", "", "", "Argument[this].MapKey", "ReturnValue.Element", "value", "manual"]
      Set out = null;
      SequencedMap in = (SequencedMap)storeMapKey(source()); out = in.sequencedKeySet(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // ["java.util", "SequencedMap", True, "sequencedValues", "", "", "Argument[this].MapValue", "ReturnValue.Element", "value", "manual"]
      SequencedCollection out = null;
      SequencedMap in = (SequencedMap)storeMapValue(source()); out = in.sequencedValues(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // ["java.util", "SequencedSet", True, "reversed", "", "", "Argument[this].Element", "ReturnValue.Element", "value", "manual"]
      SequencedSet out = null;
      SequencedSet in = storeElementNavSet(source()); out = in.reversed(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // ["java.util", "Collections", False, "unmodifiableSequencedCollection", "", "", "Argument[0].Element", "ReturnValue.Element", "value", "manual"]
      SequencedCollection out = null;
      SequencedCollection in = storeElementList(source()); out = Collections.unmodifiableSequencedCollection(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // ["java.util", "Collections", False, "unmodifiableSequencedMap", "", "", "Argument[0].MapKey", "ReturnValue.MapKey", "value", "manual"]
      SequencedMap out = null;
      SequencedMap in = (SequencedMap)storeMapKey(source()); out = Collections.unmodifiableSequencedMap(in); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // ["java.util", "Collections", False, "unmodifiableSequencedMap", "", "", "Argument[0].MapValue", "ReturnValue.MapValue", "value", "manual"]
      SequencedMap out = null;
      SequencedMap in = (SequencedMap)storeMapValue(source()); out = Collections.unmodifiableSequencedMap(in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // ["java.util", "Collections", False, "unmodifiableSequencedSet", "", "", "Argument[0].Element", "ReturnValue.Element", "value", "manual"]
      SequencedSet out = null;
      SequencedSet in = storeElementNavSet(source()); out = Collections.unmodifiableSequencedSet(in); sink(readElement(out)); // $ hasValueFlow
    }
  }
}
