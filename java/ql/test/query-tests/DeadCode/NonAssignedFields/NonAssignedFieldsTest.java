import java.util.concurrent.atomic.AtomicReferenceFieldUpdater;

public class NonAssignedFieldsTest {

	static class Node<T> {
		volatile Node<?> next;

		static final AtomicReferenceFieldUpdater<Node,Node> nextUpdater =
				AtomicReferenceFieldUpdater.newUpdater(Node.class, Node.class, "next");
	}

	{
		Node<?> node = null;
		Node<?> next = node.next;
	}
}
