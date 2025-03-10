import { useRouter } from 'next/router'

export default function Post(params) {
  const router = useRouter()
  const { id } = router.query // $ Source

  return (
    <>
      <div
        dangerouslySetInnerHTML={{ __html: id }} // $ Alert
      />
      <div
        dangerouslySetInnerHTML={{ __html: params.id }} // $ Alert
      />
      <div
        dangerouslySetInnerHTML={{ __html: params.q }} // $ Alert
      />
    </>
  )
}

export async function getServerSideProps(context) {
  return {
    props: {
      id: context.params.id || "", // $ Source
      q: context.query?.foobar || "", // $ Source
    }
  }
}
