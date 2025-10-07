<script>
import { useQuery, VueQueryClientProvider } from "@tanstack/vue-query";


export default {
  data() {
    const { isPending, isError, isFetching, data, error } = useQuery({
      queryKey: ["post"],
      queryFn: async () => {
        const response = await fetch("https://jsonplaceholder.typicode.com/posts/1"); // $ Source
        return response.json();
      },
    });
    
    return { data : data };
  }
}
</script>

<template>
  <VueQueryClientProvider :client="queryClient">
    <div v-html="data"></div> <!--$ Alert[js/xss] -->
  </VueQueryClientProvider>
</template>
