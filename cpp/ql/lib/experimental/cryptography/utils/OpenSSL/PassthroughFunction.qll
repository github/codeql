import cpp
import experimental.cryptography.utils.OpenSSL.LibraryFunction
import semmle.code.cpp.ir.dataflow.DataFlow

// TODO: possible use of extensible predicates here
// NOTE: -1 for outInd represents the return value
predicate knownPassthroughFunction(Function f, int inInd, int outInd) {
  // Trace through functions
  // See https://www.openssl.org/docs/man1.1.1/man3/OBJ_obj2txt
  //     https://www.openssl.org/docs/man3.0/man3/EVP_CIPHER_get0_name
  openSSLLibraryFunc(f) and
  (
    f.getName() in [
        "OBJ_nid2obj", "OBJ_nid2ln", "OBJ_nid2sn", "OBJ_obj2nid", "OBJ_ln2nid", "OBJ_sn2nid",
        "OBJ_txt2nid", "OBJ_txt2obj", "OBJ_dup", "EVP_CIPHER_get0_name"
      ] and
    inInd = 0 and
    outInd = -1
    or
    f.getName() in ["OBJ_obj2txt", "i2t_ASN1_OBJECT"] and
    inInd = 2 and
    outInd = 0
    or
    // Dup/copy pattern occurs in more places,
    //see: https://www.openssl.org/docs/manmaster/man3/EC_KEY_copy.html and https://www.openssl.org/docs/manmaster/man3/EVP_PKEY_CTX_dup.html
    f.getName().matches("%_dup") and inInd = 0 and outInd = -1
    or
    f.getName().matches("%_copy") and inInd = 0 and outInd = -1
  )
}

/**
 * `c` is a call to a function that preserves the algorithm but changes its form.
 * `onExpr` is the input argument passing through to, `outExpr` is the next expression in a dataflow step associated with `c`
 */
predicate knownPassthoughCall(Call c, Expr inExpr, Expr outExpr) {
  exists(int inInd, int outInd |
    knownPassthroughFunction(c.getTarget(), inInd, outInd) and
    inExpr = c.getArgument(inInd) and
    if outInd = -1 then outExpr = c else outExpr = c.getArgument(outInd)
  )
}

/*
 * Explicitly add flow through openssl functions that preserve the algorithm but alter the form (e.g., from NID to string)
 */

predicate knownPassThroughStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(Expr cur, Expr next |
    (cur = node1.asExpr() or cur = node1.asIndirectArgument()) and
    (
      next = node2.asExpr() or
      next = node2.asIndirectArgument() or
      next = node2.asDefiningArgument()
    )
  |
    exists(Call c | knownPassthoughCall(c, cur, next))
  )
}
