let mockRequests: array<Model.request> = [
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
    body: "a=b&c=d",
  },
  {
    id: "abobus-2",
    ip: "13.33.33.37",
    proto: "https",
    timestamp: Js.Date.fromFloat(Js.Date.now() -. 17000.0),
    method: "get",
    uri: "/path?a=b&a=cddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd",
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
    query: Some(Map.String.fromArray([("a", ["b", "c"])])),
    form: None,
    files: None,
    body: "a=b&c=d",
  },
]

@react.component
let make = () => {
  <div className="flex flex-col gap-8 lg:gap-10 px-[5%] py-20">
    {React.array(
      Array.map(mockRequests, request => {
        <RequestCard key=request.id request />
      }),
    )}
  </div>
}
