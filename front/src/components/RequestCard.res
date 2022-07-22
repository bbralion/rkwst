module Tag = {
  @react.component
  let make = (~text: string) => {
    <span
      className="inline-block border-2 border-theme-500 rounded-md px-4 py-[2px] uppercase break-all text-3xl text-white">
      {React.string(text)}
    </span>
  }
}

// All values formattable in the body section of the card
type formattable = RequestValues(Model.Request.values) | Timestamp(Js.Date.t)

let format = (v: formattable) => {
  switch v {
  | RequestValues(values) =>
    values
    ->Map.String.toArray
    ->Array.map(((k, values)) => Array.mapWithIndex(values, (i, v) => (k, i, v)))
    ->Array.concatMany
    ->Array.map(((k, i, v)) =>
      <p key={`${k}-${i->Int.toString}`}>
        <span className="text-white text-lg break-all"> {React.string(`${k}: `)} </span>
        <span className="text-white text-lg break-all opacity-80 font-light">
          {React.string(v)}
        </span>
      </p>
    )
    ->React.array
  | Timestamp(t) => {
      let formatPlural = (a: float, t: string) =>
        `${a->Float.toInt->Int.toString} ${a < 2. ? t : t ++ "s"} ago`

      let diff = Js.Date.now() -. t->Js.Date.getTime
      React.string(
        if diff < 1. *. 1000. {
          "less than a second ago"
        } else if diff < 60. *. 1000. {
          formatPlural(diff /. 1000., "second")
        } else if diff < 3600. *. 1000. {
          formatPlural(diff /. (60. *. 1000.), "minute")
        } else if diff < 86400. *. 1000. {
          formatPlural(diff /. (3600. *. 1000.), "hour")
        } else {
          formatPlural(diff /. (86400. *. 1000.), "day")
        },
      )
    }
  }
}

@react.component
let make = (~request: Model.Request.t) => {
  <div className="rounded-lg py-5 px-8 bg-theme-700">
    <div className="grid grid-cols-1 md:grid-cols-4 gap-y-5 gap-x-3">
      // Tags and URI
      <div className="md:col-span-3">
        <div className="mb-3 md:mb-0 md:mr-5 md:inline-block">
          {
            // In the future other tags might be supported
            React.array(
              [("proto", request.proto), ("method", request.method)]->Array.map(((k, v)) =>
                <span className="inline-block mb-2 mr-2 last:mr-0" key=k> <Tag text=v /> </span>
              ),
            )
          }
        </div>
        <h3 className="inline text-white text-xl break-all"> {React.string(request.uri)} </h3>
      </div>
      // Origin ip
      <p
        className="md:col-span-1 md:py-[3px] flex flex-wrap content-start items-center md:justify-end gap-x-3">
        <span className="text-white opacity-60"> {React.string("FROM")} </span>
        <span className="text-white text-2xl md:text-xl lg:text-2xl">
          {React.string(request.ip)}
        </span>
      </p>
      <hr className="md:col-span-4 border-black" />
      // Headers and formatted body content
      <div className="md:col-span-2 md:ml-6"> {format(RequestValues(request.headers))} </div>
      <hr className="md:hidden border-black" />
      <div className="md:col-span-2 md:ml-6">
        {[request.query, request.form]
        ->Array.keepMap(v =>
          switch v {
          | Some(values) => Some(format(RequestValues(values)))
          | None => None
          }
        )
        ->Array.reduceWithIndex([], (a, v, i) => {
          if a->Array.length == 0 {
            [v]
          } else {
            Array.concat(
              a,
              [<hr key={`hr-${i->Int.toString}`} className="my-3 mx-auto w-[95%] border-0" />, v],
            )
          }
        })
        ->React.array}
      </div>
      <hr className="md:col-span-4 border-black" />
      // Raw body
      <p className="md:col-span-3 text-white text-lg break-all font-light">
        {React.string(Webapi.Base64.atob(request.body))}
      </p>
      <p
        className="md:col-span-1 text-white text-lg break-all opacity-80 font-light flex content-end items-center md:justify-end">
        {format(Timestamp(request.timestamp))}
      </p>
    </div>
  </div>
}
