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

  /** Taint related to `ActiveStorage::Filename`. */
  private class FilenameSummaries extends ModelInput::SummaryModelCsv {
    override predicate row(string row) {
      row =
        [
          "activestorage;;Member[ActiveStorage].Member[Filename].Method[new];Argument[0];ReturnValue;taint",
          "activestorage;;Member[ActiveStorage].Member[Filename].Instance.Method[sanitized];Argument[self];ReturnValue;taint",
        ]
    }
  }

  /**
   * `Blob` is an instance of `ActiveStorage::Blob`.
   */
  private class BlobTypeSummary extends ModelInput::TypeModelCsv {
    override predicate row(string row) {
      // package1;type1;package2;type2;path
      row =
        [
          // ActiveStorage::Blob.new : Blob
          "activestorage;Blob;activestorage;;Member[ActiveStorage].Member[Blob].Instance",
          // ActiveStorage::Blob.create_and_upload! : Blob
          "activestorage;Blob;activestorage;;Member[ActiveStorage].Member[Blob].Method[create_and_upload!].ReturnValue",
          // ActiveStorage::Blob.create_before_direct_upload! : Blob
          "activestorage;Blob;activestorage;;Member[ActiveStorage].Member[Blob].Method[create_before_direct_upload!].ReturnValue",
          // ActiveStorage::Blob.compose(blobs : [Blob]) : Blob
          "activestorage;Blob;activestorage;;Member[ActiveStorage].Member[Blob].Method[compose].ReturnValue",
          "activestorage;Blob;activestorage;;Member[ActiveStorage].Member[Blob].Method[compose].Argument[0].Element[any]",
          // ActiveStorage::Blob.find_signed(!) : Blob
          "activestorage;Blob;activestorage;;Member[ActiveStorage].Member[Blob].Method[find_signed,find_signed!].ReturnValue",
          // ActiveStorage::Attachment#blob : Blob
          "activestorage;Blob;activestorage;;Member[ActiveStorage].Member[Attachment].Instance.Method[blob].ReturnValue",
          // ActiveStorage::Attachment delegates method calls to its associated Blob
          "activestorage;Blob;activestorage;;Member[ActiveStorage].Member[Attachment].Instance",
        ]
    }
  }

  /**
   * Method calls on `ActiveStorage::Blob` that send HTTP requests.
   */
  private class BlobRequestCall extends HTTP::Client::Request::Range {
    BlobRequestCall() {
      this =
        [
          // Class methods
          API::getTopLevelMember("ActiveStorage")
              .getMember("Blob")
              .getASubclass*()
              .getAMethodCall(["create_after_unfurling!", "create_and_upload!"]),
          // Instance methods
          ModelOutput::getATypeNode("activestorage", "Blob")
              .getAMethodCall([
                  "upload", "upload_without_unfurling", "download", "download_chunk", "delete",
                  "purge"
                ])
        ].asExpr().getExpr()
    }

    override string getFramework() { result = "activestorage" }

    override DataFlow::Node getResponseBody() { result.asExpr().getExpr() = this }

    override DataFlow::Node getAUrlPart() { none() }

    override predicate disablesCertificateValidation(DataFlow::Node disablingNode) { none() }
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
   * An ActiveStorage attachment, instantiated via an association with an
   * ActiveRecord model.
   *
   * ```rb
   * class User < ActiveRecord::Base
   *   has_one_attached :avatar
   * end
   *
   * user = User.find(id)
   * user.avatar
   * ```
   */
  private class AttachmentInstance extends DataFlow::CallNode {
    AttachmentInstance() {
      exists(Association assoc, string model | model = assoc.getTargetModelName() |
        this.getReceiver().(ActiveRecordInstance).getClass() = assoc.getSourceClass() and
        (
          assoc.isSingular() and this.getMethodName() = model
          or
          assoc.isCollection() and this.getMethodName() = model
        )
      )
    }
  }

  /**
   * A call on an ActiveStorage  object that results in an image transformation.
   * Arguments to these calls may be executed as system commands.
   */
  private class ImageProcessingCall extends DataFlow::CallNode, SystemCommandExecution::Range {
    ImageProcessingCall() {
      this =
        ModelOutput::getATypeNode("activestorage", "Blob")
            .getAMethodCall(["variant", "preview", "representation"]) or
      this =
        API::getTopLevelMember("ActiveStorage")
            .getMember("Attachment")
            .getInstance()
            .getAMethodCall(["variant", "preview", "representation"]) or
      this =
        API::getTopLevelMember("ActiveStorage")
            .getMember("Variation")
            .getAMethodCall(["new", "wrap", "encode"]) or
      this =
        API::getTopLevelMember("ActiveStorage")
            .getMember("Variation")
            .getInstance()
            .getAMethodCall("transformations=") or
      this =
        API::getTopLevelMember("ActiveStorage")
            .getMember("Transformers")
            .getMember("ImageProcessingTransformer")
            .getAMethodCall("new") or
      this =
        API::getTopLevelMember("ActiveStorage")
            .getMember(["Preview", "VariantWithRecord"])
            .getAMethodCall("new") or
      // `ActiveStorage.paths` is a global hash whose values are passed to
      // a `system` call.
      this = API::getTopLevelMember("ActiveStorage").getAMethodCall("paths=") or
      // `ActiveStorage.video_preview_arguments` is passed to a `system` call.
      this = API::getTopLevelMember("ActiveStorage").getAMethodCall("video_preview_arguments=")
    }

    override DataFlow::Node getAnArgument() { result = this.getArgument(0) }
  }

  /**
   * `ActiveStorage.variant_processor` is passed to `const_get`.
   */
  private class VariantProcessor extends DataFlow::CallNode, CodeExecution::Range {
    VariantProcessor() {
      this = API::getTopLevelMember("ActiveStorage").getAMethodCall("variant_processor=")
    }

    override DataFlow::Node getCode() { result = this.getArgument(0) }
  }

  /**
   * Adds ActiveStorage instances to the API graph.
   * Source code may not mention `ActiveStorage` or `ActiveStorage::Attachment`,
   * so we add synthetic nodes for them.
   */
  private module ApiNodes {
    class ActiveStorage extends API::EntryPoint {
      ActiveStorage() { this = "ActiveStorage" }

      override predicate edge(API::Node pred, API::Label::ApiLabel lbl) {
        pred = API::root() and lbl = API::Label::member("ActiveStorage")
      }
    }

    class Attachment extends API::EntryPoint {
      Attachment() { this = "ActiveStorage::Attachment" }

      override predicate edge(API::Node pred, API::Label::ApiLabel lbl) {
        pred = API::getTopLevelMember("ActiveStorage") and
        lbl = API::Label::member("Attachment")
      }
    }

    class AttachmentNew extends API::EntryPoint {
      AttachmentNew() { this = "ActiveStorage::Attachment.new" }

      override predicate edge(API::Node pred, API::Label::ApiLabel lbl) {
        pred = API::getTopLevelMember("ActiveStorage").getMember("Attachment") and
        lbl = API::Label::method("new")
      }
    }

    /**
     * An API entry point for instances of `ActiveStorage::Attachment`.
     * These arise from calls to methods generated by `has_one_attached` and
     * `has_many_attached` associations.
     */
    class AttachmentInstanceNode extends API::EntryPoint {
      AttachmentInstanceNode() { this = "ActiveStorage::Attachment.new.ReturnValue" }

      override predicate edge(API::Node pred, API::Label::ApiLabel lbl) {
        pred = API::getTopLevelMember("ActiveStorage").getMember("Attachment").getMethod("new") and
        lbl = API::Label::return()
      }

      override DataFlow::LocalSourceNode getAUse() { result = any(AttachmentInstance i) }

      override DataFlow::CallNode getACall() {
        any(AttachmentInstance i).flowsTo(result.getReceiver())
      }
    }
  }
}
