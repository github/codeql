func conditionalIfElse() {
    // The same variable is declared in _two_ branches.
    #if DEBUG
        let inCond = 1  // name=debugValue
    #else
        let inCond = 2  // name=releaseValue
        print("release")
    #endif
    print(inCond)  // $ access=debugValue access=releaseValue
}

func conditionalIfElseifElse() {
    // The same variable is declared in _three_ branches.
    #if DEBUG
        let alternative = 1  // name=debugValue
    #elseif RELEASE
        let alternative = 2  // name=releaseValue
        print(alternative)  // $ access=releaseValue
    #else
        let alternative = 3  // name=fallbackValue
        print(alternative)  // $ access=fallbackValue
    #endif
    print(alternative)  // $ access=debugValue access=releaseValue access=fallbackValue
}

func conditionalNoElse(value: Int) {  // name=outerValue
    // The variable is declared only in one skipable branch.
    #if DEBUG
        let value = value + 1  // $ access=outerValue // name=conditionalValue
        print(value)  // $ access=conditionalValue
    #endif
    print(value)  // $ access=outerValue access=conditionalValue
}

func conditionalIfNesting(nesting: Int) {  // name=nestingFirst
    // Nested conditional compilation.
    #if DEBUG
        #if EXTRA
            print(nesting)  // $ access=nestingFirst
            let nesting = nesting + 1  // $ access=nestingFirst // name=nestingExtra
        #else
            let nesting = 2  // name=nestingNotExtra
        #endif
        print(nesting)  // $ access=nestingExtra access=nestingNotExtra
    #else
        let nesting = 3  // name=outerNotDebug
    #endif
    print(nesting)  // $ access=nestingExtra access=nestingNotExtra access=outerNotDebug
}

func conditionalRealScopes() {
    // Conditional compilation, but variables are declared in a real scope.
    let value = 0  // name=realOuterValue
    #if DEBUG
        if true {
            let value = 1  // name=runtimeValue
            print(value)  // $ access=runtimeValue
        }
    #endif
    print(value)  // $ access=realOuterValue
}

func conditionalGuard(opt: Int?) {  // name=guardOpt
    #if DEBUG
        guard let value = opt else { return }  // $ access=guardOpt // name=guardValue
        print(value)  // $ access=guardValue
    #else
        guard let value = opt else { return }  // $ access=guardOpt // name=fallbackGuardValue
    #endif
    print(value)  // $ access=guardValue access=fallbackGuardValue
}

func conditionalSequentialBindings(value: Int) {  // name=sequentialOuter
    #if DEBUG
        print(value)  // $ access=sequentialOuter
        let first = 1  // name=sequentialFirst
        print(first)  // $ access=sequentialFirst
        let value = first + 1  // $ access=sequentialFirst // name=sequentialSecond
        print(value)  // $ access=sequentialSecond
    #else
        print(value)  // $ access=sequentialOuter
    #endif
    print(value)  // $ access=sequentialSecond access=sequentialOuter
}

func conditionalCapture() {
    #if DEBUG
        let value = 1  // $ captured=capturedDebug // name=capturedDebug
    #else
        let value = 2  // $ captured=capturedElse // name=capturedElse
    #endif
    let closure = {  // name=conditionalClosure
        print(value)  // $ access=capturedDebug access=capturedElse
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
        print(value)  // $ access=nestedFallbackOuter
    #endif
    print(value)  // $ access=nestedFallbackOuter access=nestedFallbackExtra
}
