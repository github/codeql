/**
 * Provides classes modeling security-relevant aspects of the `gradio` PyPI package.
 * See https://pypi.org/project/gradio/.
 */

import python
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.dataflow.new.TaintTracking
import semmle.python.ApiGraphs

/**
 * Provides models for the `gradio` PyPI package.
 * See https://pypi.org/project/gradio/.
 */
module Gradio {
  /**
   * The event handlers in Gradio, which take untrusted data.
   */

  class GradioInput extends API::CallNode {
      GradioInput() { this = API::moduleImport("gradio")
      .getMember([
      "Button", "Textbox", "UploadButton", "Slider",
      "JSON", "HTML", "Markdown", "File",
      "AnnotatedImage", "Audio", "BarPlot", "Chatbot", "Checkbox",
      "CheckboxGroup", "ClearButton", "Code", "ColorPicker", "Dataframe",
      "Dataset", "DownloadButton", "Dropdown", "DuplicateButton", "FileExplorer",
      "Gallery", "HighlightedText", "Image", "ImageEditor", "Label", "LinePlot",
      "LoginButton", "LogoutButton", "Model3D", "Number", "ParamViewer",
      "Plot", "Radio", "ScatterPlot", "SimpleImage", "State", "Video"])
      .getReturn()
      .getMember([
      "change", "input", "click", "submit",
      "edit", "clear", "play", "pause", "stop", "end", "start_recording",
      "pause_recording", "stop_recording", "focus", "blur",
      "upload", "release", "select", "stream", "like", "load",
      "like", "key_up",])
      .getACall()
      }

    }

    /**
     * The high-level gradio.Interface and gradio.ChatInterface classes, which take untrusted data.
     */
    class GradioInterface extends API::CallNode {
      GradioInterface() { this = API::moduleImport("gradio").getMember(["Interface", "ChatInterface"]).getACall() }
    }

  /**
   * The `inputs` parameters in Gradio event handlers, that are lists and are sources of untrusted data.
   * This model allows tracking each element list back to source, f.ex. `gr.Textbox(...)`.
   */
  class GradioInputList extends RemoteFlowSource::Range {
    GradioInputList() {
    exists(API::CallNode call |
    (call instanceof GradioInput
        or
        call instanceof GradioInterface)
        and
        // limit only to lists of parameters given to `inputs`.
        ((call.getKeywordParameter("inputs").asSink().asCfgNode() instanceof ListNode
            or
            call.getParameter(1).asSink().asCfgNode() instanceof ListNode)
        and
        (this = call.getKeywordParameter("inputs").getASuccessor().getAValueReachingSink()
        or
        this = call.getParameter(1).getASuccessor().getAValueReachingSink()))
    )
    }
    override string getSourceType() { result = "Gradio untrusted input" }


  }

  /**
   * The `inputs` parameters in Gradio event handlers, that are not lists and are sources of untrusted data.
   */
  class GradioInputParameter extends RemoteFlowSource::Range {
    GradioInputParameter() {
    exists(API::CallNode call |
      (call instanceof GradioInput
      or
      call instanceof GradioInterface)

      and
      (this = call.getKeywordParameter("fn").getParameter(_).asSource()
      or
      this = call.getParameter(0).getParameter(_).asSource())

      and
      // exclude lists of parameters given to `inputs`
      not call.getKeywordParameter("inputs").asSink().asCfgNode() instanceof ListNode
      and
      not call.getParameter(1).asSink().asCfgNode() instanceof ListNode
      )
    }
  override string getSourceType() { result = "Gradio untrusted input" }
 }

  /**
   * The `inputs` parameters in Gradio decorators to event handlers, that are sources of untrusted data.
   */
 class GradioInputDecorator extends RemoteFlowSource::Range {
    GradioInputDecorator() {
      exists(API::CallNode call |
        (call instanceof GradioInput or call instanceof GradioInterface)
        and
        this = call.getReturn().getACall().getParameter(0).getParameter(_).asSource()
      )
    }
  override string getSourceType() { result = "Gradio untrusted input" }
 }

  /**
   * Extra taint propagation for tracking `inputs` parameters in Gradio event handlers, that are lists.
   */
  private class ListTaintStep extends TaintTracking::AdditionalTaintStep {
    override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      exists(API::CallNode node |
        (node instanceof GradioInput
        or
        node instanceof GradioInterface)
        and
        // handle cases where there are multiple arguments passed as a list to `inputs`
        ((
          (node.getKeywordParameter("inputs").asSink().asCfgNode() instanceof ListNode
          or
          node.getParameter(1).asSink().asCfgNode() instanceof ListNode)
        and
        exists(int i |
          (nodeTo = node.getParameter(0).getParameter(i).asSource()
          or
          nodeTo = node.getKeywordParameter("fn").getParameter(i).asSource())
          and
          (nodeFrom.asCfgNode() = node.getKeywordParameter("inputs").asSink().asCfgNode().(ListNode).getElement(i)
          or
          nodeFrom.asCfgNode() = node.getParameter(1).asSink().asCfgNode().(ListNode).getElement(i))))
        )
      )
    }
  }

}
