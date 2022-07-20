private import python
private import semmle.python.dataflow.new.DataFlow
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for Python's Cryptography-related libraries.
 */
private module Cryptographyimpl {
  private string hashName() {
  result = ["sha1", "sha224", "sha256", "sha384", "sha512", "blake2b", "blake2s", "md5"]
  }
  
  /** Gets a reference to the `hmac` module. */
  API::Node hmac() { result = API::moduleImport("hmac") }
  
  /** Gets a reference to the `hashlib` module. */
  API::Node hashlib() { result = API::moduleImport("hashlib") }

   /**
   * A hashing operation by supplying initial data when calling the `hmac.new` function.
   */ 
  private class HmaclibNewCall extends DataFlow::CallCfgNode, CryptographicOperation::Range {
    HmaclibNewCall() { this = hmac().getMember("new").getACall() }
    
    override DataFlow::Node getAnInput() {
      result in [this.getArg(1), this.getArgByName("msg")]
    }
  }
  
   /**
   * A hashing operation by supplying initial data when calling the prdifined functions in `hashlib` package (such as `hashlib.md5`)
   */ 
  private class HashlibHashCall extends DataFlow::CallCfgNode, CryptographicOperation::Range {
    HashlibHashCall() {
      this = hashlib().getMember(hashName()).getACall()
    }
    
    override DataFlow::Node getAnInput() { result = this.getArg(0) }
  }
  
   /**
   * A hashing operation by supplying initial data when calling the `hashlib.new` function.
   */ 
  private class HashlibNewCall extends DataFlow::CallCfgNode, CryptographicOperation::Range {
    HashlibNewCall() {
      this = hashlib().getMember("new").getACall()
    }
    
    override DataFlow::Node getAnInput() {
      result in [this.getArg(1), this.getArgByName("data")]
    }
  }

  /**
   * A hashing operation from the `hashlib` package using one of the predefined classes
   * (such as `hashlib.md5` or `hashlib.new`), by calling its' `update` mehtod.
   */
  private class HashlibHashClassUpdateCall extends DataFlow::CallCfgNode, CryptographicOperation::Range {
    HashlibHashClassUpdateCall() { this = hashlib().getMember([hashName(), "new"]).getReturn().getMember("update").getACall() }

    override DataFlow::Node getAnInput() { result = this.getArg(0) }
  }
  
  /**
   * A hashing operation from the `hmac` package using `hmac.new` class, by calling its' `update` mehtod.
   */ 
  private class HmaclibNewUpdateCall extends DataFlow::CallCfgNode, CryptographicOperation::Range {
    HmaclibNewUpdateCall() { this = hmac().getMember("new").getReturn().getMember("update").getACall() }
    
    override DataFlow::Node getAnInput() { result = this.getArg(0) }
  }
}
