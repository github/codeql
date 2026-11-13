use std::cmp::Ordering;

/// Compares options using a custom comparator, with `None` ordered before `Some`.
pub(crate) fn cmp_option_by<T>(
    left: &Option<T>,
    right: &Option<T>,
    compare: impl FnOnce(&T, &T) -> Ordering,
) -> Ordering {
    match (left, right) {
        (Some(left), Some(right)) => compare(left, right),
        (Some(_), None) => Ordering::Greater,
        (None, Some(_)) => Ordering::Less,
        (None, None) => Ordering::Equal,
    }
}
