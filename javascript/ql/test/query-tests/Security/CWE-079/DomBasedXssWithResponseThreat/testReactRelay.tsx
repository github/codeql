import React from 'react';
import { useFragment } from 'react-relay';

const CommentComponent = ({ commentRef }) => {
  const commentData = useFragment(
    graphql`
      fragment CommentComponent_comment on Comment {
        id
        text
      }
    `,
    commentRef
  ); // $ MISSING: Source=[js/xss]

  return (
    <div>
      <h3>Comment:</h3>
      {/* Directly rendering user input without sanitation */}
      <p dangerouslySetInnerHTML = {{ __html: commentData.text}}> {commentData.text}</p> // $ MISSING: Alert=[js/xss]
    </div> 
  );
};
