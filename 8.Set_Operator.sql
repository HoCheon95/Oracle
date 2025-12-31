2025-1219-02)집합 연산자
 - 서로 다른 QUERY 의 결과 집합 간의 합집합, 교집합, 차집합 연산
 - 일부 JOIN 연산을 대신 할 수 있음
 - UNION, UNION ALL, INTERSECT, MINUS 연산자가 제공됨
 - 집합연산자 사용 조건
  · 모든 SELECT 문의 SELECT 절에 기술되는 컬럼의 수와 순서, 타입은 동일해야 함
  · 위 조건을 만족하더라도 내요잉 다르면(저장된 자료가 다르면) 서로 다른 데이터로 취급
  · 컬럼의 별칭은 첫 번째 SELECT 무의 별칭만 적용
  · ORDER BY 절은 맨 마지막 SELECT 문에서만 사용 가능 함

1. 합집합 (UNION, UNION ALL)
 - 각각의 SELECT 문에서 조회된 값을 모두 포함하는 결과를 반환
 - 조회된 값 중 중복 값을 1번만 조회(UNION), 중복된 횟수만큼 중복조회(UNION ALL)
 
사용예)
회원 테이블에서 직업이 '주부'인 회원과 마일리지가 3000이상인 회원들의
회원번호, 회원명, 직업, 마일리지를 조회하시오
  SELECT MEM_ID AS 회원번호, 
         MEM_NAME AS 회원명,
         MEM_JOB AS 직업, 
         MEM_MILEAGE AS 마일리지
    FROM MEMBER
   WHERE MEM_JOB='주부'
   UNION
  SELECT MEM_ID,MEM_NAME,MEM_JOB,MEM_MILEAGE
    FROM MEMBER
   WHERE MEM_MILEAGE >= 2000
   ORDER BY 4 DESC

** 구조가 다른 여러 테이블에서 동일한 형태의 자료를 추출
사용예)
  CREATE TABLE BUDGET(
    PERIOD CHAR(6),
    BUDGET_AMT NUMBER(5));

  CREATE TABLE SALES(
    PERIOD CHAR(6),
    SALE_AMT NUMBER(5));
  
  INSERT INTO BUDGET VALUES('202501', 1500);  
  INSERT INTO BUDGET VALUES('202502', 1300);
  INSERT INTO BUDGET VALUES('202503', 2500);
  INSERT INTO BUDGET VALUES('202504', 2000);
  INSERT INTO BUDGET VALUES('202505', 3000);
  
  INSERT INTO SALES VALUES('202501', 1200);
  INSERT INTO SALES VALUES('202502', 1300);
  INSERT INTO SALES VALUES('202503', 2200);
  INSERT INTO SALES VALUES('202504', 2800);
  INSERT INTO SALES VALUES('202505', 3200);
  
  SELECT PERIOD AS "기간",
         BUDGET_AMT AS "계획",
         0 AS "실적"
    FROM BUDGET
  UNION
  SELECT PERIOD, 0, SALE_AMT 
    FROM SALES;
    
(해결)
  SELECT PERIOD AS 기간, 
         SUM(BUDGET_AMT) AS 계획, 
         SUM(SALE_AMT) AS 실적, 
         LPAD(ROUND(SUM(SALE_AMT)/SUM(BUDGET_AMT) * 100)||'%',6) AS 달성률
    FROM (SELECT PERIOD, BUDGET_AMT, 0 AS "SALE_AMT"
            FROM BUDGET
           UNION
          SELECT PERIOD, 0, SALE_AMT 
            FROM SALES)
   GROUP BY PERIOD
   ORDER BY 1;

2. 교집합(INTERSECT)
 - 각 각의 SELECT 문에서 조회된 값 중 공통되는 부분을 반환함
 - EXISTS 연산자로 구현가능

사용예) 2020년 6월과 7월에 모두 판매된 상품의 상품코드, 상품명, 판매가를 조회하시오
(2020년 6월에 판매된 상품의 상품코드, 상품명, 판매가)
  SELECT DISTINCT A.PROD_ID AS 상품코드, 
         B.PROD_NAME AS 상품명, 
         B.PROD_PRICE AS 판매가
    FROM CART A
   INNER JOIN PROD B ON(A.PROD_ID=B.PROD_ID)
   WHERE A.CART_NO LIKE '202006%'
   
(2020년 7월에 판매된 상품의 상품코드, 상품명, 판매가)

  SELECT DISTINCT A.PROD_ID, B.PROD_NAME, B.PROD_PRICE
    FROM CART A
   INNER JOIN PROD B ON(A.PROD_ID=B.PROD_ID)
   WHERE A.CART_NO LIKE '202007%'

(INTERSECT)   
  SELECT DISTINCT A.PROD_ID AS 상품코드, 
         B.PROD_NAME AS 상품명, 
         B.PROD_PRICE AS 판매가
    FROM CART A
   INNER JOIN PROD B ON(A.PROD_ID=B.PROD_ID)
   WHERE A.CART_NO LIKE '202006%'
   INTERSECT
  SELECT DISTINCT A.PROD_ID, B.PROD_NAME, B.PROD_PRICE
    FROM CART A
   INNER JOIN PROD B ON(A.PROD_ID=B.PROD_ID)
   WHERE A.CART_NO LIKE '202007%'   
   ORDER BY 1;

(EXISTS 연산자 사용)
  SELECT DISTINCT A.PROD_ID AS 상품코드, 
         B.PROD_NAME AS 상품명, 
         B.PROD_PRICE AS 판매가
    FROM CART A
   INNER JOIN PROD B ON(A.PROD_ID=B.PROD_ID)
   WHERE A.CART_NO LIKE '202006%'
     AND EXISTS(SELECT 1
                  FROM CART C
                 WHERE C.CART_NO LIKE '202007%'
                   AND C.PROD_ID=A.PROD_ID);
                   
3. 차집합(MINUS)
 - 앞서 기술된 SELECT 문 결과에서 뒤에 기술된 SELECT 문의 결과를 뺀 결과를 반환
 - MINUS 연산자로 왼쪽, 오른쪽에 기술하는 순서에 따라 결과 값이 달라짐
 - NOT EXISTS 연산자로 구현가능


 사용예) 2020년 6월과 7월에 판매된 상품 중에 6월에만 판매된 상품의
       상품코드, 상품명, 판매가를 조회하시오
(2020년 6월에 판매된 상품의 상품코드, 상품명, 판매가)
  SELECT DISTINCT A.PROD_ID AS 상품코드, 
         B.PROD_NAME AS 상품명, 
         B.PROD_PRICE AS 판매가
    FROM CART A, PROD B
   WHERE A.PROD_ID=B.PROD_ID
     AND SUBSTR(A.CART_NO,1,6) = '202006'
  MINUS
--(2020년 7월에 판매된 상품의 상품코드, 상품명, 판매가)
  SELECT DISTINCT A.PROD_ID, B.PROD_NAME, B.PROD_PRICE
    FROM CART A, PROD B
   WHERE A.PROD_ID=B.PROD_ID
     AND SUBSTR(A.CART_NO,1,6) = '202007';

(EXISTS 연산자)
  SELECT DISTINCT A.PROD_ID AS 상품코드, 
         B.PROD_NAME AS 상품명, 
         B.PROD_PRICE AS 판매가
    FROM CART A, PROD B
   WHERE A.PROD_ID=B.PROD_ID
     AND SUBSTR(A.CART_NO,1,6) = '202006'
     AND NOT EXISTS(SELECT DISTINCT A.PROD_ID
                      FROM CART
                     WHERE A.PROD_ID=PROD_ID
                       AND SUBSTR(CART_NO,1,6) = '202007')