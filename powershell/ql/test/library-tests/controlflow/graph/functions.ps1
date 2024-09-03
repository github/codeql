Function Add-Numbers-Arguments {
    # We take in two numbers
    param(
        [int] $number1,
        [int] $number2
    )
    # We add them together
    $number1 + $number2
}

function foo() { param($a) }

Function Default-Arguments {
    param(
        [int] $name0,
        [int] $name1 = 0,
        [int] $name2 = $name1 + 1
    )
    $name + $name2
}

Function Add-Numbers-From-Array {
    # We take in a list of numbers
    param(
        [int[]] $numbers
    )
    
    $sum = 0
    foreach ($number in $numbers) {
        # We add each number to the sum
        $sum += $number
    }
    $sum
}

Function Add-Numbers-From-Pipeline {
    # We take in a list of numbers
    param(
        [int[]] $numbers
    )
    Begin {
        $sum = 0
    }
    Process {
        # We add each number to the sum
        $sum += $_
    }
    End {
        # We return the sum
        $sum
    }
}

