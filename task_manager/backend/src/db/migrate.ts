import { drizzle } from 'drizzle-orm/node-postgres';
import { migrate } from 'drizzle-orm/node-postgres/migrator';
import { Pool } from 'pg';
import * as schema from './schema';

// Function to run migrations and initialize the database
async function runMigrations() {
  console.log('Starting database migration...');
  
  const connectionString = process.env.DATABASE_URL || "postgres://postgres:test123@localhost:5432/mydb";
  console.log(`Connecting to database: ${connectionString}`);
  
  const pool = new Pool({
    connectionString,
  });

  // Test the connection
  try {
    const client = await pool.connect();
    console.log('Successfully connected to the database');
    client.release();
  } catch (error) {
    console.error('Failed to connect to the database:', error);
    process.exit(1);
  }

  const db = drizzle(pool, { schema });

  // Perform schema migrations
  try {
    // Create tables from schema
    await db.execute(/* sql */`
      CREATE TABLE IF NOT EXISTS "users" (
        "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        "name" TEXT NOT NULL,
        "email" TEXT NOT NULL UNIQUE,
        "password" TEXT NOT NULL,
        "created_at" TIMESTAMP NOT NULL DEFAULT NOW(),
        "updated_at" TIMESTAMP NOT NULL DEFAULT NOW()
      );

      CREATE TABLE IF NOT EXISTS "tasks" (
        "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        "title" TEXT NOT NULL,
        "description" TEXT NOT NULL,
        "hexColor" TEXT NOT NULL,
        "uid" UUID NOT NULL REFERENCES "users"("id") ON DELETE CASCADE,
        "dueAt" TIMESTAMP DEFAULT (NOW() + INTERVAL '7 days'),
        "created_at" TIMESTAMP NOT NULL DEFAULT NOW(),
        "updated_at" TIMESTAMP NOT NULL DEFAULT NOW()
      );
    `);
    
    console.log('Database migration completed successfully');
  } catch (error) {
    console.error('Failed to run database migrations:', error);
    process.exit(1);
  }

  await pool.end();
}

// Run the migration if this file is executed directly
if (require.main === module) {
  runMigrations()
    .then(() => {
      console.log('Migration script completed');
      process.exit(0);
    })
    .catch((err) => {
      console.error('Migration script failed:', err);
      process.exit(1);
    });
}

export { runMigrations };
