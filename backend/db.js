import pg from "pg"; // db
import dotenv from "dotenv"; // use .env files

// PostgreSQL

dotenv.config(); // load .env file

const Pool = pg.Pool;
const pool = new Pool({
  user: process.env.PGUSER || "postgres",
  host: process.env.PGHOST || "db",
  database: process.env.PGDATABASE || "codeland",
  password: process.env.PGPASSWORD || "postgres",
  port: process.env.PGPORT || 5432,
});

export default pool;
