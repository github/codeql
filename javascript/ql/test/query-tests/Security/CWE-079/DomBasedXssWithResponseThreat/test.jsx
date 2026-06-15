import React from "react";
import { useQuery } from "./wrapper";

const fetchContent = async () => {
    const response = await fetch("https://example.com/content"); // $ Source[js/xss]
    const data = await response.json();
    return data;
};

const getQueryOptions = () => {
    return {queryFn: fetchContent};
}

const ContentWithDangerousHtml = () => {
    const { data, error, isLoading } = useQuery(
        getQueryOptions()
    );

    if (isLoading) return <div>Loading...</div>;
    if (error) return <div>Error fetching content!</div>;

    return (
        <div>
            <h1>Content with Dangerous HTML</h1>
            <div
                dangerouslySetInnerHTML={{
                    __html: data, // $ Alert[js/xss]
                }}
            />
        </div>
    );
};

export default ContentWithDangerousHtml;
