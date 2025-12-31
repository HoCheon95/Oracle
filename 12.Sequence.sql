2025-1224-02) SEQUENCE 객체
 - Sequence 객체는 자동적으로 번호를 생성하기 위한 객체
 - Sequence 객체는 테이블과 독립적이므로 여러 곳에서 사용 가능
 - Sequence 를 이용하는 경우
   · Primary Key 를 설정할 후보키가 없거나 PK를 특별히 의미있게 만들지 않아도 되는 경우
   · 자동으로 순서적인 번호가 필요한 경우
구문형식)
  CREATE SEQUENCE 시퀀스명
    [START WITH n]              - n시작값설정, 기본은 MIN_VALUE
    [INCREMENT BY n]            - n자동증감값기본은1, 음수사용가능
    [MAXVALUE n | NOMAXVALUE]   - 시퀀스의 최대값 설정, default는 NOMAXVALUE 이며 10^27까지
    [MINVALUE n | NOMINVALUE]   - 시퀀스의 최소값 설정, default는 NOMINVALUE 이며 1이다
    [CYCLE | NOCYCLE]           - 최대값 또는 최소값 이후 다시 시작할지 여부 default는 NOCYCLE
    [CACHE n | NOCACHE]         - 메모리에 미리 할당할 값, default는 CACHE 20
    [ORDER | NOORDER]           - 요청순서대로 생성을 보증, default는 NOORDER

시퀀스 사용
    의사컬럼(Pseudo Column)   내용
----------------------------------------------------------------
  시퀀스명.NEXTVAL            시퀀스 객체의 다음 값 반환
  시퀀스명.CURRVAL            시퀀스 객체의 현재 값 반환

** 시퀀스가 생성된 후 해당 세션에서 수행해야하는 첫번째 명령은 반드시 '시퀀스명.NEXTVAL' 이어야 함
--ㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ
사용예1) 1번부터 1씩 증가하는 값을 반환하는 시쿼스 'SEQ_TEMP'를 생성하시오
  CREATE SEQUENCE SEQ_TEMP;

  SELECT SEQ_TEMP.CURRVAL FROM DUAL;

  SELECT SEQ_TEMP.NEXTVAL FROM DUAL;
--ㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ
사용예) LPROD 테이블에 다음 자료를 삽입하시오
       단, LPROD_ID는 시퀀스를 만들어 사용하시오
--------------------------------------------------
  LPROD_ID,    LPROD_GU        LPROD_NAME
--------------------------------------------------
   10          P501            농산물    
   11          P502            수산물
   12          P503            임산물

** 시퀀스 생성
  CREATE SEQUENCE seq_lprod_id
    START WITH 10;

** 자료 삽입
  INSERT INTO LPROD VALUES(seq_lprod_id.NEXTVAL, 'P501', '농산물');
  INSERT INTO LPROD VALUES(seq_lprod_id.NEXTVAL, 'P502', '수산물');
  INSERT INTO LPROD VALUES(seq_lprod_id.NEXTVAL, 'P503', '임산물');

** 시퀀스 삭제
  DROP SEQUENCE 시퀀스명

  DROP SEQUENCE SEQ_TEMP;
