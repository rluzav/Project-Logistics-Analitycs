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