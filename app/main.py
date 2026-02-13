from fastapi import FastAPI

from app.api.endpoints import portfolio

app = FastAPI(
    title="Sentinel Trading Backend",
    version="0.1.0",
)


@app.get("/")
def read_root():
    return {"status": "Sentinel Trading Backend is running!", "version": "0.1.0"}


# Incluir routers
app.include_router(portfolio.router)


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
