USE master ;
IF DB_ID('BD_Logistics') IS NOT NULL
        DROP DATABASE BD_Logistics;

GO
CREATE DATABASE BD_Logistics;
GO
USE BD_Logistics;

-- CARGA CUSTOMER

IF OBJECT_ID ('Customer','U') IS NOT NULL
    DROP TABLE Customer ; 

CREATE TABLE Customer (
    C_ID        INT PRIMARY KEY,        -- Identificador del cliente
    M_ID        INT,                    -- Relación con Membership
    C_NAME      NVARCHAR(100),          -- Nombre del cliente
    C_EMAIL_ID  NVARCHAR(255),          -- Correo electrónico
    C_TYPE      NVARCHAR(50),           -- Tipo de cliente (Retail, Wholesale, etc.)
    C_ADDR      NVARCHAR(255),          -- Dirección
    C_CONT_NO   NVARCHAR(20)            -- Teléfono como texto (flexible)
);


BULK INSERT Customer
FROM 'D:\Proyectos\SQL\Project-Logistics-Analitycs\data\Customer.csv'
WITH(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR =',',
    ROWTERMINATOR = '\n'
);

--CARGA EMPLOYEE_DETAILS


IF OBJECT_ID('Employee_Details', 'U') IS NOT NULL
    DROP TABLE Employee_Details;

CREATE TABLE Employee_Details (
    E_ID          INT PRIMARY KEY,           -- Identificador numérico del empleado
    E_NAME        NVARCHAR(100),             -- Nombre del empleado
    E_DESIGNATION NVARCHAR(150),             -- Cargo o puesto
    E_ADDR        NVARCHAR(255),             -- Dirección completa
    E_BRANCH      NVARCHAR(10),              -- Estado/branch (ej. TX, MA, etc.)
    E_CONT_NO     NVARCHAR(20)               -- Teléfono como texto (flexible)
);

BULK INSERT Employee_Details
FROM 'D:\Proyectos\SQL\Project-Logistics-Analitycs\data\Employee_Details.csv'
WITH(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR =',',
    ROWTERMINATOR = '\n'
);

--CARGA Employee_Manages_Shipment

IF OBJECT_ID('Employee_Manages_Shipment', 'U') IS NOT NULL
    DROP TABLE Employee_Manages_Shipment;

CREATE TABLE Employee_Manages_Shipment (
    Employee_E_ID   INT,            -- ID del empleado (referencia a Employee_Details)
    Shipment_Sh_ID  INT,            -- ID del envío
    Status_Sh_ID    INT             -- Estado del envío
);
BULK INSERT Employee_Manages_Shipment
FROM 'D:\Proyectos\SQL\Project-Logistics-Analitycs\data\Employee_Manages_Shipment.csv'
WITH(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR =',',
    ROWTERMINATOR = '\n'
);

--CARGA Membershipt

IF OBJECT_ID('Membership', 'U') IS NOT NULL
    DROP TABLE Membership;

CREATE TABLE Membership (
    M_ID        INT PRIMARY KEY,   -- Identificador de la membresía
    Star_date  DATE,              -- Fecha de inicio
    End_date    DATE               -- Fecha de fin
);
BULK INSERT Membership
FROM 'D:\Proyectos\SQL\Project-Logistics-Analitycs\data\Membership.csv'
WITH(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR =',',
    ROWTERMINATOR = '\n'
);

--CARGA Payment_Details
IF OBJECT_ID('Payment_Details', 'U') IS NOT NULL
    DROP TABLE Payment_Details;

CREATE TABLE Payment_Details (
    Payment_ID      UNIQUEIDENTIFIER PRIMARY KEY, -- UUID único para cada pago
    C_ID            INT,                          -- Cliente (relación con Customer)
    SH_ID           INT,                          -- Shipment (relación con envíos)
    AMOUNT          DECIMAL(18,2),                -- Monto del pago
    Payment_Status  NVARCHAR(20),                 -- Estado del pago (PAID / NOT PAID)
    Payment_Mode    NVARCHAR(50),                 -- Método de pago (CARD PAYMENT, COD, etc.)
    Payment_Date    DATE NULL                     -- Fecha del pago (puede ser NULL)
);
BULK INSERT Payment_Details
FROM 'D:\Proyectos\SQL\Project-Logistics-Analitycs\data\Payment_Details.csv'
WITH(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR =',',
    ROWTERMINATOR = '\n'
);

--CARGA Shipment_Details
IF OBJECT_ID('Shipment_Details', 'U') IS NOT NULL
    DROP TABLE Shipment_Details;

CREATE TABLE Shipment_Details (
    SH_ID        INT PRIMARY KEY,        -- Identificador del envío
    C_ID         INT,                    -- Cliente asociado (relación con Customer)
    SH_CONTENT   NVARCHAR(100),          -- Contenido del envío (Healthcare, Electronics, etc.)
    SH_DOMAIN    NVARCHAR(50),           -- Dominio (Domestic / International)
    SER_TYPE     NVARCHAR(50),           -- Tipo de servicio (Regular / Express)
    SH_WEIGHT    DECIMAL(10,2),          -- Peso del envío
    SH_CHARGES   DECIMAL(10,2),          -- Costo del envío
    SR_ADDR      NVARCHAR(255),          -- Dirección de origen
    DS_ADDR      NVARCHAR(255)           -- Dirección de destino
);
BULK INSERT Shipment_Details
FROM 'D:\Proyectos\SQL\Project-Logistics-Analitycs\data\Shipment_Details.csv'
WITH(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR =',',
    ROWTERMINATOR = '\n'
);

--CARGA Status_L
IF OBJECT_ID('Status_L', 'U') IS NOT NULL
    DROP TABLE Status_L;

CREATE TABLE Status_L (
    SH_ID           INT PRIMARY KEY,        -- Identificador del envío (relación con Shipment_Details)
    Current_Status  NVARCHAR(20),           -- Estado actual (DELIVERED / NOT DELIVERED)
    Sent_date       DATE,                   -- Fecha de envío
    Delivery_date   DATE NULL               -- Fecha de entrega (puede ser NULL si no se entregó)
);
BULK INSERT Status_L
FROM 'D:\Proyectos\SQL\Project-Logistics-Analitycs\data\Status.csv'
WITH(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR =',',
    ROWTERMINATOR = '\n'
);

-------------
--Verificación de duplicados
-------------
-- TABLA Customer
SELECT C_ID ,COUNT(*) 
FROM CUSTOMER
GROUP BY C_ID 
HAVING COUNT(*)>1;

-- TABLA Employee_Details
SELECT E_ID,COUNT(*)
FROM Employee_Details
GROUP BY E_ID
HAVING COUNT(*)>1;

-- TABLA Payment_Details
SELECT Payment_ID ,COUNT(*)
FROM Payment_Details
GROUP BY Payment_ID
HAVING COUNT(*) > 1;

-- TABLA Shipment_Details
SELECT  SH_ID,COUNT(*)
FROM Shipment_Details 
GROUP BY SH_ID
HAVING COUNT(*)>1;

--------------------
--Verificando datos faltantes
--------------------
 
-- TABLA Customer
SELECT COUNT(*) 
FROM CUSTOMER
WHERE C_ID IS NULL 
    OR M_ID IS NULL;

-- TABLA Employee_Details
SELECT COUNT(*)
FROM Employee_Details
WHERE E_ID IS NULL;

-- TABLA Payment_Details
SELECT COUNT(*)
FROM Payment_Details
WHERE Payment_ID IS NULL
    OR C_ID IS NULL
    OR SH_ID IS NULL;

-- TABLA Shipment_Details
SELECT  COUNT(*)
FROM Shipment_Details 
WHERE SH_ID IS NULL
    OR C_ID IS NULL;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- EXPLORATORY DATA ANALYSIS AND INSIGHTS --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--Preguntas de Negocio

-- 1 ¿Cómo se distribuyen los clientes entre las distintas categorías y cuál concentra la mayor participación?

SELECT C_TYPE , COUNT(*) AS CANTIDAD_CLIENTES
FROM CUSTOMER
GROUP BY C_TYPE
ORDER BY CANTIDAD_CLIENTES DESC;

-- 2 -  ¿Cuál es el monto total realmente convertido en ingresos, considerando únicamente los pagos con
        -- estado PAID, y qué proporción representa frente al total de transacciones?

SELECT 
    SUM(CASE WHEN Payment_Status = 'PAID' THEN Amount ELSE 0 END) AS MontoTotalPaid,
    CAST(SUM(CASE WHEN Payment_Status = 'PAID' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS PorcentajePagosCompletados
FROM Payment_Details;

-- 3 ¿Qué volumen de envíos corresponde al dominio internacional y cómo impacta en la estrategia logística global?

SELECT COUNT(*) AS CANTIDAD_ENVIO_INTERNACIONAL
FROM SHIPMENT_DETAILS
WHERE SH_DOMAIN = 'International';

-- 4 - ¿Cómo se distribuyen los empleados por designación y qué áreas concentran mayor carga operativa?

SELECT E_DESIGNATION,COUNT(*) CANTIDAD_DESIGNADOS
FROM EMPLOYEE_DETAILS
GROUP BY E_DESIGNATION
ORDER BY CANTIDAD_DESIGNADOS DESC;

-- 5 - ¿Existen diferencias significativas en el peso promedio de los envíos domésticos frente a los internacionales,
--    y qué porcentaje del total representan cada uno?

SELECT SH_DOMAIN,
    CAST(AVG(SH_WEIGHT) AS DECIMAL(10,2)) AS PROMEDIO_PESO,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM SHIPMENT_DETAILS) AS DECIMAL(5,2)) AS PORCENTAJE_ENVÍOS
FROM SHIPMENT_DETAILS
GROUP BY SH_DOMAIN ;


-- 6 - ¿Quiénes son los cinco clientes con mayor monto total pagado y cómo se posicionan en términos de contribución al negocio?.

WITH Totales AS (
    SELECT 
        C.C_NAME,
        SUM(PD.AMOUNT) AS MONTO_TOTAL
    FROM CUSTOMER C
    INNER JOIN Payment_Details PD 
        ON C.C_ID = PD.C_ID
    GROUP BY C.C_NAME
)
SELECT TOP 5
    C_NAME,
    MONTO_TOTAL,
    RANK() OVER (ORDER BY MONTO_TOTAL DESC) AS RANKING_CONTRIBUCION
FROM Totales
ORDER BY MONTO_TOTAL DESC;


-- 7 - ¿Cuál es la duración promedio (en años) de las membresías ?

SELECT CAST(AVG(DATEDIFF(DAY, STAR_DATE, END_DATE) / 365.0)AS DECIMAL(10,2)) AS DURACION_PROMEDIO
FROM MEMBERSHIP;

-- 8 - ¿Cuál es el porcentaje de envíos DELIVERED vs NOT DELIVERED en la tabla Status?

SELECT CURRENT_STATUS,
       CAST (COUNT(*) * 100.00 / (SELECT COUNT(*) FROM STATUS_L) AS DECIMAL(10,2)) AS PROCENTAJE_ENVIOS
FROM STATUS_L
GROUP BY CURRENT_STATUS;



-- 9 - ¿Cuál es el costo promedio de envíos por Tipo de servicio y por tipo de cliente?

SELECT SP.SER_TYPE,C.C_TYPE,
    CAST(AVG(SH_CHARGES) AS DECIMAL(10,2)) AS COSTO_PROMEDIO
FROM SHIPMENT_DETAILS SP JOIN CUSTOMER C
    ON SP.C_ID=C.C_ID
GROUP BY C.C_TYPE,SP.SER_TYPE
ORDER BY COSTO_PROMEDIO DESC;


-- 10 - ¿Qué empleados concentran la mayor cantidad de envíos gestionados y cómo se distribuye la carga de trabajo?

SELECT E_D.E_NAME , COUNT(E_D.E_NAME)  AS CANTIDAD_ENVIOS
FROM EMPLOYEE_DETAILS E_D INNER JOIN EMPLOYEE_MANAGES_SHIPMENT E_M
ON E_D.E_ID = E_M.EMPLOYEE_E_ID
GROUP BY E_D.E_NAME
ORDER BY  CANTIDAD_ENVIOS DESC;


-- 11 -  ¿Cómo se pueden clasificar los clientes en categorías de Bajo, Medio y Alto valor según su monto total pagado?

WITH Totales AS (
    SELECT C.C_ID,
           SUM(PD.AMOUNT) AS MONTO_TOTAL
    FROM CUSTOMER C
    INNER JOIN PAYMENT_DETAILS PD 
        ON C.C_ID = PD.C_ID
    GROUP BY C.C_ID
)
SELECT C_ID,
       MONTO_TOTAL,
       CAST (PERCENT_RANK() OVER (ORDER BY MONTO_TOTAL)AS DECIMAL(10,2)) AS RANK_RELATIVO,
       CASE
           WHEN PERCENT_RANK() OVER (ORDER BY MONTO_TOTAL) <= 0.33 THEN 'Bajo'
           WHEN PERCENT_RANK() OVER (ORDER BY MONTO_TOTAL) <= 0.66 THEN 'Medio'
           ELSE 'Alto'
       END AS CATEGORIA
FROM Totales
ORDER BY MONTO_TOTAL DESC;

-- 12 -  ¿Cómo se posicionan los clientes dentro de su propia categoría (C_TYPE) en función del monto total pagado?

WITH Totales AS (
    SELECT C.C_ID,
           C.C_TYPE,
           SUM(PD.AMOUNT) AS MONTO_TOTAL
    FROM CUSTOMER C
    INNER JOIN PAYMENT_DETAILS PD 
        ON C.C_ID = PD.C_ID
    GROUP BY C.C_ID, C.C_TYPE
)
SELECT C_ID,
       C_TYPE,
       MONTO_TOTAL,
       RANK() OVER (PARTITION BY C_TYPE ORDER BY MONTO_TOTAL DESC) AS POSICION_RELATIVA
FROM Totales
ORDER BY C_TYPE, POSICION_RELATIVA;

-- 13 - ¿Cuál es el tiempo promedio de entrega por tipo de contenido y qué categoría demuestra mayor eficiencia logística?

WITH Tiempos AS (
    SELECT 
        SD.SH_CONTENT,
        DATEDIFF(DAY, SL.Sent_date, SL.Delivery_date) AS DIAS_ENTREGA
    FROM Shipment_Details SD
    INNER JOIN Status_L SL 
        ON SD.SH_ID = SL.SH_ID
    WHERE SL.Sent_date IS NOT NULL 
      AND SL.Delivery_date IS NOT NULL
)
SELECT 
    SH_CONTENT,
    CAST(AVG(DIAS_ENTREGA) AS DECIMAL(10,2)) AS PROMEDIO_DIAS,
    RANK() OVER (ORDER BY AVG(DIAS_ENTREGA)) AS EFICIENCIA_RANK
FROM Tiempos
GROUP BY SH_CONTENT
ORDER BY PROMEDIO_DIAS ASC;



-- 14 -  ¿Qué tan efectivos son los distintos métodos de pago en convertir transacciones en pagos completados (PAID)?


WITH Conteos AS (
    SELECT 
        Payment_Mode,
        COUNT(*) AS TotalPagos,
        SUM(CASE WHEN Payment_Status = 'PAID' THEN 1 ELSE 0 END) AS PagosExitosos
    FROM Payment_Details
    GROUP BY Payment_Mode
)
SELECT 
    Payment_Mode,
    TotalPagos,
    PagosExitosos,
    CAST( (PagosExitosos * 1.0 / TotalPagos) * 100 AS DECIMAL(5,2)) AS TasaConversion_Pct
FROM Conteos
ORDER BY TasaConversion_Pct DESC;


-- 15 -  ¿Qué porcentaje de clientes con membresía vigente ha realizado al menos un pago en los últimos 20 años, y qué nos dice esto sobre su nivel de compromiso?

WITH ClientesActivos AS (
    SELECT C.C_ID
    FROM Customer C
    INNER JOIN Membership M ON C.M_ID = M.M_ID
    WHERE M.End_date >= GETDATE()   -- Membresía vigente
),
PagosUltimos20Anios AS (
    SELECT DISTINCT C.C_ID
    FROM Customer C
    INNER JOIN Membership M ON C.M_ID = M.M_ID
    INNER JOIN Payment_Details PD ON C.C_ID = PD.C_ID
    WHERE M.End_date >= GETDATE()   -- Membresía vigente
      AND PD.Payment_Date >= DATEADD(YEAR, -20, GETDATE())
)
SELECT 
    CAST( (COUNT(DISTINCT P.C_ID) * 1.0 / COUNT(DISTINCT A.C_ID)) * 100 AS DECIMAL(5,2)) AS PorcentajeConversion
FROM ClientesActivos A
LEFT JOIN PagosUltimos20Anios P 
    ON A.C_ID = P.C_ID;

