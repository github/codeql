/**
 * @name User-controlled file decompression
 * @description User-controlled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id py/user-controlled-file-decompression
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.dataflow.new.internal.DataFlowPublic

// /**
//  * Same as ZipFile
//  * I can made PyZipFile separated from ZipFile
//  * as in future this will be more compatible if it has more differences from ZipFile
//  * and we can add new changes easier.
//  */
// module PyZipFile { }
module Lzma {
  private API::Node lzmaClass() {
    result = API::moduleImport("lzma").getMember(["LZMAFile", "open"])
  }

  /**
   * `lzma.open(sink)`
   * `lzma.LZMAFile(sink)`
   * only read mode is sink
   */
  DataFlow::Node isSink() {
    exists(API::Node lzmaClass | lzmaClass = lzmaClass() |
      result = lzmaClass.getACall().getParameter(0, "filename").asSink() and
      (
        not exists(
          lzmaClass
              .getACall()
              .getParameter(1, "mode")
              .getAValueReachingSink()
              .asExpr()
              .(StrConst)
              .getText()
        ) or
        lzmaClass
            .getACall()
            .getParameter(1, "mode")
            .getAValueReachingSink()
            .asExpr()
            .(StrConst)
            .getText()
            .matches("%r%")
      )
    )
  }
}

module Bz2 {
  private API::Node bz2Class() { result = API::moduleImport("bz2").getMember(["BZ2File", "open"]) }

  /**
   * `bz2.open(sink)`
   * `bz2.BZ2File(sink)`
   * only read mode is sink
   */
  DataFlow::Node isSink() {
    exists(API::Node bz2Class | bz2Class = bz2Class() |
      result = bz2Class.getACall().getParameter(0, "filename").asSink() and
      (
        not exists(
          bz2Class
              .getACall()
              .getParameter(1, "mode")
              .getAValueReachingSink()
              .asExpr()
              .(StrConst)
              .getText()
        ) or
        bz2Class
            .getACall()
            .getParameter(1, "mode")
            .getAValueReachingSink()
            .asExpr()
            .(StrConst)
            .getText()
            .matches("%r%")
      )
    )
  }
}

module Gzip {
  private API::Node gzipClass() {
    result = API::moduleImport("gzip").getMember(["GzipFile", "open"])
  }

  /**
   * `gzip.open(sink)`
   * `gzip.GzipFile(sink)`
   * only read mode is sink
   */
  DataFlow::Node isSink() {
    exists(API::Node gzipClass | gzipClass = gzipClass() |
      result = gzipClass.getACall().getParameter(0, "filename").asSink() and
      (
        not exists(
          gzipClass
              .getACall()
              .getParameter(1, "mode")
              .getAValueReachingSink()
              .asExpr()
              .(StrConst)
              .getText()
        ) or
        gzipClass
            .getACall()
            .getParameter(1, "mode")
            .getAValueReachingSink()
            .asExpr()
            .(StrConst)
            .getText()
            .matches("%r%")
      )
    )
  }
}

module ZipFile {
  /**
   * ```python
   * zipfile.ZipFile()
   * ```
   */
  API::Node zipFileClass() {
    result =
      [
        API::moduleImport("zipfile").getMember("ZipFile"),
        API::moduleImport("zipfile").getMember("PyZipFile")
      ]
  }

  /**
   * ```python
   * zipfile.ZipFile("zipfileName.zip")
   * # read() or one of ["read", "readline", "readlines", "seek", "tell", "__iter__", "__next__"]
   * myzip.open('eggs.txt',"r").read()
   * # I decided to choice open method with "r" mode as sink
   * # because opening zipfile with "r" mode mostly is for reading content of that file
   * # so we have a very few of FP here
   * next(myzip.open('eggs.txt'))
   * myzip.extractall()
   * myzip.read()
   * myzip.extract()
   * # testzip not a RAM consumer but it uses as much CPU as possible
   * myzip.testzip()
   *
   * ```
   */
  private API::Node sink(API::Node zipFileInstance) {
    // we can go forward one more step and check whether we call the required methods for read
    // or just opening zipfile for reading is enough ( mode = "r")
    // result =
    //   zipfileReturnIOFile()
    //       .getReturn()
    //       .getMember(["read", "readline", "readlines", "seek", "tell", "__iter__", "__next__"])
    // or
    (
      result = zipFileInstance.getReturn().getMember(["extractall", "read", "extract", "testzip"])
      or
      result = zipFileInstance.getReturn().getMember("open") and
      (
        not exists(
          result
              .getACall()
              .getParameter(1, "mode")
              .getAValueReachingSink()
              .asExpr()
              .(StrConst)
              .getText()
        ) or
        result
            .getACall()
            .getParameter(1, "mode")
            .getAValueReachingSink()
            .asExpr()
            .(StrConst)
            .getText() = "r"
      ) and
      (
        not exists(
          zipFileInstance
              .getACall()
              .getParameter(1, "mode")
              .getAValueReachingSink()
              .asExpr()
              .(StrConst)
              .getText()
        ) or
        zipFileInstance
            .getACall()
            .getParameter(1, "mode")
            .getAValueReachingSink()
            .asExpr()
            .(StrConst)
            .getText() = "r"
      ) and
      zipFileSanitizer(result)
    ) and
    exists(result.getACall().getLocation().getFile().getRelativePath())
  }

  /**
   * a sanitizers which check if there is a managed read
   * ```python
   *    with zipfile.ZipFile(zipFileName) as myzip:
   *      with myzip.open(fileinfo.filename, mode="r") as myfile:
   *        while chunk:
   *          chunk = myfile.read(buffer_size)
   *          total_size += buffer_size
   *          if total_size > SIZE_THRESHOLD:
   *            ...
   * ```
   */
  predicate zipFileSanitizer(API::Node n) {
    not TaintTracking::localExprTaint(n.getReturn()
          .getMember("read")
          .getParameter(0)
          .asSink()
          .asExpr(), any(Compare i).getASubExpression*())
  }

  DataFlow::Node isSink() { result = sink(zipFileClass()).getACall() }

  /**
   * ```python
   * nodeFrom = "zipFileName.zip"
   * myZip = zipfile.ZipFile(nodeFrom)
   * nodeTo2 = myZip.open('eggs.txt',"r")
   *
   * nodeTo = myZip.extractall()
   * nodeTo = myZip.read()
   * nodeTo = myZip.extract()
   * # testzip not a RAM consumer but it uses as much CPU as possible
   * nodeTo = myZip.testzip()
   *
   * ```
   */
  predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    exists(API::Node zipFileInstance | zipFileInstance = zipFileClass() |
      nodeFrom =
        [zipFileInstance.getACall().getParameter(0, "file").asSink(), zipFileInstance.getACall()] and
      nodeTo =
        [
          sink(zipFileInstance).getACall(),
          zipFileInstance
              .getACall()
              .getReturn()
              .getMember(["extractall", "read", "extract", "testzip"])
              .getACall()
        ]
    ) and
    exists(nodeTo.getLocation().getFile().getRelativePath())
  }
}

module TarFile {
  /**
   * tarfile.open
   *
   * tarfile.Tarfile.open/xzopen/gzopen/bz2open
   * and not mode="r:" which means no compression accepted
   */
  API::Node tarfileInstance() {
    result =
      [
        API::moduleImport("tarfile").getMember("open"),
        API::moduleImport("tarfile")
            .getMember("TarFile")
            .getMember(["xzopen", "gzopen", "bz2open", "open"])
      ] and
    (
      not exists(
        result
            .getACall()
            .getParameter(1, "mode")
            .getAValueReachingSink()
            .asExpr()
            .(StrConst)
            .getText()
      ) or
      not result
          .getACall()
          .getParameter(1, "mode")
          .getAValueReachingSink()
          .asExpr()
          .(StrConst)
          .getText()
          .matches("r:%")
    )
  }

  /**
   * a Call of
   * `tarfile.open(filepath).extractall()/extract()/extractfile()`
   * or
   * `tarfile.Tarfile.xzopen()/gzopen()/bz2open()`
   */
  DataFlow::Node isSink() {
    result =
      tarfileInstance().getReturn().getMember(["extractall", "extract", "extractfile"]).getACall()
  }

  predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    exists(API::Node tarfileInstance | tarfileInstance = tarfileInstance() |
      nodeFrom =
        [tarfileInstance.getACall().getParameter(0, "name").asSink(), tarfileInstance.getACall()] and
      nodeTo =
        tarfileInstance.getReturn().getMember(["extractall", "extract", "extractfile"]).getACall()
    )
  }
}

module Shutil {
  DataFlow::Node isSink() {
    result =
      API::moduleImport("shutil")
          .getMember("unpack_archive")
          .getACall()
          .getParameter(0, "filename")
          .asSink()
  }
}

module Pandas {
  DataFlow::Node isSink() {
    exists(API::CallNode calltoPandasMethods |
      (
        calltoPandasMethods =
          API::moduleImport("pandas")
              .getMember([
                  "read_csv", "read_json", "read_sas", "read_stata", "read_table", "read_xml"
                ])
              .getACall() and
        result = calltoPandasMethods.getArg(0)
        or
        calltoPandasMethods =
          API::moduleImport("pandas")
              .getMember(["read_csv", "read_sas", "read_stata", "read_table"])
              .getACall() and
        result = calltoPandasMethods.getArgByName("filepath_or_buffer")
        or
        calltoPandasMethods = API::moduleImport("pandas").getMember("read_json").getACall() and
        result = calltoPandasMethods.getArgByName("path_or_buf")
        or
        calltoPandasMethods = API::moduleImport("pandas").getMember("read_xml").getACall() and
        result = calltoPandasMethods.getArgByName("path_or_buffer")
      ) and
      (
        not exists(calltoPandasMethods.getArgByName("compression"))
        or
        not calltoPandasMethods
            .getKeywordParameter("compression")
            .getAValueReachingSink()
            .asExpr()
            .(StrConst)
            .getText() = "tar"
      )
    )
  }
}

module FileAndFormRemoteFlowSource {
  class FastAPI extends DataFlow::Node {
    FastAPI() {
      exists(API::Node fastApiParam |
        fastApiParam =
          API::moduleImport("fastapi")
              .getMember("FastAPI")
              .getReturn()
              .getMember("post")
              .getReturn()
              .getParameter(0)
              .getKeywordParameter(_) and
        API::moduleImport("fastapi")
            .getMember("UploadFile")
            .getASubclass*()
            .getAValueReachableFromSource()
            .asExpr() =
          fastApiParam.asSource().asExpr().(Parameter).getAnnotation().getASubExpression*()
      |
        // in the case of List of files
        exists(For f, Attribute attr, DataFlow::Node a, DataFlow::Node b |
          fastApiParam.getAValueReachableFromSource().asExpr() = f.getIter().getASubExpression*()
        |
          // file.file in following
          // def upload(files: List[UploadFile] = File(...)):
          //     for file in files:
          //          **file.file**
          // thanks Arthur Baars for helping me in following
          TaintTracking::localTaint(a, b) and
          a.asExpr() = f.getIter() and
          b.asExpr() = attr.getObject() and
          attr.getName() = ["filename", "content_type", "headers", "file", "read"] and
          this.asExpr() = attr
        )
        or
        this =
          [
            fastApiParam.asSource(),
            fastApiParam.getMember(["filename", "content_type", "headers", "file"]).asSource(),
            fastApiParam.getMember("read").getReturn().asSource(),
            // file-like object, I'm trying to not do additional work here by using already existing file-like objs if it is possible
            // fastApiParam.getMember("file").getAMember().asSource(),
          ]
      )
      or
      exists(API::Node fastApiParam |
        fastApiParam =
          API::moduleImport("fastapi")
              .getMember("FastAPI")
              .getReturn()
              .getMember("post")
              .getReturn()
              .getParameter(0)
              .getKeywordParameter(_) and
        API::moduleImport("fastapi")
            .getMember("File")
            .getASubclass*()
            .getAValueReachableFromSource()
            .asExpr() =
          fastApiParam.asSource().asExpr().(Parameter).getAnnotation().getASubExpression*()
      |
        // in the case of List of files
        exists(For f, Attribute attr, DataFlow::Node a, DataFlow::Node b |
          fastApiParam.getAValueReachableFromSource().asExpr() = f.getIter().getASubExpression*()
        |
          // file.file in following
          // def upload(files: List[UploadFile] = File(...)):
          //     for file in files:
          //          **file.file**
          // thanks Arthur Baars for helping me in following
          TaintTracking::localTaint(a, b) and
          a.asExpr() = f.getIter() and
          b.asExpr() = attr.getObject() and
          attr.getName() = "file" and
          this.asExpr() = attr
        )
        or
        this = fastApiParam.asSource()
      ) and
      exists(this.getLocation().getFile().getRelativePath())
    }
  }
}

/**
 * `io.TextIOWrapper(ip, encoding='utf-8')` like following:
 * ```python
 * with gzip.open(bomb_input, 'rb') as ip:
 *   with io.TextIOWrapper(ip, encoding='utf-8') as decoder:
 *     content = decoder.read()
 *     print(content)
 * ```
 * I saw this builtin method many places so I added it as a AdditionalTaintStep.
 * it would be nice if it is added as a global AdditionalTaintStep
 */
predicate isAdditionalTaintStepTextIOWrapper(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  exists(API::CallNode textIOWrapper |
    textIOWrapper = API::moduleImport("io").getMember("TextIOWrapper").getACall()
  |
    nodeFrom = textIOWrapper.getParameter(0, "input").asSink() and
    nodeTo = textIOWrapper
  ) and
  exists(nodeTo.getLocation().getFile().getRelativePath())
}

module BombsConfig implements DataFlow::ConfigSig {
  // borrowed from UnsafeUnpackQuery.qll
  predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource
    or
    exists(MethodCallNode args |
      args = source.(AttrRead).getObject().getALocalSource() and
      args =
        [
          API::moduleImport("argparse")
              .getMember("ArgumentParser")
              .getReturn()
              .getMember("parse_args")
              .getACall(), API::moduleImport("os").getMember("getenv").getACall(),
          API::moduleImport("os").getMember("environ").getMember("get").getACall()
        ]
    )
    or
    source instanceof FileAndFormRemoteFlowSource::FastAPI
    or
    source = TarFile::tarfileInstance().getACall()
    or
    source = ZipFile::zipFileClass().getACall()
  }

  predicate isSink(DataFlow::Node sink) {
    sink =
      [
        ZipFile::isSink(), Gzip::isSink(), Lzma::isSink(), Bz2::isSink(), TarFile::isSink(),
        Shutil::isSink(), Pandas::isSink()
      ] and
    exists(sink.getLocation().getFile().getRelativePath())
  }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    (
      isAdditionalTaintStepTextIOWrapper(nodeFrom, nodeTo) or
      ZipFile::isAdditionalTaintStep(nodeFrom, nodeTo) or
      TarFile::isAdditionalTaintStep(nodeFrom, nodeTo)
    ) and
    exists(nodeTo.getLocation().getFile().getRelativePath())
  }
}

module Bombs = TaintTracking::Global<BombsConfig>;

import Bombs::PathGraph

from Bombs::PathNode source, Bombs::PathNode sink
where Bombs::flowPath(source, sink)
select sink.getNode(), source, sink, "This file extraction depends on a $@.", source.getNode(),
  "potentially untrusted source"
