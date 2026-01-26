import argv
import gleam/int
import gleam/io
import gleam/string
import gleeunit
import node_socket_client as socket

pub fn main() {
  case argv.load().arguments {
    ["demo"] -> demo()
    ["demo-binary"] -> demo_binary()
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

fn demo_binary() {
  socket.connect_binary("localhost", 3001, 0, fn(state, socket, event) {
    io.println(int.to_string(state) <> ": " <> string.inspect(event))
    case event {
      socket.ReadyEvent -> {
        let data = <<1, 2, 3, 255, 0, 128>>
        io.println("Sending binary data: " <> string.inspect(data))
        let _ = socket.write_bits(socket, data)
        Nil
      }
      socket.DataEvent(received) -> {
        io.println("Received binary data: " <> string.inspect(received))
        socket.destroy_soon(socket)
      }
      _ -> Nil
    }
    state + 1
  })
  Nil
}
