import React from 'react';
import {useQuery} from "relay-hooks";
import { graphql } from 'babel-plugin-relay/macro';
import { AppQueryResponse } from './__generated__/AppQuery.graphql';

const App = () =>
{
  const result = useQuery<AppQueryResponse>({
    query: graphql`
      query AppQuery {
        viewer {
          token
          user {
            id
            email
            firstName
          }
        }
      }
    `,
    variables: []
  });

  const { props } = result;

  if (!props || !props.viewer) {
    return <p>Hello Anonyme !</p>;
  }

  return (
    <p>Hello {props.viewer.user.firstName}</p>
  );
};

export default App;
