import { Socket } from "node:net";
import { Ok as OkG, Error as ErrorG } from "./gleam.mjs";
import {
  CloseEvent,
  ConnectEvent,
  ConnectionAttemptEvent as CAEvent,
  ConnectionAttemptFailedEvent as CAFailedEvent,
  ConnectionAttemptTimeoutEvent as CATimeoutEvent,
  DataEvent,
  DrainEvent,
  EndEvent,
  ErrorEvent,
  LookupEvent,
  ReadyEvent,
  TimeoutEvent,
  Ipv6,
  Ipv4,
} from "./node_socket_client.mjs";

export function connect(host, port, initialState, handler) {
  let state = initialState;
  const socket = new Socket();

  // Set the socket to unicode mode. A second connect function could be added
  // for non-unicode mode, with the received data being passed to the handler
  // as bit arrays.
  socket.setEncoding("utf8");

  const handle = (event) => {
    state = handler(state, socket, event);
  };

  socket.on("close", (hadError) => handle(new CloseEvent(hadError)));
  socket.on("connect", () => handle(new ConnectEvent()));
  socket.on("connectionAttempt", (ip, port, family) =>
    handle(new CAEvent(ip, port, family)),
  );
  socket.on("connectionAttemptFailed", (ip, port, family, error) =>
    handle(new CAFailedEvent(ip, port, family, error.toString())),
  );
  socket.on("connectionAttemptTimeout", (ip, port, family) =>
    handle(new CATimeoutEvent(ip, port, family)),
  );
  socket.on("data", (data) => handle(new DataEvent(data)));
  socket.on("drain", () => handle(new DrainEvent()));
  socket.on("end", () => handle(new EndEvent()));
  socket.on("error", (error) => handle(new ErrorEvent(error.toString())));
  socket.on("lookup", (err, address, family, host) =>
    handle(new LookupEvent(result(err), address, family, host)),
  );
  socket.on("ready", () => handle(new ReadyEvent()));
  socket.on("timeout", () => handle(new TimeoutEvent()));

  socket.connect(port, host);
  return socket;
}

export function write(socket, data) {
  return socket.write(data);
}

export function end(socket) {
  socket.end();
}

export function destroy(socket) {
  socket.destroy();
}

export function destroySoon(socket) {
  socket.destroySoon();
}

const ip = (number) => (number === 6 ? new Ipv6() : new Ipv4());

const result = (error) =>
  error ? new ErrorG(error.toString()) : new OkG(undefined);
