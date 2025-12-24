2025-1224-01)VIEW 객체
 - 가상의 테이블
 - 기존의 테이블이나 뷰 객체를 이용하여 생성됨
 - VIEW 를 사용해야 하는경우
  · 필요한 정보가 한 개의 테이블에 있지 않고, 여러 개의 테이블에 분산되어 있는경우
  · 테이블에 들어있는 자료의 일부분만 필요하고 자료의 전체 row 나 column 이 필요하지 않은 경우
  · 특정 자료에 대한 접근을 제한하고자 할 경우(보안)
--ㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ
생성형식)
  CREATE [OR REPLACE] [FORCE|NOFORCE] VIEW 뷰이름[(컬럼list)]
  AS
    SELECT 문
    [WITH READ ONLY]
    [WITH CHECK OPTION];
--ㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ
  - 'OR REPLACE' : 이미 같은 이름의 뷰가 존재하면 현재 생성되는 뷰로 대치
  - 'FORCE|NOFORCE' : 기준테이블이 없어도 뷰를 생성(FORCE),
                      기준테이블이 없으면 뷰를 생성하지 않음(NOFORCE)
  - '컬럼list' : 뷰에서 사용할 컬럼명.
                생략하면 SELECT 절의 별칭이 뷰의 컬럼명이되고,
                별칭이 없으면 SELECT 절의 컬럼명이 뷰의 컬럼명이됨
  - 'WITH READ ONLY' : 읽기전용뷰 생성(뷰의 값을 변경하지 못함, 
                       원본테이블의 내용은 뷰와 상관 없이 언제나 변경 가능함)
  - 'WITH CHECK OPTION' : SELECT 문의 WHERE 조건을 위배하는 값으로 뷰의 값을 변경하지 못함.
--ㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ
사용예) 회원테이블에서 마일리지가 3000이상인 회원의 회원번호, 회원명, 마일리지로 뷰를 생성하시오.
  CREATE OR REPLACE VIEW VIP_MEMBER(MID, NAME, MILEAGE)
  AS
    SELECT MEM_ID AS 회원번호, MEM_NAME AS 회원명, MEM_MILEAGE AS 마일리지
      FROM MEMBER
     WHERE MEM_MILEAGE >= 3000;

  SELECT * FROM VIP_MEMBER;
--ㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ
사용예)
 1) 뷰(VIP_MAMBER)에서 'C001' 신용환 고객의 마일리지를 100으로 변경하시오
  UPDATE VIP_MEMBER
     SET MILEAGE = 100
   WHERE UPPER(MID) = 'C001'; -- UPPER 컬럼명의 값이 소문자 일때 내가 쓴 값이 대문자일경우
  
  SELECT MEM_ID, MEM_NAME, MEM_MILEAGE
    FROM MEMBER
   WHERE UPPER(MEM_ID) = 'C001';

 2) MEMBER 테이블에서 'c001' 신용환 고객의 마일리지를 100에서 7300으로 변경하시오
  UPDATE MEMBER
     SET MEM_MILEAGE = 7300
   WHERE MEM_ID = 'c001';
--ㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ
사용예) 회원테이블에서 마일리지가 5000이상인 회원의 회원번호, 회원명, 마일리지로 뷰를 생성하시오
  CREATE OR REPLACE VIEW VIP_MEMBER
  AS
    SELECT MEM_ID AS 회원번호, MEM_NAME AS 회원명, MEM_MILEAGE AS 마일리지
      FROM MEMBER
     WHERE MEM_MILEAGE >= 5000
     WITH READ ONLY;

 3) 뷰(VIP_MAMBER)에서 'c001' 신용환 고객의 마일리지를 4000으로 변경하시오
  UPDATE VIP_MEMBER
     SET 마일리지 = 4000
   WHERE 회원번호 = 'c001';
 
 4) MEMBER 테이블에서 'c001' 신용환 고객의 마일리지를 7300에서 4000으로 변경하시오
  UPDATE MEMBER
     SET MEM_MILEAGE = 4000
   WHERE MEM_ID = 'c001';

  SELECT * FROM VIP_MEMBER;
--ㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ
사용예)회원테이블에서 마일리지가 3000이상인 회원의 회원번호, 회원명, 마일리지로 
      뷰를 WITH CHECK OPTION 사용하여 생성하시오
  CREATE OR REPLACE VIEW VIP_MEMBER
  AS
    SELECT MEM_ID, MEM_NAME, MEM_MILEAGE
      FROM MEMBER
     WHERE MEM_MILEAGE >= 3000
      WITH CHECK OPTION;

 5) 뷰(VIP_MAMBER)에서 'c001' 신용환 고객의 마일리지를 1400으로 변경하시오
-- 위에서 마일리지가 3000이상인 조건이 생김
-- 뷰의 WITH CHECK OPTION의 조건에 위배 됩니다
  UPDATE VIP_MEMBER
     SET MEM_MILEAGE = 1400
   WHERE MEM_ID = 'c001';

 6) 뷰(VIP_MAMBER)에서 'c001' 신용환 고객의 마일리지를 7400으로 변경하시오
  UPDATE VIP_MEMBER
     SET MEM_MILEAGE = 7400
   WHERE MEM_ID = 'c001';

** VIEW의 삭제
  DROP VIEW 뷰이름;
  DROP VIEW VIP_MEMBER;