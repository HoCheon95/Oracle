2025-1226-01) PL/SQL

1. 익명 블록
 - 이름이 부여도지 않은 블록
 - 컴파일되어 저장할 수 없음
 - 실행이 요구될 때마다 컴파일 되어야 함
 - PL/SQL 객체의 기본형을 제공
(구성)
  DECLARE
   선언영역 - 변수/상수/커서 서언
  BEGIN
   실행영역 - 비지니스 로직을 처리하기 위한 명령문과 SQL문
  [EXCEPTION WHEN OTHERS THEN
    예외처리 영역]
  END;

1)변수
 - 프로그램 개발 언어의  변수와 동일 기능
 - 스칼라 / 참조형 / COMPOSITE 변수 / BIND 변수
 (1) 스칼라 변수
   · 자료 하나만 저장하는 일반적인 변수
 (사용형식)
   변수명 [CONSTANT] 데이터타입 [NOT NULL] [:= 초기값];
   - 'CONSTANT' : 상수선언시 사용하며, 반드시 초기값이 기술되어야 함

사용예) 년도를 입력 받아 해당년도가 윤년인지 평년인지 판별하는 블록을 작성
  ACCEPT P_YEAR PROMPT '년도입력 : '--키보드로 입력 받음
  DECLARE
    L_RESULT VARCHAR2(100):= &P_YEAR; -- 출력할 것을 변수로 만드는 것을 원칙
  BEGIN
    IF(MOD(&P_YEAR,4)=0 AND MOD(&P_YEAR,100) != 0) 
       OR (MOD(&P_YEAR,400)=0) THEN
       L_RESULT:=L_RESULT||'년은 윤년입니다.';
    ELSE
       L_RESULT:=L_RESULT||'년은 평년입니다.';
    END IF;
    DBMS_OUTPUT.PUT_LINE(L_RESULT);
  END;

 (2) 참조형 변수
   · 데이터 타입이 지정된 열의 타입과 크기와 같게 선언 - 열참조형
   · 데이터 타입을 지정된 행과 같게 선언 - 행 참조형
 (사용형식)
   테이블명.컬럼명%TYPE -- 열 참조형
   테이블명%ROWTYPE -- 행 참조형

사용예)2020년 5월 매입금액이 500만원 이상인 상품의 상품코드와 상품명, 매입금액을 출력하는 
     익명블록을 작성

  DECLARE
    L_PROD_ID PROD.PROD_ID%TYPE; -- 상품코드
    L_PROD_NAME PROD.PROD_NAME%TYPE; -- 상품명
    L_AMT NUMBER:=0; -- 매입금액

    CURSOR CUR_BUYPROD_01 IS
      SELECT A.PROD_ID, B.PROD_NAME, SUM(A.BUY_QTY * B.PROD_COST)
        FROM BUYPROD A
       INNER JOIN PROD B ON(A.PROD_ID=B.PROD_ID)
       WHERE A.BUY_DATE BETWEEN TO_DATE('20200501') AND TO_DATE('20200531')
       GROUP BY A.PROD_ID, B.PROD_NAME
      HAVING SUM(A.BUY_QTY * B.PROD_COST) >=5000000;
  BEGIN
    OPEN CUR_BUYPROD_01;
    LOOP
      FETCH CUR_BUYPROD_01 INTO L_PROD_ID, L_PROD_NAME, L_AMT;
      EXIT WHEN CUR_BUYPROD_01%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE('상품코드 : '||L_PROD_ID);
      DBMS_OUTPUT.PUT_LINE('상품명 : '||L_PROD_NAME);
      DBMS_OUTPUT.PUT_LINE('매입금액 : '||TO_CHAR(L_AMT,'99,999,999'));
      DBMS_OUTPUT.PUT_LINE('-------------------------------');
    END LOOP;
      DBMS_OUTPUT.PUT_LINE('처리건수 : '||CUR_BUYPROD_01%ROWCOUNT);      
    EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('예외발생 : '||SQLERRM);
  END;

사용예) 키보드로 날짜를 입력 받아 해당 일자의 판매현황을 출력하시오
      출력은 일자, 상품코드, 판매수량, 회원번호이다
(열참조 변수 사용)
  ACCEPT P_DATE PROMPT '날짜입력 : '
  DECLARE
    L_DATE CHAR(8):=&P_DATE;
    L_PROD_ID PROD.PROD_ID%TYPE;
    L_QTY NUMBER:=0;
    L_MEM_ID MEMBER.MEM_ID%TYPE;

    CURSOR cur_cart_01 IS
      SELECT MEM_ID, PROD_ID, CART_QTY
        FROM CART
       WHERE SUBSTR(CART_NO,1,8)=L_DATE;
  BEGIN
    OPEN cur_cart_01;
    DBMS_OUTPUT.PUT_LINE('   일 자        상품코드    판매수량   회원번호 ');
    DBMS_OUTPUT.PUT_LINE('------------------------------------');
    LOOP
      FETCH cur_cart_01 INTO L_MEM_ID,L_PROD_ID, L_QTY;
      EXIT WHEN cur_cart_01%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(L_DATE||'  '||L_PROD_ID||'    '||L_QTY||'    '||L_MEM_ID);
      
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('------------------------------------');
    EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('오류발생 : '||SQLERRM);
  END;

(행참조 변수 사용)
  ACCEPT P_DATE PROMPT '날짜입력 : '
  DECLARE
    L_DATE CHAR(8):=&P_DATE;
    L_CART_REC CART%ROWTYPE;

    CURSOR cur_cart_01 IS
      SELECT * FROM CART
       WHERE SUBSTR(CART_NO,1,8)=L_DATE;
  BEGIN
    OPEN cur_cart_01;
    DBMS_OUTPUT.PUT_LINE('   일 자        상품코드    판매수량   회원번호 ');
    DBMS_OUTPUT.PUT_LINE('------------------------------------');
    LOOP
      FETCH cur_cart_01 INTO L_CART_REC;
      EXIT WHEN cur_cart_01%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(L_DATE||'  '||L_CART_REC.PROD_ID||'    '||
                           L_CART_REC.CART_QTY||'       '||L_CART_REC.MEM_ID);
      
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('------------------------------------');
    EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('오류발생 : '||SQLERRM);
  END;

 (3) COMPOSITE 변수
  - COLLECTION
   · 오라클에 사용되는 배열변수
   · VARRAY
    - 고절길이를 갖는 배열(첨자로 접근)
   · TABLE
    - 가변길이 배열변수(첨자나 키로 접근)
  - RECORD
   · RECORD
    - C언어의 구조체에 해당  
    - 여러 자료형이 조합된 형태
   · %ROWTYPE
    - 기존 테이블의 이름과 타입을 사용

 (4) BIND 변수
  - 데이터 전달에 사용되는 변수
  - 입력용(IN), 출력용(OUT), 입출력 공용(INOUT)으로 역할이 구분되어 사용
  - 역활 지정자를 생략하면 IN으로 간주



