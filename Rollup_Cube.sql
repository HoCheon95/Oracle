2020-1215-01) ROLLUP 과 CUBE
  - GROUP BY 절에서 사용하여 다양한 집계결과를 반환
 1) ROLLUP
  - 레벨별 집계결과를 반환
 사용형식)
  GROUP BY [컬럼명, ...,] ROLLUP(컬럼1, 컬럼2, ...컬럼n) [컬럼명,...]
  - ROLLUP 절 안의 모든 컬럼을 적용한 집계(가장 하위레벨)를 반환한 뒤
    컬럼n부터 하나씩 제거한 집계를 반환하며, 마지막으로 모든 컬럼을
    삭제한 집계(전체집계)를 반환
  - ROLLUP 절 안에 기술된 컬럼의 수가 n개이면 n + 1 종류의 집계 반환
  - ROLLUP 절 앞 또는 뒤에 컬럼명, ...,들이 기술되며 부분 ROLLUP 이라하며
    전체집계를 반환하지 않음(ROLLUP 밖의 컬럼은 상수처럼 GROUP BY 절에 적용됨
사용예) 2020년 월별, 회원별, 상품별 구매수량 집계를 조회하시오.
(GROUP BY 절만 사용)
  SELECT SUBSTR(CART_NO,5,2) AS 월, 
         MEM_ID AS 회원번호, 
         PROD_ID AS 상품코드, 
         SUM(CART_QTY) AS 구매수량합계
    FROM CART
   WHERE CART_NO LIKE '2020%'
   GROUP BY SUBSTR(CART_NO,5,2), MEM_ID, PROD_ID
   ORDER BY 1;

(ROLLUP 절 사용)
  SELECT SUBSTR(CART_NO,5,2) AS 월, 
         MEM_ID AS 회원번호, 
         PROD_ID AS 상품코드, 
         SUM(CART_QTY) AS 구매수량합계
    FROM CART
   WHERE CART_NO LIKE '2020%'
   GROUP BY ROLLUP(SUBSTR(CART_NO,5,2), MEM_ID, PROD_ID)
   ORDER BY 1;
   
(부분 ROLLUP 절 사용) -- 전체집계가 빠짐
  SELECT SUBSTR(CART_NO,5,2) AS 월, 
         MEM_ID AS 회원번호, 
         PROD_ID AS 상품코드, 
         SUM(CART_QTY) AS 구매수량합계
    FROM CART
   WHERE CART_NO LIKE '2020%'
   GROUP BY SUBSTR(CART_NO,5,2), ROLLUP(MEM_ID, PROD_ID)
   ORDER BY 1;

 2) CUBE
  - 사용된 컬럼들로 조합할 수 있는 모든 경우의 집계결과를 반환
 사용형식)
  GROUP BY [컬럼명, ...,] CUBE(컬럼1, 컬럼2, ...컬럼n) [컬럼명,...]
  - CUBE 절 안의 컬럼들로 구성 할 수 있는 모든 경우의 집계를 반환하며,
    마지막으로 모든 컬럼을 삭제한 집계(전체집계)를 반환
  - CUBE 절 안에 기술된 컬럼의 수가 n개이면 2^n 종류의 집계 반환
  - CUBE 절 앞 또는 뒤에 컬럼명, ...,들이 기술되며 부분 CUBE 이라하며
    전체집계를 반환하지 않음(CUBE 밖의 컬럼은 상수처럼 GROUP BY 절에 적용됨
사용예) 2020년 월별, 회원별, 상품별 구매수량 집계를 조회하시오.
  SELECT SUBSTR(CART_NO,5,2) AS 월, 
         MEM_ID AS 회원번호, 
         PROD_ID AS 상품코드, 
         SUM(CART_QTY) AS 구매수량합계
    FROM CART
   WHERE CART_NO LIKE '2020%'
   GROUP BY CUBE(SUBSTR(CART_NO,5,2), MEM_ID, PROD_ID)
   ORDER BY 1;