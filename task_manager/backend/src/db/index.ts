import {Pool} from 'pg';
import {drizzle} from 'drizzle-orm/node-postgres';

// Use environment variable for database connection
const pool = new Pool({
    connectionString: process.env.DATABASE_URL || "postgres://postgres:test123@localhost:5432/mydb",
});

// Test database connection
pool.connect()
  .then(client => {
    console.log('Successfully connected to the PostgreSQL database');
    client.release();
  })
  .catch(err => {
    console.error('Error connecting to the PostgreSQL database:', err);
  });

export const db = drizzle(pool);