--------------------------------------------------------------------------------------------------------------------------------
-- TAREA 1
--------------------------------------------------------------------------------------------------------------------------------
-- QUISIERA VER EL COD_EMPLEADO, CONCATENADO EL COD_CARGO CON EL APELLIDO DEL TRABAJADOR DE LA SIGUIENTE FORMA: CASTRO ES ACA_UCM, 
-- ADEMAS DEL NOMBRE DEL CARGO QUE TIENE. ENTIENDASE QUE LAS BARRAS SON SEPARADORES VISUALES, NO SEBEN ESTAR CONCATENADAS

--  COD_TRABAJADOR	|	    REPORTE	        |	CARGO
-- -----------------------------------------------------
--          101		|    CASTRO ES ACA-UCM  | ACADEMICO
-- -----------------------------------------------------


SELECT E.EMPLOYEE_ID AS "COD_EMPLEADO",
CONCAT(E.LAST_NAME, CONCAT(' ES ', CONCAT(SUBSTR(J.JOB_ID,1,3), CONCAT('-' ,SUBSTR(JOB_TITLE,1,3))))) AS "REPORTE", E.JOB_ID AS "CARGO"
FROM OEHR_EMPLOYEES E JOIN OEHR_JOBS J ON(E.JOB_ID = J.JOB_ID)
    JOIN OEHR_DEPARTMENTS D ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID);

--------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------------
-- TAREA 2
--------------------------------------------------------------------------------------------------------------------------------
-- QUISIERA SABER DEL TRABAJADO: NOMBRE CONCATENADO CON EL APELLIDO, SU CODIGO, EL NOMBRE DE SU DEPARTAMENTO ASOCIADO Y 
-- EL NOMBRE DEL JEFE ASOCIADO A DICHO DEPARTAMENTO ADEMAS DE LA CIUDAD EN LA QUE SE ENCUENTRA Y ADEMAS DEL NOMBRE DE SU CARGO
--------------------------------------------------------------------------------------------------------------------------------
SELECT CONCAT(E.FIRST_NAME, CONCAT(' ', E.LAST_NAME)) AS "NOMBRE COMPLETO", E.EMPLOYEE_ID AS "CODIGO", D.DEPARTMENT_NAME AS "DEPARTAMENTO", N.FIRST_NAME AS "JEFE", L.CITY "CIUDAD", J.JOB_TITLE AS "TRABAJO"
FROM OEHR_EMPLOYEES E JOIN OEHR_JOBS J ON (E.JOB_ID = J.JOB_ID) JOIN OEHR_DEPARTMENTS D ON (D.DEPARTMENT_ID = E.DEPARTMENT_ID ) 
    JOIN OEHR_LOCATIONS L ON (D.LOCATION_ID = L.LOCATION_ID) JOIN OEHR_EMPLOYEES N ON (D.MANAGER_ID = N.EMPLOYEE_ID);



--------------------------------------------------------------------------------------------------------------------------------

