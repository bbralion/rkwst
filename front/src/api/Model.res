// Request values, a single key can map to multiple values
type requestValues = Map.String.t<array<string>>

// Information about single file (e.g. transferred using multipart/form-data)
type requestFile = {
  filename: string,
  headers: requestValues,
  content: string,
}
type requestFiles = Map.String.t<array<requestFile>>

// Representation of a single request made to a request net
type request = {
  id: string,
  ip: string,
  proto: string,
  timestamp: Js.Date.t,
  method: string,
  uri: string,
  headers: requestValues,
  query: option<requestValues>,
  form: option<requestValues>,
  files: option<requestFiles>,
  body: string,
}
