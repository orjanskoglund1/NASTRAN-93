      SUBROUTINE FNDPAR (NP2,INDEX)        
C        
C     FNDPAR FINDS THE INDEX INTO THE  VPS FOR PARAMETER NUMBER NP      
C     IN THE CURRENT OSCAR (THIS PARAMETER MUST BE VARIABLE)        
C        
      EXTERNAL        ANDF        
      INTEGER         OSCAR,NAME(2),ANDF        
      CHARACTER       UFM*23        
      COMMON /XMSSG / UFM        
      COMMON /OSCENT/ OSCAR(7)        
      COMMON /SYSTEM/ SYSBUF,NOUT        
      COMMON /SEM   / MASK,MASK2,MASK3        
      DATA    NAME  / 4HFNDP,4HAR  /        
C        
      NIP  = OSCAR(7)        
      ITYPE= ANDF(OSCAR(3),7)        
      I    = 8 + 3*NIP        
      IF (ITYPE .EQ. 2) GO TO 100        
      NOP  = OSCAR(I)        
      I    = I + 3*NOP + 1        
  100 CONTINUE        
      I    = I + 1        
      NP1  = OSCAR(I)        
      NP   = IABS(NP2)        
      IF (NP .LE. NP1) GO TO 120        
      IF (NP2 .LE.  0) GO TO 200        
      WRITE  (NOUT,110) UFM,NP        
  110 FORMAT (A23,' 3123, PARAMETER NUMBER',I6,' NOT IN DMAP CALL.')    
      CALL MESAGE (-61,0,NAME)        
  120 CONTINUE        
      NP1 = NP - 1        
      K   = I + 1        
      IF (NP1 .EQ. 0) GO TO 170        
      DO 130 I = 1,NP1        
      M   = OSCAR(K)        
      IF (M) 140,150,150        
C        
C     VARTABLE        
C        
  140 K = K + 1        
      GO TO 130        
C        
C     CONSTANT        
C        
  150 K = K + 1 + M        
  130 CONTINUE        
C        
C     K POINTS  TO WANTED OSCAR WORD        
C        
  170 IF (OSCAR(K) .LT. 0) GO TO 190        
      IF (NP2 .LE. 0) GO TO 200        
      WRITE  (NOUT,180) UFM,NP        
  180 FORMAT (A23,' 3124, PARAMETER NUMBER',I6,' IS NOT A VARIABLE.')   
      CALL MESAGE (-61,0,NAME)        
  190 INDEX = ANDF(OSCAR(K),MASK3)        
      RETURN        
C        
C     PARAMETER SPORT NOT SUPPLIES        
C        
  200 INDEX = -1        
      RETURN        
      END        
