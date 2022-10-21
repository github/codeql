class ResolvableBaseClass
end

class UnresolvedNamespace::Subclass1 < ResolvableBaseClass
end

class UnresolvedNamespace::Subclass2 < UnresolvedNamespace::Subclass1
end

# Ensure Object is a transitive superclass of this
class UnresolvedNamespace::A < UnresolvedNamespace::B
end
