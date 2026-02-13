# Sentinel Trading Backend 🚀
Sentinel is a backend engine specialized in market sentiment analysis and strategic trading execution. It is designed under Modular Architecture principles to ensure scalability, security, and clean separation of concerns.
![Status](https://img.shields.io/badge/Status-In%20Development-orange)
![Python](https://img.shields.io/badge/Python-3.10+-blue)
![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-green)

**Sentinel** is a backend engine specialized in market sentiment analysis and strategic trading execution. It is designed under Modular Architecture principles to ensure scalability, security, and clean separation of concerns.

## 🏗️ Project Structure
sentinel/
├── app/                # Main source code
│   ├── api/            # Presentation layer (Endpoints & Routers)
│   ├── infrastructure/ # External tools & Database logic (DatabaseManager)
│   └── main.py         # FastAPI application factory
├── database/           # SQL scripts & Schema documentation
├── main.py             # Root entry point (Wrapper)
├── .env                # Local configuration (Git ignored)
└── docker-compose.yml  # PostgreSQL Infrastructure

## 🚀 Quick Start
1. Prerequisites
    Docker & Docker Compose
    Python 3.13 + active virtual environment (venv)

2. Configuration
Create a .env file in the root directory:
    DB_HOST=localhost
    DB_NAME=sentinel_db
    DB_USER=postgres
    DB_PASSWORD=your_password
    DB_PORT=5432

3. Execution
To start the development server:
# Recommended option
    uvicorn app.main:app --reload

# Alternative option
    python main.py

Access the interactive documentation at: http://localhost:8000/docs

✅ Development Workflow
Imports: Always use absolute paths from root (e.g., from app.infrastructure.database import db).

Security: SQL parameters are passed via positional arguments (%s) to prevent SQL Injection.

Modularity: Every new resource must have its own router inside app/api/endpoints/.

## 🛠️ Roadmap
[x] Base architecture & Database Dockerization.
[x] Secure connection via DatabaseManager class (Singleton).
[x] Portfolio endpoint (Reading from Postgres Views).
[ ] Implementation of Repositories for Transaction logic.
[ ] AI-driven Sentiment Analysis Bot integration.

## ⚠️ Project Status
> **Note:** This repository is currently in **active development**. The directory structure and core features are being implemented following an 8-month roadmap for Backend & AI specialization.

---
Developed by [Leonardo Mejia](https://github.com/leonardomejiadev-cell) - *Backend Developer | Clean Architecture Enthusiast*