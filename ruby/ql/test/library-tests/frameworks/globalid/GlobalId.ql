import codeql.ruby.frameworks.GlobalId

query predicate locateCalls(GlobalId::Locator::LocateCall c) { any() }

query predicate locateSignedCalls(GlobalId::Locator::LocateSignedCall c) { any() }

query predicate toGlobalIdCalls(GlobalId::Identification::ToGlobalIdCall c) { any() }

query predicate toGidParamCalls(GlobalId::Identification::ToGidParamCall c) { any() }

query predicate toSignedGlobalIdCalls(GlobalId::Identification::ToSignedGlobalIdCall c) { any() }

query predicate toSgidParamCalls(GlobalId::Identification::ToSgidParamCall c) { any() }

query predicate globalIdParseCalls(GlobalId::ParseCall c) { any() }

query predicate globalIdFindCalls(GlobalId::FindCall c) { any() }

query predicate signedGlobalIdParseCalls(SignedGlobalId::ParseCall c) { any() }

query predicate signedGlobalIdFindCalls(SignedGlobalId::FindCall c) { any() }
