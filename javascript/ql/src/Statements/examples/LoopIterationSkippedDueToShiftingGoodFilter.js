function removePathTraversal(path) {
  return path.split('/').filter(part => part !== '..').join('/');
}
