import axios from "axios";

let api = axios.create({
    baseURL: "https://api.github.com",
    timeout: 1000,
    responseType: "json",
    headers: { "X-Custom-Header": "foobar" }
});

export default api;

export async function getRepo(owner: string, repo: string) {
    api
      .get(`/repos/${owner}/${repo}`)
      .then((response) => {
        console.log("Repository data:", response.data);
        return response.data;
      })
      .catch((error) => {
        console.error("Error fetching user:", error);
      });
}

export async function updateUser(owner: string, repo: string, data: any) {
    api
      .patch(`/repos/${owner}/${repo}`, data)
      .then((response) => {
        console.log("User updated:", response.data);
      })
      .catch((error) => {
        console.error("Error updating user:", error);
      });
}
