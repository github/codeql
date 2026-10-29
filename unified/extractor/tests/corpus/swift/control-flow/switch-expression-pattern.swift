// Arbitrary expressions may appear in pattern context.
switch subject {
case value, value + offset, -value, lower...upper, makeValue(), makeValue().member,
    .inferred, (value, offset), [value], [key: value], optional?, try value,
    value!, value as Target, value is Target, await value:
    consume(value)
case condition ? value : fallback:
    consume(fallback)
default:
    break
}