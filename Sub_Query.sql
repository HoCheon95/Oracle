2025-1222-01)SUB_QUERY [서브쿼리]
 - SUBQUERY는 다른 하나의 SQL 문장의 절에 NESTED 된 SELECT 문장.
 - SELECT, UPDATE, DELETE, INSERT 와 같은 DML문과 CREATE TABLE 또는 VIEW 에서 이용될 수 있다.
 - 알려지지 않은 조건에 근거한 값들을 검색하는 SELECT 문장을 작성하는데 유용
 - SUBQUERY는 MAIN QUERY 가 실행되기 이전에 한번 실행되며, 기술된 절이 실행될 때 가장 먼저 실행됨
 - 서브쿼리는 '( )' 로 묶어야 함(예외 - INSER INT 문에 사용된 서브쿼리,
   CREATE TABLE에 사용되는 서브쿼리)
 - SUBQUERY는 연산자 오른쪽에만 기술 함
 - 두 종류의 연산자가 서브쿼리에 사용 됨(단일행 : 관계연산자, 다중행 : IN, ANY, SOME ALL, EXISTE)
 - 서브쿼리의 종류
  · 스칼라(SCALAR)서브쿼리 - SELECT 절에 사용하는 서브쿼리로 하나의 값만 반환(단일행 단일열)
  · 인라인(IN-LINE)서브쿼리 - FROM 절에 위치하며 반드시 독립실행 되어야 함
  · 중첩서브쿼리 - WHERE 절에 위치하며 결과집합을 한정하기 위한 서브쿼리로
    단일행(관계연산자 사용 가능) 또는 다중행(반드시 다중행 연산자 사용해야 함) 반환을 허용함

사용예)
 1) 사원테이블에서 사원들의 평균 급여보다 많은 급여를 받는 사원들의 사원번호, 사원명,
    부서번호, 급여, 입사일, 평균급여를 출력하시오.
(메인쿼리 : 조건(서브쿼리 결과)을 만족하는 사원들의 사원번호, 사원명, 부서번호, 급여, 입사일, 평균급여
  SELECT 사원들의 사원번호, 사원명, 부서번호, 급여, 입사일, 평균급여
    FROM HR.EMPLOYEES
   WHERE SALARY > (서브쿼리 : 평균급여)

(서브쿼리 : 평균급여)
  SELECT AVG(SALARY)
    FROM HR.EMPLOYEES

(결합 : 중첩서브쿼리)
  SELECT EMPLOYEE_ID AS 사원번호, 
         EMP_NAME AS 사원명, 
         DEPARTMENT_ID AS 부서번호, 
         SALARY AS 급여, 
         HIRE_DATE AS 입사일, 
         (SELECT ROUND(AVG(SALARY))
            FROM HR.EMPLOYEES) AS 평균급여
    FROM HR.EMPLOYEES
   WHERE SALARY > (SELECT AVG(SALARY)
                     FROM HR.EMPLOYEES);
                     
(결합 : IN-LINE 서브쿼리)
  SELECT EMPLOYEE_ID AS 사원번호, 
         EMP_NAME AS 사원명, 
         DEPARTMENT_ID AS 부서번호, 
         SALARY AS 급여, 
         HIRE_DATE AS 입사일, 
         ROUND(ASAL) AS 평균급여
    FROM HR.EMPLOYEES,
         (SELECT AVG(SALARY) AS ASAL FROM HR.EMPLOYEES)
   WHERE SALARY > ASAL;

 2) 2020년 충남에 거주하는 회원들의 구매금액보다 더 많은 구매를 한 회원들의
    회원번호, 회원명, 구매금액을 조회하시오
(메인쿼리 : 조건(서브쿼리 결과)을 만족하는 회원들의 회원번호, 회원명, 구매금액 조회)
  SELECT TBLA.회원번호 AS 회원번호, 
         TBLA.회원명 AS 회원명, 
         TBLA.구매금액합계 AS 구매금액
    FROM (2020년 회원별 구매급액합계) TBLA
   WHERE TBLA.구매금액합계 > ALL(2020년 충남거주 회원별 구매금액합계)

(2020년 회원별 구매급액합계)
  SELECT A.MEM_ID AS AMID, 
         C.MEM_NAME AS CNAME,
         SUM(A.CART_QTY * B.PROD_PRICE) AS CSUM
    FROM CART A
   INNER JOIN PROD B ON (A.PROD_ID=B.PROD_ID)-- PROD_PRICE 추출
   INNER JOIN MEMBER C ON (A.MEM_ID=C.MEM_ID)
   WHERE SUBSTR(A.CART_NO,1,4) = '2020'
   GROUP BY A.MEM_ID, C.MEM_NAME
         
(충남에 거주하는 회원들의 2020년 회원별 구매급액합계)
  SELECT A.MEM_ID AS AMID,SUM(A.CART_QTY * B.PROD_PRICE) AS CSUM
    FROM CART A
   INNER JOIN PROD B ON (A.PROD_ID=B.PROD_ID)-- PROD_PRICE 추출
   INNER JOIN MEMBER C ON(A.MEM_ID=C.MEM_ID)--MEM_ADD1 추출
   WHERE SUBSTR(A.CART_NO,1,4) = '2020'
     AND C.MEM_ADD1 LIKE '충남%' 
   GROUP BY A.MEM_ID
   
(결합)
  SELECT TBLA.AMID AS 회원번호, 
         TBLA.CNAME AS 회원명, 
         TBLA.CSUM AS 구매금액
    FROM (SELECT A.MEM_ID AS AMID, 
                 C.MEM_NAME AS CNAME,
                 SUM(A.CART_QTY * B.PROD_PRICE) AS CSUM
            FROM CART A
           INNER JOIN PROD B ON (A.PROD_ID=B.PROD_ID)-- PROD_PRICE 추출
           INNER JOIN MEMBER C ON (A.MEM_ID=C.MEM_ID)
           WHERE SUBSTR(A.CART_NO,1,4) = '2020'
           GROUP BY A.MEM_ID, C.MEM_NAME) TBLA
   WHERE TBLA.CSUM > ALL(SELECT CSUM
                           FROM(SELECT A.MEM_ID AS AMID,
                                       SUM(A.CART_QTY * B.PROD_PRICE) AS CSUM
                                  FROM CART A
                                 INNER JOIN PROD B ON (A.PROD_ID=B.PROD_ID)-- PROD_PRICE 추출
                                 INNER JOIN MEMBER C ON(A.MEM_ID=C.MEM_ID)--MEM_ADD1 추출
                                 WHERE SUBSTR(A.CART_NO,1,4) = '2020'
                                   AND C.MEM_ADD1 LIKE '충남%' 
                                 GROUP BY A.MEM_ID))
   ORDER BY 3 DESC;

 3) 재고 수불테이블에 다음 자료를 입력하시오.
   · REMAIN_YEAR : '2020'
   · PROD_ID : PROD테이블의 모든 상품코드
   · REMAIN_J_00 : PROD테이블의 PROD_PROPERSTOCK
   · REMAIN_I와 REMAIN_O는 입력하지 않음
   · REMAIN_J_99 : PROD테이블의 PROD_PROPERSTOCK
   · REMAIN_DATE : '2020-01-01'
   
  INSERT INTO REMAIN(REMAIN_YEAR, PROD_ID, REMAIN_J_00, REMAIN_J_99,REMAIN_DATE)
  SELECT '2020', PROD_ID, PROD_PROPERSTOCK, PROD_PROPERSTOCK, TO_DATE(20200101)
    FROM PROD

 4) 회원테이블에서 20대 회원의 평균 마일리지보다 더 많은 마일리지를 보유한 회원의
    회원번호, 회원명, 나이, 마일리지를 조회하시오.
(메인쿼리 : 조건을 만족하는 회원번호, 회원명, 나이, 마일리지)
  SELECT MEM_ID AS 회원번호, MEM_NAME AS 회원명, 
         EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR) AS 나이, 
         MEM_MILEAGE AS 마일리지
    FROM MEMBER A
   WHERE MEM_MILEAGE > (서브쿼리 : 20대 회원의 평균 마일리지)
     AND (EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR))>20
(서브쿼리 : 20대 회원의 평균 마일리지)
  SELECT AVG(MEM_MILEAGE) AS AMILE
    FROM MEMBER
   WHERE TRUNC((EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR))/10)=2
   
(결합)
  SELECT MEM_ID AS 회원번호, MEM_NAME AS 회원명, 
         EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR) AS 나이, 
         MEM_MILEAGE AS 마일리지
    FROM MEMBER A
   WHERE MEM_MILEAGE > (SELECT AVG(MEM_MILEAGE) AS AMILE
                          FROM MEMBER
                         WHERE TRUNC((EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR))/10)=2)
     AND (EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR))>29;   