DROP DATABASE IF EXISTS daytwo;

CREATE DATABASE daytwo;

USE daytwo;

CREATE TABLE usuarios (
    usuario_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    usuario_nombre VARCHAR(100) NOT NULL,
    usuario_email VARCHAR(100) NOT NULL,
    usuario_clave VARCHAR(100) NOT NULL,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE publicaciones(
    publicacion_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    publicacion_titulo VARCHAR(100) NOT NULL,
    publicacion_contenido TEXT NOT NULL,
    publicacion_fecha DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_id INT NOT NULL,
    CONSTRAINT fk_publicacion_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id)
);

CREATE TABLE comentarios(
    comentario_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    comentario_contenido TEXT NOT NULL,
    comentario_fecha DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_id INT NOT NULL,
    publicacion_id INT NOT NULL,
    CONSTRAINT fk_usuario_comentario FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id),
    CONSTRAINT fk_publicacion_comentario FOREIGN KEY (publicacion_id) REFERENCES publicaciones(publicacion_id)
);

INSERT INTO usuarios (usuario_nombre, usuario_email, usuario_clave) VALUES ('Juan', 'juan@gmail.com', '12345678');
INSERT INTO usuarios (usuario_nombre, usuario_email, usuario_clave) VALUES ('Pedro', 'pedro@gmail.com', '12345678');
INSERT INTO usuarios (usuario_nombre, usuario_email, usuario_clave) VALUES ('Maria', 'maria@gmail.com', '12345678');

INSERT INTO publicaciones (publicacion_titulo, publicacion_contenido, usuario_id) VALUES ('Mi primer post', 'Contenido de mi primer post', 1);
INSERT INTO publicaciones (publicacion_titulo, publicacion_contenido, usuario_id) VALUES ('Mi segundo post', 'Contenido de mi segundo post', 2);
INSERT INTO publicaciones (publicacion_titulo, publicacion_contenido, usuario_id) VALUES ('Mi tercer post', 'Contenido de mi tercer post', 3);

INSERT INTO comentarios (comentario_contenido, usuario_id, publicacion_id) VALUES ('Comentario 1', 1, 1);
INSERT INTO comentarios (comentario_contenido, usuario_id, publicacion_id) VALUES ('Comentario 2', 2, 1);
INSERT INTO comentarios (comentario_contenido, usuario_id, publicacion_id) VALUES ('Comentario 3', 3, 1);

SELECT * FROM usuarios;
SELECT * FROM publicaciones;
SELECT * FROM comentarios;