module Request = {
  // Request values, a single key can map to multiple values
  type values = Map.String.t<array<string>>

  // Information about single file (e.g. transferred using multipart/form-data)
  type file = {
    filename: string,
    headers: values,
    content: string,
  }
  type files = Map.String.t<array<file>>

  // Representation of a single request made to a request bin
  type t = {
    id: string,
    ip: string,
    proto: string,
    timestamp: Js.Date.t,
    method: string,
    uri: string,
    headers: values,
    query: option<values>,
    form: option<values>,
    files: option<files>,
    body: string,
  }
}

module Bin = {
  // Information about a single request bin
  type t = {
    id: string,
    endpoint: string,
    created: Js.Date.t,
    last: option<Js.Date.t>,
    deadline: Js.Date.t,
    count: int,
  }
}
