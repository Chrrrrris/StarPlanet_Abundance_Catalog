from flask import Flask, render_template
import sqlite3

app = Flask(__name__)

def get_db_connection():
    conn = sqlite3.connect('./StarPlanet.db')
    conn.row_factory = sqlite3.Row
    return conn

@app.route('/')
def index():
    conn = get_db_connection()
    posts = conn.execute('SELECT * FROM PlanetStarAbundance').fetchall()
    conn.close()
    return render_template('index.html', posts=posts)

if __name__ == '__main__':
    app.run(debug=True)