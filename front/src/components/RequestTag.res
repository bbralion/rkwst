@react.component
let make = (~text: string) => {
  <span
    className="inline-block border-2 border-theme-500 rounded-md px-4 py-[2px] uppercase text-3xl text-white mr-2">
    {React.string(text)}
  </span>
}
