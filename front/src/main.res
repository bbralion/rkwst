// Temporarily use interop until React 18 is supported
%%raw(`
import React from "react";
import ReactDOM from "react-dom/client";
import { make as App } from "./App.bs";

const root = ReactDOM.createRoot(document.getElementById("root"));
root.render(React.createElement(React.StrictMode, null, React.createElement(App)));
`)
