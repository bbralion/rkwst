@react.component
let make = (~request: Model.request) => {
  let requestUri = (display: string) =>
    <span className={`${display} md:ml-3 leading-9 text-white text-xl break-all`}>
      {React.string(request.uri)}
    </span>

  <div className="rounded-lg py-5 px-8 bg-theme-700">
    <div className="grid grid-cols-4 gap-3">
      <div className="col-span-4 md:col-span-3">
        <RequestTag text=request.proto />
        <RequestTag text=request.method />
        {requestUri("hidden md:inline")}
      </div>
      {requestUri("col-span-4 block md:hidden")}
      <div
        className="col-span-4 md:col-span-1 md:py-[3px] flex flex-wrap content-start items-center md:justify-end gap-x-3">
        <span className="text-white opacity-60"> {React.string("FROM")} </span>
        <span className="text-white text-2xl"> {React.string(request.ip)} </span>
      </div>
    </div>
  </div>
}
