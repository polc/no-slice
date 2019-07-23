import React, { useEffect } from 'react';
import ReactDOM from 'react-dom';
import {RelayEnvironmentProvider} from "relay-hooks";
import {useRelayEnvironment} from "./relay-environment";
import App from './components/App';

const Main = () => {
  const [relayEnvironment, setToken] = useRelayEnvironment();

  useEffect(() => {
    setToken('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJKb2tlbiIsImV4cCI6MTU2Mzg4MDMxMiwiaWF0IjoxNTYzODczMTEyLCJpc3MiOiJKb2tlbiIsImp0aSI6IjJtcHZzanFzbzR0ZnJscDcxODAwMDBiMSIsIm5iZiI6MTU2Mzg3MzExMiwidXNlcl9pZCI6ImY0M2UyYjczLWQ2YjYtNDJhZS04Y2M1LTY1NmNiYjRhMmU1YiJ9.Ad6tCFz3hLMNOYBhGgt5yBXk6nE_0srHRtykfWv1mHw');
  }, [setToken]);
  return (
    <RelayEnvironmentProvider environment={relayEnvironment}>
      <App />
    </RelayEnvironmentProvider>
  );
}

ReactDOM.render(<Main />, document.getElementById('root'));
