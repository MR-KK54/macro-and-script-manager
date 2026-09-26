import uvicorn

if __name__ == "__main__":
    print("=================================================================")
    print("🚀 Starting Macro & Script Manager Web Application...")
    print("🌐 Open http://127.0.0.1:8000 in your browser.")
    print("📖 API Documentation: http://127.0.0.1:8000/docs")
    print("=================================================================")
    uvicorn.run("app.main:app", host="127.0.0.1", port=8000, reload=True)
