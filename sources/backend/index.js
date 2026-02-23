import express from "express"; // server
import cors from "cors"; // middleware for enabling CORS (Cross-Origin Resource Sharing)

import {
  displayHome,
  getUsers,
  getUserById,
  createUser,
  updateUser,
  deleteUser,
  healthCheck,
} from "./utils.js"; // router functions

// Express
const app = express();
const port = 3000;
app.listen(port, () => {
  console.log(`App running on port ${port}.`);
});

// Middleware
app.use(express.json()); // automatically parse JSON data from incoming requests
app.use(express.urlencoded({ extended: true })); // automatically parse URL-encoded data from incoming requests with rich objects and arrays (using qs library)
app.use(cors());

// Routes
app.get("/", displayHome);

// Health check route for ECS / ALB
app.get("/health", healthCheck);

app.get("/users", getUsers);
app.get("/users/:id", getUserById);
app.post("/users", createUser);
app.put("/users/:id", updateUser);
app.delete("/users/:id", deleteUser);
