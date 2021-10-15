function contains(a, elt) {
  for (let i = 0; i <= a.length; ++i)
    if (a[i] === elt)
      return true;
  return false;
}