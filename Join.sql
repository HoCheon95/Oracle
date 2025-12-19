2025-1216-03) JOIN
 - 두 개 이상의 테이블들을 연결 또는 결합하여 데이터를 출력하는 것
 - 일반적인 경우 행들은 Primary Key(PK)나 Foreign Key(FK)값의 연관에
   의해 조인이 성립
 - 어떤 경우에는 이러한 PK, FK의 관계가 없어도 논리적인 값들의 연관만으로
   조인성립이 가능하며 JOIN 의 조건은 WHERE 절에 기술
 - 조인의 종류
  . Cartesian Product(CROSS JOIN)
  . 동등조인(Equi-Join), 비동등 조인(Non Equi-Join), Self Join
  . 일반조인, ANSI JOIN
  . 내부조인(INNER JOIN), 외부조인(Outer JOIN)

일반조인 사용형식)
  SELECT 컬럼 list
    FROM 테이블명1 [별칭1], 테이블명2 [별칭2] [,...테이블명n [별칭n]]
   WHERE 조인조건
    [AND 조인조건] 
    [AND 일반조건] 

ANSI 내부조인)
  SELECT 컬럼list
    FROM 테이블명1 [별칭1]
   INNER JOIN 테이블명2 [별칭2] ON(조인조건1 [AND 일반조건1])
   INNER JOIN 테이블명3 [별칭3] ON(조인조건2 [AND 일반조건2])
            :
  [WHERE 일반조건]
  - '테이블명1'과 '테이블명2'는 반드시 직접 조인되어야 함
  - '테이블명1'과 '테이블명2'의 조인 결과와 '테이블명3'이 조인됨
  - ON 절에 기술되는 '조인조건'과 '일반조건'은 알려진 테이블을 사용하는 조건 이어야 함.
    즉, '조인조건1'과 '일반조건1'은 '테이블명1'과 '테이블명2'에 관련된 조건 이어야하며,
    '조인조건2'과 '일반조건2'은 '테이별명1'과 '테이블명2' 및 '테이블명3'에 관련된 조건 이어야 한다.
  - WHERE 절에 사용되는 조건은 조인된 결과에 반영되는 조건이며 내부조인은 일반조건을 
    WHERE 절에 기술하거나 ON 절에 기술해도 차이가 없음

1. Cartesian Product
 - 테이블들 간의 JOIN 조건을생략하거나, 조건을 잘 못 설정 했을 경우 
 - 첫 번째 테이블의 모든 행들에 대해서 두 번째 테이블의 모든 행들이 JOIN 되어 조회되는 
   데이터의 형태를 Cartesian Product 라고 함
 - Cartesian Product가 발생하면 조회되는 데이터의 개수가 기하급수적으로 증가하게 되어 
   원하는 데이터를 얻을 수 없는것은 물론 데이터베이스나 네트워크에 부담을 주게되는 결과를 초래하게 되므로 주의해야 한다
 - ANSI 에서는 CROSS JOIN 이 Cartesioan Product 이다.
 - 조인 결과 집합은 조인에 참여한 모든 테이블의 행의 갯수를 곱한 행과 열들을 더한 결과 반환
 
사용예)
  SELECT 'CART' AS 테이블명, COUNT(*) AS "자료의 수"
    FROM CART
   UNION ALL
  SELECT 'BUYPROD',COUNT(*)
    FROM BUYPROD
   UNION ALL
  SELECT 'PROD', COUNT(*)
    FROM PROD;
    
(일반조인)
  SELECT * FROM CART A, BUYPROD B, PROD C;   

(ANSI JOIN)
  SELECT COUNT(*)
    FROM CART A
   CROSS JOIN BUYPROD B
   CROSS JOIN PROD C;
   
2. 내부조인
 - 조인조건을 만족하는 결과를 반환하고 조인조건을 만족하지 않는 자료는 무시함
사용예)
 0) 사원테이블에서 사원번호, 사원명, 부서명을 조회하시오
(ANSI JOIN)
  SELECT A.EMPLOYEE_ID AS 사원번호, 
         A.EMP_NAME AS 사원명, 
         B.DEPARTMENT_NAME AS 부서명
    FROM HR.EMPLOYEES A
   INNER JOIN HR.DEPARTMENTS B ON (A.DEPARTMENT_ID = B.DEPARTMENT_ID)
   ORDER BY A.DEPARTMENT_ID;
   
(일반조인)
  SELECT A.EMPLOYEE_ID AS 사원번호, 
         A.EMP_NAME AS 사원명, 
         B.DEPARTMENT_NAME AS 부서명
    FROM HR.EMPLOYEES A, HR.DEPARTMENTS B -- 테이블명만 가능
   WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID -- 조인조건
   ORDER BY A.DEPARTMENT_ID;

 1) 사원테이블에서 2020년 이후 입사한 사원들을 조회하시오
    조회해야할 컬럼은 사원번호, 사원명, 입사일, 부서번호, 부서명, 급여 이다.
(ANSI JOIN)
  SELECT A.EMPLOYEE_ID AS 사원번호, 
         A.EMP_NAME AS 사원명, 
         A.HIRE_DATE AS 입사일, 
         A.DEPARTMENT_ID AS 부서번호, 
         B.DEPARTMENT_NAME AS 부서명, 
         A.SALARY AS 급여
    FROM HR.EMPLOYEES A
   INNER JOIN HR.DEPARTMENTS B ON (A.DEPARTMENT_ID = B.DEPARTMENT_ID AND
                                   EXTRACT(YEAR FROM A.HIRE_DATE)>=2020)
   ORDER BY 4;
   
(WHERE 절 사용)
  SELECT A.EMPLOYEE_ID AS 사원번호, 
         A.EMP_NAME AS 사원명, 
         A.HIRE_DATE AS 입사일, 
         A.DEPARTMENT_ID AS 부서번호, 
         B.DEPARTMENT_NAME AS 부서명, 
         A.SALARY AS 급여
    FROM HR.EMPLOYEES A
   INNER JOIN HR.DEPARTMENTS B ON (A.DEPARTMENT_ID = B.DEPARTMENT_ID)
   WHERE EXTRACT(YEAR FROM A.HIRE_DATE)>=2020
   ORDER BY 4;
   
(일반조인)
  SELECT A.EMPLOYEE_ID AS 사원번호, 
         A.EMP_NAME AS 사원명, 
         A.HIRE_DATE AS 입사일, 
         A.DEPARTMENT_ID AS 부서번호, 
         B.DEPARTMENT_NAME AS 부서명, 
         A.SALARY AS 급여
    FROM HR.EMPLOYEES A, HR. DEPARTMENTS B
   WHERE EXTRACT(YEAR FROM A.HIRE_DATE)>=2020 -- 일반조건
     AND A.DEPARTMENT_ID=B.DEPARTMENT_ID -- 조인조건
   ORDER BY 4;

 2) 직무가 변경된 사원정보를 조회하시오
    조회할 내용은 사원번호, 사원명, 시작일자, 직무명
(ANSI JOIN)
  SELECT A.EMPLOYEE_ID AS 사원번호, 
         B.EMP_NAME AS 사원명, 
         A.START_DATE AS 시작일자, 
         C.JOB_TITLE AS 직무명
    FROM HR.JOB_HISTORY A
   INNER JOIN HR.EMPLOYEES B ON(A.EMPLOYEE_ID=B.EMPLOYEE_ID)--조인조건(이름 추출)
   INNER JOIN HR.JOBS C ON(A.JOB_ID=C.JOB_ID)--조인조건(직무명 추출)
   ORDER BY 1;
   
(일반조인)
  SELECT A.EMPLOYEE_ID AS 사원번호, 
         B.EMP_NAME AS 사원명, 
         A.START_DATE AS 시작일자, 
         C.JOB_TITLE AS 직무명
    FROM HR.JOB_HISTORY A, HR.EMPLOYEES B, HR.JOBS C
   WHERE A.EMPLOYEE_ID = B.EMPLOYEE_ID--조인조건(이름 추출)
     AND A.JOB_ID = C.JOB_ID--조인조건(직무명 추출)
   ORDER BY 1;
   
 3) 상품테이블에서 매입가격이 2만원 미만인 상품들을 조회하시오
    조회할 내용은 상품번호, 상품명, 분류번호, 분류명
(ANSI JOIN)
  SELECT A.PROD_ID AS 상품번호, 
         A.PROD_NAME AS 상품명, 
         A.LPROD_GU AS 분류번호, 
         B.LPROD_NAME AS 분류명
    FROM PROD A
   INNER JOIN LPROD B ON(A.LPROD_GU = B.LPROD_GU AND
                         A.PROD_COST<20000)
(일반조인)
  SELECT A.PROD_ID AS 상품번호, 
         A.PROD_NAME AS 상품명, 
         A.LPROD_GU AS 분류번호, 
         B.LPROD_NAME AS 분류명
    FROM PROD A, LPROD B
   WHERE A.LPROD_GU=B.LPROD_GU
     AND A.PROD_COST<20000

 4) 2020년 1월 상품별 매입집계를 조회하시오
    Alias는 상품코드, 상품명, 매입수량, 매입금액
(ANSI JOIN)
  SELECT A.PROD_ID AS 상품코드, 
         B.PROD_NAME AS 상품명, 
         SUM(A.BUY_QTY) AS 매입수량, 
         TO_CHAR(SUM(A.BUY_QTY * B.PROD_COST),'999,999,999') AS 매입금액
    FROM BUYPROD A
   INNER JOIN PROD B ON(A.PROD_ID = B.PROD_ID AND 
         A.BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131'))
   GROUP BY A.PROD_ID, B.PROD_NAME
   ORDER BY 1;
   
(일반조인)
  SELECT A.PROD_ID AS 상품코드, 
         B.PROD_NAME AS 상품명, 
         SUM(A.BUY_QTY) AS 매입수량, 
         TO_CHAR(SUM(A.BUY_QTY * B.PROD_COST),'999,999,999') AS 매입금액
    FROM BUYPROD A, PROD B
   WHERE A.PROD_ID = B.PROD_ID --조인조건(상품명과 매입단가 추출)
     AND A.BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131')
   GROUP BY A.PROD_ID, B.PROD_NAME
   ORDER BY 1;
    
 5) 2020년 6월 상품별 매출현황을 조회하시오
    Alias는 상품코드, 상품명, 매출수량, 매출금액
(ANSI JOIN)
  SELECT A.PROD_ID AS 상품코드, 
         B.PROD_NAME AS 상품명, 
         SUM(A.CART_QTY) AS 매출수량, 
         TO_CHAR(SUM(A.CART_QTY * B.PROD_PRICE),'9,999,999') AS 매출금액
    FROM CART A
   INNER JOIN PROD B ON(A.PROD_ID=B.PROD_ID) --조인조건(상품명과 판매단가 추출)
   WHERE A.CART_NO LIKE '202006%'
   GROUP BY A.PROD_ID, B.PROD_NAME
   ORDER BY 1;
   
(일반조인)
  SELECT A.PROD_ID AS 상품코드, 
         B.PROD_NAME AS 상품명, 
         SUM(A.CART_QTY) AS 매출수량, 
         TO_CHAR(SUM(A.CART_QTY * B.PROD_PRICE),'9,999,999') AS 매출금액
    FROM CART A, PROD B
   WHERE A.PROD_ID=B.PROD_ID
     AND SUBSTR(A.CART_NO,1,6) = '202006'
   GROUP BY A.PROD_ID, B.PROD_NAME
   ORDER BY 1;
   
 6) 2020년 7월 회원별 매출현황을 조회하시오
    Alias는 회원번호, 회원명, 구매수량, 구매금액
(ANSI JOIN)
  SELECT A.MEM_ID AS 회원번호, 
         B.MEM_NAME AS 회원명, 
         SUM(A.CART_QTY) AS 구매수량합계, 
         TO_CHAR(SUM(A.CART_QTY * C.PROD_PRICE),'99,999,999') AS 구매금액합계
    FROM CART A
   INNER JOIN MEMBER B ON(A.MEM_ID = B.MEM_ID)
   INNER JOIN PROD C ON(A.PROD_ID = C.PROD_ID)
   WHERE A.CART_NO LIKE '202007%'
   GROUP BY A.MEM_ID, B.MEM_NAME
   
(일반조인)
  SELECT A.MEM_ID AS 회원번호, 
         B.MEM_NAME AS 회원명, 
         SUM(A.CART_QTY) AS 구매수량합계, 
         TO_CHAR(SUM(A.CART_QTY * C.PROD_PRICE),'99,999,999') AS 구매금액합계
    FROM CART A, MEMBER B, PROD C
   WHERE A.MEM_ID = B.MEM_ID
     AND A.PROD_ID = C.PROD_ID 
     AND SUBSTR(A.CART_NO,1,6) = '202007'
   GROUP BY A.MEM_ID, B.MEM_NAME
   
 7) 2020년 분류별 매출현황을 조회하시오
    Alias는 분류코드, 분류명, 매출수량, 매출금액
