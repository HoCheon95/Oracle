2025-1216-02)순위함수
  - 특정 컬럼의 값을 기준으로 정렬을 한 후 순위를 부여하는 기능 제공
  - RANK() OVER, DENSE_RANK() OVER, ROW_NUMBER() OVER 가 제공
  - SELECT 절에서만 사용
  - 그룹별로 순위를 제공할수 있음
  
  ex) 
 데이터 :   9, 9, 8, 7, 7, 7, 6, 5, 4
  RANK     1  1  3  4  4  4  7  8  9
DENSE_RANK 1  1  2  3  3  3  4  5  6
ROW_NUMBER 1  2  3  4  5  6  7  8  9

사용형식)
  RANK()|DENSE_RANK()|ROW_NUMBER() OVER(ORDER BY 컬럼명[DESC|ASC][, 컬럼명
        [DESC|ASC], ···]) [AS 별칭]

사용예)
 1)회원테이블에서 마일리지가 많은 순서대로 순위를 부여 출력하시오
   출력은 회원번호, 회원명, 마일리지, 순위 이다.
  SELECT MEM_ID AS 회원번호, 
         MEM_NAME AS 회원명, 
         MEM_MILEAGE AS 마일리지, 
         RANK() OVER(ORDER BY MEM_MILEAGE DESC) AS "순위(RANK)", 
         DENSE_RANK() OVER(ORDER BY MEM_MILEAGE DESC) AS "순위(DENSE_RANK)", 
         ROW_NUMBER() OVER(ORDER BY MEM_MILEAGE DESC) AS "순위(ROW_NUMBER)"
    FROM MEMBER;

**그룹별 순위함수
사용형식)
  RANK()|DENSE_RANK()|ROW_NUMBER() OVER(PARTITION BY 컬럼명,...
        ORDER BY 컬럼명[DESC|ASC][, 컬럼명[DESC|ASC], ···]) [AS 별칭]
        
사용예)
1) 사원테이블에서 부서별 급여순으로 등위를 부여하시오
   출력은 사원번호, 사원명, 부서번호, 급여, 순위
  SELECT EMPLOYEE_ID AS 사원번호, 
         EMP_NAME AS 사원명, 
         DEPARTMENT_ID AS 부서번호, 
         SALARY AS 급여, 
         RANK() OVER(PARTITION BY DEPARTMENT_ID ORDER BY SALARY DESC) AS 순위
    FROM HR.EMPLOYEES;
    
1-1) 사원테이블에서 부서별 급여순으로 등위를 부여하시오
     같은 순위이면 입사순으로 순위 부여
     출력은 사원번호, 사원명, 부서번호, 급여, 입사일, 순위
  SELECT EMPLOYEE_ID AS 사원번호, 
         EMP_NAME AS 사원명, 
         DEPARTMENT_ID AS 부서번호, 
         SALARY AS 급여, 
         HIRE_DATE AS 입사일,
         RANK() OVER(PARTITION BY DEPARTMENT_ID 
                     ORDER BY SALARY DESC, HIRE_DATE) AS 순위
    FROM HR.EMPLOYEES;
    
2) 회원테이블에서 연령대별 마일리지순으로 등위를 부여하시오
  SELECT MEM_ID AS 회원번호, 
         MEM_NAME AS 회원명, 
         TRUNC((EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR))/10)*10 AS 연령대, 
         MEM_MILEAGE AS 마일리지, 
         RANK() OVER(PARTITION BY 
                     TRUNC((EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR))/10)
                     ORDER BY MEM_MILEAGE DESC) AS 순위
    FROM MEMBER;