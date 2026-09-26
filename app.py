import os
import sqlite3
from pathlib import Path

from flask import Flask, redirect, render_template, request, url_for

app = Flask(__name__)

DB_PATH = Path(os.environ.get("TODO_DB", "/data/todos.db"))


def get_db():
    DB_PATH.parent.mkdir(parents=True, exist_ok=True)
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def init_db():
    with get_db() as conn:
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS tasks (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                done INTEGER NOT NULL DEFAULT 0,
                created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
            )
            """
        )


@app.before_request
def ensure_db():
    init_db()


@app.get("/")
def index():
    with get_db() as conn:
        tasks = conn.execute(
            "SELECT id, title, done FROM tasks ORDER BY done ASC, id DESC"
        ).fetchall()
    return render_template("index.html", tasks=tasks)


@app.post("/add")
def add():
    title = (request.form.get("title") or "").strip()
    if title:
        with get_db() as conn:
            conn.execute("INSERT INTO tasks (title) VALUES (?)", (title,))
    return redirect(url_for("index"))


@app.post("/toggle/<int:task_id>")
def toggle(task_id: int):
    with get_db() as conn:
        conn.execute(
            "UPDATE tasks SET done = CASE WHEN done = 0 THEN 1 ELSE 0 END WHERE id = ?",
            (task_id,),
        )
    return redirect(url_for("index"))


@app.post("/delete/<int:task_id>")
def delete(task_id: int):
    with get_db() as conn:
        conn.execute("DELETE FROM tasks WHERE id = ?", (task_id,))
    return redirect(url_for("index"))


@app.get("/health")
def health():
    return {"status": "ok"}


if __name__ == "__main__":
    init_db()
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", "5000")))
