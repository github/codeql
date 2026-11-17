@available(EnabledDomain)
@available(*, unavailable)
func onlyDomain() {}
@available(EnabledDomain, *)
func macroDomain() {}
@available(EnabledDomain, unavailable)
func unavailableDomain() {}
@available(swift 6.2)
@available(_PackageDescription, introduced: 3.0, deprecated: 4.2, obsoleted: 5.0)
func checkDomains() {
    if #available(EnabledDomain) {}
    if #available(EnabledDomain, *) {}
    if #unavailable(DisabledDomain) {}
}
