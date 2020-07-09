
import java.util.Collection;
import java.util.List;
import java.util.Vector;
import java.util.Stack;
import java.util.Queue;
import java.util.Deque;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.TransferQueue;
import java.util.concurrent.BlockingDeque;
import java.util.SortedSet;
import java.util.NavigableSet;
import java.util.Map;
import java.util.Map.Entry;
import java.util.SortedMap;
import java.util.NavigableMap;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.TimeUnit;
import java.util.Dictionary;
import java.util.Iterator;
import java.util.ListIterator;
import java.util.Enumeration;

class ContainerTest {

	private static <T> T sink(T object) { return object; }
 	private static <T> T mkSink(Class<T> cls) { return null; }
	private static <T> T source(T object) { return object; }

	public static void taintSteps(
			Iterable<String> iterable,
			Collection<String> collection,
			List<String> list,
			Vector<String> vector,
			Stack<String> stack,
			Queue<String> queue,
			Deque<String> deque,
			BlockingQueue<String> blockQueue,
			BlockingDeque<String> blockDeque,
			TransferQueue<String> transferQ,
			SortedSet<String> sortedSet,
			NavigableSet<String> navSet,
			Map<String, String> map,
			Map.Entry<String, String> entry,
			SortedMap<String, String> sortedMap,
			NavigableMap<String, String> navMap,
			ConcurrentHashMap<String, String> syncHashMap,
			Dictionary<String, String> dict,
			Iterator<String> iter,
			ListIterator<String> listIter,
			Enumeration<String> enumeration
	) throws InterruptedException {
		// java.util.Iterable
		sink(iterable.iterator());
		sink(iterable.spliterator());

		// java.util.Collection
		sink(collection.parallelStream());
		sink(collection.stream());
		sink(collection.toArray());
		sink(collection.toArray(x -> new String[x]));
		sink(collection.toArray(new String[5]));
		collection.toArray(mkSink(String[].class));
		mkSink(Collection.class).add(source("value"));
		mkSink(Collection.class).addAll(collection);

		// java.util.List
		sink(list.get(1));
		sink(list.listIterator());
		sink(list.listIterator(2));
		sink(list.remove(3));
		sink(list.set(4, "value"));
		sink(list.subList(5, 6));
		mkSink(List.class).add(7, source("value"));
		mkSink(List.class).addAll(8, collection);
		mkSink(List.class).set(9, source("value"));

		// java.util.Vector
		sink(vector.elementAt(7));
		sink(vector.elements());
		sink(vector.firstElement());
		sink(vector.lastElement());
		mkSink(Vector.class).addElement(source("element"));
		mkSink(Vector.class).insertElementAt(source("element"), 1);
		mkSink(Vector.class).setElementAt(source("element"), 2);
		vector.copyInto(mkSink(String[].class));

		// java.util.Stack
		sink(stack.peek());
		sink(stack.pop());
		sink(stack.push("value")); // not tainted
		sink(new Stack().push(source("value")));
		mkSink(Stack.class).push(source("value"));

		// java.util.Queue
		sink(queue.element());
		sink(queue.peek());
		sink(queue.poll());
		sink(queue.remove());
		mkSink(Queue.class).offer(source("element"));

		// java.util.Deque
		sink(deque.getFirst());
		sink(deque.getLast());
		sink(deque.peekFirst());
		sink(deque.peekLast());
		sink(deque.pollFirst());
		sink(deque.pollLast());
		sink(deque.removeFirst());
		sink(deque.removeLast());
		mkSink(Deque.class).addFirst(source("value"));
		mkSink(Deque.class).addLast(source("value"));
		mkSink(Deque.class).offerFirst(source("value"));
		mkSink(Deque.class).offerLast(source("value"));
		mkSink(Deque.class).push(source("value"));

		// java.util.concurrent.BlockingQueue
		sink(blockQueue.poll(10, TimeUnit.SECONDS));
		sink(blockQueue.take());
		blockQueue.drainTo(mkSink(Collection.class));
		blockQueue.drainTo(mkSink(Collection.class), 4);

		// java.util.concurrent.TransferQueue
		mkSink(TransferQueue.class).transfer(source("value"));
		mkSink(TransferQueue.class).tryTransfer(source("value"));
		mkSink(TransferQueue.class).tryTransfer(source("value"), 9, TimeUnit.SECONDS);

		// java.util.concurrent.BlockingDeque
		sink(blockDeque.pollFirst(11, TimeUnit.SECONDS));
		sink(blockDeque.pollLast(12, TimeUnit.SECONDS));
		sink(blockDeque.takeFirst());
		sink(blockDeque.takeLast());
		mkSink(BlockingDeque.class).offer(source("value"), 10, TimeUnit.SECONDS);
		mkSink(BlockingDeque.class).put(source("value"));
		mkSink(BlockingDeque.class).offerFirst(source("value"), 10, TimeUnit.SECONDS);
		mkSink(BlockingDeque.class).offerLast(source("value"), 10, TimeUnit.SECONDS);
		mkSink(BlockingDeque.class).putFirst(source("value"));
		mkSink(BlockingDeque.class).putLast(source("value"));

		// java.util.SortedSet
		sink(sortedSet.first());
		sink(sortedSet.headSet("a"));
		sink(sortedSet.last());
		sink(sortedSet.subSet("b", "c"));
		sink(sortedSet.tailSet("d"));

		// java.util.NavigableSet
		sink(navSet.ceiling("e"));
		sink(navSet.descendingIterator());
		sink(navSet.descendingSet());
		sink(navSet.floor("f"));
		sink(navSet.headSet("g", true));
		sink(navSet.higher("h"));
		sink(navSet.lower("i"));
		sink(navSet.pollFirst());
		sink(navSet.pollLast());
		sink(navSet.subSet("j", true, "k", false));
		sink(navSet.tailSet("l", true));

		// java.util.Map
		sink(map.computeIfAbsent("key", key -> "result"));
		sink(map.entrySet());
		sink(map.get("key"));
		sink(map.getOrDefault("key", "default"));
		sink(map.merge("key", "value", (x, y) ->  x + y));
		sink(map.put("key", "value"));
		sink(map.putIfAbsent("key", "value"));
		sink(map.remove("object"));
		sink(map.replace("key", "value"));
		sink(map.values());
		mkSink(Map.class).merge("key", source("v"), (x,y) -> "" + x + y);
		mkSink(Map.class).put("key", source("v"));
		mkSink(Map.class).putAll(map);
		mkSink(Map.class).putIfAbsent("key", source("v"));
		mkSink(Map.class).replace("key", source("v"));
		mkSink(Map.class).replace("key", "old", source("v"));
		mkSink(Map.class).replace("key", source("old"), "v"); // not tainted

		// java.util.Map.Entry
		sink(entry.getValue());
		sink(entry.setValue("value"));
		mkSink(Map.Entry.class).setValue(source("value"));
		// java.util.SortedMap
		sink(sortedMap.headMap("key"));
		sink(sortedMap.subMap("key1", "key2"));
		sink(sortedMap.tailMap("key"));

		// java.util.NavigableMap
		sink(navMap.ceilingEntry("key"));
		sink(navMap.descendingMap());
		sink(navMap.firstEntry());
		sink(navMap.floorEntry("key"));
		sink(navMap.headMap("key", true));
		sink(navMap.higherEntry("key"));
		sink(navMap.lastEntry());
		sink(navMap.lowerEntry("key"));
		sink(navMap.pollFirstEntry());
		sink(navMap.pollLastEntry());
		sink(navMap.subMap("key1", true, "key2", true));
		sink(navMap.tailMap("key", true));

		// java.util.concurrent.ConcurrentHashMap
		sink(syncHashMap.elements());
		sink(syncHashMap.search(10, (k, v) -> v));
		sink(syncHashMap.searchEntries(11, e -> e.getValue()));
		sink(syncHashMap.searchValues(12, v -> v));

		// java.util.Dictionary
		sink(dict.elements());
		sink(dict.get("object"));
		sink(dict.put("key", "value"));
		sink(dict.remove("object"));
		mkSink(Dictionary.class).put("key", source("value"));

		// java.util.Iterator
		sink(iter.next());

		// java.util.ListIterator
		sink(listIter.previous());
		mkSink(ListIterator.class).add(source("value"));
		mkSink(ListIterator.class).set(source("value"));

		// java.util.Enumeration
		sink(enumeration.asIterator());
		sink(enumeration.nextElement());
	}
}

