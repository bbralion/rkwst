module Clipboard = {
  type t
  @new @module external clipboardJs: 'a => t = "clipboard"
  @send external destroyJs: t => unit = "destroy"

  @react.component
  let make = (~className: option<string>=?, ~target: string, ~children: React.element) => {
    let innerEl: React.ref<Js.Nullable.t<Dom.element>> = React.useRef(Js.Nullable.null)
    React.useEffect0(() => {
      let c = innerEl.current->Js.Nullable.toOption->Option.getExn->clipboardJs
      Some(() => destroyJs(c))
    })

    let original = <span className={Option.getWithDefault(className, "")}> children </span>
    React.cloneElement(
      original,
      {"ref": ReactDOM.Ref.domRef(innerEl), "data-clipboard-target": target},
    )
  }
}
