DROP TABLE afp CASCADE CONSTRAINTS;
DROP TABLE salud CASCADE CONSTRAINTS;
DROP TABLE medio_pago CASCADE CONSTRAINTS;
DROP TABLE marca CASCADE CONSTRAINTS;
DROP TABLE categoria CASCADE CONSTRAINTS;
DROP TABLE region CASCADE CONSTRAINTS;
DROP TABLE comuna CASCADE CONSTRAINTS;
DROP TABLE proveedor CASCADE CONSTRAINTS;
DROP TABLE producto CASCADE CONSTRAINTS;
DROP TABLE empleado CASCADE CONSTRAINTS;
DROP TABLE administrativo CASCADE CONSTRAINTS;
DROP TABLE vendedor CASCADE CONSTRAINTS;
DROP TABLE venta CASCADE CONSTRAINTS;
DROP TABLE detalle_venta CASCADE CONSTRAINTS;

--creacion de tablas

CREATE TABLE afp (
    id_afp NUMBER(5) GENERATED ALWAYS AS IDENTITY START WITH 210 INCREMENT BY 6, 
    nom_afp VARCHAR2(255) NOT NULL,

    CONSTRAINT PK_AFP PRIMARY KEY (id_afp)
);

CREATE TABLE salud (
    id_salud NUMBER(4),
    nom_salud VARCHAR2(40) NOT NULL,
    
    CONSTRAINT PK_SALUD PRIMARY KEY (id_salud)
);

CREATE TABLE medio_pago (
    id_mpago NUMBER(3),
    nombre_mpago VARCHAR2(50) NOT NULL,
    
    CONSTRAINT PK_MEDIO_PAGO PRIMARY KEY (id_mpago)
);

CREATE TABLE marca (
    id_marca NUMBER(3),
    nombre_marca VARCHAR2(25) NOT NULL,
    
    CONSTRAINT PK_MARCA PRIMARY KEY (id_marca)
);

CREATE TABLE categoria (
    id_categoria NUMBER(3),
    nombre_categoria VARCHAR2(255) NOT NULL,
    
    CONSTRAINT PK_CATEGORIA PRIMARY KEY (id_categoria)
);

CREATE TABLE region (
    id_region NUMBER(4),
    nom_region VARCHAR2(255) NOT NULL,
    
    CONSTRAINT PK_REGION PRIMARY KEY (id_region)
);

CREATE TABLE comuna (
    id_comuna NUMBER(4),
    nom_comuna VARCHAR2(100) NOT NULL,
    cod_region NUMBER(4) NOT NULL,
    
    CONSTRAINT PK_COMUNA PRIMARY KEY (id_comuna),
    CONSTRAINT FK_COMUNA_REGION FOREIGN KEY (cod_region)
        REFERENCES region(id_region)
);

CREATE TABLE proveedor (
    id_proveedor NUMBER(5),
    nombre_proveedor VARCHAR2(150) NOT NULL,
    rut_proveedor VARCHAR2(10) NOT NULL,
    telefono VARCHAR2(10) NOT NULL,
    email VARCHAR2(200) NOT NULL,
    direccion VARCHAR2(200) NOT NULL,
    cod_comuna NUMBER(4),
    
    CONSTRAINT PK_PROVEEDOR PRIMARY KEY (id_proveedor),
    CONSTRAINT FK_PROVEEDOR_COMUNA FOREIGN KEY (cod_comuna)
        REFERENCES comuna(id_comuna)
);

CREATE TABLE producto (
    id_producto NUMBER(4),
    nombre_producto VARCHAR2(100) NOT NULL,
    precio_unitario NUMBER NOT NULL,
    origen_nacional CHAR(1) NOT NULL,
    stock_minimo NUMBER(3) NOT NULL,
    activo CHAR(1) NOT NULL,
    cod_marca NUMBER(3) NOT NULL,
    cod_categoria NUMBER(3) NOT NULL,
    cod_proveedor NUMBER(5) NOT NULL,
    
    CONSTRAINT PK_PRODUCTO PRIMARY KEY (id_producto),
    CONSTRAINT FK_PRODUCTO_MARCA FOREIGN KEY (cod_marca)
        REFERENCES marca(id_marca),
    CONSTRAINT FK_PRODUCTO_CATEGORIA FOREIGN KEY (cod_categoria)
        REFERENCES categoria(id_categoria),
    CONSTRAINT FK_PRODUCTO_PROVEEDOR FOREIGN KEY (cod_proveedor)
        REFERENCES proveedor(id_proveedor)  
);

CREATE TABLE empleado (
    id_empleado NUMBER(4),
    rut_empleado VARCHAR2(10) NOT NULL,
    nombre_empleado VARCHAR2(25) NOT NULL,
    apellido_paterno VARCHAR2(25) NOT NULL,
    apellido_materno VARCHAR2(25) NOT NULL,
    fecha_contratacion DATE NOT NULL,
    sueldo_base NUMBER(10) NOT NULL,
    bono_jefatura NUMBER(10),
    activo CHAR(1) NOT NULL,
    tipo_empleado VARCHAR2(25) NOT NULL,
    cod_empleado NUMBER(4),
    cod_salud NUMBER(4) NOT NULL,
    cod_afp NUMBER(5) NOT NULL,
    
    CONSTRAINT PK_EMPLEADO PRIMARY KEY (id_empleado),
    CONSTRAINT FK_EMPLEADO_EMPLEADO FOREIGN KEY (cod_empleado)
        REFERENCES empleado(id_empleado),
    CONSTRAINT FK_EMPLEADO_SALUD FOREIGN KEY (cod_salud)
        REFERENCES salud(id_salud),
    CONSTRAINT FK_EMPLEADO_AFP FOREIGN KEY (cod_afp)
        REFERENCES afp(id_afp)  
);

CREATE TABLE administrativo (
    id_empleado NUMBER(4),
    
    CONSTRAINT PK_ADMINISTRATIVO PRIMARY KEY (id_empleado),
    CONSTRAINT FK_ADMINISTRATIVO_EMPLEADO FOREIGN KEY (id_empleado)
        REFERENCES empleado(id_empleado)  
);

CREATE TABLE vendedor (
    id_empleado NUMBER(4),
    comision_venta NUMBER(5,2),
    
    CONSTRAINT PK_VENDEDOR PRIMARY KEY (id_empleado),
    CONSTRAINT FK_VENDEDOR_EMPLEADO FOREIGN KEY (id_empleado)
        REFERENCES empleado(id_empleado)  
);

CREATE TABLE venta (
    id_venta NUMBER(4) GENERATED ALWAYS AS IDENTITY START WITH 5050 INCREMENT BY 3,
    fecha_venta DATE NOT NULL,
    total_venta NUMBER(10) NOT NULL,
    cod_mpago NUMBER(3) NOT NULL,
    cod_empleado NUMBER(4) NOT NULL,
    
    CONSTRAINT PK_VENTA PRIMARY KEY (id_venta),
    CONSTRAINT FK_VENTA_MEDIO_PAGO FOREIGN KEY (cod_mpago)
        REFERENCES medio_pago(id_mpago), 
    CONSTRAINT FK_VENTA_EMPLEADO FOREIGN KEY (cod_empleado)
        REFERENCES empleado(id_empleado)    
);

CREATE TABLE detalle_venta (
    cod_venta NUMBER(4) NOT NULL,
    cod_producto NUMBER(4) NOT NULL,
    cantidad NUMBER(6) NOT NULL,
    
    
    CONSTRAINT PK_DETALLE_VENTA PRIMARY KEY (cod_venta, cod_producto),
    CONSTRAINT FK_DETALLE_VENTA_VENTA FOREIGN KEY (cod_venta)
        REFERENCES venta(id_venta), 
    CONSTRAINT FK_DETALLE_VENTA_PRODUCTO FOREIGN KEY (cod_producto)
        REFERENCES producto(id_producto)    
);

-- secuencias

DROP SEQUENCE SEQ_SALUD;

CREATE SEQUENCE SEQ_SALUD
    START WITH 2050
    INCREMENT BY 10;

DROP SEQUENCE SEQ_EMPLEADO;

CREATE SEQUENCE SEQ_EMPLEADO
    START WITH 750
    INCREMENT BY 3;
    
-- modificaciones

ALTER TABLE empleado
ADD CONSTRAINT CK_EMPLEADO_SUELDO CHECK (sueldo_base >= 400000);

ALTER TABLE vendedor
ADD CONSTRAINT CK_VENDEDOR_COMISION 
CHECK (comision_venta >= 0 AND comision_venta <= 0.25);

ALTER TABLE producto
ADD CONSTRAINT CK_PRODUCTO_STOCK CHECK (stock_minimo >= 3);

ALTER TABLE proveedor
ADD CONSTRAINT UQ_PROVEEDOR_EMAIL UNIQUE (email);

ALTER TABLE marca
ADD CONSTRAINT UQ_MARCA_NOMBRE UNIQUE (nombre_marca);

ALTER TABLE detalle_venta
ADD CONSTRAINT CK_DETALLE_VENTA_CANTIDAD CHECK (cantidad > 0);

-- inserciones

INSERT INTO afp (nom_afp) VALUES ('Habitat');
INSERT INTO afp (nom_afp) VALUES ('Cuprum');
INSERT INTO afp (nom_afp) VALUES ('Provida');
INSERT INTO afp (nom_afp) VALUES ('PlanVital');

INSERT INTO salud (id_salud, nom_salud) VALUES (SEQ_SALUD.NEXTVAL, 'Fonasa');
INSERT INTO salud (id_salud, nom_salud) VALUES (SEQ_SALUD.NEXTVAL, 'Isapre Colmena');
INSERT INTO salud (id_salud, nom_salud) VALUES (SEQ_SALUD.NEXTVAL, 'Isapre Banmédica');
INSERT INTO salud (id_salud, nom_salud) VALUES (SEQ_SALUD.NEXTVAL, 'Isapre Cruz Blanca');

INSERT INTO medio_pago (id_mpago, nombre_mpago) VALUES (11, 'Efectivo');
INSERT INTO medio_pago (id_mpago, nombre_mpago) VALUES (12, 'Tarjeta Débito');
INSERT INTO medio_pago (id_mpago, nombre_mpago) VALUES (13, 'Tarjeta Crédito');
INSERT INTO medio_pago (id_mpago, nombre_mpago) VALUES (14, 'Cheque');

INSERT INTO marca (id_marca, nombre_marca) VALUES (1, 'Coca-Cola');
INSERT INTO marca (id_marca, nombre_marca) VALUES (2, 'Pepsi');
INSERT INTO marca (id_marca, nombre_marca) VALUES (3, 'Nestlé');

INSERT INTO categoria (id_categoria, nombre_categoria) VALUES (1, 'Bebidas');
INSERT INTO categoria (id_categoria, nombre_categoria) VALUES (2, 'Alimentos');
INSERT INTO categoria (id_categoria, nombre_categoria) VALUES (3, 'Snacks');

INSERT INTO region (id_region, nom_region) VALUES (1, 'Region Metropolitana'); 
INSERT INTO region (id_region, nom_region) VALUES (2, 'Valparaíso');
INSERT INTO region (id_region, nom_region) VALUES (3, 'Biobío');
INSERT INTO region (id_region, nom_region) VALUES (4, 'Los Lagos');

INSERT INTO comuna (id_comuna, nom_comuna, cod_region) VALUES (103, 'Providencia', 1);
INSERT INTO comuna (id_comuna, nom_comuna, cod_region) VALUES (104, 'Ñuñoa', 1);
INSERT INTO comuna (id_comuna, nom_comuna, cod_region) VALUES (105, 'La Florida', 1);

INSERT INTO comuna (id_comuna, nom_comuna, cod_region) VALUES (202, 'Viña del Mar', 2);
INSERT INTO comuna (id_comuna, nom_comuna, cod_region) VALUES (203, 'Quilpué', 2);
INSERT INTO comuna (id_comuna, nom_comuna, cod_region) VALUES (204, 'Concón', 2);

INSERT INTO comuna (id_comuna, nom_comuna, cod_region) VALUES (301, 'Concepción', 3);
INSERT INTO comuna (id_comuna, nom_comuna, cod_region) VALUES (302, 'Talcahuano', 3);
INSERT INTO comuna (id_comuna, nom_comuna, cod_region) VALUES (303, 'Chillán', 3);

INSERT INTO comuna (id_comuna, nom_comuna, cod_region) VALUES (401, 'Temuco', 4);
INSERT INTO comuna (id_comuna, nom_comuna, cod_region) VALUES (402, 'Villarrica', 4);
INSERT INTO comuna (id_comuna, nom_comuna, cod_region) VALUES (403, 'Angol', 4);

INSERT INTO proveedor (id_proveedor, nombre_proveedor, rut_proveedor, telefono, email, direccion, cod_comuna)
VALUES (1001, 'Proveeduría Central', '12345678-9', '22223333', 'contacto@proveeduria.cl', 'Av. Principal 100', 103);

INSERT INTO proveedor (id_proveedor, nombre_proveedor, rut_proveedor, telefono, email, direccion, cod_comuna)
VALUES (1002, 'Distribuciones Norte', '98765432-1', '22334455', 'ventas@distribuciones.cl', 'Calle Norte 45', 103);

INSERT INTO proveedor (id_proveedor, nombre_proveedor, rut_proveedor, telefono, email, direccion, cod_comuna)
VALUES (1003, 'Alimentos del Sur', '11122333-4', '22445566', 'contacto@alimentosdelsur.cl', 'Av. Sur 150', 301);

INSERT INTO proveedor (id_proveedor, nombre_proveedor, rut_proveedor, telefono, email, direccion, cod_comuna)
VALUES (1004, 'Bebidas y Snacks', '22233444-5', '22556677', 'ventas@bebidassnacks.cl', 'Calle Central 200', 402);

INSERT INTO proveedor (id_proveedor, nombre_proveedor, rut_proveedor, telefono, email, direccion, cod_comuna)
VALUES (1005, 'Distribuciones Austral', '33344555-6', '22667788', 'contacto@distribucionesaustral.cl', 'Av. Austral 300', 401);

INSERT INTO proveedor (id_proveedor, nombre_proveedor, rut_proveedor, telefono, email, direccion, cod_comuna)
VALUES (1006, 'Proveedora Norteña', '44455666-7', '22778899', 'ventas@proveedoranortena.cl', 'Calle Norte 500', 402);

INSERT INTO proveedor (id_proveedor, nombre_proveedor, rut_proveedor, telefono, email, direccion, cod_comuna)
VALUES (1008, 'Alimentos del Centro', '66677888-9', '22990011', 'ventas@alimentoscentro.cl', 'Calle Centro 50', 105);

INSERT INTO producto (id_producto, nombre_producto, precio_unitario, origen_nacional, stock_minimo, activo, cod_marca, cod_categoria, cod_proveedor)
VALUES (100, 'Coca-Cola 500ml', 800, 'S', 10, 'S', 1, 1, 1001);

INSERT INTO producto (id_producto, nombre_producto, precio_unitario, origen_nacional, stock_minimo, activo, cod_marca, cod_categoria, cod_proveedor)
VALUES (101, 'Pepsi 500ml', 750, 'S', 10, 'S', 2, 1, 1002);

INSERT INTO producto (id_producto, nombre_producto, precio_unitario, origen_nacional, stock_minimo, activo, cod_marca, cod_categoria, cod_proveedor)
VALUES (102, 'Nestlé Chocolate', 1200, 'S', 5, 'S', 3, 2, 1001);

INSERT INTO producto (id_producto, nombre_producto, precio_unitario, origen_nacional, stock_minimo, activo, cod_marca, cod_categoria, cod_proveedor)
VALUES (103, 'Sprite 500ml', 780, 'S', 8, 'S', 1, 1, 1001);

INSERT INTO producto (id_producto, nombre_producto, precio_unitario, origen_nacional, stock_minimo, activo, cod_marca, cod_categoria, cod_proveedor)
VALUES (104, 'Fanta 500ml', 770, 'S', 8, 'S', 2, 1, 1002);

INSERT INTO producto (id_producto, nombre_producto, precio_unitario, origen_nacional, stock_minimo, activo, cod_marca, cod_categoria, cod_proveedor)
VALUES (105, 'KitKat 45g', 500, 'S', 5, 'S', 3, 2, 1001);

INSERT INTO producto (id_producto, nombre_producto, precio_unitario, origen_nacional, stock_minimo, activo, cod_marca, cod_categoria, cod_proveedor)
VALUES (106, 'Lays Classic 150g', 1200, 'S', 7, 'S', 3, 3, 1005);

INSERT INTO producto (id_producto, nombre_producto, precio_unitario, origen_nacional, stock_minimo, activo, cod_marca, cod_categoria, cod_proveedor)
VALUES (107, 'Doritos Nacho 150g', 1300, 'S', 7, 'S', 3, 3, 1005);

INSERT INTO producto (id_producto, nombre_producto, precio_unitario, origen_nacional, stock_minimo, activo, cod_marca, cod_categoria, cod_proveedor)
VALUES (108, 'Pepsi 1.5L', 1500, 'S', 12, 'S', 2, 1, 1002);

INSERT INTO producto (id_producto, nombre_producto, precio_unitario, origen_nacional, stock_minimo, activo, cod_marca, cod_categoria, cod_proveedor)
VALUES (109, 'Coca-Cola 1.5L', 1550, 'S', 12, 'S', 1, 1, 1001);

INSERT INTO producto (id_producto, nombre_producto, precio_unitario, origen_nacional, stock_minimo, activo, cod_marca, cod_categoria, cod_proveedor)
VALUES (110, 'Nestlé Leche 1L', 900, 'S', 6, 'S', 3, 2, 1001);

INSERT INTO empleado (
    id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno,
    fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp
)
VALUES (SEQ_EMPLEADO.NEXTVAL, '11111111-1', 'Marcela', 'Gonzáles', 'Pérez',
        TO_DATE('2022-03-15','YYYY-MM-DD'), 950000, 80000, 'S', 'Administrativo', NULL, 2050, 210);

INSERT INTO administrativo (id_empleado)
VALUES (SEQ_EMPLEADO.CURRVAL);

INSERT INTO empleado (
    id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno,
    fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp
)
VALUES (SEQ_EMPLEADO.NEXTVAL, '22222222-2', 'Jose', 'Muñoz', 'Ramirez',
        TO_DATE('2021-07-10','YYYY-MM-DD'), 900000, 75000, 'S', 'Administrativo', NULL, 2060, 216);

INSERT INTO administrativo (id_empleado)
VALUES (SEQ_EMPLEADO.CURRVAL);

INSERT INTO empleado (
    id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno,
    fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp
)
VALUES (SEQ_EMPLEADO.NEXTVAL, '33333333-3', 'Verónica', 'Soto', 'Alarcón',
        TO_DATE('2020-01-05','YYYY-MM-DD'), 880000, 70000, 'S', 'Vendedor', 750, 2060, 228);

INSERT INTO vendedor (id_empleado, comision_venta)
VALUES (SEQ_EMPLEADO.CURRVAL, 0.15);   

INSERT INTO empleado (
    id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno,
    fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp
)
VALUES (SEQ_EMPLEADO.NEXTVAL, '44444444-4', 'Luis', 'Reyes', 'Fuentes',
        TO_DATE('2023-01-04','YYYY-MM-DD'), 560000, NULL, 'S', 'Vendedor', 750, 2070, 228);

INSERT INTO vendedor (id_empleado, comision_venta)
VALUES (SEQ_EMPLEADO.CURRVAL, 0.15);   

INSERT INTO empleado (
    id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno,
    fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp
)
VALUES (SEQ_EMPLEADO.NEXTVAL, '55555555-5', 'Claudia', 'Fernandez', 'Lagos',
        TO_DATE('2023-04-15','YYYY-MM-DD'), 600000, NULL, 'S', 'Vendedor', 753, 2070, 216);

INSERT INTO vendedor (id_empleado, comision_venta)
VALUES (SEQ_EMPLEADO.CURRVAL, 0.15);  

INSERT INTO empleado (
    id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno,
    fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp
)
VALUES (SEQ_EMPLEADO.NEXTVAL, '66666666-6', 'Carlos', 'Navarro', 'Vega',
        TO_DATE('2023-05-01','YYYY-MM-DD'), 610000, NULL, 'S', 'Administrativo', 753, 2060, 210);

INSERT INTO administrativo (id_empleado)
VALUES (SEQ_EMPLEADO.CURRVAL);

INSERT INTO empleado (
    id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno,
    fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp
)
VALUES (SEQ_EMPLEADO.NEXTVAL, '77777777-7', 'Javiera', 'Pino', 'Rojas',
        TO_DATE('2023-05-10','YYYY-MM-DD'), 650000, NULL, 'S', 'Administrativo', 750, 2050, 210);

INSERT INTO administrativo (id_empleado)
VALUES (SEQ_EMPLEADO.CURRVAL);

INSERT INTO empleado (
    id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno,
    fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp
)
VALUES (SEQ_EMPLEADO.NEXTVAL, '88888888-8', 'Diego', 'Mella', 'Contreras',
        TO_DATE('2023-05-12','YYYY-MM-DD'), 620000, NULL, 'S', 'Vendedor', 750, 2060, 216);

INSERT INTO vendedor (id_empleado, comision_venta)
VALUES (SEQ_EMPLEADO.CURRVAL, 0.15);  

INSERT INTO empleado (
    id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno,
    fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp
)
VALUES (SEQ_EMPLEADO.NEXTVAL, '99999999-9', 'Fernanda', 'Salas', 'Herrera',
        TO_DATE('2023-05-18','YYYY-MM-DD'), 570000, NULL, 'S', 'Vendedor', 753, 2070, 228);

INSERT INTO vendedor (id_empleado, comision_venta)
VALUES (SEQ_EMPLEADO.CURRVAL, 0.15);  

INSERT INTO empleado (
    id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno,
    fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp
)
VALUES (SEQ_EMPLEADO.NEXTVAL, '10101010-0', 'Tomás', 'Vidal', 'Espinoza',
        TO_DATE('2023-06-01','YYYY-MM-DD'), 530000, NULL, 'S', 'Vendedor', NULL, 2050, 222);

INSERT INTO vendedor (id_empleado, comision_venta)
VALUES (SEQ_EMPLEADO.CURRVAL, 0.15);  


INSERT INTO venta (fecha_venta, total_venta, cod_mpago, cod_empleado)
VALUES (TO_DATE('2023-05-12','YYYY-MM-DD'), 225990, 12, 771);

INSERT INTO venta (fecha_venta, total_venta, cod_mpago, cod_empleado)
VALUES (TO_DATE('2023-10-23','YYYY-MM-DD'), 524990, 13, 777);

INSERT INTO venta (fecha_venta, total_venta, cod_mpago, cod_empleado)
VALUES (TO_DATE('2023-02-17','YYYY-MM-DD'), 466990, 11, 759);

INSERT INTO detalle_venta (cod_venta, cod_producto, cantidad)
VALUES (5050, 100, 2);

INSERT INTO detalle_venta (cod_venta, cod_producto, cantidad)
VALUES (5050, 102, 1);

INSERT INTO detalle_venta (cod_venta, cod_producto, cantidad)
VALUES (5053, 101, 3);

INSERT INTO detalle_venta (cod_venta, cod_producto, cantidad)
VALUES (5053, 103, 2);

INSERT INTO detalle_venta (cod_venta, cod_producto, cantidad)
VALUES (5056, 104, 1);

INSERT INTO detalle_venta (cod_venta, cod_producto, cantidad)
VALUES (5056, 105, 4);

-- informe 1
CREATE TABLE informe_1 AS
SELECT
    id_empleado AS "IDENTIFICADOR",
    nombre_empleado || ' ' || apellido_paterno || ' ' || apellido_materno AS "NOMBRE COMPLETO",
    sueldo_base AS "SALARIO",
    bono_jefatura AS "BONIFICACION",
    sueldo_base + bono_jefatura AS "SALARIO SIMULADO"
FROM empleado
WHERE bono_jefatura IS NOT NULL AND activo = 'S'
ORDER BY "SALARIO SIMULADO" DESC, apellido_paterno DESC;

-- informe 2
CREATE TABLE informe_2 AS
SELECT 
    nombre_empleado || ' ' || apellido_paterno || ' ' || apellido_materno AS "EMPLEADO",
    sueldo_base AS "SUELDO",
    sueldo_base * 0.08 AS "POSIBLE AUMENTO",
    sueldo_base + (sueldo_base * 0.08) AS "SUELDO SIMULADO"
FROM empleado
WHERE sueldo_base >= 550000 AND sueldo_base <= 800000
ORDER BY sueldo_base ASC;