import { Elm } from './app/Main.elm';

const storageKey = "store";

const flags = localStorage.getItem(storageKey);
const app = Elm.Main.init({
  // flags: flags,
  node: document.getElementById('app'),
});

/*
app.ports.storeCache.subscribe(value => {
  if (value === null) {
    localStorage.removeItem(storageKey);
  } else {
    localStorage.setItem(storageKey, JSON.stringify(value));
  }

  // Report that the new session was stored successfully.
  setTimeout(() => {
    app.ports.onStoreChange.send(value);
  }, 0);
});

// Whenever localStorage changes in another tab, report it if necessary.
window.addEventListener("storage", event => {
  if (event.storageArea === localStorage && event.key === storageKey) {
    app.ports.onStoreChange.send(event.newValue);
  }
}, false);
*/
