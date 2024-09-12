fn main() -> i64 {
    if "foo" == "bar" {
        decrement(0)
    } else {
        decrement(5)
    }
}

fn next(n: i64) -> i64 {
    if n % 2 == 0 {
        n / 2
    } else {
        3 * n + 1
    }
}

fn spin(n: i64) -> bool {
    let mut i = n;
    loop {
        i = next(i);
        if i == 1 {
            break;
        }
        if i % 2 != 0 {
            continue;
        }
        i = i / 2
    }
    return true;
}

fn decrement(n: i64) -> i64 {
    if n <= 0 {
        0
    } else {
        n - 1
    }
}
