2025-1224-03) SYNONYM (동의어) 객체
 - 오라클에서 사용하는 객체에 부여하는 또 다른 이름
 - 테이블의 별칭과 컬럼의 별칭과의 차이점은 사용하는 영역이
   테이블의 별칭과 컬럼의 별칭은 해당 SQL 문 안에서만 유효하지만 SYNONYM 은 세션이 수립되면
   언제나 테이블명 처럼 사용가능
 - 주로 다른 소유자의 객체를 참조하기 위하여 작성하는 긴 스키마 기술 대신
   편리하고 짧은 명칭을 부여하고자 하는 경우 사용함

사용형식)
  CREATE [OR REPLACE] SYNONYM 동의어명 FOR 객체명

사용예) HR계정의 EMPLOYEES와 DEPARTMENTS 테이블을 각 각 EMP와 DEPT
       동의어를 부여하여 사용하시오.
  CREATE OR REPLACE SYNONYM EMP FOR HR.EMPLOYEES;
  CREATE OR REPLACE SYNONYM DEPT FOR HR.DEPARTMENTS;

  SELECT EMPLOYEE_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM HR.EMPLOYEES
   WHERE HIRE_DATE > TO_DATE('20191231')
   ORDER BY 3;

  SELECT EMPLOYEE_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMP
   WHERE HIRE_DATE > TO_DATE('20191231')
   ORDER BY 3;

  SELECT A.EMP_NAME, A.DEPARTMENT_ID, B.DEPARTMENT_NAME
    FROM EMP A
   INNER JOIN DEPT B ON(A.DEPARTMENT_ID = B.DEPARTMENT_ID)
   WHERE A.DEPARTMENT_ID IN(60,80,90);