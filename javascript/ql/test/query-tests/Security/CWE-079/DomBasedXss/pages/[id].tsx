import type { GetServerSidePropsContext, GetStaticProps, GetStaticPropsContext, InferGetServerSidePropsType, InferGetStaticPropsType, NextPage } from 'next'

type Props = InferGetServerSidePropsType<typeof getServerSideProps>

const Home: NextPage<Props> = ({ id, url }) => {
  return (
    <>
      <div dangerouslySetInnerHTML={{__html: url }} />
      <div dangerouslySetInnerHTML={{__html: id }} />
    </>
  )
}


export function getServerSideProps(context: GetServerSidePropsContext<{ id: string, url: string }>) {
  return {
    props: {
      id: context.params?.id,
      url: decodeURIComponent(context.req.url || "")
    }
  }
}


export default Home
