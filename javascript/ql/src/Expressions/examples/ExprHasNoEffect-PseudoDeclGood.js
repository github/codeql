function Graph(nodes, edges) {
  this.nodes = nodes;
  this.edges = edges;
  // cache minimum distance between pairs of nodes
  this.distance = {};
}