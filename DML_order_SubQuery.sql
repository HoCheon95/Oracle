2025-1223-01)DML 명령과 SubQuery
 - INSERT, UPDATE, DELETE 에 사용되는 서브쿼리
1. INSERT 문에 사용되는 서브쿼리
  - INSERT 문에 서브쿼리가 사용되는 경우 VALUES 절이 생략됨
  - INSERT 문에 서브쿼리를 사용할 경우 '( )'를 생략한다.
사용형식)
  INSERT INTO 테이블명[(컬럼명, 컬럼명, ... )]
    서브쿼리;
  - 테이블명 다음에 기술된 (컬럼명, 컬럼명, ... )의 순서와 갯수는 서브쿼리의
    SELECT 문의 SELECT 절 컬럼의 순서, 갯수와 일치해야함

2. DELETE 문에 사용되는 서브쿼리
 - DELETE 문의 조건으로 서브쿼리가 사용됨

사용예)HR계정 EMPLOYEES 테이블에 사원번호, 사원명, 입사일, 부서코드, 급여로 구성된
     TBL_EMP테이블을 생성하시오.
  CREATE TABLE HR.TBL_EMP AS
    SELECT EMPLOYEE_ID, EMP_NAME, HIRE_DATE, DEPARTMENT_ID, SALARY
      FROM HR.EMPLOYEES

사용예) TBL_EMP테이블의 데이터 중 입사년도가 '2020'년 이전인 사원들을 삭제하시오.
  DELETE FROM HR.TBL_EMP 
   WHERE EXTRACT(YEAR FROM HIRE_DATE) < 2020

사용예) TBL_EMP테이블의 데이터 중 직무가 변동된 사원을 삭제하시오.
  DELETE FROM HR.TBL_EMP
   WHERE EMPLOYEE_ID = SOME(SELECT DISTINCT EMPLOYEE_ID
                              FROM HR.JOB_HISTORY)
                              
 **  TBL_EMP 테이블의 모든 자료를 삭제
  DELETE FROM HR.TBL_EMP;
  
  COMMIT;

사용예) 사원테이블에서 2020년 이후 입사한 사원 중 
       급여가 5000이상인 사원만 TBL_EMP 테이블에 저장하시오.
메인쿼리 : 조건을 만족하는 자료를 TBL_EMP 테이블에 삽입)
  INSERT INTO HR.TBL_EMP(EMPLOYEE_ID, EMP_NAME, HIRE_DATE, DEPARTMENT_ID, SALARY)
    서브쿼리;

서브쿼리 : 2020년 이후 입사한 사원 중 급여가 5000이상인 사원
  SELECT EMPLOYEE_ID, EMP_NAME, HIRE_DATE, DEPARTMENT_ID, SALARY
    FROM HR.EMPLOYEES
   WHERE EXTRACT(YEAR FROM HIRE_DATE) >= 2020
     AND SALARY >= 5000;

결합)
  INSERT INTO HR.TBL_EMP(EMPLOYEE_ID, EMP_NAME, HIRE_DATE, DEPARTMENT_ID, SALARY)
    SELECT EMPLOYEE_ID, EMP_NAME, HIRE_DATE, DEPARTMENT_ID, SALARY
    FROM HR.EMPLOYEES
   WHERE EXTRACT(YEAR FROM HIRE_DATE) >= 2020
     AND SALARY >= 5000;
  
  SELECT * FROM HR.TBL_EMP;

3. UPDATE 문에 사용되는 서브쿼리
  - UPDATE 문에 서브쿼리가 사용되는 경우 SET 절에 기술된 컬럼(들)에 서브쿼리의
    SELECT 절에 기술된 컬럼들이 차례대로 저장됨

사용형식)
  UPDATE 테이블명 [별칭]
     SET (컬럼명, 컬럼명, ...) = (서브쿼리)
  [WHERE 조건]
  - SET 절에 두 개이상의 컬럼이 기술될 떄 '( )'안에 기술하며,
    기술된 컬럼 갯수, 순서는 서브쿼리의 SELECT 절 컬럼의 갯수, 순서와 일치해야 함
  - WHERE 조건이 생략 되면 모든 행이 변경됨을 반드시 고려해야 함

사용예) 2020년 1월 상품별 매입수량을 조회하여 재고수불테이블을 갱신하시오
서브쿼리 : 2020년 1월 상품별 매입수량을 조회)
  SELECT PROD_ID, SUM(BUY_QTY)
    FROM BUYPROD
   WHERE BUY_DATE BETWEEN TO_DATE ('20200101') AND TO_DATE('20200131')
   GROUP BY PROD_ID

COMMIT;
-- ROLLBACK;
COMMIT;

메인쿼리 : UPDATE 명령
방법-1)
  UPDATE REMAIN A
     SET (A.REMAIN_I, A.REMAIN_J_99, A.REMAIN_DATE) = 
         (SELECT A.REMAIN_I+B.BSUM, A.REMAIN_J_99+B.BSUM, TO_DATE('20200131')
            FROM (SELECT PROD_ID, SUM(BUY_QTY) AS BSUM
                    FROM BUYPROD
                   WHERE BUY_DATE BETWEEN TO_DATE ('20200101') AND TO_DATE('20200131')
                   GROUP BY PROD_ID)B
           WHERE B.PROD_ID=A.PROD_ID)
   WHERE A.PROD_ID IN (SELECT DISTINCT PROD_ID
                         FROM BUYPROD
                        WHERE BUY_DATE BETWEEN TO_DATE ('20200101') AND TO_DATE('20200131'));

방법-2)
  UPDATE REMAIN A
     SET (A.REMAIN_I, A.REMAIN_J_99, A.REMAIN_DATE) = 
         (SELECT A.REMAIN_I+SUM(B.BUY_QTY), 
                 A.REMAIN_J_99+SUM(B.BUY_QTY), 
                 LAST_DAY(TO_DATE('20200401'))
            FROM BUYPROD B
           WHERE B.PROD_ID=A.PROD_ID
             AND B.BUY_DATE BETWEEN TO_DATE ('20200301') 
                 AND LAST_DAY(TO_DATE('20200401')))
   WHERE A.PROD_ID IN (SELECT DISTINCT PROD_ID
                         FROM BUYPROD
                        WHERE BUY_DATE BETWEEN TO_DATE ('20200301') 
                              AND LAST_DAY(TO_DATE('20200401')));


COMMIT;

문제]2020년 4월 상품별 매출수량을 조회하여 재고수불테이블을 갱신하시오
서브쿼리 : 2020년 4월 상품별 매출수량 조회)
  SELECT PROD_ID, SUM(CART_QTY)
    FROM CART
   WHERE SUBSTR(CART_NO,1,6) = '202004'
   GROUP BY PROD_ID;

메인쿼리 : UPDATE 명령
  UPDATE REMAIN A
     SET (A.REMAIN_O, A.REMAIN_J_99, A.REMAIN_DATE) = 
         (SELECT A.REMAIN_O+B.SUM, A.REMAIN_J_99-B.BSUM, TO_DATE('20200430')
            FROM (SELECT PROD_ID, SUM(CART_QTY) AS BSUM
                    FROM CART
                   WHERE SUBSTR(CART_NO,1,6) = '202004'
                    GROUP BY PROD_ID)B
           WHERE B.PROD_ID=A.PROD_ID)
   WHERE A.PROD_ID IN (SELECT DISTINCT PROD_ID
                         FROM CART
                        WHERE SUBSTR(CART_NO,1,6) = '202004');

-- 답안
(서브쿼리)
  SELECT SUM(B.CART_QTY)
    FROM CART B
   WHERE B.CART_NO LIKE '202004%'
     AND B.PROD_ID=(재고수불테이블의 상품코드)

(메인쿼리)
  UPDATE REMAIN A
     SET (A.REMAIN_O, A.REMAIN_J_99, A.REMAIN_DATE) = 
         (SELECT A.REMAIN_O + SUM(B.CART_QTY),
                 A.REMAIN_J_99-SUM(B.CART_QTY),
                 TO_DATE('20200430')
            FROM CART B
           WHERE B.CART_NO LIKE '202004%'
             AND B.PROD_ID=A.PROD_ID)
  WHERE A.PROD_ID IN (SELECT DISTINCT PROD_ID
                        FROM CART
                       WHERE CART_NO LIKE '202004%')