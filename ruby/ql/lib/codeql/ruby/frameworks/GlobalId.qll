/**
 * Provides modeling for `GlobalID`, a library for identifying model instances by URI.
 * Version: 1.0.0
 * https://github.com/rails/globalid
 */

private import codeql.ruby.ApiGraphs
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.frameworks.ActiveRecord

/**
 * Provides modeling for `GlobalID`, a library for identifying model instances by URI.
 * Version: 1.0.0
 * https://github.com/rails/globalid
 */
module GlobalId {
  /** A call to `GlobalID::parse` */
  class ParseCall extends DataFlow::CallNode {
    ParseCall() { this = API::getTopLevelMember("GlobalID").getAMethodCall("parse") }
  }

  /** A call to `GlobalID::find` */
  class FindCall extends DataFlow::CallNode, OrmInstantiation::Range {
    FindCall() { this = API::getTopLevelMember("GlobalID").getAMethodCall("find") }

    override predicate methodCallMayAccessField(string methodName) { none() }
  }

  /** `GlobalID::Locator` */
  module Locator {
    /** A call to `GlobalID::Locator.locate` */
    class LocateCall extends DataFlow::CallNode, OrmInstantiation::Range {
      LocateCall() {
        this = API::getTopLevelMember("GlobalID").getMember("Locator").getAMethodCall("locate")
      }

      override predicate methodCallMayAccessField(string methodName) { none() }
    }

    /** A call to `GlobalID::Locator.locate_signed` */
    class LocateSignedCall extends DataFlow::CallNode, OrmInstantiation::Range {
      LocateSignedCall() {
        this =
          API::getTopLevelMember("GlobalID").getMember("Locator").getAMethodCall("locate_signed")
      }

      override predicate methodCallMayAccessField(string methodName) { none() }
    }

    /** A call to `GlobalID::Locator.locate_many` */
    class LocateManyCall extends DataFlow::CallNode, OrmInstantiation::Range {
      LocateManyCall() {
        this = API::getTopLevelMember("GlobalID").getMember("Locator").getAMethodCall("locate_many")
      }

      override predicate methodCallMayAccessField(string methodName) { none() }
    }

    /** A call to `GlobalID::Locator.locate_many_signed` */
    class LocateManySignedCall extends DataFlow::CallNode, OrmInstantiation::Range {
      LocateManySignedCall() {
        this =
          API::getTopLevelMember("GlobalID")
              .getMember("Locator")
              .getAMethodCall("locate_many_signed")
      }

      override predicate methodCallMayAccessField(string methodName) { none() }
    }
  }

  // TODO: methods in this module are available to any class that includes it, not just ActiveRecord models
  /** `GlobalID::Identification` */
  module Identification {
    /** A call to `GlobalID::Identification.to_global_id` */
    class ToGlobalIdCall extends ActiveRecordInstanceMethodCall {
      ToGlobalIdCall() { this.getMethodName() = ["to_global_id", "to_gid"] }
    }

    /** A call to `GlobalID::Identification.to_gid_param` */
    class ToGidParamCall extends ActiveRecordInstanceMethodCall {
      ToGidParamCall() { this.getMethodName() = "to_gid_param" }
    }

    /** A call to `GlobalID::Identification.to_signed_global_id` */
    class ToSignedGlobalIdCall extends ActiveRecordInstanceMethodCall {
      ToSignedGlobalIdCall() { this.getMethodName() = ["to_signed_global_id", "to_sgid"] }
    }

    /** A call to `GlobalID::Identification.to_sgid_param` */
    class ToSgidParamCall extends ActiveRecordInstanceMethodCall {
      ToSgidParamCall() { this.getMethodName() = "to_sgid_param" }
    }
  }
}

/** Provides modeling for `SignedGlobalID`, a module of the `rails/globalid` library. */
module SignedGlobalId {
  /** A call to `SignedGlobalID::parse` */
  class ParseCall extends DataFlow::CallNode {
    ParseCall() { this = API::getTopLevelMember("SignedGlobalID").getAMethodCall("parse") }
  }

  /** A call to `SignedGlobalID::find` */
  class FindCall extends DataFlow::CallNode, OrmInstantiation::Range {
    FindCall() { this = API::getTopLevelMember("SignedGlobalID").getAMethodCall("find") }

    override predicate methodCallMayAccessField(string methodName) { none() }
  }
}
