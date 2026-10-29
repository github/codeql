/// Contains type-specialized versions of
///
/// ```
/// impl<T, I, const N: usize> Index<I> for [T; N]
/// where
///     [T]: Index<I>,
/// {
///     type Output = <[T] as Index<I>>::Output;
///     ...
/// }
/// ```
///
/// and
///
/// ```
/// impl<T, I> ops::Index<I> for [T]
/// where
///     I: SliceIndex<[T]>,
/// {
///     type Output = I::Output;
///     ...
/// }
/// ```
///
/// and
/// ```
/// impl<T, I: SliceIndex<[T]>, A: Allocator> Index<I> for Vec<T, A> {
///     type Output = I::Output;
///     ...
/// }
/// ```
///
/// (as well as their `IndexMut` counterparts), which the type inference library
/// cannot currently handle (we fail to resolve the `Output` types).
mod index_impls {
    use std::alloc::Allocator;
    use std::ops::Index;

    impl<T, const N: usize> Index<i32> for [T; N] {
        type Output = T;

        fn index(&self, index: i32) -> &Self::Output {
            panic!()
        }
    }

    impl<T, const N: usize> IndexMut<i32> for [T; N] {
        type Output = T;

        fn index_mut(&mut self, index: i32) -> &mut Self::Output {
            panic!()
        }
    }

    impl<T, const N: usize> Index<usize> for [T; N] {
        type Output = T;

        fn index(&self, index: usize) -> &Self::Output {
            panic!()
        }
    }

    impl<T, const N: usize> IndexMut<usize> for [T; N] {
        type Output = T;

        fn index_mut(&mut self, index: usize) -> &mut Self::Output {
            panic!()
        }
    }

    impl<T> Index<i32> for [T] {
        type Output = T;

        fn index(&self, index: i32) -> &Self::Output {
            panic!()
        }
    }

    impl<T> IndexMut<i32> for [T] {
        type Output = T;

        fn index_mut(&mut self, index: i32) -> &mut Self::Output {
            panic!()
        }
    }

    impl<T> Index<usize> for [T] {
        type Output = T;

        fn index(&self, index: usize) -> &Self::Output {
            panic!()
        }
    }

    impl<T> IndexMut<usize> for [T] {
        type Output = T;

        fn index_mut(&mut self, index: usize) -> &mut Self::Output {
            panic!()
        }
    }

    impl<T, A: Allocator> Index<i32> for Vec<T, A> {
        type Output = T;

        fn index(&self, index: i32) -> &Self::Output {
            panic!()
        }
    }

    impl<T, A: Allocator> IndexMut<i32> for Vec<T, A> {
        type Output = T;

        fn index_mut(&mut self, index: i32) -> &mut Self::Output {
            panic!()
        }
    }

    impl<T, A: Allocator> Index<usize> for Vec<T, A> {
        type Output = T;

        fn index(&self, index: usize) -> &Self::Output {
            panic!()
        }
    }

    impl<T, A: Allocator> IndexMut<usize> for Vec<T, A> {
        type Output = T;

        fn index_mut(&mut self, index: usize) -> &mut Self::Output {
            panic!()
        }
    }
}
