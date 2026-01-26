import net from "net";

// Create a TCP server for binary data (no UTF-8 encoding)
const server = net.createServer((socket) => {
  console.log(`Client connected: ${socket.remoteAddress}:${socket.remotePort}`);

  // Handle incoming data from clients
  socket.on("data", (data) => {
    console.log(
      `Received ${data.length} bytes from ${socket.remoteAddress}:${socket.remotePort}`,
    );

    // Echo back the raw binary data as-is
    socket.write(data);
  });

  // Handle client connection termination
  socket.on("end", () => {
    console.log(
      `Client disconnected: ${socket.remoteAddress}:${socket.remotePort}`,
    );
  });

  // Handle errors
  socket.on("error", (err) => {
    console.error(`Socket error: ${err}`);
  });
});

// Handle server errors
server.on("error", (err) => {
  console.error(`Server error: ${err}`);
});

// Start listening on port 3001
const PORT = 3001;
server.listen(PORT, () => {
  console.log(`Binary server started on port ${PORT}`);
});
