fun usesEnum(e: Enum<*>) = e.ordinal.toString() + e.name

enum class E { A, B, C }
