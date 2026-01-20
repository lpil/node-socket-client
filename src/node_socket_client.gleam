//// Low level bindings to Node's net Socket client.
////
//// <https://nodejs.org/api/net.html#class-netsocket>

import gleam/option.{type Option}

/// https://nodejs.org/api/net.html#class-netsocket
pub type SocketClient

pub type Event(data) {
  /// Emitted once the socket is fully closed.
  ///
  /// The argument `had_error` is a bool which says if the socket was closed
  /// due to a transmission error.
  ///
  /// https://nodejs.org/api/net.html#event-close_1
  CloseEvent(had_error: Bool)

  /// Emitted when a socket connection is successfully established.
  ///
  /// https://nodejs.org/api/net.html#event-connect
  ConnectEvent

  /// Emitted when a new connection attempt is started. This may be emitted
  /// multiple times if the family autoselection algorithm is enabled.
  ///
  /// https://nodejs.org/api/net.html#event-connectionattempt
  ConnectionAttemptEvent(ip: String, port: Int, family: ConnectionFamily)

  /// Emitted when a connection attempt failed. This may be emitted multiple
  /// times if the family autoselection algorithm is enabled.
  ///
  /// https://nodejs.org/api/net.html#event-connectionattemptfailed
  ConnectionAttemptFailedEvent(
    ip: String,
    port: Int,
    family: ConnectionFamily,
    error: String,
  )

  /// Emitted when a connection attempt timed out. This is only emitted (and
  /// may be emitted multiple times) if the family autoselection algorithm is
  /// enabled.
  ///
  /// https://nodejs.org/api/net.html#event-connectionattempttimeout
  ConnectionAttemptTimeoutEvent(ip: String, port: Int, family: ConnectionFamily)

  /// Emitted when data is received.
  ///
  /// https://nodejs.org/api/net.html#event-data
  DataEvent(data: data)

  /// Emitted when the write buffer becomes empty. Can be used to throttle uploads.
  ///
  /// https://nodejs.org/api/net.html#event-drain
  DrainEvent

  /// Emitted when the other end of the socket signals the end of transmission,
  /// thus ending the readable side of the socket.
  ///
  /// https://nodejs.org/api/net.html#event-end
  EndEvent

  /// Emitted when an error occurs. The 'close' event will be called directly
  /// following this event.
  ///
  /// https://nodejs.org/api/net.html#event-error_1
  ErrorEvent(error: String)

  /// Emitted after resolving the host name but before connecting.
  ///
  /// https://nodejs.org/api/net.html#event-lookup
  LookupEvent(
    result: Result(Nil, String),
    address: String,
    family: Option(ConnectionFamily),
    host: String,
  )

  /// Emitted when a socket is ready to be used.
  ///
  /// Triggered immediately after 'connect'.
  ///
  /// https://nodejs.org/api/net.html#event-ready
  ReadyEvent

  /// Emitted if the socket times out from inactivity. This is only to notify
  /// that the socket has been idle. The user must manually close the connection.
  ///
  /// https://nodejs.org/api/net.html#event-timeout
  TimeoutEvent
}

/// Create a UTF-8 encoded socket connection to a given host and port.
///
@external(javascript, "./node_socket_client_ffi.mjs", "connect")
pub fn connect(
  host host: String,
  port port: Int,
  state state: state,
  handler handler: fn(state, SocketClient, Event(String)) -> state,
) -> SocketClient

/// Close the socket gracefully.
///
/// This will "half-close" the socket. i.e., it sends a FIN packet. It is
/// possible the server will still send some data.
///
@external(javascript, "./node_socket_client_ffi.mjs", "end")
pub fn end(socket: SocketClient) -> Nil

/// Close the socket forcefully, once all buffered data has been written to it.
///
/// If the 'finish' event was already emitted the socket is destroyed immediately.
/// If the socket is still writable it implicitly calls end().
///
@external(javascript, "./node_socket_client_ffi.mjs", "destroySoon")
pub fn destroy_soon(socket: SocketClient) -> Nil

/// Close the socket forcefully, even if there is data in the buffer still to
/// be written.
///
/// If the 'finish' event was already emitted the socket is destroyed immediately.
/// If the socket is still writable it implicitly calls end().
///
@external(javascript, "./node_socket_client_ffi.mjs", "destroy")
pub fn destroy(socket: SocketClient) -> Nil

/// Sends data on the socket with UTF-8 encoding.
///
/// Returns true if the entire data was flushed successfully to the kernel
/// buffer. Returns false if all or part of the data was queued in user memory.
/// 'drain' will be emitted when the buffer is again free.
@external(javascript, "./node_socket_client_ffi.mjs", "write")
pub fn write(socket: SocketClient, data: String) -> Bool

pub type ConnectionFamily {
  Ipv6
  Ipv4
}
