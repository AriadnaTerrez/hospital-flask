USE hospital;

CREATE TABLE IF NOT EXISTS Usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre_usuario VARCHAR(50) UNIQUE NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    rol ENUM('administrador','medico','paciente') NOT NULL
);

INSERT INTO Usuarios (nombre_usuario, contrasena, rol) VALUES
('admin1', 'admin123', 'administrador'),
('medico1', 'medico123', 'medico'),
('paciente1', 'paciente123', 'paciente');
