private Set<Node> reachableNodes = new HashSet<Node>();

boolean reachable(Node n) {
	boolean reachable;
	if (n == ROOT)
		reachable = true;
	else
		reachable = reachable(n.getParent());
	if (reachable)
		reachableNodes.add(n);
	return reachable;
}