2020-1212-03)집계함수
 - 주어진 자료를 특정칼럼을 기준으로 그룹화 하고 각 그룹에서 필요한 집계결과를 반환 하는 함수 
 - SUM, AVG, COUNT, MAX, MIN
사용형식
 SELECT 컬럼, ···,
        SUM(col | expr) | AVG(col | expr) COUNT(* | col) |
        MAX(col | expr) | MIN(col | expr)
   FROM 테이블명
 [WHERE 조건] -- 일반조건
 [GROUP BY 컬럼명[, 컬럼명, ...]]
[HAVING 조건] -- 그룹함수에 조건
 [ORDER BY 컬럼명 | 컬럼인덱스 [ASC | DESC]][, 컬럼명 | 컬럼인덱스[ASC | DESC], ···]];
  - SELECT 절에 집계함수만 사용된 경우 GROUP BY 절 생략(테이블전체가 하나의 그룹)
  - SELECT 절에 집계함수가 아닌 일반컬럼이 기술되고 집계함수가 사용되면
    반드시 GROUP BY 절이 기술되어야 하며 SELECT 절에 사용된 일반컬럼은 GROUP BY 절에
    모두 기술해야 함
  - 집계함수에 조건이 부여되는 경우 HAVING 절에 사용해야 함
  - 집계함수는 집계함수를 포함할 수 없다. 단, 일반함수는 집계함수를 포함할 수 있고,
    반대로 집계함수도 일반함수를 포함할 수 있다.

사용예)
 1) 회원테이블에서 모든 회원들의 마일리지합계와, 평균마일리지, 인원수, 최대마일리지, 최소마일리지를 구하시오.
 SELECT SUM(MEM_MILEAGE) AS 마일리지합계, 
        ROUND(AVG(MEM_MILEAGE)) AS 평균마일리지, 
        COUNT(*) AS 인원수, 
        MAX(MEM_MILEAGE) AS 최대마일리지, 
        MIN(MEM_MILEAGE) AS 최소마일리지
   FROM MEMBER;
   
 2) 상품테이블에서 상품의 수, 최대판매가, 최소판매가를 구하시오.
 SELECT COUNT(*) AS 상품의수,
        MAX(PROD_PRICE) AS 최대판매가,
        MIN(PROD_PRICE) AS 최소판매가
   FROM PROD;
   
 3) 2020년 4월 판매수량 합계를 구하시오.
 SELECT '2020년 4월' AS 기간,
        SUM(CART_QTY) AS "판매수량 합계"
   FROM CART
  WHERE CART_NO LIKE '202004%'
  
 4) 사원테이블에서 부서별 평균 급여와 인원수를 조회하시오.
 SELECT DEPARTMENT_ID AS 부서번호, 
        ROUND(AVG(SALARY)) AS 평균급여, 
        COUNT(*) AS 인원수
   FROM HR.EMPLOYEES
  GROUP BY DEPARTMENT_ID
  ORDER BY 1;
 
 5) 상품테이블에서 분류별, 상품의수, 평균판매가를 조회하시오.
 SELECT LPROD_GU AS 분류,
        COUNT(*) AS 상품의수,
        ROUND(AVG(PROD_PRICE)) AS 평균판매가
   FROM PROD
  GROUP BY LPROD_GU
  ORDER BY 1;
   
 6) 매입테이블에서 2020년 월별 매입수량합계를 조회하시오.
 SELECT EXTRACT(MONTH FROM BUY_DATE) AS "2020년 월별", 
        SUM(BUY_QTY) AS 매입수량합계
  FROM BUYPROD
 GROUP BY EXTRACT(MONTH FROM BUY_DATE)
 ORDER BY 1;
 
 7) 매입테이블에서 2020년 상품별 매입수량합계를 조회하시오.
 SELECT PROD_ID AS 상품별, 
        SUM(BUY_QTY) AS 매입수량합계
   FROM BUYPROD
  WHERE EXTRACT(YEAR FROM BUY_DATE) = 2020 -- 날짜에서 년도를 출력하니 EXTRACT 사용
  GROUP BY PROD_ID
  ORDER BY 1;
  
 8) 매출테이블에서 2020년 월별, 상품별 판매수량합계를 조회하시오.
 SELECT SUBSTR(CART_NO,5,2) AS 월, 
        PROD_ID AS 상품, 
        SUM(CART_QTY) AS 판매수량합계
   FROM CART
  WHERE SUBSTR(CART_NO,1,4) = '2020' -- 문자열에서 4글자를 출력하니 SUBSTR 사용
  GROUP BY SUBSTR(CART_NO,5,2), PROD_ID
  ORDER BY 1;
  
 8-1) 매출테이블에서 2020년 월별, 상품별, 판매수량를 구하고 
      판매수량 10개 이상인 상품만 조회시오.
 SELECT SUBSTR(CART_NO,5,2) AS 월, 
        PROD_ID AS 상품, 
        SUM(CART_QTY) AS 판매수량
   FROM CART
  WHERE SUBSTR(CART_NO,1,4) = '2020'
  GROUP BY SUBSTR(CART_NO,5,2), PROD_ID
 HAVING SUM(CART_QTY) >= 10;    -- 집계함수는 WHERE에 사용할 수 없다.
 
 8-2) 매출테이블에서 2020년 월별, 상품별, 판매수량합계를 구하고 판매수량합계가
      가장 많은 자료만 출력하시오
 SELECT SUBSTR(CART_NO,5,2) AS 월, 
        PROD_ID AS 상품, 
        SUM(CART_QTY) AS 판매수량
   FROM CART
  WHERE SUBSTR(CART_NO,1,4) = '2020'
    AND ROWNUM = 1
  GROUP BY SUBSTR(CART_NO,5,2), PROD_ID
  ORDER BY 3 DESC;
-------------------------------------------
 SELECT MON AS 월, PROD_ID AS 상품코드, CSUM AS 판매수량
   FROM (SELECT SUBSTR(CART_NO,5,2) AS MON, PROD_ID, SUM(CART_QTY) AS CSUM
           FROM CART
          WHERE SUBSTR(CART_NO,1,4) = '2020'
          GROUP BY SUBSTR(CART_NO,5,2), PROD_ID
          ORDER BY 3 DESC)
  WHERE ROWNUM=1;

** FETCH FIRST 1 ROW ONLY 명령
 - 현재 위치에서 가장 위에 존재하는 한 행만 반환
 - 서브쿼리를 대치할 수 있음
 - ORDER BY 절 다음에 기술
 
 SELECT SUBSTR(CART_NO,5,2) AS 월, 
        PROD_ID AS 상품, 
        SUM(CART_QTY) AS 판매수량
   FROM CART
  WHERE SUBSTR(CART_NO,1,4) = '2020'
  GROUP BY SUBSTR(CART_NO,5,2), PROD_ID
  ORDER BY 3 DESC
  FETCH FIRST 5 ROW ONLY; -- FETCH[읽어오다] 처음 한줄만 꺼내오다. ****************
 
 9) 사원테이블에서 부서별, 년도별 입사한 사원수를 조회하시오.
 SELECT DEPARTMENT_ID AS 부서, 
        EXTRACT(YEAR FROM HIRE_DATE) AS 입사년도, 
        COUNT(*) AS 사원수
   FROM HR.EMPLOYEES
  GROUP BY DEPARTMENT_ID, EXTRACT(YEAR FROM HIRE_DATE)
  ORDER BY 1, 2;    
  
10) 회원테이블에서 성별 평균마일리지를 조회하시오.
 SELECT CASE WHEN SUBSTR(MEM_REGNO2,1,1) IN ('1','3') THEN '남성회원' 
        ELSE '여성회원' END AS 비고, 
        ROUND(AVG(MEM_MILEAGE)) AS 평균마일리지
   FROM MEMBER
  GROUP BY CASE WHEN SUBSTR(MEM_REGNO2,1,1) IN ('1','3') THEN '남성회원' 
        ELSE '여성회원' END;
  
11) 회원테이블에서 년령대별 회원수와 평균 마일리지를 조회하시오.
 SELECT TRUNC((EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR))/10)*10 AS 년령대,  -- 년령대 구하는 방법
        COUNT(*) AS 회원수, 
        AVG(MEM_MILEAGE) AS 평균마일리지
   FROM MEMBER
  GROUP BY TRUNC((EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR))/10)
  ORDER BY 1;

12) 회원테이블에서 거주지별 평균마일리지와 회원수를 조회하시오.
 SELECT SUBSTR(MEM_ADD1,1,2) AS 거주지, 
        ROUND(AVG(MEM_MILEAGE)) AS 평균마일리지, 
        COUNT(*) AS 회원수
   FROM MEMBER
  GROUP BY SUBSTR(MEM_ADD1,1,2);