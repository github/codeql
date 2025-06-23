namespace __attribute__((deprecated)) NamespaceTest {}
namespace __attribute__((deprecated)) NamespaceTest {}
namespace __attribute__((maybe_unused)) NamespaceTest {}
namespace __attribute__((deprecated, maybe_unused)) MultiAttr {}
namespace OuterNamespace {
    namespace __attribute__((deprecated)) InnerNamespace {}
}

namespace [[deprecated("NamespaceSquared")]] NamespaceSquared {}
namespace [[deprecated, maybe_unused]] MultiSquared {}
namespace [[deprecated, maybe_unused]] MultiSquared {}