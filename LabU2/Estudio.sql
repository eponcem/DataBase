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
