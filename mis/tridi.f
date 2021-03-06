      SUBROUTINE TRIDI (D,O,C,A,B,AA)        
C        
C     MODIFIED GIVENS REAL SYMMETRIC TRIDIAGONALIZATION        
C     THIS ROUTINE IS CALLED ONLY BY VALVEC        
C        
      INTEGER          SAVEMR,ENTRY,RSTRT,ROW,XENTRY,FILCOR,ROT,ROW1,   
     1                 ROW2,ROWP1,ROWP2,SYSBUF,MCB(7),COUNT        
      DOUBLE PRECISION D(1),O(1),C(1),AA(1),B(1)        
      DIMENSION        VVCOM(150),A(2)        
      CHARACTER        UFM*23        
      COMMON /XMSSG /  UFM        
      COMMON /GIVN  /  TITLE(1),MO,MD,MR1,M1,M2,M3,M4,SAVEMR,T10,ENTRY, 
     1                 T12(5),RSTRT,ROW,T19,XENTRY        
      COMMON /SYSTEM/  SYSBUF,NOUT,IDUMMY(52),IPREC        
      COMMON /PACKX /  IT1,IT2,II,JJ,INCR        
      COMMON /UNPAKX/  IT3,III,JJJ,INCR1        
      EQUIVALENCE      (VVCOM(1),TITLE(1)), (N,VVCOM(101))        
      DATA    COUNT ,  MAX,MCB / 0, 10, 7*0/        
C        
C        
C     DEFINITION OF VARIABLES        
C        
C     D       = LOCATION OF DIAGIONAL        
C     O       = LOCATION OF OFF DIAGONAL        
C     C       = LOCATION OF COSINES        
C     A       = REST OF OPEN CORE        
C     B       = O**2        
C     SAVEMR        
C     RSTRT        
C     ROW        
C     XENTRY        
C     FILCOR        
C     ROT        
C     ROW1        
C     ROW2        
C     MO      = RESTART DATA - SINES AND COSINES        
C     MD      = INPUT  MATRIX        
C     MR1     = RESTART TAPE        
C     M1      = SCRATCH TAPE        
C     M2        
C     M3        
C     M4        
C     MR2        
C     MIDIN        
C     COUNT   = NUMBER OF ROWS ROTATED        
C     MAX     = NUMBER OF ROWS TO ROTATE BEFORE CHECKPOINTING        
C        
C        
C     INITIALIZATION        
C        
      NZ   = KORSZ(A)        
      IBUF1= NZ - SYSBUF + 1        
      IBUF2= IBUF1 - SYSBUF        
      NZ   = NZ - 2*SYSBUF        
      NZZ  = NZ/IPREC        
      NZSQ = SQRT(FLOAT((NZZ-1)*2))        
      IM1  = 1        
      NM1  = N - 1        
      NM2  = N - 2        
      M3   = 305        
      MSS  = MR1        
      MS1  = M1        
      MS2  = M2        
      MS3  = M3        
      MS4  = M4        
C        
C     INITIALIZE  TRANSFORMATION ROUTINES        
C        
C     SICOX AND ROTAX ARE NOT USED ANY MORE. SEE SINC0S AND ROTATE      
C        
C     CALL SICOX (D,O,C)        
C     CALL ROTAX (O,D,C)        
C        
      MIDIN= N        
      MR   = MR1        
C        
C     START AT THE BEGINNING        
C        
      ROW = 0        
C        
C     OPEN MD        
C        
      CALL GOPEN (MD,A(IBUF1),0)        
      CALL GOPEN (MR,A(IBUF2),1)        
C        
C     SET UP FOR UNPACK        
C        
      IT3  = 2        
      III  = 1        
      JJJ  = N        
      INCR1= 1        
      CALL UNPACK (*102,MD,D)        
C        
C     COPY REST OF MD ONTO MR        
C        
  103 CONTINUE        
      IT1 = 2        
      IT2 = 2        
      INCR= 1        
      K   = N - 1        
      DO 105 I = 1,K        
      III = 0        
      CALL UNPACK (*107,MD,A)        
      II = III        
      JJ = JJJ        
  106 CALL PACK (A,MR,MCB)        
      GO TO 105        
  107 II = 1        
      JJ = 1        
      A(1) = 0.0        
      A(2) = 0.0        
      GO TO 106        
  105 CONTINUE        
      III = 1        
      JJJ = N        
      II  = 1        
      JJ  = N        
      GO TO 104        
  102 DO 101 I = 1,N        
      D(I) = 0.0D0        
  101 CONTINUE        
      GO TO 103        
C        
C     END OF MATRIX MD        
C        
  104 CALL WRITE (MR,ROW,1,1)        
C        
C     ATTACH DIAGONALS        
C        
      CALL PACK  (D,MR,MCB)        
      CALL CLOSE (MD,1)        
      CALL CLOSE (MR,1)        
      MS = MR        
      CALL GOPEN (MS,A(IBUF1),0)        
C        
C     TRIDIAGONALIZATION PROCEDURE UNTIL THE MATRIX FITS IN CORE        
C        
  200 ROW  = ROW + 1        
      ROWP1= ROW + 1        
      ROWP2= ROW + 2        
      IT3  = 2        
      III  = ROWP1        
      CALL UNPACK (*201,MS,O(ROWP1))        
      GO TO 203        
  201 DO 202 I = ROWP1,N        
      O(I) = 0.0D0        
  202 CONTINUE        
C        
C     FIND SINES AND COSINES        
C        
  203 CALL SINC0S (ROW,ROT, D,O,C)        
      CALL GOPEN (MO,A(IBUF2),IM1)        
      IM1 = 3        
      II  = ROWP2        
      IT1 = 2        
      IT2 = 2        
      CALL PACK (D(ROWP2),MO,MCB)        
      CALL CLOSE (MO,2)        
C        
C     WILL THE REST OF MATRIX FIT IN CORE        
C        
      IF ((N-ROWP1)*(N-ROWP1+1)/2+1 .LE. NZZ) GO TO 225        
C        
C         (N-ROWP1)*(N-ROWP1  )     < (NZZ-1)*2        
C                   (N-ROWP1  )     < SQRT((NZZ-1)*2) (=NZSQ)        
C                    N              < NZSQ + ROWP1        
C                    N-NZSQ         < ROWP1        
C                    N-NZSQ         = NUMBER OF ROTAIONS NEEDED        
C        
C     NO-- MUST REST OF MATRIX BE ROTATED        
C        
      IF (ROT .EQ. 0) GO TO 215        
      COUNT = COUNT + 1        
      IF (COUNT .EQ. MAX) COUNT = 0        
C        
C     ROTATE THE REST OF THE MATRIX        
C        
      MIDOUT = ROWP1 + (N-ROWP1+3)/4        
      ROW1   = ROWP2        
      CALL GOPEN (MS3,A(IBUF2),1)        
C        
C     HERE THRU 217 WILL BE VERY TIME COMSUMING. THE ROTATION IS ONE    
C     ROW AT A TIME. COMPUTE HOW MANY ROTATIONS NEEDED. IF TOO MANY,    
C     ISSUE A USER FATAL MESSAGE AND GET OUT        
C        
      I = N - NZSQ        
      IF (I .LE. 25) GO TO 205        
      J = (N*N - NZSQ*NZSQ)*IPREC        
      WRITE  (NOUT,204) UFM,N,N,I,J        
  204 FORMAT (A23,' FROM GIVENS EIGENSOLVER - EXCESSIVE CPU TIME IS ',  
     1       'NEEDED FOR TRIDIAGONALIZE THE DYNAMIC', /5X,        
     2       'MATRIX, WHICH IS',I6,' BY',I6, 15X,1H(,I6,' LOOPS)', /5X, 
     3       'RERUN JOB WITH',I8,' ADDITIONAL CORE WORDS, OR USE FEER,',
     4       ' OR OTHER METHOD')        
      CALL MESAGE (-61,0,0)        
C        
C     FILL CORE WITH AS MUCH OF MATRIX AS POSSIBLE--UP TO ROW -ROW2-    
C        
  205 ROW2 = FILCOR(MSS,MS2,IPREC,ROW1,MIDIN,N,A,NZ,A(IBUF1))        
C        
C     ROTATE ROWS ROW1 TO ROW2        
C        
      CALL ROTATE (A,ROW,ROW1,ROW2,AA, O,D,C)        
C        
C     EMPTY THE ROTATED ROWS ONTO MS3 AND MS4        
C        
      CALL EMPCOR (MS3,MS4,IPREC,IPREC,ROW1,MIDOUT,ROW2,N,A,A(IBUF2))   
      ROW1 = ROW2 + 1        
      IF (ROW2 .LT. N) GO TO 205        
C        
C     SWITCH TAPES        
C        
      MS  = MS1        
      MS1 = MS3        
      MS3 = MS        
      MS  = MS2        
      MS2 = MS4        
      MS4 = MS        
      MSS = MS1        
      MIDIN = MIDOUT        
  215 DO 216 I = ROWP1,N        
      D(I) =  O(I)        
  216 CONTINUE        
      MS = MSS        
      IF (ROW .GT. MIDIN) GO TO 217        
      IF (ROT .EQ.     0) GO TO 200        
  218 CALL GOPEN (MS,A(IBUF1),0)        
      GO TO 200        
  217 MS = MS2        
      GO TO 218        
C        
C     TRIDIAGONALIZATION PROCEDURE WHEN MATRIX FITS IN CORE        
C        
C        
C     FILL CORE WITH THE REST OF THE MATRIX        
C        
  225 ROW2 = FILCOR(MSS,MS2,IPREC,ROWP2,MIDIN,N,A,NZ,A(IBUF1))        
      NA = 1        
      CALL GOPEN (MO,A(IBUF2),3)        
      GO TO 235        
  230 ROW   = ROW + 1        
      ROWP1 = ROW + 1        
      ROWP2 = ROW + 2        
      IF (IPREC .EQ. 2) GO TO 232        
      DO 231 I = ROWP1,N        
      O(I) = A(NA)        
      NA   = NA + 1        
  231 CONTINUE        
      GO TO 234        
  232 DO 233 I = ROWP1,N        
      O(I) = AA(NA)        
      NA   = NA + 1        
  233 CONTINUE        
  234 CALL SINC0S (ROW,ROT, D,O,C)        
C        
C     WRITE SINES ON MO        
C        
      II  = ROWP2        
      IT1 = 2        
      IT2 = 2        
      CALL PACK (D(ROWP2),MO,MCB)        
  235 IF (ROT .EQ. 0) GO TO 236        
      ROW1  = ROWP2        
      CALL ROTATE (A(NA),ROW,ROW1,ROW2,AA(NA), O,D,C)        
  236 DO 237 I = ROWP1,N        
      D(I) = O(I)        
  237 CONTINUE        
      IF (ROW .NE. NM2) GO TO 230        
C        
C     ALL DONE.        
C        
      D(N) = A(NA)        
      IF (IPREC .EQ. 2) D(N) = AA(NA)        
      O(N-1) = O(N)        
      O(N  ) = 0.0D0        
      CALL CLOSE (MO,3)        
      DO 261 I = 1,N        
      C(I) = D(I)        
      B(I) = O(I)**2        
  261 CONTINUE        
      XENTRY = -ENTRY        
      RSTRT  = 0        
      SAVEMR = 0        
      RETURN        
      END        
