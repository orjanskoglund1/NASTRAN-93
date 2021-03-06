      SUBROUTINE XSOSGN        
C        
C     THIS SUBROUTINE SCANS THE OSCAR TAPE AND GENERATES THE SOS + MD   
C        
C     LAST REVISED BY G.CHAN/UNISYS TO REMOVE THE VAX AND NOT-VAX       
C     LOGICS, AND TO SYNCHRONIZE THE SCRATH FILE NAMES AS SET FORTH BY  
C     THE XSEMX ROUTINES.   2/1990        
C        
      IMPLICIT INTEGER (A-Z)        
C     LOGICAL         DEC        
      EXTERNAL        ANDF,ORF,LSHIFT,RSHIFT        
      DIMENSION       BLOCK1(93),STR(30),NSOSGN(2),FEQU(1),FNTU(1),     
     1                FON(1),FORD(1),MINP(1),MLSN(1),MOUT(1),MSCR(1),   
     2                SAL(1),SDBN(1),SNTU(1),SORD(1),BLOCK(100),        
     3                NUMBR(10)        
      CHARACTER       UFM*23,UWM*25,UIM*29,SFM*25        
      COMMON /XMSSG / UFM,UWM,UIM,SFM        
      COMMON /SYSTEM/ IBUFSZ,OUTTAP        
      COMMON /XFIAT / FIAT(1),FMXLG,FCULG,FILE(1),FDBN(2),FMAT(1)       
      COMMON /XFIST / FIST        
      COMMON /XDPL  / DPD(1),DMXLG,DCULG,DDBN(2),DFNU(1)        
CZZ   COMMON /ZZXSEM/ BUF1(1)        
      COMMON /ZZZZZZ/ BUF1(1)        
      COMMON /XSFA1 / MD(401),SOS(1501),COMM(20),XF1AT(1),FPUN(1),      
     1                FCUM(1),FCUS(1),FKND(1)        
      COMMON /ISOSGN/ ENTN5,ENTN6,K,J,STR        
      EQUIVALENCE     (DPD(1),DNAF),(FIAT(1),FUNLG),(FILE(1),FEQU(1)),  
     1                (FILE(1),FORD(1)),(BLOCK(8),BLOCK1(1))        
      EQUIVALENCE     (MD(1),MLGN),(MD(2),MLSN(1)),(MD(3),MINP(1)),     
     1                (MD(4),MOUT(1)),(MD(5),MSCR(1)),        
     2                (SOS(1),SLGN),(SOS(2),SDBN(1)),        
     3                (SOS(4),SAL(1),SNTU(1),SORD(1)),        
     4                (COMM(1),ALMSK),(COMM(2),APNDMK),(COMM(3),CURSNO),
     5                (COMM(4),ENTN1),(COMM(5),ENTN2 ),(COMM (6),ENTN3),
     6                (COMM(7),ENTN4),(COMM(8),FLAG  ),(COMM (9),FNX  ),
     7                (COMM(10),LMSK),(COMM(11),LXMSK),(COMM(13),RMSK ),
     8                (COMM(14),RXMSK),(COMM(15),S  ),(COMM(16),SCORNT),
     9                (COMM(17),TAPMSK),(COMM(19),ZAP),        
     O                (XF1AT(1),FNTU(1),FON(1))        
      DATA    JUMP  / 4HJUMP/, REPT /4HREPT/,  COND/4HCOND/        
      DATA    OSCAR / 4HPOOL/, SCRN1,SCRN2 / 4HSCRA,4HTCH0/        
      DATA    NSOSGN/ 4HXSOS , 2HGN /        
      DATA    NUMBR / 1H1,1H2,1H3,1H4,1H5,1H6,1H7,1H8,1H9,1H0  /        
C        
      IFLAG = 0        
      CALL OPEN (*500,OSCAR,BUF1,2)        
      CALL BCKREC (OSCAR)        
      CALL READ (*400,*600,OSCAR,BLOCK,7,0,FLAG)        
      IF (BLOCK(2) .NE. CURSNO) GO TO 900        
      GO TO 103        
C        
C     READ OSCAR FORMAT HEADER + 1        
C        
  100 IF (J.GT.1400 .OR. K.GT.390) GO TO 410        
      CALL READ (*400,*600,OSCAR,BLOCK,7,0,FLAG)        
  103 BLOCK(3) = ANDF(RMSK,BLOCK(3))        
      IF (BLOCK(6) .GE. 0) GO TO 108        
      IF (BLOCK(3) .LE. 2) GO TO 110        
      IF (BLOCK(3) .NE. 3) GO TO 108        
      L = RSHIFT(ANDF(LXMSK,BLOCK(7)),16) - BLOCK(2)        
      IF (BLOCK(4) .NE. JUMP) GO TO 106        
      IF (L .LE. 1) GO TO 107        
      DO 104 I = 1,L        
      CALL FWDREC (*400,OSCAR)        
  104 CONTINUE        
      GO TO 100        
  106 IF (BLOCK(4).NE.REPT .AND. BLOCK(4).NE.COND) GO TO 108        
  107 IF (L .LT. 0) IFLAG = -1        
  108 CALL FWDREC (*400,OSCAR)        
      GO TO 100        
C        
C     INPUT FILES        
C        
  110 MINP(K) = BLOCK(7)        
      IF (BLOCK(7) .EQ. 0) GO TO 300        
      NWDS= BLOCK(7)*ENTN5        
      ASSIGN 150 TO ISW        
C        
C     FILES READER        
C        
  130 CALL READ (*400,*600,OSCAR,BLOCK1,NWDS+1,0,FLAG)        
      BLKCNT = 0        
      DO 145 I = 1,NWDS,ENTN5        
      IF (BLOCK1(I) .EQ.  0) GO TO 140        
      SOS(J  ) = BLOCK1(I  )        
      SOS(J+1) = BLOCK1(I+1)        
      SOS(J+2) = BLOCK1(I+2)        
      J = J+3        
      IF (J .GT. 1500) GO TO 460        
      GO TO 145        
  140 BLKCNT = BLKCNT + 1        
  145 CONTINUE        
      GO TO ISW, (150,170)        
C        
  150 MINP(K) = MINP(K) - BLKCNT        
      IF (BLOCK(3) .EQ. 2) GO TO 310        
C        
C     OUTPUT FILES        
C        
      MOUT(K) = BLOCK1(NWDS+1)        
  155 IF (MOUT(K) .EQ. 0) GO TO 320        
      NWDS = MOUT(K)*ENTN6        
      ASSIGN 170 TO ISW        
      GO TO 130        
C        
  170 MOUT(K) = MOUT(K) - BLKCNT        
  175 CALL FWDREC (*400,OSCAR)        
C        
C     SCRATCH FILES        
C        
      MSCR(K) = BLOCK1(NWDS+1)        
      IF (MSCR(K) .EQ. 0) GO TO 230        
      L = MSCR(K)        
C     MASK = COMPLF(LSHIFT(2**NBPC-1,MACSFT))        
C     DEC  = MACH.EQ.5 .OR. MACH.EQ.6 .OR. MACH.EQ.21        
C     IF (.NOT.DEC) KSCR = LSHIFT(RSHIFT(BCDZRO,NBPW-NBPC),MACSFT)      
C     IF (     DEC) KSCR = KHRFN1(0,1,BCDZRO,1)        
C     KSCR1 = LSHIFT(1,MACSFT)        
C     DO 220  I = 1,L        
C     KSCR   = KSCR + KSCR1        
C     SOS(J) = SCRN1        
C     IF (.NOT.DEC) SOS(J+1) = ORF(ANDF(SCRN2,MASK),KSCR)        
C     IF (     DEC) SOS(J+1) = KHRFN1(SCRN2,4,KSCR,1)        
      SCRN3  = SCRN2        
      LLL = 1        
      LL  = 0        
      DO 220 I = 1,L        
      LL  = LL + 1        
      IF (LL .EQ. 10) SCRN3 = KHRFN1(SCRN3,3,NUMBR(LLL),1)        
      SOS(J  ) = SCRN1        
      SOS(J+1) = KHRFN1(SCRN3,4,NUMBR(LL),1)        
      IF (LL .NE. 10) GO TO 200        
      LL  = 0        
      LLL = LLL + 1        
  200 IF (STR(I) .EQ. 0) GO TO 210        
      N1= STR(I)        
      SOS(N1) = ORF(LMSK,BLOCK(2))        
  210 STR(I)  = J + 2        
      SOS(J+2)= SCORNT + I        
      J = J + 3        
      IF (J .GT. 1500) GO TO 460        
  220 CONTINUE        
C        
  230 MLSN(K) = BLOCK(2)        
      IF (IFLAG .EQ. 0)  GO TO 240        
      MLSN(K) = ORF(S,MLSN(K))        
  240 IF (MINP(K)+MOUT(K)+MSCR(K) .EQ. 0) GO TO 100        
      K= K + ENTN3        
      IF (K .GT. 400) GO TO 460        
      GO TO 100        
C        
C     ZERO INPUT FILES        
C        
  300 CALL READ (*400,*600,OSCAR,BLOCK(7),1,0,FLAG)        
      IF (BLOCK(3) .EQ. 2) GO TO 310        
      MOUT(K) = BLOCK(7)        
      GO TO 155        
C        
C     TYPE O FORMAT - NO OUTPUTS        
C        
  310 MOUT(K) = 0        
      GO TO 175        
C        
C     ZERO OUTPUT FILES        
C        
  320 CALL READ (*400,*600,OSCAR,BLOCK1(NWDS+1),1,0,FLAG)        
      GO TO 175        
C        
  400 CALL SKPFIL (OSCAR,-1)        
  410 CALL CLOSE  (OSCAR, 2)        
      SLGN = (J-1)/ENTN2        
      MLGN = (K-1)/ENTN3        
      RETURN        
C        
C     SYSTEM FATAL MESSAGES        
C        
  460 WRITE  (OUTTAP,461) SFM        
  461 FORMAT (A25,' 1011, MD OR SOS TABLE OVERFLOW')        
      GO TO  1000        
  500 WRITE  (OUTTAP,501) SFM        
  501 FORMAT (A25,' 1012, POOL COULD NOT BE OPENED')        
      GO TO  1000        
  600 WRITE  (OUTTAP,601) SFM        
  601 FORMAT (A25,' 1013, ILLEGAL EOR ON POOL')        
      GO TO  1000        
  900 WRITE  (OUTTAP,901) SFM,BLOCK(2),CURSNO        
  901 FORMAT (A25,' 1014, POOL FILE MIS-POSITIONED ',2I7)        
 1000 CALL MESAGE (-37,0,NSOSGN)        
      RETURN        
      END        
