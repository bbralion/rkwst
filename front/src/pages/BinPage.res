let mockBin: Model.Bin.t = {
  id: "sussus-1",
  endpoint: "asdf.rkw.st",
  created: Js.Date.fromFloat(Js.Date.now() -. 10. *. 60000.),
  last: Some(Js.Date.fromFloat(Js.Date.now() -. 17000.0)),
  deadline: Js.Date.fromFloat(Js.Date.now() +. 20. *. 60000.),
  count: 2,
}

let mockRequests: array<Model.Request.t> = [
  {
    id: "abobus-1",
    ip: "13.33.33.37",
    proto: "http",
    timestamp: Js.Date.fromFloat(Js.Date.now() -. 17000.0),
    method: "post",
    uri: "/path?query=param",
    headers: Map.String.fromArray([
      ("Host", ["kek.rwk.st"]),
      ("User-Agent", ["curl/7.22.0"]),
      ("Connection", ["Close"]),
      (
        "Accept",
        ["text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8"],
      ),
      ("Accept-Language", ["en"]),
      ("Accept-Encoding", ["gzip, deflate"]),
      ("Content-Type", ["application/x-www-form-urlencoded"]),
    ]),
    query: Some(Map.String.fromArray([("query", ["param"])])),
    form: Some(Map.String.fromArray([("a", ["b"]), ("c", ["d"])])),
    files: None,
    body: "YT1iJmM9ZAo=",
  },
  {
    id: "abobus-2",
    ip: "192.168.23.123",
    proto: "https",
    timestamp: Js.Date.fromFloat(Js.Date.now() -. 72400.0),
    method: "keeeeeeeeeeeeeeeek",
    uri: "/path?a=b&a=cdddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd",
    headers: Map.String.fromArray([
      ("Host", ["kek.rwk.st"]),
      ("User-Agent", ["curl/7.22.0"]),
      (
        "Accept",
        ["text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8"],
      ),
      ("Accept-Language", ["en"]),
      ("Accept-Encoding", ["gzip, deflate"]),
    ]),
    query: Some(
      Map.String.fromArray([
        (
          "a",
          [
            "b",
            "cdddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd",
          ],
        ),
      ]),
    ),
    form: None,
    files: None,
    body: "",
  },
]

module RequestCard = {
  module Tag = {
    @react.component
    let make = (~text: string) => {
      <span
        className="inline-block border-2 border-sky-300 rounded-md px-4 py-[2px] uppercase break-all text-3xl text-cyan-600">
        {React.string(text)}
      </span>
    }
  }

  // All values formattable in the body section of the card
  type formattable = RequestValues(Model.Request.values) | Timestamp({t: Js.Date.t, now: float})

  let format = (v: formattable) => {
    switch v {
    | RequestValues(values) =>
      values
      ->Map.String.toArray
      ->Array.map(((k, values)) => Array.mapWithIndex(values, (i, v) => (k, i, v)))
      ->Array.concatMany
      ->Array.map(((k, i, v)) =>
        <p key={`${k}-${i->Int.toString}`}>
          <span className="text-sky-600 text-lg break-all"> {React.string(`${k}: `)} </span>
          <span className="text-sky-600 text-lg break-all opacity-80 font-light">
            {React.string(v)}
          </span>
        </p>
      )
      ->React.array
    | Timestamp({t, now}) => {
        let formatPlural = (a: float, t: string) =>
          `${a->Float.toInt->Int.toString} ${a < 2. ? t : t ++ "s"} ago`

        let diff = now -. t->Js.Date.getTime
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
    // Update the request "y x ago" marks every 10 seconds
    // TODO: move this outside since its duplicated in each component
    let (now, updateNow) = React.useState(() => Js.Date.now())
    React.useEffect0(() => {
      let timerId = Js.Global.setInterval(() => updateNow(_ => Js.Date.now()), 10 * 1000)
      Some(() => Js.Global.clearInterval(timerId))
    })

    <div className="rounded-lg py-5 px-8 bg-slate-100 border-zinc-300 border-[1px]">
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
          <h3 className="inline text-sky-600 text-xl break-all"> {React.string(request.uri)} </h3>
        </div>
        // Origin ip
        <p
          className="md:col-span-1 md:py-[3px] flex flex-wrap content-start items-center md:justify-end gap-x-3">
          <span className="text-sky-600 opacity-60"> {React.string("FROM")} </span>
          <span className="text-sky-600 text-2xl md:text-xl lg:text-2xl">
            {React.string(request.ip)}
          </span>
        </p>
        <hr className="md:col-span-4 border-zinc-300" />
        // Headers and formatted body content
        <div className="md:col-span-2 md:ml-6"> {format(RequestValues(request.headers))} </div>
        <hr className="md:hidden border-zinc-300" />
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
        <hr className="md:col-span-4 border-zinc-300" />
        // Raw body
        <p className="md:col-span-3 text-sky-600 text-lg break-all font-light">
          {React.string(Webapi.Base64.atob(request.body))}
        </p>
        <p
          className="md:col-span-1 text-sky-600 text-lg break-all opacity-80 font-light flex content-end items-center md:justify-end">
          {format(Timestamp({t: request.timestamp, now: now}))}
        </p>
      </div>
    </div>
  }
}

module Index = {
  @react.component
  let make = () => {
    <div className="flex flex-col gap-10 lg:gap-12 mx-[2.5%] mt-10 mb-16">
      <div className="mx-auto flex flex-col gap-6 items-center">
        <div className="relative">
          <h1
            id="endpoint"
            className="text-3xl inline-block text-zinc-700 font-heading font-medium break-all">
            {React.string(mockBin.endpoint)}
          </h1>
          <Utils.Clipboard target="#endpoint" className="absolute right-[-1.5rem]">
            <i
              className="transition duration-150 text-zinc-900 hover:text-zinc-600 fa-solid fa-lg fa-copy"
            />
          </Utils.Clipboard>
          <span />
        </div>
        <div className="grid grid-cols-3 gap-6">
          <ul className="list-none"> <li> {React.string("")} </li> </ul>
        </div>
      </div>
      <div className="flex flex-col gap-8 lg:gap-10 mx-[2.5%]">
        {React.array(
          mockRequests->Array.map(request => {
            <RequestCard key=request.id request />
          }),
        )}
      </div>
    </div>
  }
}
