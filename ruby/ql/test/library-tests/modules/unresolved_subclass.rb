class ResolvableBaseClass
end

class UnresolvedNamespace::Subclass1 < ResolvableBaseClass
end

class UnresolvedNamespace::Subclass2 < UnresolvedNamespace::Subclass1
end

# Ensure Object is a transitive superclass of this
class UnresolvedNamespace::A < UnresolvedNamespace::B
end

class UnresolvedNamespace::X1::X2::X3::Subclass1 < ResolvableBaseClass
end

class UnresolvedNamespace::X1::X2::X3::Subclass2 < UnresolvedNamespace::X1::X2::X3::Subclass1
end

# Ensure Object is a transitive superclass of this
class UnresolvedNamespace::X1::X2::X3::A < UnresolvedNamespace::X1::X2::X3::B
end
