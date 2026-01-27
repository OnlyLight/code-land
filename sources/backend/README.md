# Node.js Express PostgreSQL API

A RESTful API (user database) built with Node.js, Express, and PostgreSQL to demonstrate a basic example setup.

**Reference**: https://blog.logrocket.com/crud-rest-api-node-js-express-postgresql

## Database Connection

This app uses [node-postgres](https://node-postgres.com/) to connect to PostgreSQL using `pg.Pool`. Connection parameters are read from environment variables.

## Setup

Create an `.env` file in the root directory with the following PostgreSQL configuration:

| Key          | Description                    |
| ------------ | ------------------------------ |
| `PGUSER`     | postgres role                  |
| `PGPASSWORD` | role password                  |
| `PGDATABASE` | postgres database              |
| `PGHOST`     | postgres host (e.g. localhost) |
| `PGPORT`     | postgres port (e.g. 5432)      |

## Running the App

Install dependencies:

```sh
npm install
```

Start the server:

```sh
npm start
```

Launch in Development:

```sh
npm dev
```

The API will be available at [http://localhost:3000](http://localhost:3000).

## Available Endpoints

- `GET /` - API information
- `GET /users` - Get all users
- `GET /users/:id` - Get user by ID
- `POST /users` - Create new user
- `PUT /users/:id` - Update user
- `DELETE /users/:id` - Delete user

## Additional Notes

Edge cases and error handling has been neglected for simplicity.
