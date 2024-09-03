VARIABLE JOBNO NUMBER;
BEGIN
    DBMS_JOB.SUBMIT(:JOBNO
                   ,'HBM_CONTROLE_TASY_TESTE;'
                   ,SYSDATE
                   ,'TRUNC(SYSDATE + 7) + 7/24'
                   );
END;
/