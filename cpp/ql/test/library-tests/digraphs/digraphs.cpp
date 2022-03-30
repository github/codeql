static const int x = 1;

int main() <%   /* <% is { */
  return "ab"<: /* <: is [ */
          0<::x /* <: is not { here; the < is a <, and the :: is a name qualifier for x */
          :>;   /* :> is ] */
%>              /* %> is } */
