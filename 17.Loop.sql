2025-1231-02) 반복문
 - LOOP, WHILE, FOR 문 등이 제공됨
1. LOOP 문
 - 가장 기본적인 반복문
 - 무한 LOOP 기능 제공
사용형식)
  LOOP
    [반복수행 명령문;]
    EXIT [WHEN 조건];
    [반복수행 명령문;]
          :
  END LOOP;
  - 'EXIT [WHEN 조건]' : WHEN 절이 사용되면 조건이 만족되면 반복문을 벗어나고
    WHEN 절이 없으면 무조건 반복문을 벗어남
사용예) 구구단의 7단을 출력하는 블록을 작성
  DECLARE
    L_CNT NUMBER:=0;
  BEGIN
    LOOP
      L_CNT:=L_CNT+1;
      EXIT WHEN L_CNT>9;
      DBMS_OUTPUT.PUT_LINE('7 * '||L_CNT||' = '||7*L_CNT);
    END LOOP;
  END;

2. WHILE 문
 - 반복문을 수행하기 전에 조건을 판단하여 조건이 만족하면 반복문을 수행하고 조건이 만족되지 않으면
   반복문을 수행하지 않음

사용형식)
  WHILE 조건 LOOP
    반복수행 명령문(들);
  END LOOP;

사용예) 구구단의 7단을 출력하는 블록을 작성
  DECLARE
    L_CNT NUMBER:=0;
  BEGIN
    WHILE L_CNT < 9 LOOP
      L_CNT:=L_CNT+1;
      DBMS_OUTPUT.PUT_LINE('7 * '||L_CNT||' = '||7*L_CNT);
    END LOOP;
  END;

사용예) 회원 중 마일리지가 5000이상인 회원이 2020년 7월에 구매한 구매현황을 출력하는 블록을 작성하시오
       출력은 회원번호, 회원명, 구매금액 이다.
  DECLARE
    L_MEM_ID MEMBER.MEM_ID%TYPE;
    L_MEM_NAME VARCHAR2(50);
    L_SUM NUMBER:=0;
    CURSOR CUR_MEM_02 IS 
      SELECT MEM_ID, MEM_NAME
        FROM MEMBER
       WHERE MEM_MILEAGE >= 5000;
  BEGIN
    OPEN CUR_MEM_02;
    FETCH CUR_MEM_02 INTO L_MEM_ID, L_MEM_NAME;
    WHILE CUR_MEM_02%FOUND LOOP    
      SELECT SUM(A.CART_QTY*B.PROD_PRICE) INTO L_SUM
        FROM CART A
       INNER JOIN PROD B ON(A.PROD_ID=B.PROD_ID)
       WHERE A.CART_NO LIKE '202007%'
         AND A.MEM_ID=L_MEM_ID;
   
      DBMS_OUTPUT.PUT_LINE('회원번호 : '||L_MEM_ID);
      DBMS_OUTPUT.PUT_LINE('회원명 : '||L_MEM_NAME);
      DBMS_OUTPUT.PUT_LINE('구매금액 : '||NVL(L_SUM,0));
      DBMS_OUTPUT.PUT_LINE('--------------------------');
      FETCH CUR_MEM_02 INTO L_MEM_ID, L_MEM_NAME;
    END LOOP;
    CLOSE CUR_MEM_02;
  END;



3. FOR 문
 - 일반 개발언어의 FOR문과 비슷한 문법구조를 가졌음

사용형식)
  FOR 제어변수 IN [REVERSE] 최소값..최대값 LOOP
    반복수행 명령문(들);
  END LOOP;
  - '제어변수'는 시스템에서 설정
  - '제어변수'에 최소값을 배정하여 최대값과 비교하여 작거나 같으면 반복수행, 크면 반복문을 벗어남
  - 그 이후 제어변수의 값을 1씩 증가 감소시킨 후 같은 과정을 반복
  - 'REVERSE'가 사용되면 역순으로 출력
사용예)구구단의 7단을 출력
  DECLARE
  BEGIN
    FOR I IN 1..9 LOOP
      DBMS_OUTPUT.PUT_LINE('7 * '||I||' = '||I*7);
    END LOOP;

    FOR I IN REVERSE 1..9 LOOP
      DBMS_OUTPUT.PUT_LINE('7 * '||I||' = '||I*7);
    END LOOP;
  END;

(FOR 문 사용)
  DECLARE
    L_SUM NUMBER:=0;
  BEGIN
    FOR REC IN (SELECT MEM_ID, MEM_NAME
                  FROM MEMBER
                 WHERE MEM_MILEAGE >= 5000) LOOP
      SELECT SUM(A.CART_QTY*B.PROD_PRICE) INTO L_SUM
        FROM CART A
       INNER JOIN PROD B ON(A.PROD_ID=B.PROD_ID)
       WHERE A.CART_NO LIKE '202007%'
         AND A.MEM_ID=REC.MEM_ID;
   
      DBMS_OUTPUT.PUT_LINE('회원번호 : '||REC.MEM_ID);
      DBMS_OUTPUT.PUT_LINE('회원명 : '||REC.MEM_NAME);
      DBMS_OUTPUT.PUT_LINE('구매금액 : '||NVL(L_SUM,0));
      DBMS_OUTPUT.PUT_LINE('--------------------------');
    END LOOP;
  END;