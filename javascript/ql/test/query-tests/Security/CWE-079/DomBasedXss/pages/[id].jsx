export default function Post({ id, q }) {
  return (
    <>
      <div dangerouslySetInnerHTML={{__html: id }} />
      <div dangerouslySetInnerHTML={{__html: q }} />
    </>
  )
}

export async function getServerSideProps(context) {
  return {
    props: {
      id: context.params?.id || "",
      q: context.query?.foobar || "",
    }
  }
}
