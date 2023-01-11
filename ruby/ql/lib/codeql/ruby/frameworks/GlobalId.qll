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

  /** `GlobalID::Identification` */
  module Identification {
    /** A `DataFlow::CallNode` against an instance of a class that includes the `GlobalID::Identification` module */
    private class IdentificationInstanceCall extends DataFlow::CallNode {
      IdentificationInstanceCall() {
        this =
          DataFlow::getConstant("GlobalID")
              .getConstant("Identification")
              .getADescendentModule()
              .getAnImmediateReference()
              .getAMethodCall(["new", "find"])
              .getAMethodCall()
        or
        this instanceof ActiveRecordInstanceMethodCall
      }
    }

    /** A call to `GlobalID::Identification.to_global_id` */
    class ToGlobalIdCall extends IdentificationInstanceCall {
      ToGlobalIdCall() { this.getMethodName() = ["to_global_id", "to_gid"] }
    }

    /** A call to `GlobalID::Identification.to_gid_param` */
    class ToGidParamCall extends DataFlow::CallNode {
      ToGidParamCall() { this.getMethodName() = "to_gid_param" }
    }

    /** A call to `GlobalID::Identification.to_signed_global_id` */
    class ToSignedGlobalIdCall extends DataFlow::CallNode {
      ToSignedGlobalIdCall() { this.getMethodName() = ["to_signed_global_id", "to_sgid"] }
    }

    /** A call to `GlobalID::Identification.to_sgid_param` */
    class ToSgidParamCall extends DataFlow::CallNode {
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
