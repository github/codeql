func conditionalIfElse() {
    // The same variable is declared in _two_ branches.
    #if DEBUG
        let inCond = 1  // name=debugValue
    #else
        let inCond = 2  // name=releaseValue
        print("release")
    #endif
    print(inCond)  // $ MISSING: access=debugValue access=releaseValue
}

func conditionalIfElseifElse() {
    // The same variable is declared in _three_ branches.
    #if DEBUG
        let alternative = 1  // name=debugValue
    #elseif RELEASE
        let alternative = 2  // name=releaseValue
        print(alternative)  // $ MISSING: access=releaseValue
    #else
        let alternative = 3  // name=fallbackValue
        print(alternative)  // $ MISSING: access=fallbackValue
    #endif
    print(alternative)  // $ MISSING: access=debugValue access=releaseValue access=fallbackValue
}

func conditionalNoElse(value: Int) {  // name=outerValue
    // The variable is declared only in one skipable branch.
    #if DEBUG
        let value = value + 1  // $ MISSING: access=outerValue // name=conditionalValue
        print(value)  // $ MISSING: access=conditionalValue
    #endif
    print(value)  // $ access=outerValue MISSING: access=conditionalValue
}

func conditionalIfNesting(nesting: Int) {  // name=nestingFirst
    // Nested conditional compilation.
    #if DEBUG
        #if EXTRA
            print(nesting)  // $ MISSING: access=nestingFirst
            let nesting = nesting + 1  // $ MISSING: access=nestingFirst // name=nestingExtra
        #else
            let nesting = 2  // name=nestingNotExtra
        #endif
        print(nesting)  // $ MISSING: access=nestingExtra access=nestingNotExtra
    #else
        let nesting = 3  // name=outerNotDebug
    #endif
    print(nesting)  // $ MISSING: access=nestingExtra access=nestingNotExtra access=outerNotDebug SPURIOUS: access=nestingFirst
}

func conditionalRealScopes() {
    // Conditional compilation, but variables are declared in a real scope.
    let value = 0  // name=realOuterValue
    #if DEBUG
        if true {
            let value = 1  // name=runtimeValue
            print(value)  // $ MISSING: access=runtimeValue
        }
    #endif
    print(value)  // $ access=realOuterValue
}

func conditionalGuard(opt: Int?) {  // name=guardOpt
    #if DEBUG
        guard let value = opt else { return }  // $ MISSING: access=guardOpt // name=guardValue
        print(value)  // $ MISSING: access=guardValue
    #else
        guard let value = opt else { return }  // $ MISSING: access=guardOpt // name=fallbackGuardValue
    #endif
    print(value)  // $ MISSING: access=guardValue access=fallbackGuardValue
}

func conditionalSequentialBindings(value: Int) {  // name=sequentialOuter
    #if DEBUG
        print(value)  // $ MISSING: access=sequentialOuter
        let first = 1  // name=sequentialFirst
        print(first)  // $ MISSING: access=sequentialFirst
        let value = first + 1  // $ MISSING: access=sequentialFirst // name=sequentialSecond
        print(value)  // $ MISSING: access=sequentialSecond
    #else
        print(value)  // $ MISSING: access=sequentialOuter
    #endif
    print(value)  // $ access=sequentialOuter MISSING: access=sequentialSecond
}

func conditionalCapture() {
    #if DEBUG
        let value = 1  // $ MISSING: captured=capturedDebug // name=capturedDebug
    #else
        let value = 2  // $ MISSING: captured=capturedElse // name=capturedElse
    #endif
    let closure = {  // name=conditionalClosure
        print(value)  // $ MISSING: access=capturedDebug access=capturedElse
    }
    closure()  // $ access=conditionalClosure
}

func conditionalNestedFallback(value: Int) {  // name=nestedFallbackOuter
    #if DEBUG
        #if EXTRA
            let value = 1  // name=nestedFallbackExtra
        #else
        #endif
    #else
        print(value)  // $ MISSING: access=nestedFallbackOuter
    #endif
    print(value)  // $ access=nestedFallbackOuter MISSING: access=nestedFallbackExtra
}
