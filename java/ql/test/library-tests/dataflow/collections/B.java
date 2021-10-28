import java.util.*;
import java.util.concurrent.*;
import java.util.regex.*;
import java.util.stream.*;

public class B {
  static Object source() { return null; }

  static void sink(Object obj) { }

  static Object[] storeArrayElement(Object obj) { return new Object[] {obj}; }

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
      // "java.util;Map$Entry;true;getKey;;;MapKey of Argument[-1];ReturnValue;value",
      Object out = null;
      Object in = storeMapKeyEntry(source()); out = ((Map.Entry)in).getKey(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Map$Entry;true;getValue;;;MapValue of Argument[-1];ReturnValue;value",
      Object out = null;
      Object in = storeMapValueEntry(source()); out = ((Map.Entry)in).getValue(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Map$Entry;true;setValue;;;MapValue of Argument[-1];ReturnValue;value",
      Object out = null;
      Object in = storeMapValueEntry(source()); out = ((Map.Entry)in).setValue(null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Map$Entry;true;setValue;;;Argument[0];MapValue of Argument[-1];value",
      Map.Entry out = null;
      Object in = source(); out.setValue(in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.lang;Iterable;true;iterator;();;Element of Argument[-1];Element of ReturnValue;value",
      Iterator out = null;
      Iterable in = storeElementList(source()); out = in.iterator(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.lang;Iterable;true;spliterator;();;Element of Argument[-1];Element of ReturnValue;value",
      Spliterator out = null;
      Iterable in = storeElementList(source()); out = in.spliterator(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Iterator;true;next;;;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      Iterator in = storeElementListIterator(source()); out = in.next(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;ListIterator;true;previous;;;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      ListIterator in = storeElementListIterator(source()); out = in.previous(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;ListIterator;true;add;(Object);;Argument[0];Element of Argument[-1];value",
      ListIterator out = null;
      Object in = source(); out.add(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;ListIterator;true;set;(Object);;Argument[0];Element of Argument[-1];value",
      ListIterator out = null;
      Object in = source(); out.set(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Enumeration;true;asIterator;;;Element of Argument[-1];Element of ReturnValue;value",
      Iterator out = null;
      Enumeration in = storeElementEnumeration(source()); out = in.asIterator(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Enumeration;true;nextElement;;;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      Enumeration in = storeElementEnumeration(source()); out = in.nextElement(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;computeIfAbsent;;;MapValue of Argument[-1];ReturnValue;value",
      Object out = null;
      Object in = storeMapValue(source()); out = ((Map)in).computeIfAbsent(null,null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;computeIfAbsent;;;ReturnValue of Argument[1];ReturnValue;value",
      Object out = ((Map)null).computeIfAbsent(null,k -> source()); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;computeIfAbsent;;;ReturnValue of Argument[1];MapValue of Argument[-1];value",
      Map out = null;
      out.computeIfAbsent(null,k -> source()); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;entrySet;;;MapValue of Argument[-1];MapValue of Element of ReturnValue;value",
      Set<Map.Entry> out = null;
      Object in = storeMapValue(source()); out = ((Map)in).entrySet(); sink(readMapValue(readElement(out))); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;entrySet;;;MapKey of Argument[-1];MapKey of Element of ReturnValue;value",
      Set<Map.Entry> out = null;
      Object in = storeMapKey(source()); out = ((Map)in).entrySet(); sink(readMapKey(readElement(out))); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;get;;;MapValue of Argument[-1];ReturnValue;value",
      Object out = null;
      Object in = storeMapValue(source()); out = ((Map)in).get(null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;getOrDefault;;;MapValue of Argument[-1];ReturnValue;value",
      Object out = null;
      Object in = storeMapValue(source()); out = ((Map)in).getOrDefault(null,null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;getOrDefault;;;Argument[1];ReturnValue;value",
      Object out = null;
      Object in = source(); out = ((Map)null).getOrDefault(null,in); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;put;;;MapValue of Argument[-1];ReturnValue;value",
      Object out = null;
      Object in = storeMapValue(source()); out = ((Map)in).put(null,null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;put;;;Argument[0];MapKey of Argument[-1];value",
      Map out = null;
      Object in = source(); out.put(in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;put;;;Argument[1];MapValue of Argument[-1];value",
      Map out = null;
      Object in = source(); out.put(null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;putIfAbsent;;;MapValue of Argument[-1];ReturnValue;value",
      Object out = null;
      Object in = storeMapValue(source()); out = ((Map)in).putIfAbsent(null,null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;putIfAbsent;;;Argument[0];MapKey of Argument[-1];value",
      Map out = null;
      Object in = source(); out.putIfAbsent(in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;putIfAbsent;;;Argument[1];MapValue of Argument[-1];value",
      Map out = null;
      Object in = source(); out.putIfAbsent(null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;remove;(Object);;MapValue of Argument[-1];ReturnValue;value",
      Object out = null;
      Object in = storeMapValue(source()); out = ((Map)in).remove(null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;replace;(Object,Object);;MapValue of Argument[-1];ReturnValue;value",
      Object out = null;
      Object in = storeMapValue(source()); out = ((Map)in).replace(null,null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;replace;(Object,Object);;Argument[0];MapKey of Argument[-1];value",
      Map out = null;
      Object in = source(); out.replace(in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;replace;(Object,Object);;Argument[1];MapValue of Argument[-1];value",
      Map out = null;
      Object in = source(); out.replace(null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;replace;(Object,Object,Object);;Argument[0];MapKey of Argument[-1];value",
      Map out = null;
      Object in = source(); out.replace(in,null,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;replace;(Object,Object,Object);;Argument[2];MapValue of Argument[-1];value",
      Map out = null;
      Object in = source(); out.replace(null,null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;keySet;();;MapKey of Argument[-1];Element of ReturnValue;value",
      Set out = null;
      Object in = storeMapKey(source()); out = ((Map)in).keySet(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;values;();;MapValue of Argument[-1];Element of ReturnValue;value",
      Iterable out = null;
      Object in = storeMapValue(source()); out = ((Map)in).values(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;merge;(Object,Object,BiFunction);;Argument[1];MapValue of Argument[-1];value",
      Map out = null;
      Object in = source(); out.merge(null,in,null); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;putAll;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value",
      Map out = null;
      Object in = storeMapKey(source()); out.putAll((Map)in); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;true;putAll;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value",
      Map out = null;
      Object in = storeMapValue(source()); out.putAll((Map)in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collection;true;parallelStream;();;Element of Argument[-1];Element of ReturnValue;value",
      Stream out = null;
      Collection in = storeElementList(source()); out = in.parallelStream(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collection;true;stream;();;Element of Argument[-1];Element of ReturnValue;value",
      Stream out = null;
      Collection in = storeElementList(source()); out = in.stream(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collection;true;toArray;;;Element of Argument[-1];ArrayElement of ReturnValue;value",
      Object[] out = null;
      Collection in = storeElementList(source()); out = in.toArray(); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collection;true;toArray;;;Element of Argument[-1];ArrayElement of Argument[0];value",
      Object[] out = null;
      Collection in = storeElementList(source()); in.toArray(out); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collection;true;add;;;Argument[0];Element of Argument[-1];value",
      Collection out = null;
      Object in = source(); out.add(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collection;true;addAll;;;Element of Argument[0];Element of Argument[-1];value",
      Collection out = null;
      Collection in = storeElementList(source()); out.addAll(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;true;get;(int);;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      List in = storeElementList(source()); out = in.get(0); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;List;true;listIterator;;;Element of Argument[-1];Element of ReturnValue;value",
      ListIterator out = null;
      List in = storeElementList(source()); out = in.listIterator(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;true;remove;(int);;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      List in = storeElementList(source()); out = in.remove(0); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;List;true;set;(int,Object);;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      List in = storeElementList(source()); out = in.set(0,null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;List;true;set;(int,Object);;Argument[1];Element of Argument[-1];value",
      List out = null;
      Object in = source(); out.set(0,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;true;subList;;;Element of Argument[-1];Element of ReturnValue;value",
      List out = null;
      List in = storeElementList(source()); out = in.subList(0,0); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;true;add;(int,Object);;Argument[1];Element of Argument[-1];value",
      List out = null;
      Object in = source(); out.add(0,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;true;addAll;(int,Collection);;Element of Argument[1];Element of Argument[-1];value",
      List out = null;
      Collection in = storeElementList(source()); out.addAll(0,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Vector;true;elementAt;(int);;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      Vector in = storeElementStack(source()); out = in.elementAt(0); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Vector;true;elements;();;Element of Argument[-1];Element of ReturnValue;value",
      Enumeration out = null;
      Vector in = storeElementStack(source()); out = in.elements(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Vector;true;firstElement;();;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      Vector in = storeElementStack(source()); out = in.firstElement(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Vector;true;lastElement;();;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      Vector in = storeElementStack(source()); out = in.lastElement(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Vector;true;addElement;(Object);;Argument[0];Element of Argument[-1];value",
      Vector out = null;
      Object in = source(); out.addElement(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Vector;true;insertElementAt;(Object,int);;Argument[0];Element of Argument[-1];value",
      Vector out = null;
      Object in = source(); out.insertElementAt(in,0); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Vector;true;setElementAt;(Object,int);;Argument[0];Element of Argument[-1];value",
      Vector out = null;
      Object in = source(); out.setElementAt(in,0); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Vector;true;copyInto;(Object[]);;Element of Argument[-1];ArrayElement of Argument[0];value",
      Object[] out = null;
      Vector in = storeElementStack(source()); in.copyInto(out); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Stack;true;peek;();;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      Stack in = storeElementStack(source()); out = in.peek(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Stack;true;pop;();;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      Stack in = storeElementStack(source()); out = in.pop(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Stack;true;push;(Object);;Argument[0];Element of Argument[-1];value",
      Stack out = null;
      Object in = source(); out.push(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Queue;true;element;();;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      Queue in = storeElementBlockingDeque(source()); out = in.element(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Queue;true;peek;();;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      Queue in = storeElementBlockingDeque(source()); out = in.peek(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Queue;true;poll;();;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      Queue in = storeElementBlockingDeque(source()); out = in.poll(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Queue;true;remove;();;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      Queue in = storeElementBlockingDeque(source()); out = in.remove(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Queue;true;offer;(Object);;Argument[0];Element of Argument[-1];value",
      Queue out = null;
      Object in = source(); out.offer(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Deque;true;descendingIterator;();;Element of Argument[-1];Element of ReturnValue;value",
      Iterator out = null;
      Deque in = storeElementBlockingDeque(source()); out = in.descendingIterator(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Deque;true;getFirst;();;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      Deque in = storeElementBlockingDeque(source()); out = in.getFirst(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Deque;true;getLast;();;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      Deque in = storeElementBlockingDeque(source()); out = in.getLast(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Deque;true;peekFirst;();;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      Deque in = storeElementBlockingDeque(source()); out = in.peekFirst(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Deque;true;peekLast;();;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      Deque in = storeElementBlockingDeque(source()); out = in.peekLast(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Deque;true;pollFirst;();;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      Deque in = storeElementBlockingDeque(source()); out = in.pollFirst(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Deque;true;pollLast;();;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      Deque in = storeElementBlockingDeque(source()); out = in.pollLast(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Deque;true;pop;();;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      Deque in = storeElementBlockingDeque(source()); out = in.pop(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Deque;true;removeFirst;();;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      Deque in = storeElementBlockingDeque(source()); out = in.removeFirst(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Deque;true;removeLast;();;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      Deque in = storeElementBlockingDeque(source()); out = in.removeLast(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Deque;true;push;(Object);;Argument[0];Element of Argument[-1];value",
      Deque out = null;
      Object in = source(); out.push(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Deque;true;offerLast;(Object);;Argument[0];Element of Argument[-1];value",
      Deque out = null;
      Object in = source(); out.offerLast(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Deque;true;offerFirst;(Object);;Argument[0];Element of Argument[-1];value",
      Deque out = null;
      Object in = source(); out.offerFirst(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Deque;true;addLast;(Object);;Argument[0];Element of Argument[-1];value",
      Deque out = null;
      Object in = source(); out.addLast(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Deque;true;addFirst;(Object);;Argument[0];Element of Argument[-1];value",
      Deque out = null;
      Object in = source(); out.addFirst(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;BlockingDeque;true;pollFirst;(long,TimeUnit);;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      BlockingDeque in = storeElementBlockingDeque(source()); out = in.pollFirst(0,null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;BlockingDeque;true;pollLast;(long,TimeUnit);;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      BlockingDeque in = storeElementBlockingDeque(source()); out = in.pollLast(0,null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;BlockingDeque;true;takeFirst;();;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      BlockingDeque in = storeElementBlockingDeque(source()); out = in.takeFirst(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;BlockingDeque;true;takeLast;();;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      BlockingDeque in = storeElementBlockingDeque(source()); out = in.takeLast(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;BlockingQueue;true;poll;(long,TimeUnit);;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      BlockingQueue in = storeElementBlockingDeque(source()); out = in.poll(0,null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;BlockingQueue;true;take;();;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      BlockingQueue in = storeElementBlockingDeque(source()); out = in.take(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;BlockingQueue;true;offer;(Object,long,TimeUnit);;Argument[0];Element of Argument[-1];value",
      BlockingQueue out = null;
      Object in = source(); out.offer(in,0,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;BlockingQueue;true;put;(Object);;Argument[0];Element of Argument[-1];value",
      BlockingQueue out = null;
      Object in = source(); out.put(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;BlockingDeque;true;offerLast;(Object,long,TimeUnit);;Argument[0];Element of Argument[-1];value",
      BlockingDeque out = null;
      Object in = source(); out.offerLast(in,0,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;BlockingDeque;true;offerFirst;(Object,long,TimeUnit);;Argument[0];Element of Argument[-1];value",
      BlockingDeque out = null;
      Object in = source(); out.offerFirst(in,0,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;BlockingDeque;true;putLast;(Object);;Argument[0];Element of Argument[-1];value",
      BlockingDeque out = null;
      Object in = source(); out.putLast(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;BlockingDeque;true;putFirst;(Object);;Argument[0];Element of Argument[-1];value",
      BlockingDeque out = null;
      Object in = source(); out.putFirst(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;BlockingQueue;true;drainTo;(Collection,int);;Element of Argument[-1];Element of Argument[0];value",
      Collection out = null;
      BlockingQueue in = storeElementBlockingDeque(source()); in.drainTo(out,0); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;BlockingQueue;true;drainTo;(Collection);;Element of Argument[-1];Element of Argument[0];value",
      Collection out = null;
      BlockingQueue in = storeElementBlockingDeque(source()); in.drainTo(out); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;ConcurrentHashMap;true;elements;();;MapValue of Argument[-1];Element of ReturnValue;value",
      Enumeration out = null;
      Object in = storeMapValue(source()); out = ((ConcurrentHashMap)in).elements(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Dictionary;true;elements;();;MapValue of Argument[-1];Element of ReturnValue;value",
      Enumeration out = null;
      Object in = storeMapValue(source()); out = ((Dictionary)in).elements(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Dictionary;true;get;(Object);;MapValue of Argument[-1];ReturnValue;value",
      Object out = null;
      Object in = storeMapValue(source()); out = ((Dictionary)in).get(null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Dictionary;true;put;(Object,Object);;MapValue of Argument[-1];ReturnValue;value",
      Object out = null;
      Object in = storeMapValue(source()); out = ((Dictionary)in).put(null,null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Dictionary;true;put;(Object,Object);;Argument[0];MapKey of Argument[-1];value",
      Dictionary out = null;
      Object in = source(); out.put(in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Dictionary;true;put;(Object,Object);;Argument[1];MapValue of Argument[-1];value",
      Dictionary out = null;
      Object in = source(); out.put(null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Dictionary;true;remove;(Object);;MapValue of Argument[-1];ReturnValue;value",
      Object out = null;
      Object in = storeMapValue(source()); out = ((Dictionary)in).remove(null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;ceilingEntry;(Object);;MapKey of Argument[-1];MapKey of ReturnValue;value",
      Map.Entry out = null;
      Object in = storeMapKey(source()); out = ((NavigableMap)in).ceilingEntry(null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;ceilingEntry;(Object);;MapValue of Argument[-1];MapValue of ReturnValue;value",
      Map.Entry out = null;
      Object in = storeMapValue(source()); out = ((NavigableMap)in).ceilingEntry(null); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;descendingMap;();;MapKey of Argument[-1];MapKey of ReturnValue;value",
      Map out = null;
      Object in = storeMapKey(source()); out = ((NavigableMap)in).descendingMap(); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;descendingMap;();;MapValue of Argument[-1];MapValue of ReturnValue;value",
      Map out = null;
      Object in = storeMapValue(source()); out = ((NavigableMap)in).descendingMap(); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;firstEntry;();;MapKey of Argument[-1];MapKey of ReturnValue;value",
      Map.Entry out = null;
      Object in = storeMapKey(source()); out = ((NavigableMap)in).firstEntry(); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;firstEntry;();;MapValue of Argument[-1];MapValue of ReturnValue;value",
      Map.Entry out = null;
      Object in = storeMapValue(source()); out = ((NavigableMap)in).firstEntry(); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;floorEntry;(Object);;MapKey of Argument[-1];MapKey of ReturnValue;value",
      Map.Entry out = null;
      Object in = storeMapKey(source()); out = ((NavigableMap)in).floorEntry(null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;floorEntry;(Object);;MapValue of Argument[-1];MapValue of ReturnValue;value",
      Map.Entry out = null;
      Object in = storeMapValue(source()); out = ((NavigableMap)in).floorEntry(null); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;headMap;(Object,boolean);;MapKey of Argument[-1];MapKey of ReturnValue;value",
      Map out = null;
      Object in = storeMapKey(source()); out = ((NavigableMap)in).headMap(null,true); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;headMap;(Object,boolean);;MapValue of Argument[-1];MapValue of ReturnValue;value",
      Map out = null;
      Object in = storeMapValue(source()); out = ((NavigableMap)in).headMap(null,true); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;higherEntry;(Object);;MapKey of Argument[-1];MapKey of ReturnValue;value",
      Map.Entry out = null;
      Object in = storeMapKey(source()); out = ((NavigableMap)in).higherEntry(null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;higherEntry;(Object);;MapValue of Argument[-1];MapValue of ReturnValue;value",
      Map.Entry out = null;
      Object in = storeMapValue(source()); out = ((NavigableMap)in).higherEntry(null); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;lastEntry;();;MapKey of Argument[-1];MapKey of ReturnValue;value",
      Map.Entry out = null;
      Object in = storeMapKey(source()); out = ((NavigableMap)in).lastEntry(); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;lastEntry;();;MapValue of Argument[-1];MapValue of ReturnValue;value",
      Map.Entry out = null;
      Object in = storeMapValue(source()); out = ((NavigableMap)in).lastEntry(); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;lowerEntry;(Object);;MapKey of Argument[-1];MapKey of ReturnValue;value",
      Map.Entry out = null;
      Object in = storeMapKey(source()); out = ((NavigableMap)in).lowerEntry(null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;lowerEntry;(Object);;MapValue of Argument[-1];MapValue of ReturnValue;value",
      Map.Entry out = null;
      Object in = storeMapValue(source()); out = ((NavigableMap)in).lowerEntry(null); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;pollFirstEntry;();;MapKey of Argument[-1];MapKey of ReturnValue;value",
      Map.Entry out = null;
      Object in = storeMapKey(source()); out = ((NavigableMap)in).pollFirstEntry(); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;pollFirstEntry;();;MapValue of Argument[-1];MapValue of ReturnValue;value",
      Map.Entry out = null;
      Object in = storeMapValue(source()); out = ((NavigableMap)in).pollFirstEntry(); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;pollLastEntry;();;MapKey of Argument[-1];MapKey of ReturnValue;value",
      Map.Entry out = null;
      Object in = storeMapKey(source()); out = ((NavigableMap)in).pollLastEntry(); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;pollLastEntry;();;MapValue of Argument[-1];MapValue of ReturnValue;value",
      Map.Entry out = null;
      Object in = storeMapValue(source()); out = ((NavigableMap)in).pollLastEntry(); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;subMap;(Object,boolean,Object,boolean);;MapKey of Argument[-1];MapKey of ReturnValue;value",
      Map out = null;
      Object in = storeMapKey(source()); out = ((NavigableMap)in).subMap(null,true,null,true); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;subMap;(Object,boolean,Object,boolean);;MapValue of Argument[-1];MapValue of ReturnValue;value",
      Map out = null;
      Object in = storeMapValue(source()); out = ((NavigableMap)in).subMap(null,true,null,true); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;tailMap;(Object,boolean);;MapKey of Argument[-1];MapKey of ReturnValue;value",
      Map out = null;
      Object in = storeMapKey(source()); out = ((NavigableMap)in).tailMap(null,true); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableMap;true;tailMap;(Object,boolean);;MapValue of Argument[-1];MapValue of ReturnValue;value",
      Map out = null;
      Object in = storeMapValue(source()); out = ((NavigableMap)in).tailMap(null,true); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableSet;true;ceiling;(Object);;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      NavigableSet in = storeElementNavSet(source()); out = in.ceiling(null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;NavigableSet;true;descendingIterator;();;Element of Argument[-1];Element of ReturnValue;value",
      Iterator out = null;
      NavigableSet in = storeElementNavSet(source()); out = in.descendingIterator(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableSet;true;descendingSet;();;Element of Argument[-1];Element of ReturnValue;value",
      Set out = null;
      NavigableSet in = storeElementNavSet(source()); out = in.descendingSet(); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableSet;true;floor;(Object);;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      NavigableSet in = storeElementNavSet(source()); out = in.floor(null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;NavigableSet;true;headSet;(Object,boolean);;Element of Argument[-1];Element of ReturnValue;value",
      Set out = null;
      NavigableSet in = storeElementNavSet(source()); out = in.headSet(null,true); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableSet;true;higher;(Object);;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      NavigableSet in = storeElementNavSet(source()); out = in.higher(null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;NavigableSet;true;lower;(Object);;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      NavigableSet in = storeElementNavSet(source()); out = in.lower(null); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;NavigableSet;true;pollFirst;();;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      NavigableSet in = storeElementNavSet(source()); out = in.pollFirst(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;NavigableSet;true;pollLast;();;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      NavigableSet in = storeElementNavSet(source()); out = in.pollLast(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;NavigableSet;true;subSet;(Object,boolean,Object,boolean);;Element of Argument[-1];Element of ReturnValue;value",
      Set out = null;
      NavigableSet in = storeElementNavSet(source()); out = in.subSet(null,true,null,true); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;NavigableSet;true;tailSet;(Object,boolean);;Element of Argument[-1];Element of ReturnValue;value",
      Set out = null;
      NavigableSet in = storeElementNavSet(source()); out = in.tailSet(null,true); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;SortedMap;true;headMap;(Object);;MapKey of Argument[-1];MapKey of ReturnValue;value",
      Map out = null;
      Object in = storeMapKey(source()); out = ((SortedMap)in).headMap(null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;SortedMap;true;headMap;(Object);;MapValue of Argument[-1];MapValue of ReturnValue;value",
      Map out = null;
      Object in = storeMapValue(source()); out = ((SortedMap)in).headMap(null); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;SortedMap;true;subMap;(Object,Object);;MapKey of Argument[-1];MapKey of ReturnValue;value",
      Map out = null;
      Object in = storeMapKey(source()); out = ((SortedMap)in).subMap(null,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;SortedMap;true;subMap;(Object,Object);;MapValue of Argument[-1];MapValue of ReturnValue;value",
      Map out = null;
      Object in = storeMapValue(source()); out = ((SortedMap)in).subMap(null,null); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;SortedMap;true;tailMap;(Object);;MapKey of Argument[-1];MapKey of ReturnValue;value",
      Map out = null;
      Object in = storeMapKey(source()); out = ((SortedMap)in).tailMap(null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;SortedMap;true;tailMap;(Object);;MapValue of Argument[-1];MapValue of ReturnValue;value",
      Map out = null;
      Object in = storeMapValue(source()); out = ((SortedMap)in).tailMap(null); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;SortedSet;true;first;();;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      SortedSet in = storeElementNavSet(source()); out = in.first(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;SortedSet;true;headSet;(Object);;Element of Argument[-1];Element of ReturnValue;value",
      Set out = null;
      SortedSet in = storeElementNavSet(source()); out = in.headSet(null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;SortedSet;true;last;();;Element of Argument[-1];ReturnValue;value",
      Object out = null;
      SortedSet in = storeElementNavSet(source()); out = in.last(); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;SortedSet;true;subSet;(Object,Object);;Element of Argument[-1];Element of ReturnValue;value",
      Set out = null;
      SortedSet in = storeElementNavSet(source()); out = in.subSet(null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;SortedSet;true;tailSet;(Object);;Element of Argument[-1];Element of ReturnValue;value",
      Set out = null;
      SortedSet in = storeElementNavSet(source()); out = in.tailSet(null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;TransferQueue;true;tryTransfer;(Object,long,TimeUnit);;Argument[0];Element of Argument[-1];value",
      TransferQueue out = null;
      Object in = source(); out.tryTransfer(in,0,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;TransferQueue;true;transfer;(Object);;Argument[0];Element of Argument[-1];value",
      TransferQueue out = null;
      Object in = source(); out.transfer(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util.concurrent;TransferQueue;true;tryTransfer;(Object);;Argument[0];Element of Argument[-1];value",
      TransferQueue out = null;
      Object in = source(); out.tryTransfer(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;copyOf;(Collection);;Element of Argument[0];Element of ReturnValue;value",
      List out = null;
      Collection in = storeElementList(source()); out = List.copyOf(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object[]);;ArrayElement of Argument[0];Element of ReturnValue;value",
      List out = null;
      Object[] in = storeArrayElement(source()); out = List.of(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object);;Argument[0];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object);;Argument[0];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object);;Argument[1];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object);;Argument[0];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object);;Argument[1];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object);;Argument[2];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object);;Argument[0];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(in,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object);;Argument[1];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object);;Argument[2];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object);;Argument[3];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object);;Argument[0];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(in,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object);;Argument[1];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,in,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object);;Argument[2];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object);;Argument[3];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object);;Argument[4];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object);;Argument[0];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(in,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object);;Argument[1];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,in,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object);;Argument[2];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,in,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object);;Argument[3];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,null,in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object);;Argument[4];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object);;Argument[5];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object);;Argument[0];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(in,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object);;Argument[1];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,in,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object);;Argument[2];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,in,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object);;Argument[3];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,null,in,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object);;Argument[4];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object);;Argument[5];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object);;Argument[6];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[0];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(in,null,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,in,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[2];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,in,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[3];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,null,in,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[4];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,in,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[5];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,null,in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[6];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,null,null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[7];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,null,null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[0];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(in,null,null,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,in,null,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[2];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,in,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[3];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,null,in,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[4];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,in,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[5];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,null,in,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[6];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,null,null,in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[7];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,null,null,null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[8];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,null,null,null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[0];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(in,null,null,null,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,in,null,null,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[2];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,in,null,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[3];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,null,in,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[4];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,in,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[5];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,null,in,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[6];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,null,null,in,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[7];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,null,null,null,in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[8];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,null,null,null,null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;List;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[9];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = List.of(null,null,null,null,null,null,null,null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;copyOf;(Map);;MapKey of Argument[0];MapKey of ReturnValue;value",
      Map out = null;
      Object in = storeMapKey(source()); out = Map.copyOf((Map)in); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;copyOf;(Map);;MapValue of Argument[0];MapValue of ReturnValue;value",
      Map out = null;
      Object in = storeMapValue(source()); out = Map.copyOf((Map)in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;entry;(Object,Object);;Argument[0];MapKey of ReturnValue;value",
      Map.Entry out = null;
      Object in = source(); out = Map.entry(in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;entry;(Object,Object);;Argument[1];MapValue of ReturnValue;value",
      Map.Entry out = null;
      Object in = source(); out = Map.entry(null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[0];MapKey of ReturnValue;value",
      Map out = null;
      Object in = source(); out = Map.of(in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[1];MapValue of ReturnValue;value",
      Map out = null;
      Object in = source(); out = Map.of(null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[2];MapKey of ReturnValue;value",
      Map out = null;
      Object in = source(); out = Map.of(null,null,in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[3];MapValue of ReturnValue;value",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[4];MapKey of ReturnValue;value",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[5];MapValue of ReturnValue;value",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[6];MapKey of ReturnValue;value",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,null,null,in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[7];MapValue of ReturnValue;value",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,null,null,null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[8];MapKey of ReturnValue;value",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,null,null,null,null,in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[9];MapValue of ReturnValue;value",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,null,null,null,null,null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[10];MapKey of ReturnValue;value",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,null,null,null,null,null,null,in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[11];MapValue of ReturnValue;value",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,null,null,null,null,null,null,null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[12];MapKey of ReturnValue;value",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,null,null,null,null,null,null,null,null,in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[13];MapValue of ReturnValue;value",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,null,null,null,null,null,null,null,null,null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[14];MapKey of ReturnValue;value",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,null,null,null,null,null,null,null,null,null,null,in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[15];MapValue of ReturnValue;value",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[16];MapKey of ReturnValue;value",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[17];MapValue of ReturnValue;value",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[18];MapKey of ReturnValue;value",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;of;;;Argument[19];MapValue of ReturnValue;value",
      Map out = null;
      Object in = source(); out = Map.of(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;ofEntries;;;MapKey of ArrayElement of Argument[0];MapKey of ReturnValue;value",
      Map out = null;
      Object[] in = storeArrayElement(storeMapKey(source())); out = Map.ofEntries((Map.Entry[])in); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Map;false;ofEntries;;;MapValue of ArrayElement of Argument[0];MapValue of ReturnValue;value",
      Map out = null;
      Object[] in = storeArrayElement(storeMapValue(source())); out = Map.ofEntries((Map.Entry[])in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;copyOf;(Collection);;Element of Argument[0];Element of ReturnValue;value",
      Set out = null;
      Collection in = storeElementList(source()); out = Set.copyOf(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object[]);;ArrayElement of Argument[0];Element of ReturnValue;value",
      Set out = null;
      Object[] in = storeArrayElement(source()); out = Set.of(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object);;Argument[0];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object);;Argument[0];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object);;Argument[1];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object);;Argument[0];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object);;Argument[1];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object);;Argument[2];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object);;Argument[0];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(in,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object);;Argument[1];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object);;Argument[2];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object);;Argument[3];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object);;Argument[0];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(in,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object);;Argument[1];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,in,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object);;Argument[2];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object);;Argument[3];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object);;Argument[4];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object);;Argument[0];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(in,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object);;Argument[1];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,in,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object);;Argument[2];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,in,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object);;Argument[3];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object);;Argument[4];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object);;Argument[5];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object);;Argument[0];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(in,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object);;Argument[1];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,in,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object);;Argument[2];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,in,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object);;Argument[3];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,in,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object);;Argument[4];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object);;Argument[5];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object);;Argument[6];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[0];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(in,null,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,in,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[2];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,in,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[3];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,in,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[4];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,in,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[5];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,null,in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[6];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,null,null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object);;Argument[7];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,null,null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[0];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(in,null,null,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,in,null,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[2];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,in,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[3];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,in,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[4];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,in,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[5];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,null,in,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[6];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,null,null,in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[7];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,null,null,null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[8];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,null,null,null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[0];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(in,null,null,null,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,in,null,null,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[2];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,in,null,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[3];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,in,null,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[4];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,in,null,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[5];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,null,in,null,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[6];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,null,null,in,null,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[7];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,null,null,null,in,null,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[8];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,null,null,null,null,in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Set;false;of;(Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[9];Element of ReturnValue;value",
      Set out = null;
      Object in = source(); out = Set.of(null,null,null,null,null,null,null,null,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;stream;;;ArrayElement of Argument[0];Element of ReturnValue;value",
      Stream out = null;
      Object[] in = storeArrayElement(source()); out = ((Arrays)null).stream(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;spliterator;;;ArrayElement of Argument[0];Element of ReturnValue;value",
      Spliterator out = null;
      Object[] in = storeArrayElement(source()); out = ((Arrays)null).spliterator(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;copyOfRange;;;ArrayElement of Argument[0];ArrayElement of ReturnValue;value",
      Object[] out = null;
      Object[] in = storeArrayElement(source()); out = ((Arrays)null).copyOfRange(in,0,0); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;copyOf;;;ArrayElement of Argument[0];ArrayElement of ReturnValue;value",
      Object[] out = null;
      Object[] in = storeArrayElement(source()); out = ((Arrays)null).copyOf(in,0); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;list;(Enumeration);;Element of Argument[0];Element of ReturnValue;value",
      List out = null;
      Enumeration in = storeElementEnumeration(source()); out = ((Collections)null).list(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;enumeration;(Collection);;Element of Argument[0];Element of ReturnValue;value",
      Enumeration out = null;
      Collection in = storeElementList(source()); out = ((Collections)null).enumeration(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;nCopies;(int,Object);;Argument[1];Element of ReturnValue;value",
      Collection out = null;
      Object in = source(); out = ((Collections)null).nCopies(0,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;singletonMap;(Object,Object);;Argument[0];MapKey of ReturnValue;value",
      Map out = null;
      Object in = source(); out = ((Collections)null).singletonMap(in,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;singletonMap;(Object,Object);;Argument[1];MapValue of ReturnValue;value",
      Map out = null;
      Object in = source(); out = ((Collections)null).singletonMap(null,in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;singletonList;(Object);;Argument[0];Element of ReturnValue;value",
      List out = null;
      Object in = source(); out = ((Collections)null).singletonList(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;singleton;(Object);;Argument[0];Element of ReturnValue;value",
      Collection out = null;
      Object in = source(); out = ((Collections)null).singleton(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;checkedNavigableMap;(NavigableMap,Class,Class);;MapKey of Argument[0];MapKey of ReturnValue;value",
      Map out = null;
      Object in = storeMapKey(source()); out = ((Collections)null).checkedNavigableMap((NavigableMap)in,null,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;checkedNavigableMap;(NavigableMap,Class,Class);;MapValue of Argument[0];MapValue of ReturnValue;value",
      Map out = null;
      Object in = storeMapValue(source()); out = ((Collections)null).checkedNavigableMap((NavigableMap)in,null,null); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;checkedSortedMap;(SortedMap,Class,Class);;MapKey of Argument[0];MapKey of ReturnValue;value",
      Map out = null;
      Object in = storeMapKey(source()); out = ((Collections)null).checkedSortedMap((SortedMap)in,null,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;checkedSortedMap;(SortedMap,Class,Class);;MapValue of Argument[0];MapValue of ReturnValue;value",
      Map out = null;
      Object in = storeMapValue(source()); out = ((Collections)null).checkedSortedMap((SortedMap)in,null,null); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;checkedMap;(Map,Class,Class);;MapKey of Argument[0];MapKey of ReturnValue;value",
      Map out = null;
      Object in = storeMapKey(source()); out = ((Collections)null).checkedMap((Map)in,null,null); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;checkedMap;(Map,Class,Class);;MapValue of Argument[0];MapValue of ReturnValue;value",
      Map out = null;
      Object in = storeMapValue(source()); out = ((Collections)null).checkedMap((Map)in,null,null); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;checkedList;(List,Class);;Element of Argument[0];Element of ReturnValue;value",
      List out = null;
      List in = storeElementList(source()); out = ((Collections)null).checkedList(in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;checkedNavigableSet;(NavigableSet,Class);;Element of Argument[0];Element of ReturnValue;value",
      Set out = null;
      NavigableSet in = storeElementNavSet(source()); out = ((Collections)null).checkedNavigableSet(in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;checkedSortedSet;(SortedSet,Class);;Element of Argument[0];Element of ReturnValue;value",
      Set out = null;
      SortedSet in = storeElementNavSet(source()); out = ((Collections)null).checkedSortedSet(in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;checkedSet;(Set,Class);;Element of Argument[0];Element of ReturnValue;value",
      Set out = null;
      Set in = storeElementNavSet(source()); out = ((Collections)null).checkedSet(in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;checkedCollection;(Collection,Class);;Element of Argument[0];Element of ReturnValue;value",
      Collection out = null;
      Collection in = storeElementList(source()); out = ((Collections)null).checkedCollection(in,null); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;synchronizedNavigableMap;(NavigableMap);;MapKey of Argument[0];MapKey of ReturnValue;value",
      Map out = null;
      Object in = storeMapKey(source()); out = ((Collections)null).synchronizedNavigableMap((NavigableMap)in); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;synchronizedNavigableMap;(NavigableMap);;MapValue of Argument[0];MapValue of ReturnValue;value",
      Map out = null;
      Object in = storeMapValue(source()); out = ((Collections)null).synchronizedNavigableMap((NavigableMap)in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;synchronizedSortedMap;(SortedMap);;MapKey of Argument[0];MapKey of ReturnValue;value",
      Map out = null;
      Object in = storeMapKey(source()); out = ((Collections)null).synchronizedSortedMap((SortedMap)in); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;synchronizedSortedMap;(SortedMap);;MapValue of Argument[0];MapValue of ReturnValue;value",
      Map out = null;
      Object in = storeMapValue(source()); out = ((Collections)null).synchronizedSortedMap((SortedMap)in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;synchronizedMap;(Map);;MapKey of Argument[0];MapKey of ReturnValue;value",
      Map out = null;
      Object in = storeMapKey(source()); out = ((Collections)null).synchronizedMap((Map)in); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;synchronizedMap;(Map);;MapValue of Argument[0];MapValue of ReturnValue;value",
      Map out = null;
      Object in = storeMapValue(source()); out = ((Collections)null).synchronizedMap((Map)in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;synchronizedList;(List);;Element of Argument[0];Element of ReturnValue;value",
      List out = null;
      List in = storeElementList(source()); out = ((Collections)null).synchronizedList(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;synchronizedNavigableSet;(NavigableSet);;Element of Argument[0];Element of ReturnValue;value",
      Set out = null;
      NavigableSet in = storeElementNavSet(source()); out = ((Collections)null).synchronizedNavigableSet(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;synchronizedSortedSet;(SortedSet);;Element of Argument[0];Element of ReturnValue;value",
      Set out = null;
      SortedSet in = storeElementNavSet(source()); out = ((Collections)null).synchronizedSortedSet(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;synchronizedSet;(Set);;Element of Argument[0];Element of ReturnValue;value",
      Set out = null;
      Set in = storeElementNavSet(source()); out = ((Collections)null).synchronizedSet(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;synchronizedCollection;(Collection);;Element of Argument[0];Element of ReturnValue;value",
      Collection out = null;
      Collection in = storeElementList(source()); out = ((Collections)null).synchronizedCollection(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;unmodifiableNavigableMap;(NavigableMap);;MapKey of Argument[0];MapKey of ReturnValue;value",
      Map out = null;
      Object in = storeMapKey(source()); out = ((Collections)null).unmodifiableNavigableMap((NavigableMap)in); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;unmodifiableNavigableMap;(NavigableMap);;MapValue of Argument[0];MapValue of ReturnValue;value",
      Map out = null;
      Object in = storeMapValue(source()); out = ((Collections)null).unmodifiableNavigableMap((NavigableMap)in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;unmodifiableSortedMap;(SortedMap);;MapKey of Argument[0];MapKey of ReturnValue;value",
      Map out = null;
      Object in = storeMapKey(source()); out = ((Collections)null).unmodifiableSortedMap((SortedMap)in); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;unmodifiableSortedMap;(SortedMap);;MapValue of Argument[0];MapValue of ReturnValue;value",
      Map out = null;
      Object in = storeMapValue(source()); out = ((Collections)null).unmodifiableSortedMap((SortedMap)in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;unmodifiableMap;(Map);;MapKey of Argument[0];MapKey of ReturnValue;value",
      Map out = null;
      Object in = storeMapKey(source()); out = ((Collections)null).unmodifiableMap((Map)in); sink(readMapKey(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;unmodifiableMap;(Map);;MapValue of Argument[0];MapValue of ReturnValue;value",
      Map out = null;
      Object in = storeMapValue(source()); out = ((Collections)null).unmodifiableMap((Map)in); sink(readMapValue(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;unmodifiableList;(List);;Element of Argument[0];Element of ReturnValue;value",
      List out = null;
      List in = storeElementList(source()); out = ((Collections)null).unmodifiableList(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;unmodifiableNavigableSet;(NavigableSet);;Element of Argument[0];Element of ReturnValue;value",
      Set out = null;
      NavigableSet in = storeElementNavSet(source()); out = ((Collections)null).unmodifiableNavigableSet(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;unmodifiableSortedSet;(SortedSet);;Element of Argument[0];Element of ReturnValue;value",
      Set out = null;
      SortedSet in = storeElementNavSet(source()); out = ((Collections)null).unmodifiableSortedSet(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;unmodifiableSet;(Set);;Element of Argument[0];Element of ReturnValue;value",
      Set out = null;
      Set in = storeElementNavSet(source()); out = ((Collections)null).unmodifiableSet(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;unmodifiableCollection;(Collection);;Element of Argument[0];Element of ReturnValue;value",
      Collection out = null;
      Collection in = storeElementList(source()); out = ((Collections)null).unmodifiableCollection(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;max;;;Element of Argument[0];ReturnValue;value",
      Object out = null;
      Collection in = storeElementList(source()); out = ((Collections)null).max(in); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;min;;;Element of Argument[0];ReturnValue;value",
      Object out = null;
      Collection in = storeElementList(source()); out = ((Collections)null).min(in); sink(out); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(Object[],int,int,Object);;Argument[3];ArrayElement of Argument[0];value",
      Object[] out = null;
      Object in = source(); ((Arrays)null).fill(out,0,0,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(Object[],Object);;Argument[1];ArrayElement of Argument[0];value",
      Object[] out = null;
      Object in = source(); ((Arrays)null).fill(out,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(float[],int,int,float);;Argument[3];ArrayElement of Argument[0];value",
      float[] out = null;
      float in = (Float)source(); ((Arrays)null).fill(out,0,0,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(float[],float);;Argument[1];ArrayElement of Argument[0];value",
      float[] out = null;
      float in = (Float)source(); ((Arrays)null).fill(out,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(double[],int,int,double);;Argument[3];ArrayElement of Argument[0];value",
      double[] out = null;
      double in = (Double)source(); ((Arrays)null).fill(out,0,0,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(double[],double);;Argument[1];ArrayElement of Argument[0];value",
      double[] out = null;
      double in = (Double)source(); ((Arrays)null).fill(out,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(boolean[],int,int,boolean);;Argument[3];ArrayElement of Argument[0];value",
      boolean[] out = null;
      boolean in = (Boolean)source(); ((Arrays)null).fill(out,0,0,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(boolean[],boolean);;Argument[1];ArrayElement of Argument[0];value",
      boolean[] out = null;
      boolean in = (Boolean)source(); ((Arrays)null).fill(out,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(byte[],int,int,byte);;Argument[3];ArrayElement of Argument[0];value",
      byte[] out = null;
      byte in = (Byte)source(); ((Arrays)null).fill(out,0,0,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(byte[],byte);;Argument[1];ArrayElement of Argument[0];value",
      byte[] out = null;
      byte in = (Byte)source(); ((Arrays)null).fill(out,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(char[],int,int,char);;Argument[3];ArrayElement of Argument[0];value",
      char[] out = null;
      char in = (Character)source(); ((Arrays)null).fill(out,0,0,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(char[],char);;Argument[1];ArrayElement of Argument[0];value",
      char[] out = null;
      char in = (Character)source(); ((Arrays)null).fill(out,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(short[],int,int,short);;Argument[3];ArrayElement of Argument[0];value",
      short[] out = null;
      short in = (Short)source(); ((Arrays)null).fill(out,0,0,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(short[],short);;Argument[1];ArrayElement of Argument[0];value",
      short[] out = null;
      short in = (Short)source(); ((Arrays)null).fill(out,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(int[],int,int,int);;Argument[3];ArrayElement of Argument[0];value",
      int[] out = null;
      int in = (Integer)source(); ((Arrays)null).fill(out,0,0,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(int[],int);;Argument[1];ArrayElement of Argument[0];value",
      int[] out = null;
      int in = (Integer)source(); ((Arrays)null).fill(out,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(long[],int,int,long);;Argument[3];ArrayElement of Argument[0];value",
      long[] out = null;
      long in = (Long)source(); ((Arrays)null).fill(out,0,0,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;fill;(long[],long);;Argument[1];ArrayElement of Argument[0];value",
      long[] out = null;
      long in = (Long)source(); ((Arrays)null).fill(out,in); sink(readArrayElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;replaceAll;(List,Object,Object);;Argument[2];Element of Argument[0];value",
      List out = null;
      Object in = source(); ((Collections)null).replaceAll(out,null,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;copy;(List,List);;Element of Argument[1];Element of Argument[0];value",
      List out = null;
      List in = storeElementList(source()); ((Collections)null).copy(out,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;fill;(List,Object);;Argument[1];Element of Argument[0];value",
      List out = null;
      Object in = source(); ((Collections)null).fill(out,in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Arrays;false;asList;;;ArrayElement of Argument[0];Element of ReturnValue;value",
      List out = null;
      Object[] in = storeArrayElement(source()); out = ((Arrays)null).asList(in); sink(readElement(out)); // $ hasValueFlow
    }
    {
      // "java.util;Collections;false;addAll;(Collection,Object[]);;ArrayElement of Argument[1];Element of Argument[0];value"
      Collection out = null;
      Object[] in = storeArrayElement(source()); ((Collections)null).addAll(out,in); sink(readElement(out)); // $ hasValueFlow
    }
  }
}
