import { useQueries } from '@tanstack/react-query';

const fetchRepoData = async () => {
  const response = await fetch('https://example.com'); // $ MISSING: Source
  return response.json();
};

async function fetchPost() {
    const response = await fetch("www.example.com"); // $ MISSING: Source
    return response.json();
}

export default function UseQueriesComponent() {
  const results = useQueries({
    queries: [
      {
        queryKey: ['repoData'],
        queryFn: fetchRepoData,
      },
      {
        queryKey: ['repoData'],
        queryFn: () => fetchPost,
      },
    ],
  });

  const repoQuery = results[0];

  if (repoQuery.isLoading) return <p>Loading...</p>;
  if (repoQuery.isError) return <p>Error: {repoQuery.error.message}</p>;

  return (
    <div>
        <h1>Content with Dangerous HTML</h1>
        <div
            dangerouslySetInnerHTML={{
                __html: repoQuery.data, // $ MISSING: Alert
            }}
        />
    </div>
);
}
