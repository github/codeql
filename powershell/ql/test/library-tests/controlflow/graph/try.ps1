function test-try-catch {
    try {
        Write-Output "Hello!";
    } catch {
        return 0;
    }
    return 1;
}

function test-try-with-throw-catch($b) {
    try {
        if($b) {
            throw 42;
        }
    } catch {
        return 0;
    }
    return 1;
}

function test-try-with-throw-catch-with-throw($b) {
    try {
        if($b) {
            throw 42;
        }
    } catch {
        throw "";
    }
    return 1;
}

function test-try-with-throw-catch-with-rethrow($b) {
    try {
        if($b) {
            throw 42;
        }
    } catch {
        throw;
    }
    return 1;
}

function test-try-catch-specific-1 {
    try {
        Write-Output "Hello!";
    } catch [System.Net.WebException] {
        return 0;
    }
    return 1;
}

function test-try-catch-specific-1 {
    try {
        Write-Output "Hello!";
    } catch [System.Net.WebException] {
        return 0;
    }
    return 1;
}

function test-try-two-catch-specific-1 {
    try {
        Write-Output "Hello!";
    } catch [System.Net.WebException] {
        return 0;
    } catch {
        return 1;
    }   
    return 2;
}

function test-try-catch-specific-2 {
    try {
        Write-Output "Hello!";
    } catch [System.Net.WebException, SystemMmanagement.Automation.MethodInvocationeEception] {
        return 0;
    }
    return 1;
}

function test-try-two-catch-specific-2 {
    try {
        Write-Output "Hello!";
    } catch [System.Net.WebException, SystemMmanagement.Automation.MethodInvocationeEception] {
        return 0;
    } catch [Exception] {
        return 1;
    }   
    return 2;
}

function test-try-three-catch-specific-2 {
    try {
        Write-Output "Hello!";
    } catch [System.Net.WebException, SystemMmanagement.Automation.MethodInvocationeEception] {
        return 0;
    } catch [Exception] {
        return 1;
    } catch {
        return 2;
    }
    return 3;
}

function test-try-catch-finally {
    try {
        Write-Output "Hello!";
    } catch {
        return 0;
    } finally {
        Write-Output "Finally!";
    }   
    return 1;
}

function test-try-finally {
    try {
        Write-Output "Hello!";
    } finally {
        Write-Output "Finally!";
    }   
    return 1;
}

function test-try-finally-catch-specific-1 {
    try {
        Write-Output "Hello!";
    } catch [System.Net.WebException] {
        return 0;
    } finally {
        Write-Output "Finally!";
    }
    return 1;
}

function test-nested-try-inner-finally {
    try {
        try {
            Write-Output "Hello!";
        } catch [System.Net.WebException] {
            return 0;
        }
    } catch {
        return 0;
    }
    return 1;
}

function test-nested-try-inner-finally {
    try {
        try {
            Write-Output "Hello!";
        } catch [System.Net.WebException] {
            return 0;
        } finally {
            Write-Output "Finally!";
        }
    } catch {
        return 0;
    }
    return 1;
}

function test-nested-try-outer-finally {
    try {
        try {
            Write-Output "Hello!";
        } catch [System.Net.WebException] {
            return 0;
        }
    } catch {
        return 0;
    } finally {
        Write-Output "Finally!";
    }
    return 1;
}

function test-nested-try-inner-outer-finally {
    try {
        try {
            Write-Output "Hello!";
        } catch [System.Net.WebException] {
            return 0;
        } finally {
            Write-Output "Finally!";
        }
    } catch {
        return 0;
    } finally {
        Write-Output "Finally!";
    }
    return 1;
}