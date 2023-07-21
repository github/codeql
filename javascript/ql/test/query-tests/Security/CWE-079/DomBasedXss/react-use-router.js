import { useRouter } from 'next/router'

export function nextRouter() {
  const router = useRouter();
  return (
    <div>
      <span onClick={() => {
        router.push(router.query.foobar) // NOT OK
      }}>Click to XSS 1</span>
      <span onClick={() => {
        router.replace(router.query.foobar) // NOT OK
      }}>Click to XSS 2</span>
      <span onClick={() => {
        router.push('/?foobar=' + router.query.foobar) // OK
      }}>Safe Link</span>
    </div>
  )
}

import { withRouter } from 'next/router'

function Page({ router }) {
  return <span onClick={() => router.push(router.query.foobar)}>Click to XSS 3</span> // NOT OK
}
export const pageWithRouter = withRouter(Page);

import { myUseRouter } from './react-use-router-lib';
export function nextRouterWithLib() {
  const router = myUseRouter()
  return (
    <div>
      <span onClick={() => {
        router.push(router.query.foobar) // NOT OK
      }}>Click to XSS 1</span>
    </div>
  )
}
