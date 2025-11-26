export default function Page() {
    return <span />;
}

Page.getInitialProps = async (ctx) => {
    const req = ctx.req;
    const res = ctx.res;
    res.end(req.url); // $ Alert
    return {}
}

export async function getServerSideProps(ctx) {
    const req = ctx.req;
    const res = ctx.res;
    res.end(req.url); // $ Alert
    return {
        props: {}
    }
}
