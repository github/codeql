import { useRouter } from 'next/router'

export default function Post(params) {
  const router = useRouter()
  const { id } = router.query

  return (
    <>
      <div
        dangerouslySetInnerHTML={{ __html: id }} // NOT OK
      />
      <div
        dangerouslySetInnerHTML={{ __html: params.id }} // NOT OK
      />
      <div
        dangerouslySetInnerHTML={{ __html: params.q }} // NOT OK
      />
    </>
  )
}

export async function getServerSideProps(context) {
  return {
    props: {
      id: context.params.id || "",
      q: context.query?.foobar || "",
    }
  }
}
