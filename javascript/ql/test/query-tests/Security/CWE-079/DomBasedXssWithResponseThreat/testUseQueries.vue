<script>
import { useQueries } from "@tanstack/vue-query";

export default {
  data() {
    const ids = [1, 2, 3]
    const results = useQueries({
    queries: ids.map((id) => ({
        queryKey: ['post', id],
        queryFn: async () => {
            const response = await fetch("${id}"); // $ Source
            return response.json();
        },
        staleTime: Infinity,
    })),
    });
    
    return { data2 : results[0].data };
  }
}
</script>

<template>
  <VueQueryClientProvider :client="queryClient">
    <div v-html="data2"></div> <!--$ Alert -->
  </VueQueryClientProvider>
</template>
