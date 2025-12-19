2025-1219-01)
** 다음 조건으로 테이블을 생성하시오
 1)테이블명 : REMAIN
 2)컬럼명세
 -----------------------------------------------------------------------
    컬럼명          데이터타입       NULLABLE    default value     PF/FK
 -----------------------------------------------------------------------
  REMAIN_YEAR      CHAR(4)        N                             PK
  PROD_ID          VARCHAR2(10)   N                             PK & FK
  REMAIN_J_00      NUMBER(5)      Y             0               
  REMAIN_I         NUMBER(5)      Y             0                  
  REMAIN_O         NUMBER(5)      Y             0
  REMAIN_J_99      NUMBER(5)      Y             0
  REMAIN_DATE      DATE           Y            SYSDATE
  

4) SELF JOIN
  - 하나의 테이블에 복수개의 테이블 별칭을 부여하여 서로 다른 테이블 처럼 수행하는 JOIN
  
사용예) 사원테이블 50번부서에서 책임사원(부서장)은 121번 'Adam Fripp' 사원이다
       이 사원보다 입사일이 빠른 사원들 (50번 부서의 사원 중)의
       사원번호, 사원명, 입사일, 직무코드, 급여를 조회하시오
  SELECT B.EMPLOYEE_ID AS 사원번호, 
         B.EMP_NAME AS 사원명, 
         B.HIRE_DATE AS 입사일, 
         B.JOB_ID AS 직무코드, 
         B.SALARY AS 급여
    FROM HR.EMPLOYEES A
   INNER JOIN HR.EMPLOYEES B ON(A.HIRE_DATE > B.HIRE_DATE
         AND B.DEPARTMENT_ID=50)
   WHERE A.EMPLOYEE_ID=121
   ORDER BY 3;

