items.@id;
items.*[1];
order.@*;
e..employee.(@id == 0 || @id == 1);
message.@soap::encodingStyle;
message.soap::Body;
items.@[f()];
message.soap::[g()];

var e = <elt>
  <!-- comment -->
  </elt>;