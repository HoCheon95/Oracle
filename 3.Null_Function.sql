2025-1216-01)NULL처리 함수
 - 오라클에서 사용자가 값을 입력하지 않은 컬럼은 그 타입에 상관 없이 NULL로 초기화 됨
 - NULL 값과 연산된 결과는 NULL임
 - NULL 처리 함수는 NVL, NVL2, NULLIF, COALESCE 와 연산자 IS NULL, IS NOT NULL 이 제공
1. IS NULL, IS NOT NULL
 - NULL 여부를 판단하기 위하여 사용('='이나  '!='으로 판단 불가)
사용예) 상품테이블에서 상품의 색상정보가 없는 상품의 수를 조회하시오.
  SELECT COUNT(*)
    FROM PROD
   WHERE PROD_COLOR IS NOT NULL;

2. NVL(col, value)
 - 'col'의 값이 NULL이면 'value' 값을 반환하고 NULL이 아니면 'col'의 값을 반환함
 - 'col'과 'value'는 형이 일치 해야함
 
3. NVL2(col, value1, value2)
 - 'col'의 값이 NULL이면 'value2' 값을 반환하고 NULL이 아니면 'value1'의 값을 반환함
 - 'value1'과 'value2'는 형이 일치 해야함
 - NVL2는 NVL을 확장한 함수임

4. NULLIF(col1, col2)
 - 'col1'과 'col2'가 같은 값이면 NULL을 반환하고 같은 값이 아니면 'col1'을 반환

사용예)
1) 사원테이블에서 영업 실적코드(COMMISSION_PCT)에 따른 보너스를 계산하고 지급액을 조회하시오.
   보너스 = 영업실적코드 * 급여의 50%
   지급액 = 급여 + 보너스. 단, 영업 실적코드가 null 이면 0으로 계산할 것
 SELECT EMPLOYEE_ID AS 사원번호, 
        EMP_NAME AS 사원명,
        NVL(TO_CHAR(COMMISSION_PCT,'999.9'),'실적없음') AS 영업실적, 
        SALARY AS 급여, 
        NVL(ROUND(COMMISSION_PCT * SALARY * 0.5),0) AS 보너스, 
        SALARY + NVL(ROUND(COMMISSION_PCT * SALARY * 0.5),0) AS 지급액
   FROM HR.EMPLOYEES
  ORDER BY 1;

2) 상품테이블에서 크기정도(prod_size)를 조회하되 그 값이 null 이면 "크기정보없음"을 출력하시오.
 SELECT PROD_ID AS 상품코드,
        PROD_NAME AS 상품명,
        NVL(PROD_SIZE, '크기정보없음') AS 크기정보1, 
        NVL2(PROD_SIZE,PROD_SIZE,'크기정보없음') AS 크기정보2
  FROM PROD;
** 상품테이블에서 분류코드 'P301'에 속한 상품들의 매출가격을 매입가격으로 변경하시오.
  UPDATE PROD
     SET PROD_PRICE = PROD_COST
   WHERE LPROD_GU = 'P301'
   
   COMMIT;
   
2-1) 상품테이블에서 매입, 매출가격이 같으면 비고난에 '단종예정상품'을 출력하고
     같지 않으면 비고난에 매출가격을 출력하시오
     출력 : 상품코드, 상품명, 분류코드, 비고
매입, 매출 단가 금액이 같은지 비교 NULL IF 

NVL , NVL2 NULL IF (매출단가, 매입단가)

 SELECT PROD_ID AS 상품코드,
        PROD_NAME AS 상품명,
        LPROD_GU AS 분류코드,
        NVL(TO_CHAR(NULLIF(PROD_PRICE, PROD_COST),'9,999,999'),'단종예정상품') AS 비고
   FROM PROD;

3) 2020년 6월 모든 회원별 구매정보를 조회하시오.
   Alias 는 회원번호, 회원명, 구매금액합계이며 구매정보가 없는 회원은 "구매없음"을 출력하시오.
  SELECT B.MEM_ID AS 회원번호, 
         B.MEM_NAME AS 회원명, 
         NVL(SUM(A.CART_QTY*C.PROD_PRICE),0) AS 구매금액합계
    FROM CART A
   RIGHT OUTER JOIN MEMBER B ON(A.MEM_ID = B.MEM_ID AND A.CART_NO LIKE '202006%')
    LEFT OUTER JOIN PROD C ON(A.PROD_ID = C.PROD_ID)
   GROUP BY B.MEM_ID, B.MEM_NAME;
