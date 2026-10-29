import { QueryClient, injectQuery } from '@tanstack/angular-query-experimental'
import { HttpClient } from '@angular/common/http'   

class ServiceOrComponent {
    query = injectQuery(() => ({
      queryKey: ['repoData'],
      queryFn: () =>
        this.#http.get<Response>('https://api.github.com/repos/tanstack/query'), // $ Source
    }))

    #http: {
      get: <T>(url: string) => Promise<T>
    };

    constructor(http: HttpClient) {
      this.#http = http;
    }
    
    displayRepoDetails() {
      this.query.data.then(response => {
        document.getElementById('repoInfo').innerHTML = response.description; // $ Alert
        
        const detailsElement = document.createElement('div');
        detailsElement.innerHTML = `<h2>${response.name}</h2><p>${response.owner.bio}</p>`;  // $ Alert
        document.body.appendChild(detailsElement);
      });
    }
}

interface Response {
  name: string;
  description: string;
  stargazers_count: number;
  owner: {
    bio: string;
  }
}
