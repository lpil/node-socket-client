# node_socket_client

Bindings to Node's TCP socket client.

[![Package Version](https://img.shields.io/hexpm/v/node_socket_client)](https://hex.pm/packages/node_socket_client)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/node_socket_client/)

```sh
gleam add node_socket_client@1
```
```gleam
import node_socket_client.{DataEvent, CloseEvent, ErrorEvent} as socket

pub fn main() {
  socket.connect("localhost", 3000, 0, fn(count, _socket, event) {
    case event {
      DataEvent(data) -> io.println("Got data: " <> data)
      ErrorEvent(error) -> io.println("Got error: " <> error)
      CloseEvent(had_error: True) -> io.println("Closed with error")
      CloseEvent(had_error: False) -> io.println("Closed")
      _other_event -> Nil
    }
    count + 1
  })
}
```

Further documentation can be found at <https://hexdocs.pm/node_socket_client>.
