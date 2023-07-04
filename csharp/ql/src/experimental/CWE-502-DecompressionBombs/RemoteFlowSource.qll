import csharp
import semmle.code.csharp.security.dataflow.flowsources.Remote

/** A data flow source of remote user input by Form File (ASP.NET unvalidated request data). */
class FormFile extends AspNetRemoteFlowSource {
  FormFile() {
    exists(MethodCall mc |
      mc.getTarget().hasQualifiedName("Microsoft.AspNetCore.Http", "IFormFile", "OpenReadStream") and
      this.asExpr() = mc
    )
    or
    exists(MethodCall mc |
      mc.getTarget()
          .hasQualifiedName("Microsoft.AspNetCore.Http", "IFormFile", ["CopyTo", "CopyToAsync"]) and
      this.asParameter() = mc.getTarget().getParameter(0)
    )
    or
    exists(Property fa |
      fa.getDeclaringType().hasQualifiedName("Microsoft.AspNetCore.Http", "IFormFile") and
      fa.hasName(["ContentType", "ContentDisposition", "Name", "FileName"]) and
      this.asExpr() = fa.getAnAccess()
    )
  }

  override string getSourceType() {
    result = "ASP.NET unvalidated request data from multipart request"
  }
}

/** A data flow source of remote user input by Form (ASP.NET unvalidated request data). */
class FormCollection extends AspNetRemoteFlowSource {
  FormCollection() {
    exists(Property fa |
      fa.getDeclaringType().hasQualifiedName("Microsoft.AspNetCore.Http", "IFormCollection") and
      fa.hasName("Keys") and
      this.asExpr() = fa.getAnAccess()
    )
  }

  override string getSourceType() {
    result = "ASP.NET unvalidated request data from multipart request Form Keys"
  }
}

/** A data flow source of remote user input by Headers (ASP.NET unvalidated request data). */
class HeaderDictionary extends AspNetRemoteFlowSource {
  HeaderDictionary() {
    exists(Property fa |
      fa.getDeclaringType().hasQualifiedName("Microsoft.AspNetCore.Http", "IHeaderDictionary") and
      this.asExpr() = fa.getAnAccess()
    )
  }

  override string getSourceType() {
    result = "ASP.NET unvalidated request data from Headers of request"
  }
}
