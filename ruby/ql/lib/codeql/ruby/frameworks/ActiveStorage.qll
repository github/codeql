/**
 * Provides modeling for the `ActiveStorage` library.
 */

private import codeql.ruby.AST
private import codeql.ruby.ApiGraphs
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.frameworks.data.ModelsAsData
private import codeql.ruby.frameworks.ActiveRecord

/**
 * Provides modeling for the `ActiveStorage` library.
 * Version: 7.0.
 */
module ActiveStorage {
  /** A call to `ActiveStorage::Filename#sanitized`, considered as a path sanitizer. */
  private class FilenameSanitizedCall extends Path::PathSanitization::Range, DataFlow::CallNode {
    FilenameSanitizedCall() {
      this =
        API::getTopLevelMember("ActiveStorage")
            .getMember("Filename")
            .getInstance()
            .getAMethodCall("sanitized")
    }
  }

  private class BlobInstance extends DataFlow::Node {
    BlobInstance() {
      this = ModelOutput::getATypeNode("ActiveStorage::Blob").getAValueReachableFromSource()
      or
      // ActiveStorage::Attachment#blob : Blob
      exists(DataFlow::CallNode call |
        call = this and
        call.getReceiver() instanceof AttachmentInstance and
        call.getMethodName() = "blob"
      )
      or
      // ActiveStorage::Attachment delegates method calls to its associated Blob
      this instanceof AttachmentInstance
    }
  }

  /**
   * Method calls on `ActiveStorage::Blob` that send HTTP requests.
   */
  private class BlobRequestCall extends Http::Client::Request::Range {
    BlobRequestCall() {
      this =
        [
          // Class methods
          API::getTopLevelMember("ActiveStorage")
              .getMember("Blob")
              .getAMethodCall(["create_after_unfurling!", "create_and_upload!"]),
          // Instance methods
          any(BlobInstance i, DataFlow::CallNode c |
            i.(DataFlow::LocalSourceNode).flowsTo(c.getReceiver()) and
            c.getMethodName() =
              [
                "upload", "upload_without_unfurling", "download", "download_chunk", "delete",
                "purge"
              ]
          |
            c
          )
        ]
    }

    override string getFramework() { result = "activestorage" }

    override DataFlow::Node getResponseBody() { result = this }

    override DataFlow::Node getAUrlPart() { none() }

    override predicate disablesCertificateValidation(
      DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
    ) {
      none()
    }
  }

  /**
   * A call to `has_one_attached` or `has_many_attached`, which declares an
   * association between an ActiveRecord model and an ActiveStorage attachment.
   *
   * ```rb
   * class User < ActiveRecord::Base
   *   has_one_attached :avatar
   * end
   * ```
   */
  private class Association extends ActiveRecordAssociation {
    Association() { this.getMethodName() = ["has_one_attached", "has_many_attached"] }
  }

  /**
   * An ActiveStorage attachment, instantiated directly or via an association with an
   * ActiveRecord model.
   *
   * ```rb
   * class User < ActiveRecord::Base
   *   has_one_attached :avatar
   * end
   *
   * user = User.find(id)
   * user.avatar
   * ActiveStorage::Attachment.new
   * ```
   */
  class AttachmentInstance extends DataFlow::Node {
    AttachmentInstance() {
      this =
        API::getTopLevelMember("ActiveStorage")
            .getMember("Attachment")
            .getInstance()
            .getAValueReachableFromSource()
      or
      exists(Association assoc, string model, DataFlow::CallNode call |
        model = assoc.getTargetModelName()
      |
        call = this and
        call.getReceiver().(ActiveRecordInstance).getClass() = assoc.getSourceClass() and
        call.getMethodName() = model
      )
      or
      any(AttachmentInstance i).(DataFlow::LocalSourceNode).flowsTo(this)
    }
  }

  /**
   * A call on an ActiveStorage object that results in an image transformation.
   * Arguments to these calls may be executed as system commands.
   */
  private class ImageProcessingCall extends SystemCommandExecution::Range instanceof DataFlow::CallNode
  {
    ImageProcessingCall() {
      this.getReceiver() instanceof BlobInstance and
      this.getMethodName() = ["variant", "preview", "representation"]
      or
      this =
        API::getTopLevelMember("ActiveStorage")
            .getMember("Attachment")
            .getInstance()
            .getAMethodCall(["variant", "preview", "representation"])
      or
      this =
        API::getTopLevelMember("ActiveStorage")
            .getMember("Variation")
            .getAMethodCall(["new", "wrap", "encode"])
      or
      this =
        API::getTopLevelMember("ActiveStorage")
            .getMember("Variation")
            .getInstance()
            .getAMethodCall("transformations=")
      or
      this =
        API::getTopLevelMember("ActiveStorage")
            .getMember("Transformers")
            .getMember("ImageProcessingTransformer")
            .getAMethodCall("new")
      or
      this =
        API::getTopLevelMember("ActiveStorage")
            .getMember(["Preview", "VariantWithRecord"])
            .getAMethodCall("new")
      or
      // `ActiveStorage.paths` is a global hash whose values are passed to
      // a `system` call.
      this = API::getTopLevelMember("ActiveStorage").getAMethodCall("paths=")
      or
      // `ActiveStorage.video_preview_arguments` is passed to a `system` call.
      this = API::getTopLevelMember("ActiveStorage").getAMethodCall("video_preview_arguments=")
    }

    override DataFlow::Node getAnArgument() { result = super.getArgument(0) }
  }

  /**
   * `ActiveStorage.variant_processor` is passed to `const_get`.
   */
  private class VariantProcessor extends DataFlow::CallNode, CodeExecution::Range {
    VariantProcessor() {
      this = API::getTopLevelMember("ActiveStorage").getAMethodCall("variant_processor=")
    }

    override DataFlow::Node getCode() { result = this.getArgument(0) }

    override predicate runsArbitraryCode() { none() }
  }
}
