# Macro & Script Manager

A fast, high-performance web application for storing, organizing, searching, importing, and exporting Microsoft Word VBA macros, Word keyboard shortcuts, and Adobe/DTP application scripts (InDesign JSX, Illustrator, Photoshop, Python, etc.).

---

## 🌟 Key Features

### 1. Microsoft Word Macros & Customizations
- **VBA Module Management**: Store and organize `.bas`, `.cls`, `.frm`, and `.vba` procedures.
- **Duplicate Prevention & Replacement**: Smart name conflict detection with automated prior version backup before replacing.
- **Export to `.bas`**: Formatted standard VBA modules ready for direct import into the Word VBA Editor (`Alt + F11`).
- **Metadata Tracking**: Word version targets, descriptions, tags, version histories, and notes.

### 2. Word Shortcut Manager & Conflict Detector
- **Collision Analyzer**: Real-time detection of overlapping key combinations (e.g. `Ctrl+Alt+C` assigned to multiple commands or macros).
- **VBA KeyBinding Installer Exporter**: Generates a ready-to-run VBA script (`Install_Word_Shortcuts.bas`) that automatically programmatically binds shortcuts into Microsoft Word's `Normal.dotm` template.
- **CSV & JSON Export**: Export custom keybinding matrices for documentation and distribution.

### 3. Multi-Application Script Manager
- Default and custom taxonomies for:
  - **Adobe InDesign** (`.jsx`, ExtendScript)
  - **Adobe Illustrator** (`.js`, ExtendScript)
  - **Adobe Photoshop** (`.jsx`, `.js`)
  - **Adobe XD** & **Adobe Acrobat** (`.js`)
  - **FrameMaker** & **Office Automation** (Word, Excel, PowerPoint)
  - **Python Document Automation** (`.py`)
  - Custom categories and scripts

### 4. File Storage Architecture
- **Separation of Concerns**: Actual script/macro code is safely persisted in separate storage (`./storage/files/`) isolated from database records.
- **Security Guardrails**: Strict no-execution policy on the server for uploaded scripts and path traversal prevention.

### 5. Global Search
- Instant full-text search across:
  - Macro names, shortcut combinations, script titles
  - Categories and target applications
  - Tags and descriptions
  - Full source code contents

### 6. Version History & Full System Backups
- Complete audit trail of every code edit with instant one-click rollback/restore.
- Full system export to ZIP containing individual `.bas` modules, organized application scripts, CSV reports, and a JSON manifest.

---

## 🏗️ Architecture & Tech Stack

| Layer | Technology | Description |
| :--- | :--- | :--- |
| **Backend** | Python 3.12 + FastAPI | High-performance async REST API and WebSocket realtime server |
| **Local Database** | SQLite (WAL Mode + FTS5) | Zero-setup, instant local database with full-text search index |
| **Cloud Database** | Supabase PostgreSQL | Optional cloud database with Row Level Security (RLS) & triggers |
| **File Storage** | Local Disk / Supabase Bucket | Safe separate object storage for scripts and macros |
| **Frontend** | Modern Vanilla JS + Tailwind CSS | Fast responsive Single Page Application with glassmorphism UI |
| **Realtime** | WebSockets | Instant multi-tab and live sync |

---

## 🚀 Getting Started Locally

### Prerequisites
- Python 3.10+ (Python 3.12 recommended)

### Installation & Run

1. **Install Dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

2. **Launch the Application**:
   ```bash
   python run.py
   ```
   *(Or using uvicorn directly)*:
   ```bash
   uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload
   ```

3. **Open in Browser**:
   - Web App UI: [http://127.0.0.1:8000](http://127.0.0.1:8000)
   - Interactive API Documentation (Swagger / OpenAPI): [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)

---

## 🧪 Running Tests

Run the comprehensive unit and API integration test suite with `pytest`:

```bash
python -m pytest tests/
```

---

## ☁️ Supabase Cloud Setup (Optional)

To connect Supabase:
1. Create a new project in [Supabase](https://supabase.com).
2. Go to the SQL Editor and execute the statements in [`schema.sql`](./schema.sql).
3. Set your environment variables in `.env`:
   ```env
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_KEY=your-anon-or-service-key
   ```

---

## 🌐 Render Deployment

This project includes [`render.yaml`](./render.yaml) and [`Dockerfile`](./Dockerfile) for continuous deployment on [Render](https://render.com).

### Deployment Workflow:
1. Commit changes to your local Git branch.
2. Push your commits to GitHub using **GitHub Desktop**.
3. Render will automatically detect the push and deploy the live web application.
