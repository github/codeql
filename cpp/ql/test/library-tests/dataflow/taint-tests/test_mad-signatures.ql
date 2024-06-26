import cpp
import semmle.code.cpp.dataflow.ExternalFlow
import ExternalFlowDebug

query predicate signatureMatches = signatureMatches_debug/5;

query predicate getSignatureParameterName = getSignatureParameterName_debug/4;

query predicate getParameterTypeName = getParameterTypeName_debug/2;
