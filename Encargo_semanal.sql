CREATE TABLE ESTADO_CIVIL (
    id_estado_civil NUMBER (2) NOT NULL,
    descripcion_est_civil VARCHAR2 (25) NOT NULL
);

ALTER TABLE
    ESTADO_CIVIL
ADD
    CONSTRAINT PK_ESTADO_CIVIL PRIMARY KEY (id_estado_civil);

CREATE TABLE GENERO (
    id_genero NUMBER (3) NOT NULL,
    descripcion_genero VARCHAR2 (25) NOT NULL
);

ALTER TABLE
    GENERO
ADD
    CONSTRAINT PK_GENERO PRIMARY KEY (id_genero);

CREATE TABLE TITULO (
    id_titulo NUMBER (3) NOT NULL,
    descripcion_titulo VARCHAR2 (60) NOT NULL
);

ALTER TABLE
    TITULO
ADD
    CONSTRAINT PK_TITULO PRIMARY KEY (id_titulo);

CREATE TABLE IDIOMA (
    id_idioma NUMBER (3) GENERATED ALWAYS AS IDENTITY START WITH 25 INCREMENT BY 3 NOT NULL,
    nombre_idioma VARCHAR2 (30) NOT NULL
);

ALTER TABLE
    IDIOMA
ADD
    CONSTRAINT PK_IDIOMA PRIMARY KEY (id_idioma);

CREATE TABLE COMUNA (
    id_comuna NUMBER (5) NOT NULL,
    comuna_nombre VARCHAR2 (25) NOT NULL,
    cod_region NUMBER (2) NOT NULL
);

ALTER TABLE
    COMUNA
ADD
    CONSTRAINT PK_COMUNA PRIMARY KEY (id_comuna, cod_region);

CREATE SEQUENCE SE_COMUNA_ID_COMUNA START WITH 1101 INCREMENT BY 6;

CREATE TABLE COMPANIA (
    id_empresa NUMBER (2) NOT NULL,
    nombre_empresa VARCHAR2 (25) NOT NULL,
    calle VARCHAR2 (20) NOT NULL,
    numeracion NUMBER (5) NOT NULL,
    renta_promedio NUMBER (10) NOT NULL,
    pct_aumento NUMBER (4),
    cod_comuna NUMBER (5) NOT NULL,
    cod_region NUMBER (2) NOT NULL
);

ALTER TABLE
    COMPANIA
ADD
    CONSTRAINT PK_COMPANIA PRIMARY KEY (id_empresa);

ALTER TABLE
    COMPANIA
ADD
    CONSTRAINT UN_COMPANIA_NOMBRE UNIQUE (nombre_empresa);

CREATE SEQUENCE SE_COMPANIA_ID_EMPRESA START WITH 10 INCREMENT BY 5;

CREATE TABLE REGION (
    id_region NUMBER (2) GENERATED ALWAYS AS IDENTITY START WITH 7 INCREMENT BY 2 NOT NULL,
    nombre_region VARCHAR2 (25) NOT NULL
);

ALTER TABLE
    REGION
ADD
    CONSTRAINT PK_REGION PRIMARY KEY (id_region);

CREATE TABLE PERSONAL (
    rut_persona NUMBER (8) NOT NULL,
    dv_persona CHAR (1) NOT NULL,
    primer_nombre VARCHAR2 (25) NOT NULL,
    segundo_nombre VARCHAR2 (25),
    primer_apellido VARCHAR2 (25) NOT NULL,
    segundo_apellido VARCHAR2 (25) NOT NULL,
    email VARCHAR2 (100),
    calle VARCHAR2 (50) NOT NULL,
    numeracion NUMBER (5) NOT NULL,
    sueldo NUMBER (5) NOT NULL,
    cod_empresa NUMBER (2) NOT NULL,
    cod_estado_civil NUMBER (2),
    encargado_rut NUMBER (8),
    cod_genero NUMBER (3),
    cod_comuna NUMBER (5) NOT NULL,
    cod_region NUMBER (2) NOT NULL
);

ALTER TABLE
    PERSONAL
ADD
    CONSTRAINT PK_PERSONAL PRIMARY KEY (rut_persona);

ALTER TABLE
    PERSONAL
ADD
    CONSTRAINT CK_DV_PERSONA CHECK (
        dv_persona IN (
            '0',
            '1',
            '2',
            '3',
            '4',
            '5',
            '6',
            '7',
            '8',
            '9',
            'K'
        )
    );

ALTER TABLE
    PERSONAL
ADD
    CONSTRAINT CK_SUELDO CHECK (sueldo >= 450000);

ALTER TABLE
    PERSONAL
ADD
    CONSTRAINT UN_PERSONAL_EMAIL UNIQUE (email);

CREATE TABLE DOMINIO (
    id_idioma NUMBER (3) NOT NULL,
    rut_persona NUMBER (8) NOT NULL,
    nivel VARCHAR2 (25) NOT NULL
);

ALTER TABLE
    DOMINIO
ADD
    CONSTRAINT PK_DOMINIO PRIMARY KEY (id_idioma, rut_persona);

CREATE TABLE TITULACION (
    cod_titulo NUMBER (3) NOT NULL,
    rut_persona NUMBER (8) NOT NULL,
    fecha_titulacion DATE NOT NULL
);

ALTER TABLE
    TITULACION
ADD
    CONSTRAINT PK_TITULACION PRIMARY KEY (cod_titulo, rut_persona);

ALTER TABLE
    COMUNA
ADD
    CONSTRAINT FK_COMUNA_REGION FOREIGN KEY (cod_region) REFERENCES REGION (id_region);

ALTER TABLE
    COMPANIA
ADD
    CONSTRAINT FK_COMPANIA_COMUNA FOREIGN KEY (cod_comuna, cod_region) REFERENCES COMUNA (id_comuna, cod_region);

ALTER TABLE
    PERSONAL
ADD
    CONSTRAINT FK_PERSONAL_COMPANIA FOREIGN KEY (cod_empresa) REFERENCES COMPANIA (id_empresa);

ALTER TABLE
    PERSONAL
ADD
    CONSTRAINT FK_PERSONAL_COMUNA FOREIGN KEY (cod_comuna, cod_region) REFERENCES COMUNA (id_comuna, cod_region);

ALTER TABLE
    PERSONAL
ADD
    CONSTRAINT FK_PERSONAL_ESTADO_CIVIL FOREIGN KEY (cod_estado_civil) REFERENCES ESTADO_CIVIL (id_estado_civil);

ALTER TABLE
    PERSONAL
ADD
    CONSTRAINT FK_PERSONAL_GENERO FOREIGN KEY (cod_genero) REFERENCES GENERO (id_genero);

ALTER TABLE
    PERSONAL
ADD
    CONSTRAINT FK_PERSONAL_PERSONAL FOREIGN KEY (encargado_rut) REFERENCES PERSONAL (rut_persona);

ALTER TABLE
    DOMINIO
ADD
    CONSTRAINT FK_DOMINIO_IDIOMA FOREIGN KEY (id_idioma) REFERENCES IDIOMA (id_idioma);

ALTER TABLE
    DOMINIO
ADD
    CONSTRAINT FK_DOMINIO_PERSONAL FOREIGN KEY (rut_persona) REFERENCES PERSONAL (rut_persona);

ALTER TABLE
    TITULACION
ADD
    CONSTRAINT FK_TITULACION_TITULO FOREIGN KEY (cod_titulo) REFERENCES TITULO (id_titulo);

ALTER TABLE
    TITULACION
ADD
    CONSTRAINT FK_TITULACION_PERSONAL FOREIGN KEY (rut_persona) REFERENCES PERSONAL (rut_persona);

-- Recuperacion de datos:

-- informe 1

SELECT
    nombre_empresa AS "Nombre Empresa",
    calle || ' ' || numeracion AS "Direccion",
    renta_promedio AS "Renta Promedio",
    renta_promedio + (renta_promedio * pct_aumento) AS "Simulacion de Renta"
FROM
    COMPANIA
ORDER BY
    renta_promedio DESC,
    nombre_empresa ASC;

-- informe 2

SELECT
    id_empresa AS "CODIGO",
    nombre_empresa AS "EMPRESA",
    renta_promedio AS "PROM RENTA ACTUAL",
    pct_aumento * 1.15 AS "PCT AUMENTADO EN 15%",
    renta_promedio + (renta_promedio * (pct_aumento * 1.15)) AS "RENTA AUMENTADA"
FROM COMPANIA
ORDER BY 
    renta_promedio ASC,
    nombre_empresa DESC;