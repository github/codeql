import axios from "axios";

let api = axios.create({
    baseURL: "https://api.github.com",
    timeout: 1000,
    responseType: "json",
    headers: { "X-Custom-Header": "foobar" }
});

export default api;

export async function getRepo(owner: string, repo: string) {
    try {
        const response = await api.get(`/repos/${owner}/${repo}`);
        console.log("Repository data:", response.data);
        return response.data;
    } catch (error) {
        console.error("Error fetching repo:", error);
        throw error;
    }
}

export async function updateUser(owner: string, repo: string, data: any) {
    try {
        const response = await api.patch(`/repos/${owner}/${repo}`, data);
        console.log("User updated:", response.data);
        return response.data;
    } catch (error) {
        console.error("Error updating user:", error);
        throw error;
    }
}
