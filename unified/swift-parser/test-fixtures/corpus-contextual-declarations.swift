func contextual() {
    macro = self.missingToken(.identifier)
    self.assumeIsolated { actor in
        actor.counter
        actor()
    }
    _local let localSelf = self
}
actor Counter {}
macro identity<T>(_ value: T) -> T = #externalMacro(module: "Macros", type: "Identity")
