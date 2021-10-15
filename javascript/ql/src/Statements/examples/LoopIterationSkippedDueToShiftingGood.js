function removePathTraversal(path) {
  let parts = path.split('/');
  for (let i = 0; i < parts.length; ++i) {
    if (parts[i] === '..') {
      parts.splice(i, 1);
      --i; // adjust for array shift
    }
  }
  return path.join('/');
}
