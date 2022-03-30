Customer getNext(List<Customer> queue) {
	if (queue == null)
		return null;
	LinkedList<Customer> myQueue = (LinkedList<Customer>)queue;  // AVOID: Cast to concrete type.
	return myQueue.poll();
}

Customer getNext(Queue<Customer> queue) {
	if (queue == null)
		return null;
	return queue.poll();  // GOOD: Use abstract type.
}
