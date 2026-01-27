import pool from "./db.js";

// Route functions & DB interactions

export function displayHome(req, res) {
  res.status(200).json({
    info: "Node.js, Express, and Postgres API",
    GET: "/ | displayHome()",
    GET: "/users | getUsers()",
    GET: "/users/:id | getUserById()",
    POST: "/users | createUser()",
    PUT: "/users/:id | updateUser()",
    DELETE: "/users/:id | deleteUser() });",
  });
}
export function getUsers(req, res) {
  pool.query("SELECT * FROM users ORDER BY id ASC", (error, results) => {
    if (error) {
      throw error;
    }
    res.status(200).json(results.rows);
  });
}
export function getUserById(req, res) {
  const id = req.params.id;
  pool.query("SELECT * FROM users WHERE id = $1", [id], (error, results) => {
    if (error) {
      throw error;
    }
    res.status(200).json(results.rows);
  });
}
export function createUser(req, res) {
  const { name, email } = req.body;
  if (!req.body?.name || !req.body?.email) {
    res.status(400).send("Please provide {name} & {email} in body");
  }
  pool.query(
    "INSERT INTO users (name, email) VALUES ($1, $2) RETURNING *",
    [name, email],
    (error, results) => {
      if (error) {
        throw error;
      }
      res.status(201).json(results.rows);
    }
  );
}
export function updateUser(req, res) {
  const id = req.params.id;
  const { name, email } = req.body;
  pool.query(
    "UPDATE users SET name = $1, email = $2 WHERE id = $3 RETURNING *",
    [name, email, id],
    (error, result) => {
      if (error) {
        throw error;
      }
      res.status(200).json(result.rows);
    }
  );
}
export function deleteUser(req, res) {
  const id = req.params.id;
  pool.query(
    "DELETE FROM users WHERE id = $1 RETURNING *",
    [id],
    (error, result) => {
      if (error) {
        throw error;
      }
      res.status(200).json(result.rows);
    }
  );
}
