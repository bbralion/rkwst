# rkwst

rkwst is a service that provides a simple URL to collect HTTP requests you make and present them in a human-friendly way. The backend is written in the [Elixir language](https://elixir-lang.org/) using the [Phoenix framework](https://phoenixframework.org/).

With rkwst, you can inspect requests made to the URL in real-time, making it easy to debug and understand the flow of your data. It's especially useful when working with webhooks, APIs, and other services that make HTTP requests.

## Features
- Collects HTTP requests made to the URL and presents them in a clear, human-friendly way
- Real-time updates for each request
- Support for GET, POST, PUT, DELETE, and other HTTP methods
- Easily inspect request headers, query parameters, and request bodies

## Getting started
1. Get a unique URL via request
2. Make HTTP requests to the URL provided
3. Visit the URL to see a real-time stream of requests made to it

## License
rkwst is licensed under the Apache-2.0 license. See the [LICENSE](LICENSE) file for details.
