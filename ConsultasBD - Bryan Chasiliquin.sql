
-- consultas de la base de datos Saludtotal
use saludtotal;

select * from clientes;
select count(*) from clientes;
select count(*) from medicinas;

-- caso: Consultar los datos de un cliente por su numero de cedula 
-- Ejempplo: 1000000041

select *
from clientes
where celdula = '1000000041'

select *
from clientes 
where cedula = '10000000041'

-- caso: Consultar todos los cilentes cuyos nombres enpiezen con la letra A
select 
    cedula,
    nombre
from clientes 
where nombre like 'A%';

-- caso: Consultar todos los medicamentos que enmpiezen con la letra F
select
    medicina
from medicina
where medicina

select
    cedula,
    nombre
FROM clientes
where nombre like 'Juan%';

where 


-- caso: Buscar los clientes cuyo email tengo dominio en gmail y sean JUR

SELECT
    cedula,
    nombre
FROM clientes
where clientes

select * from medicinafrecuente;

select count(*)
from medicinafrecuente;

-- caso: consultar los pacinete del plan de medicina frecuente
-- 

use saludtotal;

select
    cliente_cedula,
    (select nombre from clientes where ceduala = cliente_cedula) as cliente,
    medicina_id,
    (select nombre from medicinas where id = medicina_id) as medicina,
    descuento
FROM
    medicinafrecuente;
-- caso: listar los cliente y las medicinas que tienen un descuento menor
-- al descuento del cliente con cedula '100000010'

select
    cliente_cedula,
    (select nombre from clientes where ceduala = cliente_cedula) as cliente,
    medicina_id,
    (select nombre from medicinas where id = medicina_id) as medicina,
    descuento
FROM
    medicinafrecuente;
where descuento <(
    select descuento
    from medicinafrecuente
    where cliente_cedula = '100000010'
);

---  caso: listado de pacinetes del plan medicina frecuente
-- presente el precio final de la medicina junto
--- con el prercio sin descuenteo



SELECT
    p.patient_id,
    p.full_name AS paciente,
    pl.plan_name AS plan,
    m.medicine_name AS medicina,
    pr.quantity AS cantidad,
    -- Precio sin descuento = unit_price * quantity
    ROUND(m.unit_price * pr.quantity, 2) AS precio_sin_descuento,
    -- Determinar % descuento aplicable
    COALESCE(pmd.discount, pl.general_discount) AS porcentaje_descuento,
    -- Precio final = precio_sin_descuento * (1 - descuento)
    ROUND((m.unit_price * pr.quantity) * (1 - COALESCE(pmd.discount, pl.general_discount)), 2) AS precio_final
FROM prescriptions pr
JOIN patients p           ON p.patient_id = pr.patient_id
JOIN plans pl             ON pl.plan_id = p.plan_id
JOIN medicines m          ON m.medicine_id = pr.medicine_id
LEFT JOIN plan_medicine_discounts pmd
                          ON pmd.plan_id = pl.plan_id AND pmd.medicine_id = m.medicine_id
WHERE pl.plan_name = 'Medicina Frecuente'
ORDER BY p.full_name, pr.prescribed


-- caso: las medicinas comerciales pueden ser remplazadas por
--  sus sus correspondientes medicinas genericas.
-- elaborar un listado que compare el precio de la medicina comercial
-- con su  equivalente generico


-- crear todas las conbinaciones posibles entre la tabla 
-- de clientes y la tabla de medicinafrecuente
-- producto carteciano

use SaludTotal;

SELECT
FROM
    cliente,
    medicinafrecuente;
WHERE
    cliente.cedula = medicinafrecuente.cliente_cedula;

select
    c.cedula,
    c.nombre,
    m.nombre,
    mf.descuento,
    m.tipo
FROM
    medicinafrecuente mf
join clientes c on c.cedula = mf.cliente_cedula
join medicinas m on m.id = mf.medicina_id
where 
    m.tipo = 'COM';
where 
        m.id = mf.medicina_id
    and c.cedula = mf.cliente_cedula
    and m.tipo = 'C0M';

select 
    mcom.id,
    mcom.nombre,
    mcg.medicinagenerica_id,
    mgen.nombre,
    mgen.precio,
    mcon.precio - mgen.precio as diferencia
from 
    medicinafrecuentegeneric
join medicinas mcom on mcom.id = mcg.medicinacomercial_id
join medicinas mgen on mgen.id = mcg.medicinagenerica_id
WHERE 
    mcom.preicio > 5
and mgem.precio < 5
;

create view v_medicinagencom
AS
select 
    mcom.id,
    mcom.nombre as nombre_comercial 
    mcg.medicinagenerica_id,
    mgen.nombre,
    mgen.precio,
    mcon.precio - mgen.precio as diferencia
from 
    medicinafrecuentegeneric
join medicinas mcom on mcom.id = mcg.medicinacomercial_id
join medicinas mgen on mgen.id = mcg.medicinagenerica_id
WHERE 
    mcom.preicio > 5
and mgem.precio < 5


-- Caso: presentar una factura y sus detalles, que incluya,
-- los datos de la farmcia: nombre, ruc, .....
-- los clientes:....
-- los datos de la cabecera de la factura: numero, fecha
-- las medicinas vendidas: nombre medicina, id, cant, precio, subtotal
-- los datos al pie de la factura: total y la forma de pago

-- 1.- carga de datos dn facturas cabeceras y detalles 
--     usar los datos ya existentes
-- 2.- Select para cabera de factura
-- 3.- Select para los detalles de factura
-- 4.- Select para el pie factura


-- Cabecera de la factura
CREATE TABLE facturas (
  id                 INT AUTO_INCREMENT PRIMARY KEY,
  farmacia_id        INT NOT NULL,
  cliente_id         INT NOT NULL,
  numero             VARCHAR(15) NOT NULL,     -- Secuencial (ej.: '000000123')
  fecha_emision      DATETIME NOT NULL,
  moneda             VARCHAR(3) NOT NULL DEFAULT 'USD',
  condicion_pago     VARCHAR(50) NULL,         -- 'Contado', 'Crédito 15 días', etc.
  estado             ENUM('BORRADOR','EMITIDA','ANULADA','PAGADA') NOT NULL DEFAULT 'BORRADOR',

  -- Campos para el pie (totales) que se recalculan con triggers
  subtotal_0         DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  subtotal_12        DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  descuentos_total   DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  iva_total          DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  total_pagar        DECIMAL(12,2) NOT NULL DEFAULT 0.00,

  -- Para validar unicidad por serie (establecimiento + punto_emisión + número)
  establecimiento    VARCHAR(3) NOT NULL,      -- copia desde farmacia al emitir
  punto_emision      VARCHAR(3) NOT NULL,

  observaciones      VARCHAR(500) NULL,

  -- Índices y FK
  UNIQUE KEY uq_factura_unica (farmacia_id, establecimiento, punto_emision, numero),
  KEY fk_factura_farmacia (farmacia_id),
  KEY fk_factura_cliente (cliente_id),
  CONSTRAINT fk_factura_farmacia FOREIGN KEY (farmacia_id) REFERENCES farmacias(id),
  CONSTRAINT fk_factura_cliente FOREIGN KEY (cliente_id) REFERENCES clientes(id)
) ENGINE=InnoDB;

-- Detalle de la factura (líneas de medicamentos vendidos)
CREATE TABLE factura_items (
  id                   INT AUTO_INCREMENT PRIMARY KEY,
  factura_id           INT NOT NULL,
  medicamento_id       INT NOT NULL,
  descripcion          VARCHAR(300) NOT NULL,       -- redundancia útil para impresión
  cantidad             DECIMAL(12,3) NOT NULL CHECK (cantidad > 0),
  precio_unitario      DECIMAL(12,4) NOT NULL CHECK (precio_unitario >= 0),
  descuento            DECIMAL(12,2) NOT NULL DEFAULT 0.00 CHECK (descuento >= 0),

  -- Snapshot de IVA en la línea para cálculos (evita depender del catálogo)
  tasa_iva_porcentaje  DECIMAL(5,2) NOT NULL CHECK (tasa_iva_porcentaje IN (0.00, 12.00)),

  -- Campos calculados (se llenan vía trigger)
  subtotal             DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  iva_valor            DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  total_linea          DECIMAL(12,2) NOT NULL DEFAULT 0.00,

  -- Índices y FK
  KEY fk_item_factura (factura_id),
  KEY fk_item_medicamento (medicamento_id),
  CONSTRAINT fk_item_factura FOREIGN KEY (factura_id) REFERENCES facturas(id) ON DELETE CASCADE,
  CONSTRAINT fk_item_medicamento FOREIGN KEY (medicamento_id) REFERENCES medicamentos(id)
) ENGINE=InnoDB;

alter table facturas
drop column total;

use saludtotal;

desc facturas;

desc facturadetalle;

select count (*) from factura;

select count(*) from facturadetalle;

select 
    f.facturanumero,
    f.fecha,
    c.nombre

FROM factura f 
join cliente c on c.cedula = f.cedula
where 
    facruranemro = 'F00000000036'

select 
    fd.facturanumero,
    fd.medicamiento_id,
    m.nombre,
    fd.precio,
    fd.cantidad,
    fd.precio * fd.cantidad as subtotal
from facturadetalle

join medicina m on m.id = fd.medicamiento_id
WHERE
    fd.facturanumero = 'F0000000016'

desc facturadetalla;

-- pie de la factura

SELECT
    sun (fd.precio * fd.cantidad) as subtotal
FROM
    medicinas
where 



-- mediante eluso del or 
SELECT
    *
from
medicinafrecuente
WHERE
    frecuente = 'SEM'
or frecuencia = 'MEN'

select * from v_

update clientes
set direccion = NULL
where cedula in ('1000000008','10000000010','10000000012');


select count (*) from medicinas;
select count(*) from medicinafrecuente;

select 
    * 
from medicins
where id not IN
(
    select medicina_id from medicinafrecuente
);
SELECT
    *   
from medicinafrecuente mf m join medicinas m onm.id = mf.medicina_id;
where mf,medicina_id is null;


select
    nombre,
    fechanacimiento
FROM
    clientes
ORDER BY
    fechanacimiento desc;
limit 1;

-- caso: conocer las cinco medicinas mas caras de la farmacia 
SELECT
    nombre,
    precio
from medicinas
WHERE
    
order by
    precio 
limt 5;
-- caso: conocer las cinco medicinas mas bartas de la farmacia
SELECT
    nombre,
    precio
from medicinas
WHERE
    
order by
    precio 
limt 5;
-- caso: la medicina comercial mas barata
SELECT
    nombre,
    precio
from medicinas
WHERE
    tipo 'COM'
order by
    precio asc
limt 1;
-- caso: la medicina generica mas cara
SELECT
    nombre,
    precio
from medicinas
    tipo 'GEN'
order by
    precio desc
limt 1;

-- caso: las cinco medicinas comercial con el menor descuento
select 
    id,
    nombre,
    precio,
    descuento
from mediicinafrecuente
join medicina on id = medicina_id
where tipo = 'COM'
and descuento id not NULL
ORDER BY
    descuento
limit 5;

select * from medicinas where nombre like 'voltaren Su%'

select * from medicinafrecuente where medicina_id=101;

insert into medicinafrecuente values(
    '1000000000000005',101, 'Dolor frecuente de rodilla','SEM'
);

select 
    nombre
from medicinas
WHERE
    id in(
        SELECT
            ID
        from medicinafrecuente
        join medicina on id = medicina_id
        WHERE
            tipo = 'COM'
        order BY
            descuento
    );

order BY


-- caso: agrupacion
select 
    tipo,
    count(*) as numero
from cientes
GROUP BY
    tipo 
;

desc medicinas;
select 
    id,
    nombre,
    precio,
    stock,
    precio * stock
from medicinas;

select 
    tipo,
    sum(precio * stock)
from medicinas
GROUP BY
    tipo;


-- caso: facturas detalles. Valor monetario por medicina vendida

select * from facturadetalle;

SELECT
    medicamento_id,
    cantidad,
    precio,



-- caso: el mejor cliente
SELECT 
    fd.facturanumero,
    f.cedula,
    sum(fd.cantidad * fd.precio)
FROM facturadetalle fd
join facturas f on f.facturanuero = fd.facturanemro
join 

-- caso: proyeccion de la venta total del stock, tomando en cuanta 
-- el descuento para las medicinas del plan de medicina frecuente

select 
    id,
    nombre,
    precio,
    stock,
    precio * stock
from medicinas;

SELECT
    mf.medicina_id,
    m.nombre,
    m.precio,
    m.stock,
    mf.descuento --- descuento del plan 
    m.precio *  (1-mf.descuento/100) as nuevo_precio
from medicinafrecuente mf
right join medicinas m on m.id  = mf.medicina_id
where mf.descuento is null
;

select 
    suma(nuevo_precio * stock)
from 

select curdate;


-- caso: averiguar que medicinas vencen en el proximo mes.

SELECT
    id_medicamento,
    nombre_medicamento,
    fecha_vencimiento
FROM
    Medicamentos
WHERE
    fecha_vencimiento >= DATE_ADD(CURDATE() - DAY(CURDATE()) + INTERVAL 1 DAY, INTERVAL 1 MONTH)
    AND fecha_vencimiento < DATE_ADD(CURDATE() - DAY(CURDATE()) + INTERVAL 1 DAY, INTERVAL 2 MONTH);


select 
    id,
    nombre,
    fechacaducidad
FROM  
    medicinas
where 
    fechacaducida >= date_add(last_date(curdate()), interval 1 day)
    and fechadecaducidad <=
                last_day(date_add (curdate(), interval 1 month))
order BY
    fechacaducidad;

update medicinas
set fechacaducidad= '2025-12-25'
where id in (12,13,14,21,23);

-- caso: cronograma de vencimineto de medicinas a tres meses vista
SELECT
    DATE_FORMAT(fecha_vencimiento, '%Y-%m') AS mes_vencimiento,
    COUNT(*) AS cantidad_medicamentos
FROM
    Medicamentos
WHERE
    fecha_vencimiento BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 3 MONTH)
GROUP BY
    mes_vencimiento
ORDER BY
    mes_vencimiento;
    