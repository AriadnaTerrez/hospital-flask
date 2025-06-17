import os
from flask import Flask, render_template, request, redirect, url_for, session, flash
import psycopg2
import psycopg2.extras

app = Flask(__name__)
app.secret_key = 'clave_super_secreta'  # En producción idealmente mover a variable de entorno

# Conexión a PostgreSQL usando DATABASE_URL de Render
DATABASE_URL = os.environ.get("DATABASE_URL")

def get_connection():
    return psycopg2.connect(DATABASE_URL, cursor_factory=psycopg2.extras.DictCursor)

# Ruta inicial
@app.route('/')
def index():
    return redirect(url_for('login'))

# Login
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        usuario = request.form['usuario']
        contrasena = request.form['contrasena']

        with get_connection() as conn:
            with conn.cursor() as cursor:
                sql = "SELECT * FROM Usuarios WHERE nombre_usuario = %s AND contrasena = %s"
                cursor.execute(sql, (usuario, contrasena))
                user = cursor.fetchone()

                if user:
                    session['usuario'] = user['nombre_usuario']
                    session['rol'] = user['rol']
                    return redirect(url_for('dashboard'))
                else:
                    flash('Usuario o contraseña incorrectos')
                    return redirect(url_for('login'))

    return render_template('login.html')

# Dashboard
@app.route('/dashboard')
def dashboard():
    if 'usuario' in session:
        return render_template('dashboard.html', usuario=session['usuario'], rol=session['rol'])
    else:
        return redirect(url_for('login'))

# Enviar mensaje (paciente)
@app.route('/enviar_mensaje', methods=['POST'])
def enviar_mensaje():
    if 'usuario' in session:
        contenido = request.form['contenido']
        usuario = session['usuario']

        with get_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute("SELECT id_usuario FROM Usuarios WHERE nombre_usuario = %s", (usuario,))
                id_usuario = cursor.fetchone()[0]
                cursor.execute("INSERT INTO Mensajes (id_usuario, contenido) VALUES (%s, %s)", (id_usuario, contenido))
                conn.commit()

        flash("Comentario enviado correctamente")
        return redirect(url_for('dashboard'))
    else:
        return redirect(url_for('login'))

# Ver mensajes (solo administrador)
@app.route('/ver_mensajes')
def ver_mensajes():
    if 'usuario' in session and session['rol'] == 'administrador':
        with get_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute("""
                    SELECT U.nombre_usuario, M.contenido, M.fecha
                    FROM Mensajes M
                    JOIN Usuarios U ON M.id_usuario = U.id_usuario
                    ORDER BY M.fecha DESC
                """)
                mensajes = cursor.fetchall()

        return render_template('mensajes.html', mensajes=mensajes)
    else:
        return redirect(url_for('login'))

# Cerrar sesión
@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('login'))

# Ejecutar servidor Flask
if __name__ == '__main__':
    app.run(debug=True)
