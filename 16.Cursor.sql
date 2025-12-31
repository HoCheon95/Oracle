2025-1231-01)커서
 - 넓은 의미의 커서 : SQL명령의 영향을 받은 행들의 집합
 - 좁은 의미의 커서 : SELECT 문의 결과(뷰) 집합
 - 커서를 사용해야하는 이유
  . PL/SQL에서 사용하는 SELECT 문은 SELECT 절의 컬럼 값을 반드시 변수에 할당해야 함
    (단, 서브쿼리에 사용된 SELECT 문과 커서용 SELECT 문은 제외)
  . 이때 SELECT 절에 복수개의 결과가 반환 되는 경우 변수가 모두 처리할 수 없어서 커서를 사용함
 - 커서는 익명커서(IMPLICITE CURSOR)/이름이 부여된 커서(EXPLICITE CURSOR)
 - SELECT 문에서 생성된 결과 집합에 대해 개별적인 행 단위 작업을 가능하게 한다.
 - Query 결과를 읽거나 수정, 삭제할 수 있도록 해주는 개념
 - SELECT 문의 Query 결과를 먼저 정의한 후 이를 바탕으로 첫 레코드 부터 마지막 레코드까지 액세스
 - 선택된 행들은 서버상에서 개별적으로 처리 된다.
 - 개발자가 PL/SQL 블록에서 수동으로 제어할 수 있다
 - 커서의 사용
  1) 커서 선언(선언부)
  2) 커서 OPEN (실행영역 BEGIN ~ END)
  3) 커서에서 행단위로 읽어 오기(FETCH : 주로 반복문 내부에 위치)
  4) 커서 닫기(CLOSE : 닫지 않은 커서는 재 OPEN 할 수 없다)
 ** 반복문 중 FOR 문과 커서를 사용할 경우 2) ~ 4)을 생략한다.

 - 커서속성
------------------------------------------------------------
   속성             의미
------------------------------------------------------------
 %ISOPEN           · 커서가 OPEN 상태이면 true
 %NOTFOUND         · 커서 내부에 자료가 없으면 true, 있으면 false
 %FOUND            · 커서 내부에 자료가 없으면 false, 있으면 true
 %ROWCOUNT         · 커서 내부에 존재하는 행의 갯수
------------------------------------------------------------
 *** %NOTFOUND, %FOUND 속성은 FETCH 를 수행해야 값이 설정됨
  ** 익명커서의 %ISOPEN의 값이 항상 false 임

1. 커서 선언
 - 선언부에서 선언
선언형식)
  CURSOR 커서명[(변수명 타입명, ...)] IS
    SELECT 문;
  - 변수명 타입명 : 커서에서 사용할 값을 전달하는 변수로 데이터 타입만 기술하고 크기를 기술하면 오류
  - OPEN 문에서 전달할 값을 기술하며 FOR 문인 경우 FOR 문의 IN 절에서 기술함

사용예) 인원수가 5명이상인 부서번호, 부서명, 인원수, 평균급여를 출력하는 커서를 작성
  DECLARE 
    L_DEPARTMENT_ID HR.DEPARTMENTS.DEPARTMENT_ID%TYPE;
    L_DEPARTMENT_NAME VARCHAR2(100);
    L_CNT NUMBER:=0; -- 인원수
    L_AVG_SALARY NUMBER:=0; -- 평균급여
    
    CURSOR cur_emp_01 IS
      SELECT A.DEPARTMENT_ID, B.DEPARTMENT_NAME, COUNT(*), ROUND(AVG(A.SALARY))
        FROM HR.EMPLOYEES A
       INNER JOIN HR.DEPARTMENTS B ON(A.DEPARTMENT_ID=B.DEPARTMENT_ID)
       GROUP BY A.DEPARTMENT_ID, B.DEPARTMENT_NAME
      HAVING COUNT(*) >= 5
  BEGIN
  END;

2. 커서 OPEN
 - 커서를 사용하기 위하여 반드시 OPEN 해야 함
 사용형식)
  OPEN 커서명[(매개변수 값, ...)]

사용예)
  DECLARE 
    L_DEPARTMENT_ID HR.DEPARTMENTS.DEPARTMENT_ID%TYPE;
    L_DEPARTMENT_NAME VARCHAR2(100);
    L_CNT NUMBER:=0; -- 인원수
    L_AVG_SALARY NUMBER:=0; -- 평균급여
    
    CURSOR cur_emp_01 IS
      SELECT A.DEPARTMENT_ID, B.DEPARTMENT_NAME, COUNT(*), ROUND(AVG(A.SALARY))
        FROM HR.EMPLOYEES A
       INNER JOIN HR.DEPARTMENTS B ON(A.DEPARTMENT_ID=B.DEPARTMENT_ID)
       GROUP BY A.DEPARTMENT_ID, B.DEPARTMENT_NAME
      HAVING COUNT(*) >= 5
  BEGIN
    OPEN cur_emp_01;   
  END;

3. FETCH
 - 커서 내부의 자료를 행단위로 읽어오는 명령
 - 첫 번째 위치는 자동적으로 맨 첫번째 자료를 지칭함
 사용형식)
  FETCH 커서명 INTO 변수list;
  - 커서에서 행단위로 읽은 자료를 INTO 다음의 변수에 차례대로 할당함
  - 커서 선언시 사용된 SELECT 문의 SELECT 절의 컬럼 갯수, 순서와
    INTO 절의 변수 갯수, 순서는 일치해야 함

사용예)
  DECLARE 
    L_DEPARTMENT_ID HR.DEPARTMENTS.DEPARTMENT_ID%TYPE;
    L_DEPARTMENT_NAME VARCHAR2(100);
    L_CNT NUMBER:=0; -- 인원수
    L_AVG_SALARY NUMBER:=0; -- 평균급여
    
    CURSOR cur_emp_01 IS
      SELECT A.DEPARTMENT_ID, B.DEPARTMENT_NAME, COUNT(*), ROUND(AVG(A.SALARY))
        FROM HR.EMPLOYEES A
       INNER JOIN HR.DEPARTMENTS B ON(A.DEPARTMENT_ID=B.DEPARTMENT_ID)
       GROUP BY A.DEPARTMENT_ID, B.DEPARTMENT_NAME
      HAVING COUNT(*) >= 5;
  BEGIN
    OPEN cur_emp_01;   
    LOOP
      FETCH cur_emp_01 INTO L_DEPARTMENT_ID, L_DEPARTMENT_NAME, L_CNT, L_AVG_SALARY;
      EXIT WHEN cur_emp_01%NOTFOUND;
      DBMS_OUTPUT.PUT('  '); 
      DBMS_OUTPUT.PUT('  '||L_DEPARTMENT_ID);
      DBMS_OUTPUT.PUT('  '||L_DEPARTMENT_NAME);
      DBMS_OUTPUT.PUT('  '||TO_CHAR(L_CNT,'999'));  
      DBMS_OUTPUT.PUT_LINE('  '||TO_CHAR(L_AVG_SALARY,'99,999'));  
      DBMS_OUTPUT.PUT_LINE('----------------------------');    
    END LOOP;
    CLOSE cur_emp_01;
  END;

4. CLOSE
 - 사용이 종료된 커서를 닫아 줌
 - CLOSE 되지 않은 커서는 실행 중 재 OPEN 될 수 없다.
 사용형식)
  CLOSE 커서명;