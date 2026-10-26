/*
1-PROCEDURA
*/

-- NOMBRE_TABLA.NOMBRE_CAMPO%TYPE

CREATE TABLE empleados_practica(
    ID_BOY NUMBER,
    FIRST_NAME    VARCHAR2(50),
    PHONE    VARCHAR2(20),
    SALARY      NUMBER,
    CONSTRAINT PK_ID_EMPLEADO PRIMARY KEY (ID_BOY)
);

INSERT INTO empleados_practica
    (ID_BOY, FIRST_NAME, PHONE, SALARY)
VALUES (1, 'Ernesto', '111-1111', 1000);

INSERT INTO empleados_practica
    (ID_BOY, FIRST_NAME, PHONE, SALARY)
VALUES (2, 'Diego', '222-2222', 1500);

INSERT INTO empleados_practica
    (ID_BOY, FIRST_NAME, PHONE, SALARY)
VALUES (3, 'Alicia', '333-3333', 2000);


/*
EJERCICIO: CAMBIAR EL TELEFONO

Crear un procedimiento llamado CAMBIAR_TELEFONO.
Debe recibir:
- EMPLEADO_P: identificador del empleado, tipo NUMBER.
- TELEFONO_P: nuevo telefono, tipo VARCHAR2.
Debe actualizar la columna TELEFONO de la tabla
EMPLEADOS_PRACTICA, solamente cuando ID_EMPLEADO
coincida con EMPLEADO_P.
Finalmente, escribir una llamada para cambiar
el telefono de Diego (ID 2) a '555-1234'.
Por ahora, trabajar solamente parametros y UPDATE.
*/

CREATE OR REPLACE PROCEDURE CAMBIAR_TELEFONO(
    EMPLEADO_P NUMBER,
    TELEFONO_P VARCHAR2
)
IS
BEGIN
    UPDATE empleados_practica SET PHONE = TELEFONO_P
    WHERE ID_BOY = EMPLEADO_P;
    
END;

BEGIN
    CAMBIAR_TELEFONO(1,'222-222');
    COMMIT;
END;

select * from empleados_practica

/*
Se solicita crear un procedimiento almacenado llamado CAMBIAR_SUELDO
para la tabla EMPLEADOS_PRACTICA, que reciba como parametros de entrada
el identificador del empleado y su nuevo sueldo, ambos de tipo NUMBER.

El procedimiento debera verificar mediante IF que el sueldo sea mayor
que cero; si cumple, actualizara unicamente al empleado indicado y,
en caso contrario, mostrara el mensaje 'El sueldo debe ser mayor que cero'
mediante DBMS_OUTPUT.PUT_LINE.

Pruebe el procedimiento asignando al empleado 2 un sueldo de 1800
y luego intentando asignarle -500; confirme el cambio valido mediante
COMMIT desde el bloque llamador y consulte la tabla para comprobar
el resultado. Utilice ID_BOY en el filtro si ese es el nombre de
su columna identificadora.
*/

CREATE OR REPLACE PROCEDURE CAMBIAR_SUELDO(
    P_EMPLEADO NUMBER,
    P_SALARIO NUMBER
)
IS
BEGIN
    IF (P_SALARIO > 0) THEN
        UPDATE EMPLEADOS_PRACTICA SET SALARY = P_SALARIO
        WHERE ID_BOY = P_EMPLEADO;
    ELSE
        DBMS_OUTPUT.PUT_LINE('El sueldo debe ser mayor que cero');
    END IF;
END;

BEGIN
    CAMBIAR_SUELDO(2,1800);
    CAMBIAR_SUELDO(2,-500);
    COMMIT;
END;

SELECT ID_BOY, SALARY FROM EMPLEADOS_PRACTICA;


/*
Se solicita crear un procedimiento almacenado llamado
CAMBIAR_SUELDO_CON_BONO para la tabla EMPLEADOS_PRACTICA,
que reciba el identificador del empleado y un sueldo base,
ambos de tipo NUMBER.

Si el sueldo recibido es mayor que cero, debera sumarle
un bono fijo de 100 y guardar el resultado en una variable
local llamada V_SUELDO_FINAL, declarada despues de IS.
Luego actualizara SALARY con ese resultado, solamente
para el empleado cuyo ID_BOY coincida con el recibido.

Si el sueldo no es valido, mostrara el mensaje
'El sueldo debe ser mayor que cero'.

Pruebe con el empleado 2 y un sueldo base de 1800:
el sueldo final debera quedar en 1900. Luego pruebe
con -500 y compruebe que no se modifique el sueldo.
Confirme el cambio valido con COMMIT desde el bloque
llamador y consulte la tabla para verificar el resultado.
*/

CREATE OR REPLACE PROCEDURE CAMBIAR_SUELDO_CON_BONO(
    P_EMPLEADO NUMBER,
    P_SUELDO NUMBER
)
IS
    V_SUELDO_FINAL NUMBER;
BEGIN
    IF (P_SUELDO > 0) THEN
        V_SUELDO_FINAL := P_SUELDO + 100;
        UPDATE EMPLEADOS_PRACTICA
        SET SALARY = V_SUELDO_FINAL
        WHERE ID_BOY = P_EMPLEADO;
    ELSE
        DBMS_OUTPUT.PUT_LINE('El sueldo debe ser mayor que cero');
    END IF;
END;

BEGIN
    CAMBIAR_SUELDO_CON_BONO(2,1800);
    COMMIT;
END;

SELECT * FROM EMPLEADOS_PRACTICA;

/*
Se requiere implementar un procedimiento almacenado llamado
AUMENTAR_SUELDO_ACTUAL para la tabla EMPLEADOS_PRACTICA,
que reciba el identificador de un empleado.

Si su sueldo actual es inferior a 2000, debera incrementarlo
en 200. En caso contrario, debera mostrar el mensaje
'El empleado no recibe aumento'.

La operacion debera afectar exclusivamente al empleado indicado.
Demuestre su funcionamiento con un empleado que cumpla
la condicion y otro que no la cumpla.
*/

CREATE OR REPLACE PROCEDURE AUMENTAR_SUELDO_ACTUAL(
    P_EMPLEADO NUMBER 
)
IS
    SUELDO_TEMP NUMBER := 0;
    TEMP NUMBER;
BEGIN
    SELECT SALARY INTO TEMP
    FROM EMPLEADOS_PRACTICA 
    WHERE ID_BOY = P_EMPLEADO;

    IF (TEMP < 2000) THEN
        SUELDO_TEMP := TEMP + 200;
        UPDATE EMPLEADOS_PRACTICA
        SET SALARY = SUELDO_TEMP
        WHERE ID_BOY = P_EMPLEADO;
    ELSE
        DBMS_OUTPUT.PUT_LINE('El empleado no recibe aumento');
    END IF;
END;

BEGIN
    AUMENTAR_SUELDO_ACTUAL(1);
END;

SELECT * FROM EMPLEADOS_PRACTICA;


----------------------------------------------------------------
--- EXCEPTION
----------------------------------------------------------------
EXCEPTION
        WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Empleado inexistente');
		WHEN PROGRAM_ERROR THEN
			RAISE_APPLICATION_ERROR(-20002,'ERROR DE PROGRAMA Y/O ASIGNACION DE VARIABLES');
		WHEN STORAGE_ERROR THEN
			RAISE_APPLICATION_ERROR(-20021,'SE ACABO LA MEMORIA, O ES CORRUPTA');
		WHEN ROWTYPE_MISMATCH THEN
			RAISE_APPLICATION_ERROR(-20980,'ERROR DE ASIGNACION DE VARIABLES');
		WHEN OTHERS THEN
			RAISE_APPLICATION_ERROR(-20010,'ERROR');
	ROLLBACK;

/*
Se solicita crear un procedimiento almacenado llamado
REAJUSTAR_SUELDO para la tabla EMPLEADOS_PRACTICA,
que reciba el identificador de un empleado.

Si su sueldo actual es inferior a 1500, debera aumentarlo
en 300. Si su sueldo esta entre 1500 y 2500, ambos incluidos,
debera aumentarlo en 150. Si supera los 2500, debera mostrar
el mensaje 'El empleado no tiene reajuste'.

La operacion debera modificar exclusivamente al empleado
indicado. Considere las columnas ID_BOY y SALARY.

Demuestre el funcionamiento del procedimiento con un empleado
para cada una de las tres situaciones.
*/

CREATE OR REPLACE PROCEDURE REAJUSTAR_SUELDO(
    P_EMPLEADO NUMBER
)
IS
    SUELDO_ACT NUMBER;
    TOTAL_SUELDO NUMBER := 0;
BEGIN
    SELECT SALARY INTO SUELDO_ACT
    FROM EMPLEADOS_PRACTICA
    WHERE ID_BOY = P_EMPLEADO;

    IF (SUELDO_ACT < 1500) THEN
        TOTAL_SUELDO := SUELDO_ACT + 300;

        UPDATE EMPLEADOS_PRACTICA
        SET SALARY = TOTAL_SUELDO
        WHERE ID_BOY = P_EMPLEADO;

    ELSIF (SUELDO_ACT BETWEEN 1500 AND 2500) THEN
        TOTAL_SUELDO := SUELDO_ACT + 150;

        UPDATE EMPLEADOS_PRACTICA
        SET SALARY = TOTAL_SUELDO
        WHERE ID_BOY = P_EMPLEADO;
        
    ELSE
        DBMS_OUTPUT.PUT_LINE('El empleado no tiene reajuste');
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Empleado inexistente');
		WHEN PROGRAM_ERROR THEN
			RAISE_APPLICATION_ERROR(-20002,'ERROR DE PROGRAMA Y/O ASIGNACION DE VARIABLES');
		WHEN STORAGE_ERROR THEN
			RAISE_APPLICATION_ERROR(-20021,'SE ACABO LA MEMORIA, O ES CORRUPTA');
		WHEN ROWTYPE_MISMATCH THEN
			RAISE_APPLICATION_ERROR(-20980,'ERROR DE ASIGNACION DE VARIABLES');
		WHEN OTHERS THEN
			RAISE_APPLICATION_ERROR(-20010,'ERROR');
	ROLLBACK;
END;



BEGIN
    REAJUSTAR_SUELDO(1);
    REAJUSTAR_SUELDO(4); 
    REAJUSTAR_SUELDO(2); 
  
    COMMIT;
END;

------------------------------------------------------------------------------------------
-- SEQUENCE
------------------------------------------------------------------------------------------

CREATE SEQUENCE COD_GENERATOR
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 3700 -- RECORDAR: ENCONTRAR EL MAXIMO DE LOS EJERCICIOS
    NOCYCLE; -- O CYCLE

-- .NEXTVAL  -> PARA SEGUIR EN EL CONTADOR EN EL MOMENTO DE LLAMAR


/*
Se solicita crear una secuencia llamada SEQ_COD_EMPLEADO que genere identificadores desde 100,
con incrementos de uno y sin reiniciar la numeracion al alcanzar su limite. Considere que los
codigos desde 100 estan disponibles para este ejercicio.

Posteriormente, cree un procedimiento almacenado llamado REGISTRAR_EMPLEADO para la tabla
EMPLEADOS_PRACTICA, que reciba el nombre y el sueldo de un nuevo empleado. El identificador
ID_BOY debera obtenerse automaticamente mediante la secuencia, sin solicitarlo como parametro.
El nombre se almacenara en FIRST_NAME y el sueldo en SALARY.

Demuestre su funcionamiento registrando dos empleados y compruebe que reciban identificadores
diferentes.
*/

CREATE SEQUENCE SEQ_COD_EMPLEADO
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 100
    NOCYCLE;
   
CREATE OR REPLACE PROCEDURE REGISTRAR_EMPLEADO(
    P_NAME VARCHAR2,
    P_SUELDO NUMBER,
    P_PHONE VARCHAR2
)
IS
BEGIN
    LOCK TABLE EMPLEADOS_PRACTICA IN ROW EXCLUSIVE MODE;
    INSERT INTO EMPLEADOS_PRACTICA(ID_BOY, FIRST_NAME, PHONE, SALARY) VALUES (SEQ_COD_EMPLEADO.NEXTVAL, P_NAME, P_PHONE, P_SUELDO);
END;

BEGIN
    REGISTRAR_EMPLEADO('JORGE',20101,'1121-222');
END;


SELECT * FROM EMPLEADOS_PRACTICA;

/*
Se solicita modificar el procedimiento REGISTRAR_EMPLEADO de la tabla EMPLEADOS_PRACTICA,
manteniendo la generacion automatica de ID_BOY mediante la secuencia SEQ_COD_EMPLEADO.

El procedimiento debera recibir el nombre, el telefono y el sueldo del nuevo empleado.
Solamente se permitira registrar empleados cuyo sueldo sea mayor que cero. Cuando no
se cumpla esta condicion, debera mostrar 'No se puede registrar un sueldo no positivo',
sin agregar el empleado a la tabla.

Cuando el registro sea exitoso, debera mostrar el mensaje 'Empleado registrado con codigo: '
seguido del identificador asignado al nuevo empleado.

Demuestre su funcionamiento con un registro valido y otro con sueldo negativo. Compruebe
que solamente el empleado valido haya sido incorporado y que el codigo mostrado coincida
con el almacenado en la tabla.
*/
CREATE SEQUENCE SEQ_COD_EMPLEADO
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 100
    NOCYCLE;
   
CREATE OR REPLACE PROCEDURE REGISTRAR_EMPLEADO(
    P_NAME VARCHAR2,
    P_SUELDO NUMBER,
    P_PHONE VARCHAR2
)
IS
BEGIN
    LOCK TABLE EMPLEADOS_PRACTICA IN ROW EXCLUSIVE MODE;

    IF (P_SUELDO > 0) THEN
        INSERT INTO EMPLEADOS_PRACTICA(ID_BOY, FIRST_NAME, PHONE, SALARY) VALUES (SEQ_COD_EMPLEADO.NEXTVAL, P_NAME, P_PHONE, P_SUELDO);
    ELSE
        DBMS_OUTPUT.PUT_LINE('No se puede registrar un sueldo no positivo');
    END IF;
END;

BEGIN
    REGISTRAR_EMPLEADO('ERNESTO', 200000, '1223-123');
    COMMIT;
END;

SELECT * FROM EMPLEADOS_PRACTICA;

/*
Se solicita crear un procedimiento almacenado de nombre ELIMINAR_EMPLEADO para la tabla
EMPLEADOS_PRACTICA, que reciba el identificador del empleado que se desea eliminar.

La eliminacion solamente podra realizarse cuando el sueldo del empleado sea inferior
a 2000. Si cumple esta condicion, debera eliminar su registro y mostrar el mensaje
'Empleado eliminado correctamente'. En caso contrario, debera conservar sus datos
y mostrar 'El empleado no cumple las condiciones para ser eliminado'.

Si el identificador recibido no corresponde a un empleado existente, debera informar
'Empleado inexistente', incluyendo el manejo de excepciones correspondiente.

El procedimiento debera considerar control de transacciones y afectar exclusivamente
al empleado indicado. Demuestre su funcionamiento con una eliminacion permitida,
una eliminacion rechazada por el sueldo y un identificador inexistente.
*/

CREATE OR REPLACE PROCEDURE ELIMINAR_EMPLEADO(
    P_IDDEL NUMBER
)
IS
    SUELDO_TEMP NUMBER;
BEGIN
    LOCK TABLE EMPLEADOS_PRACTICA IN ROW EXCLUSIVE MODE;
    SELECT SALARY INTO SUELDO_TEMP
    FROM EMPLEADOS_PRACTICA
    WHERE ID_BOY = P_IDDEL;

    IF (SUELDO_TEMP < 2000) THEN
        DELETE FROM EMPLEADOS_PRACTICA WHERE ID_BOY = P_IDDEL;
        DBMS_OUTPUT.PUT_LINE('Empleado eliminado correctamente');
    ELSE
        DBMS_OUTPUT.PUT_LINE('El empleado no cumple las condiciones para ser eliminado');
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Empleado inexistente');
		WHEN PROGRAM_ERROR THEN
			RAISE_APPLICATION_ERROR(-20002,'ERROR DE PROGRAMA Y/O ASIGNACION DE VARIABLES');
		WHEN STORAGE_ERROR THEN
			RAISE_APPLICATION_ERROR(-20021,'SE ACABO LA MEMORIA, O ES CORRUPTA');
		WHEN ROWTYPE_MISMATCH THEN
			RAISE_APPLICATION_ERROR(-20980,'ERROR DE ASIGNACION DE VARIABLES');
		WHEN OTHERS THEN
			RAISE_APPLICATION_ERROR(-20010,'ERROR');
	ROLLBACK;
END;

BEGIN
    ELIMINAR_EMPLEADO(41);
    COMMIT;
END;

SELECT * FROM EMPLEADOS_PRACTICA;
UPDATE EMPLEADOS_PRACTICA SET SALARY = 1900
WHERE ID_BOY = 41;



------------------------------------------------------------------------------------------
--- FUNCTIONS
------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION TEST_START(
    VARIABLES NUMBER
) RETURN NUMBER
IS
BEGIN
    RETURN;
    EXCEPTION
        RETURN;
END;

/*
EJERCICIO 1 — FACIL: FUNCION DE CALCULO

Se solicita crear una funcion llamada CALCULAR_BONO, que reciba un sueldo y retorne
ese valor aumentado en 100. La funcion solamente debera entregar el resultado del
calculo, sin modificar los datos de EMPLEADOS_PRACTICA.

Demuestre su funcionamiento con sueldos de 1000, 1800 y 2500.
*/

CREATE OR REPLACE FUNCTION CALCULAR_BONO(
    P_SUELDO NUMBER
) RETURN NUMBER
IS
    SUELDO_MAS NUMBER := 0;
BEGIN
    SUELDO_MAS := P_SUELDO + 100;
    RETURN SUELDO_MAS;
END;

/*
EJERCICIO 2 — FACIL: FUNCION PARA NORMALIZAR NOMBRES

Se solicita crear una funcion llamada NORMALIZAR_NOMBRE, que reciba el nombre de
una persona y lo retorne en mayusculas, eliminando los espacios que pudiera tener
al principio y al final.

Demuestre su funcionamiento con nombres escritos en minusculas, combinando
mayusculas y minusculas, y con espacios al inicio y al final.
*/

-- TRIM -> BORRA LOS CARACTERES VACIOS DEL INICIO Y DEL FINAL

CREATE OR REPLACE FUNCTION NORMALIZAR_NOMBRE(
    NAME_NORMAL VARCHAR2
) RETURN VARCHAR2
IS
        TEMP VARCHAR2;
BEGIN
    TEMP := UPPER(TRIM(NAME_NORMAL));
    RETURN TEMP;
END;


/*
EJERCICIO 3 — FACIL: FUNCION DE VALIDACION

Se solicita crear una funcion llamada SUELDO_VALIDO, que reciba un sueldo y retorne
1 cuando sea mayor que cero, o 0 cuando sea cero, negativo o no tenga un valor informado.

Demuestre su funcionamiento con un sueldo positivo, cero, un sueldo negativo
y un valor nulo. La funcion no debera modificar registros de la tabla.
*/


CREATE OR REPLACE FUNCTION SUELDO_VALIDO(
    P_SUELDO NUMBER
) RETURN NUMBER
IS
BEGIN
    IF (P_SUELDO > 0) THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
    
END;


/*
EJERCICIO 4 — FACIL A INTERMEDIO: CONSULTAR EL SUELDO

Se solicita crear una funcion llamada OBTENER_SUELDO, que reciba el identificador
de un empleado de EMPLEADOS_PRACTICA y retorne su sueldo actual.

Si el empleado existe, pero no tiene sueldo informado, debera retornar 0.
Si el empleado no existe, debera retornar -1, considerando el manejo de excepciones
correspondiente. Demuestre las tres situaciones.
*/


CREATE OR REPLACE FUNCTION OBTENER_SUELDO(
    P_ID_EMPLEADO NUMBER
) RETURN NUMBER
IS
    SUELDO_TEMP NUMBER;
BEGIN
    SELECT SALARY INTO SUELDO_TEMP
    FROM EMPLEADOS_PRACTICA
    WHERE ID_BOY = P_ID_EMPLEADO;

    IF ((P_ID_EMPLEADO IS NOT NULL) AND (SUELDO_TEMP IS NULL) ) THEN
        RETURN 0;
    ELSE
        RETURN SUELDO_TEMP;
    END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN -1;
    
END;




/*
EJERCICIO 5 — INTERMEDIO: CALCULO CON MANEJO DE ERRORES

Se solicita crear una funcion llamada CALCULAR_REAJUSTE, que reciba un sueldo y un
porcentaje de aumento, y retorne el sueldo resultante redondeado a dos decimales.

El sueldo debera ser mayor que cero y el porcentaje debera ser mayor que cero y
no superar el 20 por ciento. Ambos valores seran obligatorios. Si los datos no cumplen
estas condiciones, debera comunicar un error de aplicacion que identifique el problema.

Demuestre un calculo correcto, un sueldo invalido y un porcentaje fuera del rango.
*/

CREATE OR REPLACE FUNCTION CALCULAR_REAJUSTE(
    P_SUELDO NUMBER,
    P_AUMENTO NUMBER
) RETURN NUMBER
IS 
    SUELDO_RESULTANTE NUMBER;
BEGIN
    IF ((P_SUELDO > 0) AND (P_AUMENTO > 0) AND (P_AUMENTO < 20)) THEN
        SUELDO_RESULTANTE := (P_SUELDO * P_AUMENTO)/100;
        RETURN ROUND(SUELDO_RESULTANTE,2);
    ELSE
        RETURN P_SUELDO;
    END IF;
    EXCEPTION
        WHEN ROWTYPE_MISMATCH THEN
            RAISE_APPLICATION_ERROR(-20000,'ERROR');
    
END;


/*
EJERCICIO 1 - REGISTRO DE EMPLEADOS CON SUELDO REAJUSTADO

Se solicita crear la tabla E1_EMPLEADOS con los campos ID_EMPLEADO NUMBER como clave
primaria, NOMBRE VARCHAR2(50), TELEFONO VARCHAR2(20) y SUELDO NUMBER(10,2).

Cree una funcion llamada E1_CALCULAR_SUELDO que reciba un sueldo base y un porcentaje
de aumento, y retorne el sueldo resultante redondeado a dos decimales. El sueldo base
debera ser positivo y el porcentaje debera estar entre 0 y 20, ambos incluidos.
Los valores no informados o fuera de estas condiciones deberan generar errores
de aplicacion que permitan identificar el problema.

Posteriormente, cree el procedimiento E1_REGISTRAR_EMPLEADO, que reciba nombre,
telefono, sueldo base y porcentaje. Debera registrar el nombre en mayusculas y
almacenar el sueldo calculado mediante la funcion. El nombre sera obligatorio.

El identificador se obtendra mediante una secuencia propia llamada E1_SEQ_EMPLEADO,
que comenzara en 1 y no reutilizara sus valores.

Considere control de transacciones y manejo de excepciones. Demuestre dos registros
correctos y rechazos por nombre no informado, sueldo invalido y porcentaje fuera
del rango permitido. Compruebe que los intentos rechazados no agreguen empleados.
*/


/*
EJERCICIO 2 - REAJUSTE SEGUN ANTIGUEDAD

Se solicita crear la tabla E2_EMPLEADOS con los campos ID_EMPLEADO NUMBER como clave
primaria, NOMBRE VARCHAR2(50), FECHA_INGRESO DATE y SUELDO NUMBER(10,2). Prepare empleados
con diferentes antiguedades y asigne sus identificadores al cargar los datos de prueba.

Cree una funcion llamada E2_PORCENTAJE_AUMENTO que reciba el identificador de un empleado
y retorne el porcentaje que le corresponde: 10 para quienes tengan cinco o mas anos
cumplidos, 5 para quienes tengan al menos dos anos cumplidos y menos de cinco,
y 0 para quienes tengan menos de dos anos.

Si el empleado no existe o su fecha de ingreso no esta informada o es futura,
debera comunicar el error de aplicacion correspondiente.

Cree un procedimiento llamado E2_REAJUSTAR_EMPLEADO que reciba el identificador,
utilice la funcion y aplique el aumento sobre el sueldo actual, con dos decimales.
Los empleados sin porcentaje de aumento conservaran su sueldo. No se permitira
trabajar con sueldos nulos o no positivos.

Incluya control de transacciones y excepciones. Demuestre las tres categorias de
antiguedad, un identificador inexistente y una fecha de ingreso invalida.
*/


/*
EJERCICIO 3 - PROCEDIMIENTO INTEGRAL DE EMPLEADOS

Se solicita crear la tabla E3_EMPLEADOS con los campos ID_EMPLEADO NUMBER como clave
primaria, NOMBRE VARCHAR2(50), TELEFONO VARCHAR2(20) y SUELDO NUMBER(10,2).

Cree una funcion llamada E3_DATOS_VALIDOS que reciba nombre, telefono y sueldo.
Debera retornar 1 cuando nombre y telefono tengan contenido y el sueldo sea positivo
y no supere 100000. En cualquier otro caso debera retornar 0.

Cree una secuencia propia llamada E3_SEQ_EMPLEADO y un procedimiento almacenado
llamado E3_IUD_EMPLEADO, que permita insertar, modificar o eliminar empleados mediante
una operacion I, U o D, aceptando letras mayusculas y minusculas.

La insercion debera generar automaticamente el identificador. La modificacion permitira
cambiar nombre, telefono y sueldo, conservando el identificador. Ambas operaciones
deberan utilizar la funcion de validacion.

La eliminacion solamente estara permitida cuando el sueldo sea positivo e inferior
a 2000. Para eliminar no se deberan exigir los datos necesarios para registrar.

Las operaciones invalidas, los datos rechazados y los identificadores inexistentes
deberan comunicarse mediante errores de aplicacion. Incluya control de transacciones
y excepciones. Demuestre las tres operaciones y sus principales situaciones de rechazo.
*/


/*
EJERCICIO 4 - REAJUSTE GENERAL CON CURSOR Y RESUMEN

Se solicita crear la tabla E4_EMPLEADOS con ID_EMPLEADO NUMBER como clave primaria,
NOMBRE VARCHAR2(50) y SUELDO NUMBER(10,2). Prepare empleados con distintos sueldos.

Cree una funcion llamada E4_SUELDO_REAJUSTADO que reciba un sueldo y retorne su nuevo
valor: aumento del 10 por ciento para sueldos inferiores a 2000, del 5 por ciento
para sueldos entre 2000 y 5000, ambos incluidos, y sin aumento para los superiores
a 5000. Los resultados deberan tener dos decimales. Un sueldo nulo o no positivo
debera generar un error de aplicacion.

Cree el procedimiento E4_REAJUSTE_GENERAL, que procese los empleados mediante un cursor
y utilice la funcion para determinar sus nuevos sueldos.

Cada ejecucion exitosa debera registrar un resumen en una tabla propia E4_PROCESOS,
con identificador de proceso, fecha, cantidad de empleados cuyo sueldo cambio y
monto total de los aumentos. El identificador se generara mediante E4_SEQ_PROCESO.

Si cualquier empleado presenta un sueldo invalido, no debera quedar aplicado ningun
aumento de esa ejecucion ni su resumen. Si ningun empleado requiere aumento,
se registrara un resumen con cantidad y monto iguales a cero.

Incluya transacciones y excepciones. Demuestre un proceso correcto y otro que falle
al encontrar un dato invalido entre los empleados que se deben procesar.
*/


/*
EJERCICIO 5 - REDISTRIBUCION SALARIAL CON CONCURRENCIA

Se solicita crear la tabla E5_EMPLEADOS con ID_EMPLEADO NUMBER como clave primaria,
NOMBRE VARCHAR2(50) y SUELDO NUMBER(10,2).

Cree una funcion llamada E5_CALCULAR_NUEVO_SUELDO que reciba un sueldo y una variacion,
positiva o negativa, y retorne el resultado con dos decimales. El sueldo original
y el resultado deberan ser positivos, y ninguno de los argumentos podra ser nulo.
Los incumplimientos deberan comunicarse mediante errores de aplicacion.

Cree el procedimiento E5_TRANSFERIR_SUELDO, que reciba dos identificadores y un importe.
Debera descontar el importe al empleado de origen y sumarlo al de destino, utilizando
la funcion. Ambos empleados deberan existir y ser distintos; el importe sera positivo
y tendra un maximo de dos decimales. La suma de ambos sueldos debera mantenerse constante.

Cada transferencia exitosa debera registrarse en una tabla propia E5_MOVIMIENTOS,
con identificador de movimiento, fecha, empleado de origen, empleado de destino
e importe. Utilice una secuencia propia llamada E5_SEQ_MOVIMIENTO.

La operacion debera contemplar concurrencia, transacciones y excepciones. Ante cualquier
fallo, deberan conservarse ambos sueldos anteriores y no quedar registrado el movimiento.

Demuestre una transferencia correcta, un descuento que dejaria un sueldo no positivo,
un identificador inexistente y operaciones desde dos sesiones sobre empleados
compartidos, incluyendo transferencias en sentidos opuestos.
*/


