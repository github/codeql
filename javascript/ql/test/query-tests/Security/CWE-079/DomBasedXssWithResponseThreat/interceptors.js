const express = require("express");
const axios = require("axios");

const app = express();

axios.interceptors.response.use(
    (response) => { // $ Source
        const userGeneratedHtml = response.data;
        document.getElementById("content").innerHTML = userGeneratedHtml; // $ Alert
        return response;
    },
    (error) => {
        return Promise.reject(error);
    }
);

app.post("/fetch", (req, res) => {
    const { url } = req.body;
    axios.get(url);
});
