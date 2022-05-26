/** Provides models of taint flow in `org.springframework.web.multipart` */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class FlowSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.springframework.web.multipart;MultipartFile;true;getBytes;;;Argument[-1];ReturnValue;taint",
        "org.springframework.web.multipart;MultipartFile;true;getInputStream;;;Argument[-1];ReturnValue;taint",
        "org.springframework.web.multipart;MultipartFile;true;getName;;;Argument[-1];ReturnValue;taint",
        "org.springframework.web.multipart;MultipartFile;true;getOriginalFilename;;;Argument[-1];ReturnValue;taint",
        "org.springframework.web.multipart;MultipartFile;true;getResource;;;Argument[-1];ReturnValue;taint",
        "org.springframework.web.multipart;MultipartHttpServletRequest;true;getMultipartHeaders;;;Argument[-1];ReturnValue;taint",
        "org.springframework.web.multipart;MultipartHttpServletRequest;true;getRequestHeaders;;;Argument[-1];ReturnValue;taint",
        "org.springframework.web.multipart;MultipartRequest;true;getFile;;;Argument[-1];ReturnValue;taint",
        "org.springframework.web.multipart;MultipartRequest;true;getFileMap;;;Argument[-1];ReturnValue.MapValue;taint",
        "org.springframework.web.multipart;MultipartRequest;true;getFileNames;;;Argument[-1];ReturnValue.Element;taint",
        "org.springframework.web.multipart;MultipartRequest;true;getFiles;;;Argument[-1];ReturnValue.Element;taint",
        "org.springframework.web.multipart;MultipartRequest;true;getMultiFileMap;;;Argument[-1];ReturnValue.MapValue;taint",
        "org.springframework.web.multipart;MultipartResolver;true;resolveMultipart;;;Argument[0];ReturnValue;taint"
      ]
  }
}
