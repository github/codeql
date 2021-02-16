export async function getStaticPaths() {
    return {
        paths: [],
        fallback: true
    }
}


export async function getStaticProps({ params }) {
    return {
        props: {
            id: params.id,
            taint: source()
        }
    }
}

export default function Post({ taint, stars }) {
    sink(taint);
    sink(stars);
    return <span />;
}

Post.getInitialProps = async (ctx) => {
    return { stars: source(2) }
}