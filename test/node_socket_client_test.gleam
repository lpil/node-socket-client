import argv
import gleam/int
import gleam/io
import gleam/string
import gleeunit
import node_socket_client as socket

pub fn main() {
  case argv.load().arguments {
    ["demo"] -> demo()
    _ -> gleeunit.main()
  }
}

fn demo() {
  socket.connect("localhost", 3000, 0, fn(state, _socket, event) {
    io.println(int.to_string(state) <> ": " <> string.inspect(event))
    state + 1
  })
  Nil
}
