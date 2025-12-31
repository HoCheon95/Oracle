2025-1224-04) INDEX
 - 자료 검색의 효율성을 증대 시키기위한 객체
 - SELECT 문과 INSERT 문 혹은 UPDATE 문에서 WHERE 절에 사용하게 되는 경우에 인덱스를 사용
 - 또한 SELECT 한 데이터를 SORT(ORDER BY) 하거나 GROUP BY 를 사용하여
   그룹별로 묶을 때에도 인덱스를 사용하게 되면 속도향상에 도움
 - DBMS의 부하를 줄여 전체 성능을 향상 시킨다.
 - 단점
  · 인덱스를 사용하게 되면 인덱스를 만드는데 많은 저장 공간과 시간이 소요된다.
  · 이는 처음만드는 경우에만 적용되는 것이 아니라 데이터가 지속적으로
    삽입, 수정, 삭제의 과정을 거칠 때마다 요구되는 사항이다.
  · 데이터를 수정하는데 있어서 더 많은 시간이 소요된다.
  · 따라서 인덱스는 꼭 필요한 곳에만 적절하게 사용
 - 인덱스의 분류
  · Unique / Non-Unique
  · Single / Composite
  · 자동 / 수동 Index
  · Normal Index( B-tree Index ) / Bitmap Index / Function-based Normal Index
사용형식)
  CREATE [UNIQUE|BITMAP] INDEX 인덱스명 ON 테이블명 (컬럼1[, 컬럼2, ...][ASC|DESC]

사용예) CART 테이블과 REMAIN 테이블을 Cartesian Product 하여 
       테이블 tb1_idx로 저장하시오
  CREATE TABLE tbl_idx(R_YEAR, R_PID, RJ_00, R_I, R_O, RJ_99, R_DATE,
                       C_MID, C_NO, C_PID, C_QTY) AS
    SELECT * FROM REMAIN CROSS JOIN CART;
  COMMIT;
  SELECT COUNT(*) FROM TBL_IDX;

사용예) 테이블 TBL_IDX에서 R_PID가 'P201000005'이고 C_NO가 '2020041000001'인 
       자료를 조회하시오
  SELECT * 
    FROM TBL_IDX
   WHERE R_PID = 'P201000005' 
     AND C_NO = '2020041000001';

  인덱스 생성)
  CREATE INDEX idx_temp ON TBL_IDX(R_PID, C_NO);
 
 
사용예) CART 테이블에서 장바구니번호와 상품코드를 결합한 후 13번째부터 5글자로 인덱스를 구성하시오.
  CREATE INDEX idx_cart_no ON CART(SUBSTR(CART_NO||PROD_ID,13,5));
  
사용에) CART_NO와 PROD_ID의 결합 데이터 중 '2P302' 자료를 검색하시오
  SELECT * FROM CART
   WHERE SUBSTR(CART_NO||PROD_ID,13,5)='2P302';

  DROP INDEX idx_cart_no;
  COMMIT;

** INDEX 의 재구성
  - 대상 테이블의 데이터 변경이 많이 발생된 경우
  - 테이블의 저장 위치가 바뀐 경우(TABLESPACE 가 바뀐 경우)
 사용형식)
  ALTER INDE 인덱스명 REBUILD;
 