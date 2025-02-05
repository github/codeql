deprecated module;

import java
import semmle.code.java.dataflow.FlowSources

class CommonsFileUploadAdditionalTaintStep extends Unit {
  abstract predicate step(DataFlow::Node n1, DataFlow::Node n2);
}

module ApacheCommonsFileUpload {
  module RemoteFlowSource {
    class TypeServletFileUpload extends RefType {
      TypeServletFileUpload() {
        this.hasQualifiedName("org.apache.commons.fileupload.servlet", "ServletFileUpload")
      }
    }

    class TypeFileUpload extends RefType {
      TypeFileUpload() {
        this.getAStrictAncestor*().hasQualifiedName("org.apache.commons.fileupload", "FileItem")
      }
    }

    class TypeFileItemStream extends RefType {
      TypeFileItemStream() {
        this.getAStrictAncestor*()
            .hasQualifiedName("org.apache.commons.fileupload", "FileItemStream")
      }
    }

    class ServletFileUpload extends RemoteFlowSource {
      ServletFileUpload() {
        exists(MethodCall ma |
          ma.getReceiverType() instanceof TypeServletFileUpload and
          ma.getCallee().hasName("parseRequest") and
          this.asExpr() = ma
        )
      }

      override string getSourceType() { result = "Apache Commons Fileupload" }
    }

    private class FileItemRemoteSource extends RemoteFlowSource {
      FileItemRemoteSource() {
        exists(MethodCall ma |
          ma.getReceiverType() instanceof TypeFileUpload and
          ma.getCallee()
              .hasName([
                  "getInputStream", "getFieldName", "getContentType", "get", "getName", "getString"
                ]) and
          this.asExpr() = ma
        )
      }

      override string getSourceType() { result = "Apache Commons Fileupload" }
    }

    private class FileItemStreamRemoteSource extends RemoteFlowSource {
      FileItemStreamRemoteSource() {
        exists(MethodCall ma |
          ma.getReceiverType() instanceof TypeFileItemStream and
          ma.getCallee().hasName(["getContentType", "getFieldName", "getName", "openStream"]) and
          this.asExpr() = ma
        )
      }

      override string getSourceType() { result = "Apache Commons Fileupload" }
    }
  }

  module Util {
    class TypeStreams extends RefType {
      TypeStreams() { this.hasQualifiedName("org.apache.commons.fileupload.util", "Streams") }
    }

    private class AsStringAdditionalTaintStep extends CommonsFileUploadAdditionalTaintStep {
      override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
        exists(Call call |
          call.getCallee().getDeclaringType() instanceof TypeStreams and
          call.getArgument(0) = n1.asExpr() and
          call = n2.asExpr() and
          call.getCallee().hasName("asString")
        )
      }
    }

    private class CopyAdditionalTaintStep extends CommonsFileUploadAdditionalTaintStep {
      override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
        exists(Call call |
          call.getCallee().getDeclaringType() instanceof TypeStreams and
          call.getArgument(0) = n1.asExpr() and
          call.getArgument(1) = n2.asExpr() and
          call.getCallee().hasName("copy")
        )
      }
    }
  }
}

module ServletRemoteMultiPartSources {
  class TypePart extends RefType {
    TypePart() { this.hasQualifiedName(["javax.servlet.http", "jakarta.servlet.http"], "Part") }
  }

  private class ServletPartCalls extends RemoteFlowSource {
    ServletPartCalls() {
      exists(MethodCall ma |
        ma.getReceiverType() instanceof TypePart and
        ma.getCallee()
            .hasName([
                "getInputStream", "getName", "getContentType", "getHeader", "getHeaders",
                "getHeaderNames", "getSubmittedFileName", "write"
              ]) and
        this.asExpr() = ma
      )
    }

    override string getSourceType() { result = "Javax Servlet Http" }
  }
}
