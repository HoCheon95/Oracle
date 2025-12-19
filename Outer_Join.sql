2020-1218-02)외부조인
 - 조인에 참여하는 테이블 중 자료의 종류가 많은 쪽을 기준으로 적은 쪽에 NULL 값의 행을 삽입하여
   자료의 종류를 일치 시킨 후 조인을 수행
   
사용형식(일반 외부조인))
  SELECT 컬럼lise
    FROM 테이블1 [별칭1], 테이블2 [별칭2], ...
   WHERE 별칭1.컬럼명(+)=별칭2.컬럼명 -- 테이블1의 자료 종류 < 테이블2의 자료 종류
 [주의 사항]
  - 일반 외부조인에서 조건이 복수개가 필요한 경우 모두 외부조인 연산자 '(+)'를 사용해야 함
  - 조인조건 기술시 연산자 양쪽 모두에 '(+)'를 사용할 수 없음(WHERE A(+)=B(+)는 허용되지 않음)
  - 3개 이상의 테이블이 외부조인 되는 경우 하나의 테이블이 두테이블과 동시에 외부조인 될 수 없다.
    (A, B, C 테이블이 사용된 경우 WHERE A(+) = B AND A(+) = C 는 허용되지 않음)
  - 일반조건이 기술되면 외부조인 결과가 내부조인 결과로 변환됨 => 해결방법으로
    ANSI 외부조인 or 서브쿼리를 사용해야 함
  - 복수개의 테이블에 동시 존재하는 컬럼을 SELECT 절에서 출력하는 경우 많은쪽 테이블의 컬럼을 
    사용해야 하며, COUNT(*)는 COUNT(컬럼명)형식으로 사용해야함

사용형식(ANSI 외부조인))
  SELECT 컬럼lise
    FROM 테이블1 [별칭1]
  [RIGHT|LEFT|FULL] OUTER JOIN 테이블2 [별칭2] ON(조인조건 [AND 일반조건])
  [RIGHT|LEFT|FULL] OUTER JOIN 테이블3 [별칭3] ON(조인조건 [AND 일반조건])
           :
  [WHERE 일반조건]
   - 테이블1과 테이블2는 반드시 직접 조인 되어야 함
   - 테이블1과 테이블2의 조인 결과와 테이블3이 조인됨
   - FROM 절 쪽에 기술된 테이블의 내용이 OUTER JOIN 다음에 기술된 테이블의 내용보다
     많을 때 : LEFT, 적을 때 : RIGHT, 양쪽 모두 부족할 때 : FULL 을 사용함
   - WHERE 절이 사용되면 내부조인 결과로 변형됨

사용예)상품테이블에서 모든 분류별 상품의 수를 조회하시오.
      출력은 분류코드, 분류명, 상품의 수
(일반 외부조인)
  SELECT COUNT(DISTINCT LPROD_GU)
    FROM PROD;
  SELECT COUNT(*)
    FROM LPROD;

  SELECT A.LPROD_GU AS 분류코드, 
         A.LPROD_NAME AS 분류명, 
         COUNT(B.PROD_ID) AS "상품의 수" -- COUNT *사용금지 , 해당기본 컬럼 사용
    FROM LPROD A, PROD B
   WHERE A.LPROD_GU=B.LPROD_GU(+)
   GROUP BY A.LPROD_GU, A.LPROD_NAME

(ANSI 외부조인)
  SELECT A.LPROD_GU AS 분류코드, 
         A.LPROD_NAME AS 분류명, 
         COUNT(B.PROD_ID) AS "상품의 수" -- COUNT *사용금지 , 해당기본 컬럼 사용
    FROM LPROD A
    LEFT OUTER JOIN PROD B ON(A.LPROD_GU=B.LPROD_GU)
   GROUP BY A.LPROD_GU, A.LPROD_NAME

사용예)HR계정에서 모든 부서별 사원의 수를 조회하시오.
      출력은 부서번호, 부서명, 사원의 수
(일반 외부 조인 => 사용할 수 없음)
  SELECT A.DEPARTMENT_ID AS 부서번호, 
         A.DEPARTMENT_NAME AS 부서명, 
         COUNT(EMPLOYEE_ID) AS "사원의 수"
    FROM HR.DEPARTMENTS A, HR.EMPLOYEES B
   WHERE A.DEPARTMENT_ID(+)=B.DEPARTMENT_ID(+)
   GROUP BY A.DEPARTMENT_ID, A.DEPARTMENT_NAME
   ORDER BY 1;

(ANSI 외부조인)
  SELECT A.DEPARTMENT_ID AS 부서번호, 
         A.DEPARTMENT_NAME AS 부서명, 
         COUNT(EMPLOYEE_ID) AS "사원의 수"
    FROM HR.DEPARTMENTS A
    FULL OUTER JOIN HR.EMPLOYEES B ON(A.DEPARTMENT_ID=B.DEPARTMENT_ID)
   GROUP BY A.DEPARTMENT_ID, A.DEPARTMENT_NAME
   ORDER BY 1;

사용예) 2020년 1월 모든 상품별 매입수량을 조회하시오.(상품번호, 상품명, 매입수량합계)
      (일반조건) (외부)(집계)
(일반 외부 조인)
  SELECT B.PROD_ID AS 상품번호, 
         B.PROD_NAME AS 상품명, 
         SUM(A.BUY_QTY) AS 매입수량합계
    FROM BUYPROD A, PROD B
   WHERE A.PROD_ID(+)=B.PROD_ID
     AND A.BUY_DATE BETWEEN '20200101' AND '20200131'
   GROUP BY B.PROD_ID, B.PROD_NAME
   ORDER BY 1;

(ANSI JOIN)
  SELECT B.PROD_ID AS 상품번호, 
         B.PROD_NAME AS 상품명, 
         NVL(SUM(A.BUY_QTY),0) AS 매입수량합계
    FROM BUYPROD A
   RIGHT OUTER JOIN PROD B ON(A.PROD_ID=B.PROD_ID AND 
         A.BUY_DATE BETWEEN '20200101' AND '20200131')
 --  WHERE A.BUY_DATE BETWEEN '20200101' AND '20200131'
   GROUP BY B.PROD_ID, B.PROD_NAME
   ORDER BY 1;

(SUBQUERY + 외부조인)
(메인쿼리)
  SELECT 상품번호, 상품명, 매입수량합계
    FROM PROD A,
         (2020년 1월 상품별 매입수량합계) B
   WHERE A.PROD_ID=B.상품코드(+)
   ORDER BY 1;
   
(서브쿼리:2020년 1월 상품별 매입수량합계)
  SELECT PROD_ID,
         SUM(BUY_QTY) AS BSUM
    FROM BUYPROD
   WHERE BUY_DATE BETWEEN '20200101' AND '20200131'
   GROUP BY PROD_ID
(결합)
  SELECT A.PROD_ID AS 상품번호, 
         A.PROD_NAME AS 상품명, 
         NVL(B.BSUM,0) AS 매입수량합계
    FROM PROD A,
         (SELECT PROD_ID, SUM(BUY_QTY) AS BSUM
            FROM BUYPROD
           WHERE BUY_DATE BETWEEN '20200101' AND '20200131'
           GROUP BY PROD_ID) B
   WHERE A.PROD_ID=B.PROD_ID(+)
   ORDER BY 1;
--
사용예) 2020년 6월 모든 상품별 매입수량과 매출수량을 조회하시오.
      Alias는 상품코드, 상품명, 매입수량합계, 매출수량합계
(2020년 6월 모든 상품별 매입수량)
  SELECT A.PROD_ID AS 상품코드, 
         A.PROD_NAME AS 상품명, 
         NVL(SUM(B.BUY_QTY),0) AS 매입수량합계
    FROM PROD A
    LEFT OUTER JOIN BUYPROD B ON(A.PROD_ID=B.PROD_ID AND
               B.BUY_DATE BETWEEN '20200601' AND '20200630')
   GROUP BY A.PROD_ID, A.PROD_NAME
   ORDER BY 1;
   
(2020년 6월 모든 상품별 매출수량)
  SELECT B.PROD_ID AS 상품코드, 
         B.PROD_NAME AS 상품명, 
         NVL(SUM(CART_QTY),0) AS 매출수량합계
    FROM CART A
   RIGHT OUTER JOIN PROD B ON(A.PROD_ID=B.PROD_ID AND
         A.CART_NO LIKE '202006%')
   GROUP BY B.PROD_ID, B.PROD_NAME
   ORDER BY 1;

(매입/매출을 동시처리)
  SELECT A.PROD_ID AS 상품코드, 
         A.PROD_NAME AS 상품명, 
         NVL(SUM(B.BUY_QTY),0) AS 매입수량합계, 
         NVL(SUM(C.CART_QTY),0) AS 매출수량합계
    FROM PROD A, BUYPROD B, CART C
   WHERE A.PROD_ID=B.PROD_ID(+)
     AND A.PROD_ID=C.PROD_ID(+)
     AND B.BUY_DATE(+) BETWEEN '20200601' AND '20200630'
     AND C.CART_NO(+) LIKE '202006%'
--     AND SUBSTR(C.CART_NO,1,6)(+) = '202006' -- 외부연산자 사용시 함수사용하면 오류발생
   GROUP BY A.PROD_ID, A.PROD_NAME
   ORDER BY 1;

(ANSI JOIN)
  SELECT A.PROD_ID AS 상품코드, 
         A.PROD_NAME AS 상품명, 
         NVL(SUM(B.BUY_QTY),0) AS 매입수량합계, 
         NVL(SUM(C.CART_QTY),0) AS 매출수량합계
    FROM PROD A
    LEFT OUTER JOIN BUYPROD B ON(A.PROD_ID = B.PROD_ID AND
         B.BUY_DATE BETWEEN '20200601' AND '20200630')
    LEFT OUTER JOIN CART C ON(A.PROD_ID = C.PROD_ID AND 
         C.CART_NO LIKE '202006%')
   GROUP BY A.PROD_ID, A.PROD_NAME
   ORDER BY 1;

(SUBQUERY)   
 메인쿼리 : 상품코드, 상품명, 매입수량합계, 매출수량합계
  SELECT 상품코드, 상품명, 매입수량합계, 매출수량합계
    FROM PROD A,
         (2020년 6월 상품별 매입수량합계 : 내부조인) B,
         (2020년 6월 상품별 매출수량합계 : 내부조인) C
   WHERE A.PROD_ID=B.PROD_ID(+)
     AND A.PROD_ID=C.PROD_ID(+)
   ORDER BY 1;

(2020년 6월 상품별 매입수량합계 : 내부조인)   
  SELECT PROD_ID, SUM(BUY_QTY) AS BSUM
    FROM BUYPROD
   WHERE BUY_DATE BETWEEN '20200101' AND '20201231'
   GROUP BY PROD_ID
   
(2020년 6월 상품별 매출수량합계 : 내부조인)   
  SELECT PROD_ID, SUM(CART_QTY) AS CSUM
    FROM CART
   WHERE CART_NO LIKE '2020%'
   GROUP BY PROD_ID

(결합)
  SELECT A.PROD_ID AS 상품코드, 
         A.PROD_NAME AS 상품명, 
         NVL(B.BSUM,0) AS 매입수량합계, 
         NVL(C.CSUM,0)매출수량합계
    FROM PROD A,
         (SELECT PROD_ID, SUM(BUY_QTY) AS BSUM
            FROM BUYPROD
           WHERE BUY_DATE BETWEEN '20200101' AND '20201231'
           GROUP BY PROD_ID) B,
         (SELECT PROD_ID, SUM(CART_QTY) AS CSUM
            FROM CART
           WHERE CART_NO LIKE '2020%'
           GROUP BY PROD_ID) C
   WHERE A.PROD_ID=B.PROD_ID(+)
     AND A.PROD_ID=C.PROD_ID(+)
   ORDER BY 1;

(ANSI OUTER JOIN)
  SELECT A.PROD_ID AS 상품코드, 
         A.PROD_NAME AS 상품명, 
         NVL(B.BSUM,0) AS 매입수량합계, 
         NVL(C.CSUM,0)매출수량합계
    FROM PROD A
    LEFT OUTER JOIN (SELECT PROD_ID, SUM(BUY_QTY) AS BSUM
                       FROM BUYPROD
                      WHERE BUY_DATE BETWEEN '20200101' AND '20201231'
                      GROUP BY PROD_ID) B ON(A.PROD_ID=B.PROD_ID)
    LEFT OUTER JOIN (SELECT PROD_ID, SUM(CART_QTY) AS CSUM
                       FROM CART
                      WHERE CART_NO LIKE '2020%'
                      GROUP BY PROD_ID) C ON(A.PROD_ID=C.PROD_ID)
   ORDER BY 1;            