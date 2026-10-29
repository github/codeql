function countLeaves(nd) {
	var leftLeaves, rightLeaves;
	
	if (nd.isLeaf)
		return 1;
	
	leftLeaves = countLeaves(nd.left);
	rigtLeaves = countLeaves(nd.right);
	return leftLeaves + rightLeaves;
}