# Task Manager Backend

A Node.js/Express backend for the Task Manager application built with TypeScript, PostgreSQL, and Drizzle ORM.

## Prerequisites

- Node.js (v18 or higher)
- PostgreSQL database
- Docker (optional)

## Setup Instructions

### 1. Clone the repository
```bash
git clone <your-repository-url>
cd task_manager/backend
```

### 2. Install dependencies
```bash
npm install
```

### 3. Environment Setup
1. Copy the environment template:
```bash
cp .env.example .env
```

2. Update `.env` with your database credentials:
```env
DATABASE_URL=postgres://your_username:your_password@localhost:5432/your_database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=your_database_name
DB_USER=your_username
DB_PASSWORD=your_password
PORT=8000
NODE_ENV=development
JWT_SECRET=your_super_secret_jwt_key_minimum_32_characters
```

### 4. Database Setup
Create a PostgreSQL database:
```sql
CREATE DATABASE task_manager;
```

### 5. Run the application

#### Development mode (with hot reload)
```bash
npm run dev
```

#### Production mode
```bash
npm run build
npm start
```

### 6. Using Docker (Optional)
```bash
# Build and run with Docker Compose
docker-compose up --build

# This will start both the backend and PostgreSQL database
```

## API Endpoints

- `GET /` - Welcome message
- `GET /health` - Health check
- `POST /api/auth/signup` - User registration (coming soon)
- `POST /api/auth/login` - User login (coming soon)
- `GET /api/tasks` - Get all tasks (coming soon)
- `POST /api/tasks` - Create new task (coming soon)

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DATABASE_URL` | PostgreSQL connection string | - |
| `DB_HOST` | Database host | localhost |
| `DB_PORT` | Database port | 5432 |
| `DB_NAME` | Database name | - |
| `DB_USER` | Database username | - |
| `DB_PASSWORD` | Database password | - |
| `PORT` | Server port | 8000 |
| `NODE_ENV` | Environment mode | development |
| `JWT_SECRET` | JWT secret key | - |

## Security Notes

- Never commit `.env` files to version control
- Use strong passwords for database credentials
- Generate a strong JWT secret (minimum 32 characters)
- Keep environment variables secure in production

## Scripts

- `npm run dev` - Start development server with hot reload
- `npm run build` - Build TypeScript to JavaScript
- `npm start` - Start production server
- `npm run dev:ts` - Alternative development command with ts-node

## Tech Stack

- **Runtime**: Node.js
- **Framework**: Express.js
- **Language**: TypeScript
- **Database**: PostgreSQL
- **ORM**: Drizzle ORM
- **Dev Tools**: Nodemon, ts-node
