import express from 'express';
import authrouter from './routes/auth';
import taskRouter from './routes/task';
import { auth } from './middleware/auth';
import { runMigrations } from './db/migrate';

const app = express();
const PORT = 8000; 

// Initialize database
async function initializeApp() {
  try {
    // Run database migrations
    await runMigrations();
    console.log('Database initialized successfully');
    
    startServer();
  } catch (error) {
    console.error('Failed to initialize database:', error);
    process.exit(1);
  }
}

function startServer() {
  app.use(express.json());
  app.use("/auth", authrouter);
  app.use("/tasks", auth, taskRouter);

  app.get("/", (req, res) => {
      res.json({
          message: "kasa kai maharashtra !!!!",
          environment: "development",
          timestamp: new Date().toISOString()
      });
  });

  app.get("/health", (req, res) => {
      res.json({ 
          status: "OK", 
          port: PORT,
          environment: "development"
      });
  });
  app.listen(PORT, '0.0.0.0', () => {
    console.log(`🚀 Server is running on port ${PORT}`);
    console.log(`📊 Environment: ${process.env.NODE_ENV}`);
    console.log(`🔗 Health check: http://localhost:${PORT}/health`);
  });
}

initializeApp();


