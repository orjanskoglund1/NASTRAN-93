      SUBROUTINE STRI32        
C        
C     ROUTINE TO RECOVER CTRIA3 ELEMENT FORCES, STRAINS, AND STRESSES.  
C     PHASE 2.        
C        
C     WAS NAMED T3ST2D/S (DISP) IN UAI CODE        
C        
C     ALGORITHM:        
C        
C     1- STRAIN RECOVERY DATA IS SENT BY PHASE 1 THRU PH1OUT IN /SDR2X7/
C        WHICH INCLUDES ALL THE NECESSARY TRANSFORMATIONS AND STRAIN    
C        RECOVERY MATRICES. A MAJOR PORTION OF THE DATA IS REPEATED FOR 
C        EACH STRESS EVALUATION POINT.        
C     2- GLOBAL DISPLACEMENT VECTOR, WHICH RESIDES IN CORE, IS PASSED TO
C        THE ROUTINE THRU THE CALLING SEQUENCE.        
C     3- NSTROP IN /SDR2C1/ CONTAINS THE STRESS OUTPUT REQUEST OPTION   
C        FOR THE CURRENT SUBCASE.        
C     4- WORD 151 OF /SDR2DE/ CONTAINS THE STRAIN OUTPUT REQUEST OPTION 
C        FOR THE CURRENT SUBCASE (NEPSOP).        
C     5- ELEMENT/GRID POINT TEMPERATURE DATA ENTERS THE ROUTINE THRU    
C        /SDR2DE/ (POSITIONS 97-129.)        
C     6- ELEMENT STRAINS ARE CALCULATED, CORRECTED FOR THERMAL STRAINS, 
C        AND PREMULTIPLIED BY [G].        
C        
C        
C     *****************       RESIDES IN COMMON BLOCK /SDR2X7/        
C     PH1OUT DATA BLOCK       TOTAL NO. OF WORDS =  713        
C     *****************        
C        
C     PH1OUT( 1)    = ELID, ELEMENT ID        
C     PH1OUT( 2- 4) = SIL NUMBERS        
C     PH1OUT( 5- 7) = ARRAY IORDER        
C     PH1OUT( 8)    = TSUB0, REFERENCE TEMP.        
C     PH1OUT( 9-10) = Z1 AND Z2, FIBER DISTANCES        
C     PH1OUT(11)    = ID OF THE ORIGINAL PCOMPI PROPERTY ENTRY        
C     PH1OUT(12)    = DUMMY WORD (FOR ALLIGNMENT)        
C        
C     PH1RST( 1)    = AVGTHK, AVERAGE THICKNESS        
C     PH1RST( 2)    = MOMINR, MOMENT OF INER. FACTOR        
C     PH1RST( 3-38) = 6X6 MATERIAL PROPERTY (NO SHEAR)        
C     PH1RST(39-41) = THERMAL EXPANSION COEFFICIENTS FOR MEMBRANE       
C     PH1RST(42-44) = THERMAL EXPANSION COEFFICIENTS FOR BENDING        
C     PH1RST(45-47) = NODAL   THICKNESSES        
C     PH1RST(48)    = OFFSET OF ELEMENT FROM GP PLANE        
C     PH1RST(49-57) = 3X3 USER-TO-MATERIAL COORD. TRANSF. MATRIX, UEM   
C     PH1RST(58-66) = 3X3 ELEM-TO-STRSS/STRAIN  TRANSF. TENSOR, TES     
C     PH1RST(67-93) = 3X3 GLOBAL-TO-ELEM COORD. TRANSF. MATRICES, TEG,  
C                     ONE FOR EACH NODE        
C        
C     THE FOLLOWING IS REPEATED FOR EACH EVALUATION POINT (4 TIMES).    
C     THE EVALUATION POINTS ARE AT THE CENTER OF THE ELEMENT AND        
C     STANDARD TRIANGULAR POINTS. THE CHOICE OF THE FINAL STRESS/       
C     FORCE OUTPUT POINTS IS MADE AT THE SUBCASE LEVEL (PHASE 2).       
C        
C              1             ELEMENT THICKNESS AT THIS POINT        
C            2 - 5           OUT-OF-PLANE-SHEAR-FORCE/STRAIN MATRIX     
C            6 - 8           ELEMENT SHAPE FUNCTION VALUES        
C          8+1 - 8+8*NDOF    STRAIN RECOVERY MATRIX        
C        
C        
      EXTERNAL        ANDF        
      LOGICAL         COMPOS,STSREQ,STNREQ,FORREQ,TEMPER,TEMPP1,TEMPP2, 
     1                GRIDS ,VONMS ,LAYER ,BENDNG,STRCUR,        
     2                GRIDSS,VONMSS,LAYERS        
      INTEGER         ELID,CENTER,EXTRNL,        
     1                FLAG,COMPS,ANDF,LDTEMP,DEVICE,OES1L,OEF1L,OES1AL  
      REAL            G(6,6),ALFAM(3),ALFAB(3),GPTH(3),STEMP(8)        
      COMMON /BLANK / APP(2),SORT2,IDUM(2),COMPS        
CZZ   COMMON /ZZSDR2/ DISP(1)        
      COMMON /ZZZZZZ/ DISP(1)        
      COMMON /SDR2X2/ DUMM(30),OES1L,OEF1L        
      COMMON /SDR2X4/ DUMMY(35),IVEC,IVECN,LDTEMP        
C    1,               DUM(13),KTYPE        
      COMMON /SDR2C1/ IPCMP,NPCMP,IPCMP1,NPCMP1,IPCMP2,NPCMP2,NSTROP    
      COMMON /SDR2DE/ KSDRDE(200)        
      COMMON /SDR2X7/ ELID,KSIL(3),IORDER(3),TSUB0,Z1O,Z2O,IPID,        
     1                IDUMAL,PH1RST(701)        
      COMMON /SDR2X8/ EXTRNL(6),IGRID(4),IDR(3),INDXG2(3,3),THIKNS(4),  
     1                Z12(2,4),DELTA(39),DELTAT(6),TDELTA(6),G2(3,3),   
     2                U(36),STEMPD(3),EPSLN(8),EPSLNM(6),EPSLNT(6),     
     3                VXVY(2),EPSCSI(6,4),EPSUSI(6,4),QVECI(2,4),       
     4                EPSCMI(6,4),EPSUMI(6,4),TES(9),UES(9),VES(4),     
     5                UEM(9),G2ALFB(3,4),        
     6                GDUM,DETG2,T3OV12,OFFSET,TBAR        
      COMMON /OUTREQ/ STSREQ,STNREQ,FORREQ,STRCUR,GRIDS,VONMS,LAYER,    
     1                GRIDSS,VONMSS,LAYERS        
      COMMON /TMPDAT/ TEMPER,TEMPP1,TEMPP2        
      EQUIVALENCE     (IZ1O,Z1O),(IZ2O,Z2O),        
     1                (AVGTHK,PH1RST(1)),(MOMINR,PH1RST(2)),        
     2                (G(1,1),PH1RST(3)),(ALFAM(1),PH1RST(39)),        
     3                (ALFAB(1),PH1RST(42)),(GPTH(1),PH1RST(45)),       
     4                (DEVICE,KSDRDE(2)),(NEPSOP,KSDRDE(151)),        
     5                (KSTRS,KSDRDE(42)),(KSTRN ,KSDRDE(142)),        
     6                (KFORC,KSDRDE(41)),(STEMP(1),KSDRDE(97)),        
     7                (STEMP(7),FLAG)   ,(OES1AL,OES1L)        
      DATA    ISTART/ 93    /        
      DATA    CENTER/ 4HCNTR/        
      DATA    NBLNK / 4HBLNK/        
C        
C     INITIALIZE        
C        
C     NNODE  = TOTAL NUMBER OF NODES        
C     NDOF   = TOTAL NUMBER OF DEGREES OF FREEDOM        
C     LDTEMP = FLAG INDICATING THE PRESENCE OF TEMPERATURE LOADS        
C     ICOUNT = POINTER FOR PH1RST DATA        
C        
C     STRCUR = STRAIN/CURVATURE OUTPUT REQUEST FLAG        
C        
      NNODE  = 3        
      NDOF   = 6*NNODE        
      NDOF8  = 8*NDOF        
      TEMPER = LDTEMP .NE. -1        
      BENDNG = MOMINR .GT. 0.0        
C        
C     CHECK FOR OFFSET AND COMPOSITES        
C        
      OFFSET = PH1RST(48)        
      COMPOS = COMPS.EQ.-1 .AND. IPID.GT.0        
C        
C     CHECK THE OUTPUT STRESS FORCE AND STRAIN REQUESTS        
C        
      STSREQ = KSTRS .EQ. 1        
      FORREQ = KFORC .EQ. 1        
      STNREQ = KSTRN .EQ. 1        
C        
C     STRESS OUTPUT REQUEST FLAGS        
C        
C     GRIDS = ANDF(NSTROP, 1).NE.0        
C     VONMS = ANDF(NSTROP, 8).NE.0        
C     LAYER = ANDF(NSTROP,32).NE.0 .AND. COMPOS .AND. KTYPE.EQ.1        
C        
      GRIDS = .FALSE.        
      VONMS = ANDF(NSTROP,1) .NE. 0        
      LAYER = ANDF(NSTROP,2) .NE. 0        
C        
C     STRAIN OUTPUT REQUEST FLAGS        
C        
C     GRIDSS = ANDF(NEPSOP,  1).NE.0 .AND. STNREQ        
C     VONMSS = ANDF(NEPSOP,  8).NE.0 .AND. STNREQ        
C     LAYERS = ANDF(NEPSOP, 32).NE.0 .AND. COMPOS .AND. KTYPE.EQ.1      
C     STRCUR = ANDF(NEPSOP,128).NE.0 .AND. STNREQ        
C        
      GRIDSS = .FALSE.        
      VONMSS = .FALSE.        
      LAYERS = .FALSE.        
      STRCUR = .FALSE.        
C        
C     IF USER ERRONEOUSLY REQESTS LAYERED OUTPUT AND THERE ARE NO LAYER-
C     COMPOSITE DATA, SET LAYER FLAGS TO FALSE        
C        
      IF (NPCMP+NPCMP1+NPCMP2 .GT. 0) GO TO 10        
      LAYER  = .FALSE.        
      LAYERS = .FALSE.        
      GO TO 20        
C        
C     USER CORRECTLY REQUESTS LAYERED OUTPUT, BUT CURRENT ELEMENT IS NOT
C     A LAYER-COMPOSITE; SET LAYER FLAGS TO FALSE        
C        
   10 IF (IPID .GT. 0) GO TO 20        
      LAYER  = .FALSE.        
      LAYERS = .FALSE.        
C        
C     SET DEFAULTS FOR FORCE IF STRESS ABSENT        
C        
   20 IF (.NOT.FORREQ .OR. NSTROP.NE.0) GO TO 30        
C     GRIDS = .TRUE.        
      LAYER = .FALSE.        
C        
C     CHECK FOR THE TYPE OF TEMPERATURE DATA (SET BY SDRETD)        
C     - TYPE TEMPP1 ALSO INCLUDES TYPE TEMPP3.        
C     - IF TEMPPI ARE NOT SUPPLIED, GRID POINT TEMPERATURES ARE PRESENT.
C        
   30 TEMPP1 = FLAG .EQ. 13        
      TEMPP2 = FLAG .EQ.  2        
C        
C     GET THE EXTERNAL GRID POINT ID NUMBERS FOR CORRESPONDING SIL NOS. 
C        
C     CALL FNDGID (ELID,3,KSIL,EXTRNL)        
C        
      DO 40 I = 1,NNODE        
   40 EXTRNL(I) = 0        
C        
C     COMMENTS FROM G.C.  2/1990        
C     EXTRNL ARE SET TO ZEROS HERE. IT IS USED LATER FOR SETTING IDR    
C     ARRAY. BOTH EXTRNL AND IDR ARE USED ONLY WHEN GRIDS IS TRUE.      
C     IN COSMIC VERSION, GRIDS IS FALSE.        
C        
C        
C     PREPARE TO REARRANGE STRESSES, STRAINS, AND FORCES ACCORDING TO   
C     EXTERNAL ORDER        
C        
      IF (.NOT.GRIDS .AND. .NOT.GRIDSS) GO TO 70        
      DO 60 INPL = 1,3        
      DO 50 I = 1,NNODE        
      IF (IORDER(I) .NE. INPL) GO TO 50        
      IDR(INPL) = EXTRNL(I)        
      GO TO 60        
   50 CONTINUE        
   60 CONTINUE        
      GO TO 80        
   70 IDR(1) = 1        
      IDR(2) = 2        
      IDR(3) = 3        
C        
C     ARRANGE THE INCOMING DATA        
C        
C     SORT THE GRID TEMPERATURE CHANGES INTO SIL ORDER        
C        
   80 IF (.NOT.TEMPER .OR. (TEMPP1 .AND. TEMPP2)) GO TO 100        
      DO 90 K = 1,NNODE        
      KPOINT = IORDER(K)        
      DELTAT(K) = STEMP(KPOINT)        
   90 CONTINUE        
C        
C     PICK UP THE GLOBAL DISPLACEMENT VECTOR AND TRANSFORM IT INTO THE  
C     ELEMENT COORD. SYSTEM        
C        
  100 DO 120 IDELT = 1,NNODE        
C     JDELT =        KSIL(IDELT) - 1        
      JDELT = IVEC + KSIL(IDELT) - 2        
      KDELT = 6*(IDELT-1) + 1        
      DO 110 LDELT = 1,6        
      TDELTA(LDELT) = DISP(JDELT+LDELT)        
  110 CONTINUE        
C        
C     FETCH [TEG] 3X3 FOR EACH NODE, LOAD IT INTO A 6X6 MATRIX AND      
C     INCLUDE THE EFFECTS OF OFFSET        
C        
      CALL TLDRS  (OFFSET,IDELT,PH1RST(67),U)        
      CALL GMMATS (U,6,6,0, TDELTA,6,1,0, DELTA(KDELT))        
  120 CONTINUE        
C        
C     RECOVER THE STRESS-TO-ELEMENT ORTHOGONAL TRANSFORMATION AND BUILD 
C     THE ELEMENT-TO-STRESS 'STRAIN' TENSOR TRANSFORMATION.        
C     IF LAYER OUTPUT IS REQUESTED, STRAINS MUST BE TRANSFORMED TO THE  
C     MATERIAL COORDINATE SYSTEM.        
C        
      DO 130 I = 1,9        
      UEM(I) = PH1RST(48+I)        
      TES(I) = PH1RST(57+I)        
  130 CONTINUE        
      CALL SHSTTS (TES,UES,VES)        
C        
C     RECOVER STRAINS AT EVALUATION POINTS        
C        
C     THE ARRANGEMENT OF EVALUATION POINTS ON THE MID-SURFACE FOLLOWS   
C     THE SEQUENCE OF GRID POINTS AS INPUT BY THE USER. THEREFORE,      
C     SHUFFLING OF DATA IS ONLY REQUIRED TO MATCH THE USER-DEFINED ORDER
C     OF INPUT.        
C        
C     PRESET THE PH1RST COUNTER TO THE START OF THE REPEATED SECTION    
C     WHICH WILL NOW BE FILLED.        
C        
      ICOUNT = ISTART        
C        
      DO 500 INPLAN = 1,4        
C        
C     MATCH GRID ID NUMBER WHICH IS IN SIL ORDER        
C        
      IGRID(INPLAN) = CENTER        
      IF (INPLAN .LE. 1) GO TO 210        
      DO 200 I = 1,NNODE        
      IF (IORDER(I) .NE. INPLAN-1) GO TO 200        
      IGRID(INPLAN) = EXTRNL(I)        
  200 CONTINUE        
C        
C     THICKNESS AND MOMENT OF INERTIA AT THIS POINT        
C        
  210 THIKNS(INPLAN) = PH1RST(ICOUNT+1)        
      IF ((GRIDS .OR. GRIDSS) .AND. INPLAN.NE.1)        
     1     THIKNS(INPLAN) = GPTH(INPLAN-1)        
      T3OV12 = THIKNS(INPLAN)**3/12.0        
C        
C     DETERMINE FIBER DISTANCE VALUES        
C        
      Z12(1,INPLAN) = Z1O        
      IF (IZ1O .EQ. NBLNK) Z12(1,INPLAN) =-0.5*THIKNS(INPLAN)        
C        
      Z12(2,INPLAN) = Z2O        
      IF (IZ2O .EQ. NBLNK) Z12(2,INPLAN) = 0.5*THIKNS(INPLAN)        
C        
C        
C     FIRST COMPUTE LOCAL STRAINS UNCORRECTED FOR THERMAL STRAINS AT    
C     THIS EVALUATION POINT.        
C        
C     EPSLN = PH1RST(KSIG) * DELTA        
C       EPS =        B     *   U        
C       8X1        8XNDOF    NDOFX1        
C        
      CALL GMMATS (PH1RST(ICOUNT+9),8,NDOF,0, DELTA(1),NDOF,1,0, EPSLN) 
C        
      IF (.NOT.LAYER .AND. .NOT.LAYERS) GO TO 230        
C        
C     TRANSFORM UNCORRECTED STRAINS FROM ELEMENT TO MATERIAL COORD.     
C     SYSTEM TO BE USED FOR ELEMENT LAYER STRAINS        
C        
      CALL GMMATS (UEM(1),3,3,0, EPSLN(1),3,1,0, EPSUMI(1,INPLAN))      
      CALL GMMATS (UEM(1),3,3,0, EPSLN(4),3,1,0, EPSUMI(4,INPLAN))      
C        
      DO 220 I = 1,6        
      EPSCMI(I,INPLAN) = EPSUMI(I,INPLAN)        
  220 CONTINUE        
C        
  230 IF (.NOT.FORREQ .AND. LAYER .AND. LAYERS) GO TO 250        
C        
C     TRANSFORM UNCORRECTED STRAINS FROM ELEMENT TO STRESS COORD. SYSTEM
C     TO BE USED FOR ELEMENT STRAINS        
C        
      CALL GMMATS (UES(1),3,3,0, EPSLN(1),3,1,0, EPSUSI(1,INPLAN))      
      CALL GMMATS (UES(1),3,3,0, EPSLN(4),3,1,0, EPSUSI(4,INPLAN))      
C        
      DO 240 I = 1,6        
      EPSCSI(I,INPLAN) = EPSUSI(I,INPLAN)        
  240 CONTINUE        
C        
C     IF REQUIRED, COMPUTE SHEAR FORCES AT THIS EVALUATION POINT IN THE 
C     ELEMENT COORD. SYSTEM, THEN TRANSFORM AND STORE THEM. CONSULT     
C     SHSTTS DOCUMENTATION ON WHY [VES] MAY BE USED TO TRANSFORM FORCES 
C     DESPITE THE FACT THAT IT IS MEANT FOR STRAINS.        
C     SHEAR STRAINS MAY NOT BE TRANSFORMED BEFORE MULTIPLICATION BECAUSE
C     [G3] IS DIRECTION-DEPENDENT.        
C        
  250 IF (.NOT.(FORREQ .OR. LAYER .OR. LAYERS)) GO TO 260        
      CALL GMMATS (PH1RST(ICOUNT+2),2,2,0, EPSLN(7),2,1,0, VXVY)        
      CALL GMMATS (VES(1),2,2,0, VXVY,2,1,0, QVECI(1,INPLAN))        
C        
C     CALCULATE THERMAL STRAINS IF TEMPERATURES ARE PRESENT        
C        
  260 IF (.NOT.TEMPER) GO TO 420        
      DO 270 IET = 1,6        
      EPSLNT(IET) = 0.0        
  270 CONTINUE        
C        
C     MEMBRANE STRAINS        
C        
      IF (.NOT.TEMPP1 .AND. .NOT.TEMPP2) GO TO 280        
      TBAR = STEMP(1)        
      GO TO 300        
  280 TBAR = 0.0        
      DO 290 ISH = 1,NNODE        
      TBAR = TBAR + PH1RST(ICOUNT+5+ISH)*DELTAT(ISH)        
  290 CONTINUE        
C        
  300 DO 310 IEPS = 1,3        
      EPSLNT(IEPS) = (TBAR-TSUB0)*ALFAM(IEPS)        
  310 CONTINUE        
C        
C     BENDING STRAINS (ELEMENT TEMPERATURES ONLY)        
C        
      IF (.NOT.BENDNG .OR. .NOT.(TEMPP1 .AND. TEMPP2)) GO TO 390        
C        
C     EXTRACT [G2] FROM [G]        
C        
      DO 330 IG2 = 1,3        
      DO 320 JG2 = 1,3        
      G2(IG2,JG2) = G(IG2+3,JG2+3)        
  320 CONTINUE        
  330 CONTINUE        
      CALL GMMATS (G2,3,3,0, ALFAB,3,1,0, G2ALFB(1,INPLAN))        
C        
      IF (.NOT.TEMPP2) GO TO 370        
      DO 350 IG2 = 1,3        
      DO 340 JG2 = 1,3        
      G2(IG2,JG2) = G2(IG2,JG2)*T3OV12        
  340 CONTINUE        
  350 CONTINUE        
C        
      DO 360 ITMP = 1,3        
      STEMPD(ITMP) = STEMP(ITMP+1)        
  360 CONTINUE        
C        
      CALL INVERS (3,G2,3,GDUM,0,DETG2,ISNGG2,INDXG2)        
      CALL GMMATS (G2,3,3,0, STEMPD,3,1,0, EPSLNT(4))        
      GO TO 390        
C        
  370 IF (.NOT.TEMPP1) GO TO 390        
      TPRIME = STEMP(2)        
      DO 380 IEPS = 4,6        
      EPSLNT(IEPS) = -TPRIME*ALFAB(IEPS-3)        
  380 CONTINUE        
  390 CONTINUE        
C        
C     CORRECT STRAINS FOR THERMAL EFFECTS        
C        
      DO 400 I = 1,6        
      EPSLNM(I) = EPSLN(I) - EPSLNT(I)        
  400 CONTINUE        
C        
      IF (.NOT.LAYER) GO TO 410        
C        
C     TRANSFORM CORRECTED STRAINS FROM ELEMENT TO MATERIAL COOR. SYSTEM 
C     TO BE USED FOR ELEMENT LAYER STRESSES        
C        
      CALL GMMATS (UEM(1),3,3,0, EPSLNM(1),3,1,0, EPSCMI(1,INPLAN))     
      CALL GMMATS (UEM(1),3,3,0, EPSLNM(4),3,1,0, EPSCMI(4,INPLAN))     
C        
  410 IF (LAYER .AND. .NOT.FORREQ) GO TO 420        
C        
C     TRANSFORM CORRECTED STRAINS FROM ELEMENT TO STRESS COORD. SYSTEM  
C     TO BE USED FOR ELEMENT STRESSES AND ELEMENT (LAYER) FORCES        
C        
      CALL GMMATS (UES(1),3,3,0, EPSLNM(1),3,1,0, EPSCSI(1,INPLAN))     
      CALL GMMATS (UES(1),3,3,0, EPSLNM(4),3,1,0, EPSCSI(4,INPLAN))     
C        
C     CORRECT THE CURVATURE SIGNS WHEN THE Z-AXIS OF THE TARGET STRESS  
C     COORD. SYSTEM IS FLIPPED WITH RESPECT TO THE USER COORD. SYSTEM.  
C     THIS DOES NOT AFFECT THE MEMBRANE STRAINS, AND TRANSVERSE SHEAR   
C     STRAIN TRANSFORMATION TAKES CARE OF THOSE COMPONENTS.        
C        
  420 IF (PH1RST(66) .GE. 0.0) GO TO 440        
      DO 430 I = 4,6        
      EPSCMI(I,INPLAN) = -EPSCMI(I,INPLAN)        
      EPSCSI(I,INPLAN) = -EPSCSI(I,INPLAN)        
      EPSUMI(I,INPLAN) = -EPSUMI(I,INPLAN)        
      EPSUSI(I,INPLAN) = -EPSUSI(I,INPLAN)        
  430 CONTINUE        
C        
C     END OF THE STRAIN RECOVERY LOOP        
C        
C     INCREMENT THE PH1RST POINTER        
C        
  440 ICOUNT = ICOUNT + 8 + NDOF8        
  500 CONTINUE        
C        
C        
C     IF REQUIRED, EXTRAPOLATE NON-CENTER VALUES FROM EVALUATION POINTS 
C     TO GRID POINTS.        
C        
      IF (GRIDSS) CALL SHXTRS (6,NNODE,EPSUSI(1,2))        
      IF (GRIDS ) CALL SHXTRS (6,NNODE,EPSCSI(1,2))        
      IF (GRIDS .AND. FORREQ) CALL SHXTRS (2,NNODE,QVECI(1,2))        
C        
C     CALCULATE AND OUTPUT STRESSES        
C        
      IF (STSREQ .AND. .NOT.LAYER)        
     1    CALL SHSTSS (4,ELID,IGRID,THIKNS,Z12,G,EPSCSI,STEMP,TBAR,     
     2                 G2ALFB,BENDNG,IDR)        
C        
C     CALCULATE AND OUTPUT STRAINS        
C        
      IF (STNREQ .AND. .NOT.LAYERS)        
     1    CALL SHSTNS (4,ELID,IGRID,Z12,EPSUSI,BENDNG,IDR)        
C        
C     CALCULATE AND OUTPUT FORCES        
C        
      IF (FORREQ .OR. LAYER .OR. LAYERS)        
     1   CALL SHFORS (4,ELID,IGRID,THIKNS,G,EPSCSI,QVECI,IDR)        
C        
C     CALCULATE AND OUTPUT LAYER-RELATED INFORMATION        
C        
      IF (LAYER .OR. LAYERS)        
     1   CALL SHLSTS (ELID,IPID,AVGTHK,EPSUMI,EPSCMI)        
C        
      RETURN        
      END        
