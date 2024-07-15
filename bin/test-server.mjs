import net from "net";

// Create a TCP server
const server = net.createServer((socket) => {
  console.log(`Client connected: ${socket.remoteAddress}:${socket.remotePort}`);

  // Set the encoding to 'utf8' to handle Unicode data
  socket.setEncoding("utf8");

  // Handle incoming data from clients
  socket.on("data", (data) => {
    console.log(
      `Received from ${socket.remoteAddress}:${socket.remotePort}: ${data}`,
    );

    // Echo back the data to the client
    socket.write(`Echo from server: ${data}`);
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

// Start listening on port 3000
const PORT = 3000;
server.listen(PORT, () => {
  console.log(`Server started on port ${PORT}`);
});
