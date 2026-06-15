import python
import semmle.python.dataflow.new.TaintTracking
import semmle.python.ApiGraphs

/**
 * Provides user-controllable Remote sources for file(s) upload and Multipart-Form
 */
module FileAndFormRemoteFlowSource {
  /**
   * A FastAPI Remote Flow Source for requests with multipart data in the body or requests with single file in the body
   */
  class FastApi extends DataFlow::Node {
    FastApi() {
      exists(API::Node fastApiParam, Expr fastApiUploadFile |
        fastApiParam =
          API::moduleImport("fastapi")
              .getMember("FastAPI")
              .getReturn()
              .getMember("post")
              .getReturn()
              .getParameter(0)
              .getKeywordParameter(_) and
        fastApiUploadFile =
          API::moduleImport("fastapi")
              .getMember("UploadFile")
              .getASubclass*()
              .getAValueReachableFromSource()
              .asExpr()
      |
        // Multiple uploaded files as list of fastapi.UploadFile
        // @app.post("/")
        //    def upload(files: List[UploadFile] = File(...)):
        //        for file in files:
        fastApiUploadFile =
          fastApiParam.asSource().asExpr().(Parameter).getAnnotation().getASubExpression*() and
        exists(For f, Attribute attr |
          fastApiParam.getAValueReachableFromSource().asExpr() = f.getIter().getASubExpression*()
        |
          DataFlow::localFlow(DataFlow::exprNode(f.getIter()), DataFlow::exprNode(attr.getObject())) and
          attr.getName() = ["filename", "content_type", "headers", "file", "read"] and
          this.asExpr() = attr
        )
        or
        // One uploaded file as fastapi.UploadFile
        // @app.post("/zipbomb2")
        //    async def zipbomb2(file: UploadFile):
        //        print(file.filename)
        this =
          [
            fastApiParam.getMember(["filename", "content_type", "headers"]).asSource(),
            fastApiParam
                .getMember("file")
                .getMember(["readlines", "readline", "read"])
                .getReturn()
                .asSource(), fastApiParam.getMember("read").getReturn().asSource()
          ]
      )
    }

    string getSourceType() { result = "fastapi HTTP FORM files" }
  }
}
