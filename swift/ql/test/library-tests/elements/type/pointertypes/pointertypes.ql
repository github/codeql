import swift
import codeql.swift.frameworks.StandardLibrary.PointerTypes

string describe(Type t) {
  t instanceof BuiltinRawPointerType and result = "BuiltinRawPointerType"
  or
  t instanceof UnsafeTypedPointerType and result = "UnsafeTypedPointerType"
  or
  t instanceof UnsafeRawPointerType and result = "UnsafeRawPointerType"
  or
  t instanceof OpaquePointerType and result = "OpaquePointerType"
  or
  t instanceof AutoreleasingUnsafeMutablePointerType and
  result = "AutoreleasingUnsafeMutablePointerType"
  or
  t instanceof UnmanagedType and result = "UnmanagedType"
  or
  t instanceof CVaListPointerType and result = "CVaListPointerType"
  or
  t instanceof ManagedBufferPointerType and result = "ManagedBufferPointerType"
}

from VarDecl v, Type t
where
  v.getLocation().getFile().getBaseName() != "" and
  t = v.getType()
select v, t.toString(), strictconcat(describe(t), ", ")
