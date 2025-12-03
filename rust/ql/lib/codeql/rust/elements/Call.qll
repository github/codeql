/**
 * This module provides the public classes `Call` and `MethodCall`.
 */

private import rust
private import internal.CallImpl
private import internal.CallExprImpl::Impl as CallExprImpl

final class Call = Impl::Call;

final class MethodCall = Impl::MethodCall;
