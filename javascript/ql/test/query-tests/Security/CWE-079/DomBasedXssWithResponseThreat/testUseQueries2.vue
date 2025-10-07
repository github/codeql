<script>
import { useQueries } from "@tanstack/vue-query";
import { computed } from "vue";

const fetchContent = async () => {
    const response = await fetch("https://example.com/content"); // $ Source
    const data = await response.json();
    return data;
};

async function fetchPost() {
    const response = await fetch("${id}"); // $ Source
    return response.json();
}

export default {
  data() {
    const results = useQueries({
      queries: [
        {
          queryKey: ["post", 1],
          queryFn: fetchContent,
          staleTime: Infinity,
        },
        {
          queryKey: ["post", 2],
          queryFn: () => fetchPost(),
          staleTime: Infinity,
        },
      ],
    });

    return { data3 : results[0].data };
  },
};
</script>

<template>
  <VueQueryClientProvider :client="queryClient">
    <div v-html="data3"></div> <!--$ Alert -->
  </VueQueryClientProvider>
</template>
