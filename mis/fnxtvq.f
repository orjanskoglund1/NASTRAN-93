      SUBROUTINE FNXTVQ (V1,V2,V3,V4,V5,ZB,IFN)        
C        
C     THIS ROUTINE IS SAME AS FNXTVC EXCEPT IN CERTAIN KEY AREAS THE    
C     COMPUTATIONS ARE REINFORCED BY QUAD PRECISION OPERATIONS FOR      
C     IMPROVED NUMERIC ACCURACY. IT IS INTENED TO BE USED IN THE 32     
C     BIT WORD MACHINES WITH REAL*16 CAPABILITY        
C        
C     FOR THE 60/64 BIT WORD MACHINES, USE FNXTVD, WHICH IS A DOUBLE    
C     PRECISION VERSION OF THIS FNXTVQ.        
C        
C     THIS ROUTINE USES THE FOLLOWING SYSTEM QUAD FUNCTIONS -        
C     QSQRT, QABS, DBLEQ AND SNGLQ        
C        
C     ON VAX, FNXTVQ RUNS ABOUT 2 TO 3 TIMES SLOWER THAN FNXTVC        
C        
C     THIS ROUTINE IS ACTIVATED BY THE EIGR BULKDATA CARD USING THE BCD 
C     WORD 'FEER-Q' INSTEAD OF 'FEER' ON THE 3RD FIELD.        
C        
C     FNXTVQ OBTAINS THE REDUCED TRIDIAGONAL MATRIX B WHERE FRBK2       
C     PERFORMS THE OPERATIONAL INVERSE.   (QUAD/DOUBLE PREC VERSION)    
C        
C           T   -        
C      B = V  * A  * V        
C        
C     V1  = SPACE FOR THE PREVIOUS CURRENT TRIAL VECTOR. INITALLY NULL  
C     V2  = SPACE FOR THE CURRENT TRIAL VECTOR. INITIALLY A PSEUDO-     
C           RANDOM START VECTOR        
C     V3,V4,V5 = WORKING SPACES FOR THREE VECTORS        
C     IFN = NO. OF TRIAL VECOTRS EXTRACTED. INITIALLY ZERO.        
C     SEE FEER FOR DEFINITIONS OF OTHER PARAMETERS. ALSO PROGRAMMER'S   
C           MANUAL PP. 4.48-19G THRU I        
C        
      INTEGER            SYSBUF    ,CNDFLG   ,SR5FLE   ,NAME(5)  ,      
     1                   VQDOT        
      DOUBLE PRECISION   V1(1)     ,V2(1)    ,V3(1)    ,V4(1)    ,      
     1                   V5(1)     ,LMBDA    ,B(2)     ,LAMBDA   ,      
     2                   ZB(1)     ,TMP      ,TMX        
CD    DOUBLE PRECISION   D         ,DB       ,DSQ      ,SD       ,      
      REAL*16            D         ,DB       ,DSQ      ,SD       ,      
     1                   AII       ,DBI      ,DEPX     ,DEPX2    ,      
     2                   OPDEPX    ,OMDEPX   ,SDMAX    ,DTMP     ,      
     3                   ZERO      ,ONE        
      CHARACTER          UFM*23    ,UWM*25        
      COMMON   /XMSSG /  UFM       ,UWM        
      COMMON   /FEERCX/  IFKAA(7)  ,IFMAA(7) ,IFLELM(7),IFLVEC(7),      
     1                   SR1FLE    ,SR2FLE   ,SR3FLE   ,SR4FLE   ,      
     2                   SR5FLE    ,SR6FLE   ,SR7FLE   ,SR8FLE   ,      
     3                   DMPFLE    ,NORD     ,XLMBDA   ,NEIG     ,      
     4                   MORD      ,IBK      ,CRITF    ,NORTHO   ,      
     5                   IFLRVA    ,IFLRVC        
      COMMON   /FEERXX/  LAMBDA    ,CNDFLG   ,ITER     ,TIMED    ,      
     1                   L16       ,IOPTF    ,EPX      ,ERRC     ,      
     2                   IND       ,LMBDA    ,IFSET    ,NZERO    ,      
     3                   NONUL     ,IDIAG    ,MRANK    ,ISTART        
      COMMON   /SYSTEM/  SYSBUF    ,IO        
      COMMON   /OPINV /  MCBLT(7)  ,MCBSMA(7),MCBVEC(7),MCBRM(7)        
      COMMON   /UNPAKX/  IPRC      ,II       ,NN       ,INCR        
      COMMON   /PACKX /  ITP1      ,ITP2     ,IIP      ,NNP      ,      
     1                   INCRP        
      COMMON   /NAMES /  RD        ,RDREW    ,WRT      ,WRTREW   ,      
     1                   REW       ,NOREW    ,EOFNRW        
      DATA      NAME  /  4HFNXT    ,4HVQ     ,2*4HBEGN ,4HEND    /      
      DATA      VQDOT /  4HVQ.     /        
      DATA      ZERO  ,  ONE       /0.0Q+0   ,1.0Q+0             /      
CD    DATA      ZERO  ,  ONE       /0.0D+0   ,1.0D+0             /      
C        
C        
C     SR5FLE CONTAINS THE REDUCED TRIDIAGONAL ELEMENTS        
C        
C     SR6FLE CONTAINS THE G VECTORS        
C     SR7FLE CONTAINS THE ORTHOGONAL  VECTORS        
C     SR8FLE CONTAINS THE CONDITIONED MAA MATRIX        
C        
      IF (MCBLT(7) .LT. 0) NAME(2) = VQDOT        
      NAME(3) = NAME(4)        
      CALL CONMSG (NAME,3,0)        
      ITER  = ITER + 1        
      IPRC  = 2        
      INCR  = 1        
      INCRP = INCR        
      ITP1  = IPRC        
      ITP2  = IPRC        
      IFG   = MCBRM(1)        
      IFV   = MCBVEC(1)        
      DEPX  = EPX        
      DEPX2 = DEPX**2        
      OPDEPX= ONE + DEPX        
      OMDEPX= ONE - DEPX        
      D     = ZERO        
      NORD1 = NORD - 1        
C        
C     NORMALIZE START VECTOR        
C        
      DSQ = ZERO        
      IF (IOPTF .EQ. 1) GO TO 20        
      CALL FRMLTD (MCBSMA(1),V2(1),V3(1),V5(1))        
      DO 10 I = 1,NORD        
   10 DSQ = DSQ + V2(I)*V3(I)        
      GO TO 40        
   20 DO 30 I = 1,NORD        
   30 DSQ = DSQ + V2(I)*V2(I)        
CD 40 DSQ = ONE/DSQRT(DSQ)        
   40 DSQ = ONE/QSQRT(DSQ)        
      TMP = DBLEQ(DSQ)        
CD    TMP = DBLE (DSQ)        
      DO 50 I = 1,NORD        
   50 V2(I) = V2(I)*TMP        
      IF (NORTHO .EQ. 0) GO TO 200        
C        
C     ORTHOGONALIZE WITH PREVIOUS VECTORS        
C        
      DO 60 I = 1,NORD        
   60 V3(I) = V2(I)        
   70 DO 170 IX = 1,14        
      NONUL = NONUL + 1        
      CALL GOPEN (IFV,ZB(1),RDREW)        
      IF (IOPTF .EQ. 0) CALL FRMLTD (MCBSMA(1),V2(1),V3(1),V5(1))       
      SDMAX = ZERO        
      DO 110 IY = 1,NORTHO        
      II = 1        
      NN = NORD        
      SD = ZERO        
      CALL UNPACK (*90,IFV,V5(1))        
      DO 80 I = 1,NORD        
      SD = SD + V3(I)*V5(I)        
   80 CONTINUE        
CD 90 IF (DABS(SD) .GT. SDMAX) SDMAX = DABS(SD)        
   90 IF (QABS(SD) .GT. SDMAX) SDMAX = QABS(SD)        
      TMP = DBLEQ(SD)        
CD    TMP = DBLE (SD)        
      DO 100 I = 1,NORD        
  100 V2(I) = V2(I) - TMP*V5(I)        
  110 CONTINUE        
      CALL CLOSE (IFV,EOFNRW)        
      DSQ = ZERO        
      IF (IOPTF .EQ. 1) GO TO 130        
      CALL FRMLTD (MCBSMA(1),V2(1),V3(1),V5(1))        
      DO 120 I = 1,NORD1        
  120 DSQ = DSQ + V2(I)*V3(I)        
      GO TO 150        
  130 DO 140 I = 1,NORD1        
  140 DSQ = DSQ + V2(I)*V2(I)        
C        
  150 D = V3(NORD)        
      IF (IOPTF .EQ. 1) D = V2(NORD)        
      D = V2(NORD)*D        
      DTMP = DSQ        
      DSQ  = DSQ + D        
      IF (DSQ .LT. DEPX2) GO TO 500        
      DTMP = QABS(D/DTMP)        
CD    DTMP = DABS(D/DTMP)        
      IF (DTMP.GT.OMDEPX .AND. DTMP.LT.OPDEPX) GO TO 500        
      D = ZERO        
C        
      DSQ = QSQRT(DSQ)        
CD    DSQ = DSQRT(DSQ)        
      IF (L16 .NE. 0) WRITE (IO,620) IX,SDMAX,DSQ        
      DSQ = ONE/DSQ        
      TMP = DBLEQ(DSQ)        
CD    TMP = DBLE (DSQ)        
      DO 160 I = 1,NORD        
      V2(I) = V2(I)*TMP        
  160 V3(I) = V2(I)        
      IF (SDMAX .LT. DEPX) GO TO 200        
  170 CONTINUE        
      GO TO 500        
C        
  200 IF (IFN .NE. 0) GO TO 300        
C        
C     SWEEP START VECTOR FOR ZERO ROOTS        
C        
      DSQ = ZERO        
      IF (IOPTF .EQ. 1) GO TO 220        
      CALL FRSW2 (V2(1),V4(1),V3(1),V5(1))        
      CALL FRMLTD (MCBSMA(1),V3(1),V4(1),V5(1))        
      DO 210 I = 1,NORD        
  210 DSQ = DSQ + V3(I)*V4(I)        
      GO TO 240        
  220 CALL FRBK2 (V2(1),V4(1),V3(1),V5(1))        
      DO 230 I = 1,NORD        
  230 DSQ = DSQ + V3(I)*V3(I)        
CD240 DSQ = ONE/DSQRT(DSQ)        
  240 DSQ = ONE/QSQRT(DSQ)        
      TMP = DBLEQ(DSQ)        
CD    TMP = DBLE (DSQ)        
      DO 250 I = 1,NORD        
  250 V2(I) = V3(I)*TMP        
      GO TO 320        
C        
C     CALCULATE OFF DIAGONAL TERM OF B        
C        
  300 D = ZERO        
      DO 310 I = 1,NORD        
  310 D = D + V2(I)*V4(I)        
C        
C     COMMENTS FROM G.CHAN/UNISYS  1/92        
C     WHAT HAPPENS IF D IS NEGATIVE HERE? NEXT LINE WOULD BE ALWAYS TRUE
C        
      IF (D .LT. DEPX*QABS(AII)) GO TO 500        
CD    IF (D .LT. DEPX*DABS(AII)) GO TO 500        
  320 CALL GOPEN (IFG,ZB(1),WRT)        
      IIP = 1        
      NNP = NORD        
      IF (IOPTF .EQ. 1) GO TO 330        
      CALL FRSW2 (V2(1),V4(1),V3(1),V5(1))        
      CALL FRMLTD (MCBSMA(1),V3(1),V4(1),V5(1))        
      CALL PACK (V2(1),IFG,MCBRM(1))        
      GO TO 350        
  330 CALL FRBK2 (V2(1),V4(1),V3(1),V5(1))        
      CALL PACK (V4(1),IFG,MCBRM(1))        
      DO 340 I = 1,NORD        
  340 V4(I) = V3(I)        
  350 CALL CLOSE (IFG,NOREW)        
C        
C     CALCULATE DIAGONAL TERM OF B        
C        
      AII = ZERO        
      DO 400 I = 1,NORD        
  400 AII = AII + V2(I)*V4(I)        
      TMP = DBLEQ(AII)        
CD    TMP = DBLE (AII)        
      IF (D .EQ. ZERO) GO TO 420        
      TMX = DBLEQ(D)        
CD    TMX = DBLE (D)        
      DO 410 I = 1,NORD        
  410 V3(I) = V3(I) - TMP*V2(I) - TMX*V1(I)        
      GO TO 440        
  420 DO 430 I = 1,NORD        
  430 V3(I) = V3(I) - TMP*V2(I)        
  440 DB = ZERO        
      IF (IOPTF .EQ. 1) GO TO 460        
      CALL FRMLTD (MCBSMA(1),V3(1),V4(1),V5(1))        
      DO 450 I = 1,NORD        
  450 DB = DB + V3(I)*V4(I)        
      GO TO 480        
  460 DO 470 I = 1,NORD        
  470 DB = DB + V3(I)*V3(I)        
CD480 DB = DSQRT(DB)        
  480 DB = QSQRT(DB)        
      ERRC = SNGLQ(DB)        
CD    ERRC = SNGL (DB)        
      B(1) = AII        
      B(2) = D        
      CALL WRITE (SR5FLE,B(1),4,1)        
      CALL GOPEN (IFV,ZB(1),WRT)        
      IIP  = 1        
      NNP  = NORD        
      CALL PACK (V2(1),IFV,MCBVEC(1))        
      CALL CLOSE (IFV,NOREW)        
      NORTHO = NORTHO + 1        
      IFN   = NORTHO - NZERO        
      IF (L16 .NE. 0) WRITE (IO,610) IFN,MORD,AII,DB,D        
      IF (IFN .GE. MORD) GO TO 630        
C        
C     IF NULL VECTOR GENERATED, RETURN TO OBTAIN A NEW SEED VECTOR      
C        
      IF (DB .LT. DEPX*QABS(AII)) GO TO 630        
CD    IF (DB .LT. DEPX*DABS(AII)) GO TO 630        
C        
C     A GOOD VECTOR IN V2. MOVE IT INTO 'PREVIOUS' VECTOR SPACE V1,     
C     NORMALIZE V3 AND V2. LOOP BACK FOR MORE VECTORS.        
C        
      DBI = ONE/DB        
      TMP = DBLEQ(DBI)        
CD    TMP = DBLE (DBI)        
      DO 490 I = 1,NORD        
      V1(I) = V2(I)        
      V3(I) = V3(I)*TMP        
  490 V2(I) = V3(I)        
      GO TO 70        
C        
  500 MORD = IFN        
      WRITE (IO,600) UWM,MORD        
      GO TO 630        
C        
  600 FORMAT (A25,' 2387, PROBLEM SIZE REDUCED TO',I5,' DUE TO -', /5X, 
     1        'ORTHOGONALITY DRIFT OR NULL TRIAL VECTOR', /5X,        
     2        'ALL EXISTING MODES MAY HAVE BEEN OBTAINED.  USE DIAG 16',
     3        ' TO DETERMINE ERROR BOUNDS',/)        
  610 FORMAT (5X,'TRIDIAGONAL ELEMENTS ROW (IFN)',I5, /5X,'MORD =',I5,  
     1        ', AII,DB,D = ',1P,3D16.8)        
  620 FORMAT (11X,'ORTH ITER (IX)',I5,',  MAX PROJ (SDMAX)',1P,D16.8,   
     1        ',  NORMAL FACT (DSQ)',1P,D16.8)        
C        
  630 NAME(3) = NAME(5)        
      CALL CONMSG (NAME,3,0)        
      RETURN        
      END        
