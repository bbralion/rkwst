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
    query: Some(Map.String.fromArray([("a", ["b", "c"])])),
    form: None,
    files: None,
    body: "",
  },
]

@react.component
let make = () => {
  <div className="flex flex-col gap-8 lg:gap-10 px-[5%] py-20">
    {React.array(
      mockRequests->Array.map(request => {
        <RequestCard key=request.id request />
      }),
    )}
  </div>
}
