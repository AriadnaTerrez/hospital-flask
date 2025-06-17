DROP DATABASE hospital;
CREATE DATABASE hospital;
USE hospital;

-- Tabla pacientes
CREATE TABLE Pacientes (
    id_paciente INT AUTO_INCpacientesREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,pacientes
    apellido VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE,
    telefono VARCHAR(15),
    direccion VARCHAR(200),
    email VARCHAR(100),
    sexo VARCHAR(10)

);

-- Tabla médicos
CREATE TABLE Medicos (
    id_medico INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    especialidad VARCHAR(100),
    telefono VARCHAR(20),
    email VARCHAR(200)
    
);

-- Tabla citas
CREATE TABLE Citas (
    id_cita INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT,
    id_medico INT,
    fecha_cita DATE,
    hora_cita TIME,
    motivo_consulta TEXT,
    FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente),
    FOREIGN KEY (id_medico) REFERENCES Medicos(id_medico)
);

-- Tabla consultas
CREATE TABLE Consultas (
    id_consulta INT AUTO_INCREMENT PRIMARY KEY,
    id_cita INT,
    diagnostico VARCHAR(200),
    tratamiento VARCHAR(500),
    fecha_consulta DATE,
    resultados_examenes JSON,
    FOREIGN KEY (id_cita) REFERENCES Citas(id_cita)
);

-- Tabla habitaciones del Hospital
CREATE TABLE Habitaciones (
    id_habitacion INT AUTO_INCREMENT PRIMARY KEY,
    numero_habitacion VARCHAR(10),
    tipo_habitacion VARCHAR(50),
    estado VARCHAR(15)
);

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



-- Agregar datos en tabla Pacientes
INSERT INTO Pacientes (nombre, apellido, fecha_nacimiento, telefono, direccion, email, sexo)
VALUES 
('Juan', 'Pérez', '1990-05-15', '5591264859', 'Calle Ximena 178', 'juanperez04@email.com', 'Masculino'),
('Ana', 'Gómez', '1985-08-20', '5589776647', 'Avenida Florida 456', 'anagomez@email.com', 'Femenino'),
('Carlos', 'López', '1978-11-30', '555123456', 'Boulevard Niños Heroes 789', 'carloslopez@email.com', 'Masculino');

-- Agregar datos en la tabla Medicos
INSERT INTO Medicos (nombre, apellido, especialidad, telefono, email)
VALUES 
('María', 'Rodríguez', 'Cardiología', '5558907765', 'mariaroCAr@email.com'),
('Pedro', 'García', 'Pediatría', '5554331678', 'pedrogarPed@email.com'),
('Lucía', 'Fernández', 'Cirujano', '555555666', 'luciaferCir@email.com');

-- Agregar datos en la tabla Citas
INSERT INTO Citas (id_paciente, id_medico, fecha_cita, hora_cita, motivo_consulta)
VALUES 
(1, 1, '2023-10-25', '10:00:00', 'Dolor en el pecho'),
(2, 2, '2023-10-26', '11:00:00', 'Pie plano'),
(3, 3, '2023-10-27', '12:00:00', 'Resección tumoral');

-- Agregar datos en la tabla Consultas
INSERT INTO Consultas (id_cita, diagnostico, tratamiento, fecha_consulta, resultados_examenes)
VALUES 
(1, 'Angina de pecho', 'Reposo y medicación', '2023-10-25', '{"presion_arterial": "120/80", "frecuencia_cardiaca": 72}'),
(2, 'Control normal', 'Seguimiento en 6 meses', '2023-10-26', '{"peso": "25 kg", "altura": "1.10 m"}'),
(3, 'Turmor maligno', 'Cirugia de emergencia', '2023-10-27', '{"tipo": "melanoma","grado": "maligno","tamaño": "2.5 cm"}');

-- Agregar datos en la tabla Habitaciones
INSERT INTO Habitaciones (numero_habitacion, tipo_habitacion, estado)
VALUES 
('101', 'Individual', 'disponible'),
('102', 'Doble', 'ocupada'),
('103', 'Suite', 'reservada');