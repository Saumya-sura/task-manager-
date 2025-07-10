import express from 'express';
import authrouter from './routes/auth';

const app = express();
const PORT = 8000; 

app.use(express.json());
app.use("/auth", authrouter);

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


