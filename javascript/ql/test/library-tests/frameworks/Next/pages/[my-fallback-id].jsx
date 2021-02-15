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

export default function Post({ taint }) {
    sink(taint);
    return <span />;
}
