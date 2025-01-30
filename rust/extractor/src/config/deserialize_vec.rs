use serde::de::Visitor;
use serde::Deserializer;
use std::fmt::Formatter;
use std::marker::PhantomData;

// phantom data ise required to allow parametrizing on `T` without actual `T` data
struct VectorVisitor<T: From<String>>(PhantomData<T>);

impl<T: From<String>> VectorVisitor<T> {
    fn new() -> Self {
        VectorVisitor(PhantomData)
    }
}

impl<'de, T: From<String>> Visitor<'de> for VectorVisitor<T> {
    type Value = Vec<T>;

    fn expecting(&self, formatter: &mut Formatter) -> std::fmt::Result {
        formatter.write_str("either a sequence, or a comma or newline separated string")
    }

    fn visit_str<E: serde::de::Error>(self, value: &str) -> Result<Vec<T>, E> {
        Ok(value
            .split(['\n', ','])
            .map(|s| T::from(s.to_owned()))
            .collect())
    }

    fn visit_seq<A>(self, mut seq: A) -> Result<Vec<T>, A::Error>
    where
        A: serde::de::SeqAccess<'de>,
    {
        let mut ret = Vec::new();
        while let Some(el) = seq.next_element::<String>()? {
            ret.push(T::from(el));
        }
        Ok(ret)
    }
}

/// deserialize into a vector of `T` either of:
/// * a sequence of elements serializable into `String`s, or
/// * a single element serializable into `String`, then split on `,` and `\n`
///
/// This is required to be in scope when the `extractor_cli_config` macro is used.
pub(crate) fn deserialize_newline_or_comma_separated<'a, D: Deserializer<'a>, T: From<String>>(
    deserializer: D,
) -> Result<Vec<T>, D::Error> {
    deserializer.deserialize_seq(VectorVisitor::new())
}
