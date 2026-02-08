from fastapi import FastAPI

app = FastAPI(title="Sentinel Trading Backend")


@app.get("/")
def read_root():
    return {"status": "Sentinel Trading Backend is running!", "version": "0.1.0"}
