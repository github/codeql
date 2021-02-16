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

export default function Post({ taint, stars, more }) {
    sink(taint);
    sink(stars);
    sink(more);
    return <span />;
}

Post.getInitialProps = async (ctx) => {
    return { stars: source(2) }
}

export async function getServerSideProps(ctx) {
    return {
        props: {
            more: source(3)
        }
    }
}