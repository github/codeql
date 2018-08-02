<%@ Page Language="C#" %>

<html>
<body>
<%
  if (builder == null)
    builder = ec.GetTemporaryLocal (type);

  if (builder.LocalType.IsByRef) {
    //
    // if is_address, than this is just the address anyways,
    // so we just return this.
    //
    ec.Emit (Response, OpCodes.Ldloc, builder);
  } else {
    ec.Emit (Response, OpCodes.Ldloca, builder);
  }
%>
</body>
</html>
