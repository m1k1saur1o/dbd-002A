CREATE USER PRY2204_S9 IDENTIFIED BY "PRY2204.semana_9" DEFAULT TABLESPACE DATA TEMPORARY TABLESPACE TEMP QUOTA UNLIMITED ON DATA;

GRANT CREATE SESSION TO PRY2204_S9;

GRANT RESOURCE TO PRY2204_S9;

ALTER USER PRY2204_S9 DEFAULT ROLE RESOURCE;

CREATE SEQUENCE SEQ_REGION START WITH 21 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE TABLE AFP (
    id_afp NUMBER NOT NULL,
    nombre VARCHAR2 (50) NOT NULL
);

ALTER TABLE
    AFP
ADD
    CONSTRAINT PK_AFP PRIMARY KEY (id_afp);

ALTER TABLE
    AFP
ADD
    CONSTRAINT UQ_AFP_NOMBRE UNIQUE (nombre);

CREATE TABLE ASIGNACION_TURNO (
    id_asignacion_turno NUMBER NOT NULL,
    fecha DATE NOT NULL,
    rol VARCHAR2 (50),
    id_maquina NUMBER NOT NULL,
    id_turno VARCHAR2 (10) NOT NULL,
    id_empleado NUMBER NOT NULL,
    id_planta NUMBER NOT NULL
);

ALTER TABLE
    ASIGNACION_TURNO
ADD
    CONSTRAINT PK_ASIGNACION_TURNO PRIMARY KEY (id_asignacion_turno);

CREATE TABLE COMUNA (
    id_comuna NUMBER GENERATED ALWAYS AS IDENTITY START WITH 1050 INCREMENT BY 5 NOT NULL,
    nombre VARCHAR2(50) NOT NULL,
    id_region NUMBER NOT NULL,
    CONSTRAINT PK_COMUNA PRIMARY KEY (id_comuna)
);

ALTER TABLE
    COMUNA
ADD
    CONSTRAINT UQ_COMUNA_NOMBRE UNIQUE (nombre);

CREATE TABLE EMPLEADO (
    id NUMBER NOT NULL,
    rut VARCHAR2 (11) NOT NULL,
    nombre VARCHAR2 (100) NOT NULL,
    apellido VARCHAR2 (100) NOT NULL,
    fecha_contratacion DATE NOT NULL,
    sueldo_base NUMBER NOT NULL,
    estado CHAR (1) DEFAULT 'S' NOT NULL,
    id_afp NUMBER NOT NULL,
    id_sistema_salud NUMBER NOT NULL
);

ALTER TABLE
    EMPLEADO
ADD
    CONSTRAINT CK_EMPLEADO_ESTADO CHECK (estado IN ('S', 'N'));

ALTER TABLE
    EMPLEADO
ADD
    CONSTRAINT PK_EMPLEADO PRIMARY KEY (id);

ALTER TABLE
    EMPLEADO
ADD
    CONSTRAINT UQ_EMPLEADO_RUT UNIQUE (rut);

CREATE TABLE JEFE_TURNO (
    id NUMBER NOT NULL,
    area_responsabilidad VARCHAR2 (100) NOT NULL,
    max_operarios NUMBER NOT NULL
);

ALTER TABLE
    JEFE_TURNO
ADD
    CONSTRAINT PK_JEFE_TURNO PRIMARY KEY (id);

CREATE TABLE MAQUINA (
    id_maquina NUMBER NOT NULL,
    nombre VARCHAR2 (50) NOT NULL,
    estado CHAR (1) NOT NULL,
    tipo VARCHAR2 (50) NOT NULL,
    id_planta NUMBER NOT NULL
);

ALTER TABLE
    MAQUINA
ADD
    CONSTRAINT UQ_MAQUINA_TIPO UNIQUE (tipo);

ALTER TABLE
    MAQUINA
ADD
    CONSTRAINT CK_MAQUINA_ESTADO CHECK (estado IN ('S', 'N'));

ALTER TABLE
    MAQUINA
ADD
    CONSTRAINT PK_MAQUINA PRIMARY KEY (id_maquina, id_planta);

CREATE TABLE OPERARIO (
    id NUMBER NOT NULL,
    categoria_proceso VARCHAR2 (100) NOT NULL,
    certificacion VARCHAR2 (100),
    horas_estandar NUMBER DEFAULT 8 NOT NULL
);

ALTER TABLE
    OPERARIO
ADD
    CONSTRAINT PK_OPERARIO PRIMARY KEY (id);

CREATE TABLE ORDEN_MANTENCION (
    id NUMBER NOT NULL,
    fecha_programada DATE NOT NULL,
    fecha_ejecucion DATE,
    descripcion VARCHAR2 (100) NOT NULL,
    id_maquina NUMBER NOT NULL,
    id_planta NUMBER NOT NULL
);

ALTER TABLE
    ORDEN_MANTENCION
ADD
    CONSTRAINT PK_ORDEN_MANTENCION PRIMARY KEY (id);

ALTER TABLE
    ORDEN_MANTENCION
ADD
    CONSTRAINT CK_FECHA_EJECUCION CHECK (
        fecha_ejecucion IS NULL
        OR fecha_ejecucion >= fecha_programada
    );

CREATE TABLE PLANTA (
    id_planta NUMBER NOT NULL,
    nombre VARCHAR2 (50) NOT NULL,
    direccion VARCHAR2 (100) NOT NULL,
    id_comuna NUMBER NOT NULL
);

ALTER TABLE
    PLANTA
ADD
    CONSTRAINT PK_PLANTA PRIMARY KEY (id_planta);

CREATE TABLE REGION (
    id_region NUMBER NOT NULL,
    nombre VARCHAR2 (50) NOT NULL
);

ALTER TABLE
    REGION
ADD
    CONSTRAINT PK_REGION PRIMARY KEY (id_region);

ALTER TABLE
    REGION
ADD
    CONSTRAINT UQ_REGION_NOMBRE UNIQUE (nombre);

CREATE TABLE SISTEMA_SALUD (
    id_sistema_salud NUMBER NOT NULL,
    nombre VARCHAR2 (50) NOT NULL
);

ALTER TABLE
    SISTEMA_SALUD
ADD
    CONSTRAINT PK_SISTEMA_SALUD PRIMARY KEY (id_sistema_salud);

ALTER TABLE
    SISTEMA_SALUD
ADD
    CONSTRAINT UQ_SISTEMA_SALUD_NOMBRE UNIQUE (nombre);

CREATE TABLE TECNICO_MANTENCION (
    id NUMBER NOT NULL,
    especialidad VARCHAR2 (100) NOT NULL,
    nivel_certificacion VARCHAR2 (100),
    tiempo_respuesta NUMBER NOT NULL
);

ALTER TABLE
    TECNICO_MANTENCION
ADD
    CONSTRAINT PK_TECNICO_MANTENCION PRIMARY KEY (id);

CREATE TABLE TIENE_JEFE (
    empleado_id NUMBER NOT NULL,
    jefe_id NUMBER NOT NULL
);

ALTER TABLE
    TIENE_JEFE
ADD
    CONSTRAINT Relation_15_PK PRIMARY KEY (empleado_id, jefe_id);

CREATE TABLE TURNO (
    id_turno VARCHAR2(10) NOT NULL,
    tipo_horario VARCHAR2 (20) NOT NULL,
    hora_inicio CHAR (5) NOT NULL,
    hora_fin CHAR (5) NOT NULL
);

ALTER TABLE
    TURNO
ADD
    CONSTRAINT UQ_TURNO_TIPO UNIQUE (tipo_horario);

ALTER TABLE
    TURNO
ADD
    CONSTRAINT CK_HORA_INICIO_FORMAT CHECK (
        REGEXP_LIKE(
            hora_inicio,
            '^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$'
        )
    );

ALTER TABLE
    TURNO
ADD
    CONSTRAINT CK_HORA_FIN_FORMAT CHECK (
        REGEXP_LIKE(hora_fin, '^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$')
    );

ALTER TABLE
    TURNO
ADD
    CONSTRAINT PK_TURNO PRIMARY KEY (id_turno);

ALTER TABLE
    ASIGNACION_TURNO
ADD
    CONSTRAINT FK_ASIGNACION_TURNO_EMPLEADO FOREIGN KEY (id_empleado) REFERENCES EMPLEADO (id);

ALTER TABLE
    ASIGNACION_TURNO
ADD
    CONSTRAINT FK_ASIGNACION_TURNO_MAQUINA FOREIGN KEY (id_maquina, id_planta) REFERENCES MAQUINA (id_maquina, id_planta);

ALTER TABLE
    ASIGNACION_TURNO
ADD
    CONSTRAINT FK_ASIGNACION_TURNO_TURNO FOREIGN KEY (id_turno) REFERENCES TURNO (id_turno);

ALTER TABLE
    COMUNA
ADD
    CONSTRAINT FK_COMUNA_REGION FOREIGN KEY (id_region) REFERENCES REGION (id_region);

ALTER TABLE
    EMPLEADO
ADD
    CONSTRAINT FK_EMPLEADO_AFP FOREIGN KEY (id_afp) REFERENCES AFP (id_afp);

ALTER TABLE
    TIENE_JEFE
ADD
    CONSTRAINT FK_EMPLEADO_EMPLEADO FOREIGN KEY (empleado_id) REFERENCES EMPLEADO (id);

ALTER TABLE
    TIENE_JEFE
ADD
    CONSTRAINT FK_EMPLEADO_JEFE FOREIGN KEY (jefe_id) REFERENCES EMPLEADO (id);

ALTER TABLE
    EMPLEADO
ADD
    CONSTRAINT FK_EMPLEADO_SISTEMA_SALUD FOREIGN KEY (id_sistema_salud) REFERENCES SISTEMA_SALUD (id_sistema_salud);

ALTER TABLE
    JEFE_TURNO
ADD
    CONSTRAINT FK_JEFE_TURNO_EMPLEADO FOREIGN KEY (id) REFERENCES EMPLEADO (id);

ALTER TABLE
    MAQUINA
ADD
    CONSTRAINT FK_MAQUINA_PLANTA FOREIGN KEY (id_planta) REFERENCES PLANTA (id_planta);

ALTER TABLE
    OPERARIO
ADD
    CONSTRAINT FK_OPERARIO_EMPLEADO FOREIGN KEY (id) REFERENCES EMPLEADO (id);

ALTER TABLE
    ORDEN_MANTENCION
ADD
    CONSTRAINT FK_ORDEN_MANTENCION_MAQUINA FOREIGN KEY (id_maquina, id_planta) REFERENCES MAQUINA (id_maquina, id_planta);

ALTER TABLE
    PLANTA
ADD
    CONSTRAINT FK_PLANTA_COMUNA FOREIGN KEY (id_comuna) REFERENCES COMUNA (id_comuna);

ALTER TABLE
    TECNICO_MANTENCION
ADD
    CONSTRAINT FK_TECNICO_MANTENCION_EMPLEADO FOREIGN KEY (id) REFERENCES EMPLEADO (id);

CREATE
OR REPLACE TRIGGER FKNTM_COMUNA BEFORE
UPDATE
    OF id_region ON COMUNA FOR EACH ROW BEGIN RAISE_APPLICATION_ERROR(
        -20225,
        'Non Transferable FK constraint on table COMUNA is violated'
    );

END;
/ 

CREATE
OR REPLACE TRIGGER FKNTM_MAQUINA BEFORE
UPDATE
    OF id_planta ON MAQUINA FOR EACH ROW BEGIN RAISE_APPLICATION_ERROR(
        -20225,
        'Non Transferable FK constraint on table MAQUINA is violated'
    );

END;
/ 

CREATE
OR REPLACE TRIGGER FKNTM_ORDEN_MANTENCION BEFORE
UPDATE
    OF id_maquina,
    id_planta ON ORDEN_MANTENCION FOR EACH ROW BEGIN RAISE_APPLICATION_ERROR(
        -20225,
        'Non Transferable FK constraint on table ORDEN_MANTENCION is violated'
    );

END;
/ 

CREATE
OR REPLACE TRIGGER FKNTM_PLANTA BEFORE
UPDATE
    OF id_comuna ON PLANTA FOR EACH ROW BEGIN RAISE_APPLICATION_ERROR(
        -20225,
        'Non Transferable FK constraint on table PLANTA is violated'
    );

END;
/ 

-- inserts

INSERT INTO
    REGION (id_region, nombre)
VALUES
    (SEQ_REGION.NEXTVAL, 'Región de Valparaíso');

INSERT INTO
    REGION (id_region, nombre)
VALUES
    (SEQ_REGION.NEXTVAL, 'Region Metropolitana');

INSERT INTO
    COMUNA (nombre, id_region)
VALUES
    ('Quilpué', 21);

INSERT INTO
    COMUNA (nombre, id_region)
VALUES
    ('Maipú', 22);

INSERT INTO
    PLANTA (id_planta, nombre, direccion, id_comuna)
VALUES
    (
        45,
        'Planta Oriente',
        'Camino Industrial 1234',
        1050
    );

INSERT INTO
    PLANTA (id_planta, nombre, direccion, id_comuna)
VALUES
    (
        46,
        'Planta Costa',
        'Av. Vidrieras 890',
        1055
    );

INSERT INTO
    TURNO (id_turno, tipo_horario, hora_inicio, hora_fin)
VALUES
    ('M0715', 'Mañana', '07:00', '15:00');

INSERT INTO
    TURNO (id_turno, tipo_horario, hora_inicio, hora_fin)
VALUES
    ('N2307', 'Noche', '23:00', '07:00');

INSERT INTO
    TURNO (id_turno, tipo_horario, hora_inicio, hora_fin)
VALUES
    ('T1523', 'Tarde', '15:00', '23:00');

-- selects

-- informe 1

SELECT 
    id_turno || '-' || tipo_horario AS TURNO,
    hora_inicio AS ENTRADA,
    hora_fin AS SALIDA
FROM TURNO
WHERE hora_inicio > '20:00'
ORDER BY hora_inicio DESC;

-- informe 2

SELECT
  id_turno || ' (' || tipo_horario || ')' AS TURNO,
  TRIM(hora_inicio) AS ENTRADA,
  TRIM(hora_fin)   AS SALIDA
FROM TURNO
WHERE TRIM(hora_inicio) BETWEEN '06:00' AND '14:59'
ORDER BY TRIM(hora_inicio) ASC;