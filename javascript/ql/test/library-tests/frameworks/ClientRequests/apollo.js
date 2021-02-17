import { ApolloClient } from 'apollo-client'
import { HttpLink } from 'apollo-link-http'
import { createHttpLink } from 'apollo-link-http'

const httpLink = new createHttpLink({ uri: 'https://api.github.com/graphql' }) // url 1

const ApolloClient = require('apollo-client-preset').ApolloClient;
const HttpLink = require('apollo-link-http').HttpLink;

new HttpLink({ uri: 'http://localhost:8080/graphql' }); // url 2

import ApolloClient from 'apollo-boost'; // / 'apollo-client'
 
const client = new ApolloClient({uri: 'https://graphql.example.com'}); // url 3

let PresetHttpLink = require('apollo-client-preset').HttpLink;
new PresetHttpLink({uri: "myurl"}); // url 4

import { createNetworkInterface } from 'apollo-client';
createNetworkInterface({uri: 'https://web-go-demo.herokuapp.com/__/graphql'}) // url 5

const { WebSocketLink } = require('apollo-link-ws')
new WebSocketLink({uri: wsUri}) // url 6