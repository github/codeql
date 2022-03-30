function countLeaves(nd) {
	var leftLeaves, rightLeaves;
	
	if (nd.isLeaf)
		return 1;
	
	leftLeaves = countLeaves(nd.left);
	rightLeaves = countLeaves(nd.right);
	return leftLeaves + rightLeaves;
}