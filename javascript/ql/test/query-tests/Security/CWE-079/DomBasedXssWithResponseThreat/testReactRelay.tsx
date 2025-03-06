import React, { useState } from "react";
import { useFragment } from 'react-relay';

const func1 = ({ commentRef, query }) => {
  const commentData = useFragment(query, commentRef); // $ Source=[js/xss]
  return (
    <p dangerouslySetInnerHTML={{ __html: commentData.text }}> // $ Alert=[js/xss]
      {" "}
      {commentData.text}
    </p>
  ); 
};

import { useLazyLoadQuery } from "react-relay";

function func2({ query }) {
  const data = useLazyLoadQuery(query, {}); // $ Missing: Source
  return <p dangerouslySetInnerHTML={{ __html: data.comments[0].text }} />; // $ Missing: Alert
}

import { useQueryLoader, usePreloadedQuery } from "react-relay";

function func3({ initialQueryRef, query }) {
  const [queryReference, loadQuery] = useQueryLoader(query, initialQueryRef);
  return (
    <h1
      dangerouslySetInnerHTML={{
        __html: usePreloadedQuery(query, queryReference).user?.name, // $ Missing: Alert
      }}
    />
  ); 
}

import { useClientQuery } from "react-relay";

function func4({ query }) {
  const data = useClientQuery(query, {}); // $ Missing: Source
  return <h1 dangerouslySetInnerHTML={{ __html: data }} />; // $ Missing: Alert
}

import { useRefetchableFragment } from "react-relay";

function func5({ query, props }) {
  const [data, refetch] = useRefetchableFragment(query, props.comment); // $ Missing: Source
  return (
    <>
      <h1 dangerouslySetInnerHTML={{ __html: data }} /> // $ Missing: Alert
      <Button
        onClick={() => {
          refetch({ lang: "SPANISH" }, { fetchPolicy: "store-or-network" });
        }}
      ></Button>
    </>
  );
}

import { usePaginationFragment } from "react-relay";

function func6({ query }) {
  const {
    data,
    loadNext,
    loadPrevious,
    hasNext,
    hasPrevious,
    isLoadingNext,
    isLoadingPrevious,
    refetch,
  } = usePaginationFragment(query, {}); // $ Missing: Source
  return <h1 dangerouslySetInnerHTML={{ __html: data }} />; // $ Missing: Alert
}


import { useMutation } from 'react-relay';
import type { FeedbackLikeMutation } from './FeedbackLikeMutation.graphql';

function func7(query) {
  const [commit, inFlight] = useMutation<FeedbackLikeMutation>(query);
  const [feedbackText, setFeedbackText] = useState('');
  
  commit({
    onCompleted(data) { // $ Missing: Source
      setFeedbackText(data);
    },
  });

  return (<div dangerouslySetInnerHTML={{__html: feedbackText, }}/>); // $ Missing: Alert
}

import { useSubscription } from 'react-relay';
import { useMemo } from 'react';

function func8({GroupLessonsSubscription}) {
  const [fragmentRef, setFragmentRef] = useState();

  const groupLessonConfig = useMemo(() => ({
    subscription: GroupLessonsSubscription,
    variables: {},
    onNext: (res) => { // $ Missing: Source
      setFragmentRef(res);
    },
    onError: (err) => {
      console.error('Error with subscription:', err);
    },
    onCompleted: () => {
      console.log('Subscription completed');
    },
  }), []);

  useSubscription(groupLessonConfig);

return (<div dangerouslySetInnerHTML={{__html: fragmentRef, }}/>); // $ Missing: Alert
}


import { fetchQuery } from 'react-relay'

function func9({query, environment}) {
  fetchQuery(environment, query,{id: 4},).subscribe({
    start: () => {},
    complete: () => {},
    error: (error) => {},
    next: (data) => { // $ Missing: Source
      const outputElement = document.getElementById('output');
      if (outputElement) {
        outputElement.innerHTML = data.user; // $ Missing: Alert
      }
    }
  });
}

import { readFragment } from "relay-runtime";

function func10({ query, key }) {
  const data = readFragment(query, key); // $ Missing: Source
  return (<h1 dangerouslySetInnerHTML={{ __html: data }} />); // $ Missing: Alert
}
