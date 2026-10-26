function isEmpty(xs) {
  for(var i=0; i<xs.length; ++i)
    return false;
  return true;
}

function desk(xs) {
  for(var i=0; i<xs.length; ++i)
    if(xs[i] < xs[0])
      return "yellow";
  return [];
}
