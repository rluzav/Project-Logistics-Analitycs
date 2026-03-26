# 🚚 Proyecto SQL: Análisis de Logística – Clientes, Pagos y Eficiencia Operativa

## 📌 Resumen (Overview)

El área de **Logística y Administración** busca optimizar la gestión de envíos, mejorar la eficiencia en la facturación y entender mejor el comportamiento de clientes y empleados.  
Mi objetivo es utilizar **SQL en SQL Server Management Studio (SSMS)** para realizar un **Exploratory Data Analysis (EDA)** sobre la base de datos **BD_Logistics**, generando insights que apoyen la toma de decisiones estratégicas en clientes, pagos, envíos y desempeño de empleados.

---

## 📂 Estructura del Proyecto

- [Sobre los Datos](#sobre-los-datos)  
- [Limpieza y Validación](#limpieza-y-validación)  
- [Preguntas de Negocio y EDA](#preguntas-de-negocio-y-eda)  
- [Conclusiones](#conclusiones)

---

## 📊 Sobre los Datos

La base de datos **BD_Logistics** contiene información integrada de clientes, empleados, membresías, pagos y envíos.  
Las principales tablas son:

- **Customer** → datos de clientes y su relación con membresías.  
- **Membership** → fechas de inicio y fin de membresías.  
- **Payment_Details** → transacciones de pago, estado y método.  
- **Shipment_Details** → información de envíos, tipo de servicio, peso y costos.  
- **Status_L** → estado actual de los envíos y fechas de envío/entrega.  
- **Employee_Details** y **Employee_Manages_Shipment** → datos de empleados y su participación en la gestión de envíos.



---

## 🧹 Limpieza y Validación

Antes del análisis, se verificó la calidad de los datos:

- **Duplicados**: se revisaron claves primarias (`C_ID`, `E_ID`, `Payment_ID`, `SH_ID`) y no se encontraron duplicados.  
- **Valores faltantes**: se validaron campos críticos (`C_ID`, `Payment_ID`, `SH_ID`) y se identificaron posibles nulos en fechas de entrega (`Delivery_date`), lo cual es esperado en envíos no completados.  
- **Integridad relacional**: las tablas están correctamente vinculadas por claves foráneas (ej. `C_ID`, `M_ID`, `SH_ID`).



---

## 🔎 Preguntas de Negocio y EDA

Durante el análisis exploratorio se respondieron 15 preguntas clave:

1. **Distribución de clientes por categoría**  
   !

2. **Ingresos efectivos (PAID) y proporción frente al total**  

3. **Volumen de envíos internacionales y su impacto**  

4. **Distribución de empleados por designación**  

5. **Peso promedio de envíos domésticos vs internacionales**  

6. **Top 5 clientes por monto total pagado y ranking de contribución**  
   

7. **Duración promedio de membresías**  

8. **Porcentaje de envíos entregados vs no entregados**  
   

9. **Costo promedio de envíos por servicio y tipo de cliente**  

10. **Carga de trabajo de empleados en gestión de envíos**  

11. **Clasificación de clientes en Bajo, Medio y Alto valor**  

12. **Ranking relativo dentro de cada tipo de cliente (C_TYPE)**  

13. **Tiempo promedio de entrega por tipo de contenido**  

14. **Tasa de conversión de pagos por método de pago**  

15. **Compromiso de clientes con membresía en los últimos 20 años**

---

## ✅ Conclusiones

El análisis permitió identificar insights clave para la gestión logística y administrativa:

- **Clientes estratégicos**: un pequeño grupo concentra gran parte de los ingresos, lo que sugiere programas de fidelización.  
- **Pagos y conversión**: algunos métodos de pago son más confiables que otros, orientando decisiones sobre canales preferidos.  
- **Eficiencia logística**: los envíos internacionales tienden a tener mayor peso y tiempos de entrega más largos, impactando en costos.  
- **Empleados y carga operativa**: ciertos empleados gestionan más envíos, lo que puede requerir balancear responsabilidades.  
- **Membresías y compromiso**: la duración promedio y la actividad de clientes con membresía reflejan niveles de fidelidad que deben aprovecharse.  

En conjunto, estos hallazgos ofrecen una base sólida para mejorar la eficiencia operativa, optimizar la experiencia del cliente y fortalecer la estrategia de negocio.

---
