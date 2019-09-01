/// <reference types="react-scripts" />

declare module 'babel-plugin-relay/macro' {
	export { graphql } from 'react-relay';
}

declare module 'relay-hooks' {
  import { RelayEnvironmentProvider } from 'react-relay';
  import { UseQueryProps } from 'relay-hooks/RelayHooksType';

  type RenderProps<T> = {
    error: Error;
    props: T | null;
    retry: () => void;
    cached?: boolean;
  };
  declare const useQuery: <T>(props: UseQueryProps) => RenderProps<T>;

  export { useQuery, RelayEnvironmentProvider };
}
