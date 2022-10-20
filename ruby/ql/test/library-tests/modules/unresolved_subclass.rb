class ResolvableBaseClass
end

class UnresolvedNamespace::Subclass1 < ResolvableBaseClass
end

class UnresolvedNamespace::Subclass2 < UnresolvedNamespace::Subclass1
end
