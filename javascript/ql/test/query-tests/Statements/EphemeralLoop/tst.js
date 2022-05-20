// NOT OK
while(c){
  switch(c){
    case "/":
      break;
    default:
  }
  break;
}

// NOT OK
function f() {
  for (; k < numprecincts;) {
    var packet = createPacket(resolution, k, l);
    k++;
    return packet;
  }
}

// OK
var oHasProps = false;
for (var p in o) {
  oHasProps = true;
  break;
}

// OK
while(c){
  if (c === '"')
    break;
  console.log(c);
}
