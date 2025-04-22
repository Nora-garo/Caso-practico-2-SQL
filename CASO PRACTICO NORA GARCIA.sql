/*Objetivo
Identificar cuáles son los productos del menú que han tenido más éxito y cuales son los que
menos han gustado a los clientes.*/

--a) Crear la base de datos con el archivo create_restaurant_db.sql
SELECT * FROM menu_items;
SELECT * FROM order_details;

--b) Explorar la tabla “menu_items” para conocer los productos del menú.

SELECT * FROM menu_items;

--1.- Realizar consultas para contestar las siguientes preguntas:
--Encontrar el número de artículos en el menú.
--RESPUESTA: 32

SELECT COUNT(DISTINCT item_name)
FROM menu_items;

--¿Cuál es el artículo menos caro y el más caro en el menú?
--RESPUESTA: Menos caro= Edamames Más caro= Shrimp Scampi

SELECT item_name, price AS artículo_menos_caro
FROM menu_items
GROUP BY 1,2
ORDER BY 2 ASC
LIMIT 1;

SELECT item_name, MAX (price) AS artículo_mas_caro
FROM menu_items
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;


--¿Cuántos platos americanos hay en el menú?
--RESPUESTA: 6

SELECT * FROM menu_items
WHERE category='American';

--¿Cuál es el precio promedio de los platos?
--RESPUESTA: $13.29

SELECT ROUND(AVG(price),2) AS precio_promedio
FROM menu_items;

/*c) Explorar la tabla “order_details” para conocer los datos que han sido recolectados.
1.- Realizar consultas para contestar las siguientes preguntas:*/

SELECT * FROM order_details

--¿Cuántos pedidos únicos se realizaron en total?
--RESPUESTA: 5370

SELECT COUNT(DISTINCT order_id) AS total_pedidos
FROM order_details;

--¿Cuáles son los 5 pedidos que tuvieron el mayor número de artículos?
--RESPUESTA: 330, 4305, 1957, 2675, 443  todos con 14 articulos

SELECT DISTINCT order_id, COUNT(item_id) AS numero_de_articulos
FROM order_details
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--¿Cuándo se realizó el primer pedido y el último pedido?
--RESPUESTA: Primier pedido: 2023-01-01 Último pedido: 2023-03-31

SELECT MIN (order_date)
FROM order_details
LIMIT 1;

SELECT MAX (order_date)
FROM order_details
LIMIT 1;


SELECT order_id, order_date AS fecha_primer_pedido
FROM order_details
WHERE order_date = (SELECT MIN(order_date) FROM order_details)
LIMIT 1;

SELECT order_id, order_date AS fecha_ultimo_pedido
FROM order_details
WHERE order_date = (SELECT MAX(order_date) FROM order_details)
LIMIT 1;


--¿Cuántos pedidos se hicieron entre el '2023-01-01' y el '2023-01-05'?
--RESPUESTA: 308

SELECT COUNT(DISTINCT order_id) AS total_de_pedidos
FROM order_details
WHERE order_date BETWEEN '2023-01-01' AND '2023-01-05'

/*d) Usar ambas tablas para conocer la reacción de los clientes respecto al menú.
1.-Realizar un left join entre entre order_details y menu_items con el identificador
item_id(tabla order_details) y menu_item_id(tabla menu_items).*/


SELECT * 
FROM order_details
LEFT JOIN menu_items ON menu_items.menu_item_id=order_details.item_id;
 
--1 Cuál es el producto más vendido y menos vendido?
--RESPUESTA:  Más vendido: Hamburger Menos vengido= Chicken tacos

SELECT COUNT( DISTINCT o.order_details_id), m.item_name
FROM order_details AS o
LEFT JOIN menu_items as m 
ON m.menu_item_id=o.item_id
GROUP BY m.item_name
ORDER BY 1 DESC;

SELECT COUNT( o.order_details_id), m.item_name
FROM order_details AS o
LEFT JOIN menu_items as m 
ON m.menu_item_id=o.item_id
GROUP BY m.item_name
ORDER BY 1 ASC;


--2 Cuál es la categoría más vendida y la menos vendida?
--RESPUESTA: Más vendida: Asian y Menos vendida: American

SELECT COUNT( o.order_details_id), m.category
FROM order_details AS o
LEFT JOIN menu_items as m 
ON m.menu_item_id=o.item_id
GROUP BY  m.category
ORDER BY 1 DESC;

--3 Cuál es el día que registró más ventas?
--RESPUESTA: 2023-02-01

SELECT 
    o.order_date,
    SUM(m.price) AS total_ventas
FROM order_details o
LEFT JOIN menu_items m 
ON o.item_id = m.menu_item_id
GROUP BY o.order_date
ORDER BY total_ventas DESC
LIMIT 1;



--4 Cuál es la categoría que registró más ingresos?
--RESPUESTA: Italian

SELECT 
    m.category,
    SUM(m.price) AS ingresos_totales
FROM order_details o
LEFT JOIN menu_items m 
ON o.item_id = m.menu_item_id
GROUP BY m.category
ORDER BY ingresos_totales DESC;

--5 Cuál es el precio promedio por orden? 
--RESPUESTA: $29.80

SELECT 
    ROUND(AVG(gasto_total),2) AS gasto_promedio_por_consumo
FROM (
    SELECT 
	DISTINCT o.order_id,
        SUM(m.price) AS gasto_total
    FROM order_details o
    LEFT JOIN menu_items m ON o.item_id = m.menu_item_id
    GROUP BY o.order_id
) AS pedidos;









