// Setup Font Awesome using wrapper around the SVG core
@module("./js/fontawesome.js") external setupFontAwesome: unit => unit = "setupFontAwesome"
setupFontAwesome()

// Temporarily use interop until React 18 is supported
module React18 = {
  module Root = {
    type t

    @send external render: (t, React.element) => unit = "render"
  }
}

module ReactDOM18 = {
  @module("react-dom/client") external createRoot: Dom.element => React18.Root.t = "createRoot"
}

let root = ReactDOM18.createRoot(ReactDOM.querySelector("#root")->Option.getExn)
React18.Root.render(root, <App />)
