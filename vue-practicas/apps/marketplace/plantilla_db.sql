DROP DATABASE if EXISTS marketplace;

CREATE DATABASE marketplace;

USE marketplace;
 
CREATE TABLE roles_administradores(
id_rol CHAR(36) NOT NULL PRIMARY KEY,
nombre_rol VARCHAR(60),
CONSTRAINT uq_nombre_rol_unico UNIQUE(nombre_rol)
);

CREATE TABLE administradores(
id_administrador CHAR(36) NOT NULL PRIMARY KEY,
nombre_administrador VARCHAR(50) NOT NULL,
apellido_administrador VARCHAR(50) NOT NULL,
clave_administrador VARCHAR(100) NOT NULL,
correo_administrador VARCHAR(50) NOT NULL,
CONSTRAINT uq_correo_administrador_unico UNIQUE(correo_administrador),
telefono_administrador VARCHAR(15) NOT NULL,
dui_administrador VARCHAR(10) NOT NULL,
CONSTRAINT uq_dui_administrador_unico UNIQUE(dui_administrador),
fecha_nacimiento_administrador DATE NOT NULL,
alias_administrador VARCHAR(25) NOT NULL,
CONSTRAINT uq_alias_administrador_unico UNIQUE(alias_administrador),
fecha_creacion DATETIME DEFAULT NOW(),
id_rol CHAR(36) NOT NULL,
CONSTRAINT fk_rol_administradores FOREIGN KEY (id_rol)
REFERENCES roles_administradores(id_rol),
intentos_administrador INT DEFAULT 0,
estado_administrador BOOLEAN DEFAULT 1,
tiempo_intento DATETIME NULL,
fecha_clave DATETIME NULL DEFAULT NOW(),
fecha_bloqueo DATETIME NULL,
foto_administrador VARCHAR(50) NULL
);

CREATE TABLE documentos(
id_documento CHAR(36) NOT NULL PRIMARY KEY,
nombre_documento VARCHAR(60),
CONSTRAINT uq_nombre_documento_unico UNIQUE(nombre_documento)
);

CREATE TABLE documentos_administradores(
id_documento_administrador CHAR(36) NOT NULL PRIMARY KEY,
id_documento CHAR(36) NOT NULL,
CONSTRAINT fk_documentos_administradores FOREIGN KEY (id_documento)
REFERENCES documentos(id_documento),
id_administrador CHAR(36) NOT NULL,
CONSTRAINT fk_administradores_documentos FOREIGN KEY (id_administrador)
REFERENCES administradores(id_administrador),
valor_documento VARCHAR(60),
CONSTRAINT uq_valor_documento_administrador_unico UNIQUE(valor_documento)
);

CREATE TABLE clientes(
id_cliente CHAR(36) NOT NULL AUTO_INCREMENT PRIMARY KEY,
nombre_cliente VARCHAR(50) NOT NULL,
apellido_cliente VARCHAR(50) NOT NULL,
clave_cliente VARCHAR(100) NOT NULL,
correo_cliente VARCHAR(50) NOT NULL,
CONSTRAINT uq_correo_cliente_unico UNIQUE(correo_cliente),
genero_cliente ENUM('Masculino', 'Femenino', 'No definido') NOT NULL,
fecha_nacimiento_cliente DATE NOT NULL,
telefono_cliente VARCHAR(15) NOT NULL,
estado_cliente BOOLEAN DEFAULT 1 NULL,
fecha_registro DATETIME DEFAULT NOW(),
direccion_cliente VARCHAR(100) NOT NULL,
foto_cliente VARCHAR(50) NULL
);

CREATE TABLE documentos_clientes(
id_documento_cliente CHAR(36) NOT NULL PRIMARY KEY,
id_documento CHAR(36) NOT NULL,
CONSTRAINT fk_documentos_clientes FOREIGN KEY (id_documento)
REFERENCES documentos(id_documento),
id_cliente CHAR(36) NOT NULL,
CONSTRAINT fk_clientes_documentos FOREIGN KEY (id_cliente)
REFERENCES clientes(id_cliente),
valor_documento VARCHAR(60),
CONSTRAINT uq_valor_documento_cliente_unico UNIQUE(valor_documento)
);

CREATE TABLE categorias (
id_categoria CHAR(36) NOT NULL PRIMARY KEY,
nombre_categoria VARCHAR(100) NOT NULL,
descripcion_categoria TEXT NULL,
CONSTRAINT uq_nombre_categoria_unico UNIQUE (nombre_categoria)
);

CREATE TABLE subcategorias (
id_subcategoria CHAR(36) NOT NULL PRIMARY KEY,
nombre_subcategoria VARCHAR(100) NOT NULL,
id_categoria CHAR(36) NOT NULL,
descripcion_subcategoria TEXT NULL,
CONSTRAINT fk_subcategoria_categoria FOREIGN KEY (id_categoria) REFERENCES categorias (id_categoria),
CONSTRAINT uq_nombre_subcategoria_unico UNIQUE (nombre_subcategoria)
);

CREATE TABLE filtros (
id_filtro CHAR(36) NOT NULL PRIMARY KEY,
nombre_filtro VARCHAR(100) NOT NULL,
tipo_filtro ENUM ('Texto', 'Numérico', 'Lista') NOT NULL,
id_subcategoria CHAR(36) NOT NULL,
CONSTRAINT fk_filtro_subcategoria FOREIGN KEY (id_subcategoria) REFERENCES subcategorias (id_subcategoria)
);

CREATE TABLE opciones_filtro (
id_opcion_filtro CHAR(36) NOT NULL PRIMARY KEY,
valor_opcion_filtro VARCHAR(100) NOT NULL,
id_filtro CHAR(36) NOT NULL,
CONSTRAINT fk_opcion_filtro FOREIGN KEY (id_filtro) REFERENCES filtros (id_filtro)
);

-- Tabla principal para los productos
CREATE TABLE productos (
id_producto CHAR(36) NOT NULL PRIMARY KEY,
nombre_producto VARCHAR(100) NOT NULL,
descripcion_producto TEXT NOT NULL,
precio_producto DECIMAL(10, 2) UNSIGNED NOT NULL,
tipo_precio_producto ENUM ('Fijo', 'Negociable') DEFAULT 'Fijo',
estado_producto BOOLEAN DEFAULT 1,
id_subcategoria CHAR(36) NOT NULL,
CONSTRAINT fk_producto_subcategoria FOREIGN KEY (id_subcategoria) REFERENCES subcategorias (id_subcategoria)
);

CREATE TABLE producto_filtro (
id_producto CHAR(36) NOT NULL,
id_filtro CHAR(36) NOT NULL,
valor_filtro VARCHAR(100) NOT NULL, -- El valor asociado al filtro
PRIMARY KEY (id_producto, id_filtro),
CONSTRAINT fk_producto_filtro FOREIGN KEY (id_producto) REFERENCES productos (id_producto),
CONSTRAINT fk_filtro_producto FOREIGN KEY (id_filtro) REFERENCES filtros (id_filtro)
);

CREATE TABLE detalles_producto (
id_detalle_producto CHAR(36) NOT NULL PRIMARY KEY,
id_producto CHAR(36) NOT NULL,
foto_producto VARCHAR(50) NULL,
id_opcion_filtro CHAR(36) NOT NULL, 
valor_detalle_producto VARCHAR(100) NOT NULL, 
cantidad_disponible INT UNSIGNED NOT NULL, 
CONSTRAINT fk_detalle_producto FOREIGN KEY (id_producto) REFERENCES productos (id_producto),
CONSTRAINT fk_detalle_opcion_filtro FOREIGN KEY (id_opcion_filtro) REFERENCES opciones_filtro (id_opcion_filtro)
);

CREATE TABLE pedidos (
id_pedido CHAR(36) NOT NULL PRIMARY KEY,
estado_pedido ENUM ('Pendiente','Enviado','En camino','Cancelado','Negociando') DEFAULT 'Pendiente',
fecha_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
direccion_pedido VARCHAR(255) NOT NULL,
id_cliente CHAR(36) NOT NULL,
CONSTRAINT fk_cliente_pedido FOREIGN KEY (id_cliente) REFERENCES usuarios (id_usuario)
);

CREATE TABLE detalles_pedidos (
id_detalle_pedido CHAR(36) NOT NULL PRIMARY KEY,
id_pedido CHAR(36) NOT NULL,
id_producto CHAR(36) NOT NULL,
cantidad INT NOT NULL,
precio_unitario DECIMAL(10, 2) NOT NULL,
CONSTRAINT chk_precio_unitario_positive CHECK (precio_unitario > 0),
CONSTRAINT chk_cantidad_positive CHECK (cantidad > 0),
CONSTRAINT fk_detalle_pedido_pedido FOREIGN KEY (id_pedido) REFERENCES pedidos (id_pedido),
CONSTRAINT fk_detalle_pedido_producto FOREIGN KEY (id_producto) REFERENCES productos (id_producto)
);

CREATE TABLE favoritos (
id_favorito CHAR(36) NOT NULL PRIMARY KEY,
id_cliente CHAR(36) NOT NULL,
id_producto CHAR(36) NOT NULL,
fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_favorito_cliente FOREIGN KEY (id_cliente) REFERENCES clientes (id_cliente),
CONSTRAINT fk_favorito_producto FOREIGN KEY (id_producto) REFERENCES productos (id_producto)
);

-- Tabla para registrar likes/dislikes (aplica tanto a productos como servicios)
CREATE TABLE valoraciones (
id_valoracion CHAR(36) NOT NULL PRIMARY KEY,
id_cliente CHAR(36) NOT NULL,
id_producto CHAR(36) NOT NULL,
es_like BOOLEAN NOT NULL,
fecha_valoracion DATETIME DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_valoracion_cliente FOREIGN KEY (id_cliente) REFERENCES clientes (id_cliente),
CONSTRAINT fk_valoracion_producto FOREIGN KEY (id_producto) REFERENCES productos (id_producto)
);

CREATE TABLE comentarios (
id_comentario CHAR(36) NOT NULL PRIMARY KEY,
id_cliente CHAR(36) NOT NULL,
id_producto CHAR(36) NOT NULL,
comentario TEXT NOT NULL,
fecha_comentario DATETIME DEFAULT CURRENT_TIMESTAMP,
estado_comentario BOOLEAN DEFAULT 1,
CONSTRAINT fk_comentario_cliente FOREIGN KEY (id_cliente) REFERENCES clientes (id_cliente),
CONSTRAINT fk_comentario_producto FOREIGN KEY (id_producto) REFERENCES productos (id_producto)
);
