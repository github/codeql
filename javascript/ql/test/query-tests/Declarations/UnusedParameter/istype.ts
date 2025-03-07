class Node {}
class LeafNode extends Node {}
class BranchNode extends Node {}

interface ITreeModel {
  isLeafNode(node: Node): node is LeafNode;
  isBranchNode(node: Node): node is BranchNode;
  isValidNode(node: Node): boolean;
}

class SingletonTreeModel implements ITreeModel {
  isLeafNode(node: Node): node is LeafNode {
    return node instanceof LeafNode;
  }
  isBranchNode(node: Node): node is BranchNode {
    return false; // This model has no branches.
  }
  isValidNode(node: Node): boolean { // $ Alert
    return Node != null; // woops
  }
}
