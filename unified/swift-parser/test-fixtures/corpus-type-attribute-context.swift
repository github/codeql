extension TranslationSession: @retroactive @unchecked(Sendable) {}
extension Controller: @unchecked Sendable {}
let type: @preconcurrency @Sendable () -> Void
let callback = { (self: Self, _: TraitCollection) in self.update() }
func addressable(tuple: @_addressable (Item, Item)) {}
let annotatedTuple: Wrapper<@Custom (Item, Item)>
let customArgument: @Custom(Item) Other
