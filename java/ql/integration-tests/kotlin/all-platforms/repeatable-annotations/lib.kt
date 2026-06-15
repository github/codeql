@Repeatable
public annotation class LibRepeatable { }

annotation class KtDefinedContainer(val value: Array<ExplicitContainerRepeatable>) { }

@java.lang.annotation.Repeatable(KtDefinedContainer::class)
annotation class ExplicitContainerRepeatable() { }
