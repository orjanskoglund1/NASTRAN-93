      SUBROUTINE DUMERG        
C        
C     DRIVER FOR DMAP MODULE UMERGE        
C        
C     UMERGE   USET,PHIA,PHIO/PHIF/C,N,MAJOR/C,N,SUB0/C,N,SUB1 $        
C        
      INTEGER         USET,PHIA,PHIO,PHIF,SCR1,SUB0,SUB1,IABIT(16),     
     1                NAME(2),IB(3)        
      COMMON /BLANK / MAJOR(2),SUB0(2),SUB1(2)        
      COMMON /BITPOS/ IBIT(32),IABIT        
      DATA    NAME  / 4HUMER , 4HGE       /        
      DATA    USET  , PHIA,PHIO,PHIF,SCR1 / 101,102,103,201,301/        
C        
      NOGO = 0        
C        
C     DECIDE IF CHARACTERS ARE LEGAL BIT NUMBERS        
C        
      IB(1) = MAJOR(1)        
      IB(2) = SUB0(1)        
      IB(3) = SUB1(1)        
C        
      DO 30 J = 1,3        
      DO 20 I = 1,32        
      IF (IB(J) .NE. IABIT(I)) GO TO 20        
      IB(J) = IBIT(I)        
      GO TO 30        
   20 CONTINUE        
C        
C     INVALID        
C        
      CALL MESAGE (59,IB(J),NAME)        
      NOGO = 1        
   30 CONTINUE        
C        
      IF (NOGO .EQ. 1) CALL MESAGE (-7,0,NAME)        
      CALL SDR1B (SCR1,PHIA,PHIO,PHIF,IB(1),IB(2),IB(3),USET,0,0)       
      RETURN        
C        
      END        
