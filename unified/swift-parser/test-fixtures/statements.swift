func process(_ values: [Int]?, enabled: Bool) -> Int {
    guard let values = values, enabled else { return 0 }
    var total = 0
    for value in values where value > 0 {
        if value == 1 { continue }
        else if value == 2 { total += 2 }
        else { total += value }
    }
    while total < 10 { total += 1 }
    repeat { total -= 1 } while total > 10
    defer { print(total) }
    do { try run() } catch { print(error) }
    switch total {
    case 0, 1: return 1
    default: break
    }
    return total
}
