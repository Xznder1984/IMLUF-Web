# server.py
# Run this with: python server.py <port>
import uvicorn
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
import sys
import os

app = FastAPI()

port = int(sys.argv[1]) if len(sys.argv) > 1 else 8080
# Serve current directory as static files
app.mount("/", StaticFiles(directory=".", html=True), name="static")

if __name__ == "__main__":
    print(f"Starting IMF Python server on port {port}...")
    uvicorn.run(app, host="0.0.0.0", port=port)
