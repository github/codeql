export default function Post() {
    return <span />;
}

Post.getInitialProps = async (ctx) => {
    const req = ctx.req;
    const res = ctx.res;
    res.end(req.url);
    return {}
}

export async function getServerSideProps(ctx) {
    const req = ctx.req;
    const res = ctx.res;
    res.end(req.url);
    return {
        props: {}
    }
}