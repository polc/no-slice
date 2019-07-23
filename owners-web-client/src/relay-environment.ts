import {useEffect, useState} from 'react';
import {Environment, Network, RecordSource, Store, FetchFunction} from 'relay-runtime';
import jwtDecoder from 'jwt-decode';
import Cookies from 'universal-cookie/es6';

const cookies = new Cookies();
const TOKEN_COOKIE_NAME = 'token';

function createFetcher(token: string | null, resetToken: () => void): FetchFunction
{
  return (operation, variables) =>
    fetch(`${process.env.REACT_APP_API_URL}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        ...(token && {'Authorization': `Bearer ${token}`})
      },
      body: JSON.stringify({
        query: operation.text,
        variables,
      }),
    })
    .then(response => {
      if (response.status === 401) {
        resetToken();
      }

      return response.json();
    });
}

const createEnvironment = (fetcher: FetchFunction) => new Environment({
  network: Network.create(fetcher),
  store: new Store(new RecordSource()),
});

const fetchToken = () => cookies.get<string>(TOKEN_COOKIE_NAME) || null;

const getExpirationDate = (token: string) => {
  const decodedToken = jwtDecoder(token) as any;
  const expirationTimestamp = decodedToken.exp || 0;

  return new Date(expirationTimestamp * 1000);
}

const persistToken = (token: string | null) => token !== null
  ? cookies.set(TOKEN_COOKIE_NAME, token, { expires: getExpirationDate(token) })
  : cookies.remove(TOKEN_COOKIE_NAME);

// tuples are not inferred so we have to explicitly write return type
export function useRelayEnvironment(): [Environment, (token: null | string) => void] {
  const resetToken = () => setToken(null);
  const [relay, setRelay] = useState(() => {
    const token = fetchToken();
    const fetcher = createFetcher(token, resetToken);

    return {
      token: token,
      environment: createEnvironment(fetcher),
    }
  });

  useEffect(() => {
    persistToken(relay.token);
  }, [relay.token]);

  const setToken = (newToken: string | null) => {
    if (newToken === relay.token) {
      return;
    }

    const fetcher = createFetcher(newToken, resetToken);

    setRelay({
      token: newToken,
      environment: createEnvironment(fetcher),
    });
  };

  return [relay.environment, setToken];
}
