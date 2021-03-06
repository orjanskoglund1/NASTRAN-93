      SUBROUTINE USRMSG (I)        
C        
C     USRMSG WILL PRINT THE INDICATED USER LEVEL ERROR MESSAGE        
C        
      INTEGER         A,B,C,D,E,F,UO,UM,US,UR,UL,L,P1,P2,OUTTAP,BLANK,  
     1                BCD(5)        
      DIMENSION       ITYPE(6),LIST(10),ICRIGD(4),NAME(2)        
      CHARACTER       QUAD4*6,TRIA3*6,INTER*8,EXTER*8,EXIN*8        
      CHARACTER       UFM*23,UWM*25,UIM*29,SFM*25,SWM*27        
      COMMON /XMSSG / UFM,UWM,UIM,SFM,SWM        
      COMMON /SYSTEM/ SYSBUF,OUTTAP        
      COMMON /MACHIN/ MACH        
      COMMON /MSGX  / N,M,MSG(4,1)        
      DATA    BLANK / 3H   /, LIMIT / 234  /, I2015 / 0       /        
      DATA    BCD   / 4H  UM, 4H  US, 4H  UO, 4HUAUR, 4HUAUL        /   
      DATA    ITYPE / 4HDARE, 4HA   , 4HDELA, 4HY   , 4HDPHA, 4HSE  /   
      DATA    ICRIGD/ 1H1   , 1H2   , 1H3   , 1HR                   /   
      DATA    LIST  / 15, 41, 79,103, 117, 137, 199, 211, 212, 215  /   
      DATA    AX,RG / 2HAX,  2HRG   / , NAME  / 4HUSRM,4HSG   /        
      DATA    INTER / 'INTERNAL'    / , EXTER / 'EXTERNAL'    /        
      DATA    QUAD4 , TRIA3 / 'CQUAD4', 'CTRIA3'   /        
C        
C        
      L  = MSG(2,I)        
      P1 = MSG(3,I)        
      P2 = MSG(4,I)        
      IF (L.LE.0 .OR. L.GT.LIMIT) GO TO 9000        
      DO 800 J = 1,10        
      IF (L .EQ. LIST(J)) GO TO 810        
  800 CONTINUE        
      J = 2        
      IF (L .EQ. 92) J = 4        
      IF (L .NE. 15) GO TO 820        
      J = 3        
      IF (I2015 .GT.  4) J = 1        
      IF (I2015 .GE. 31) J = 0        
      GO TO 820        
  810 J = 3        
  820 CALL PAGE2 (J)        
      LOCAL = L - 120        
      IF (LOCAL .GT. 0) GO TO 830        
      GO TO (01,002,003,004,005,006,007,008,009,010,011,012,013,014,015,
     1      016,017,018,019,020,021,022,023,024,025,026,027,028,029,030,
     2      031,032,033,034,035,036,037,038,039,040,041,042,043,044,045,
     3      046,047,048,049,050,051,052,053,054,055,056,057,058,059,060,
     4      061,062,063,064,065,066,067,068,069,070,071,072,073,074,075,
     5      076,077,078,079,080,081,082,083,084,085,086,087,088,089,090,
     6      091,092,093,094,095,096,097,098,099,100,101,102,103,104,105,
     7      106,107,108,109,110,111,112,113,114,115,116,117,118,119,120 
     8      ),  L        
  830 GO TO(121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,
     9      136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,
     *      151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,
     A      166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,
     B      181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,
     C      196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,
     D      211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,
     E      226,227,228,229,230,231,232,233,234),  LOCAL        
    1 WRITE (OUTTAP,1010) UFM,P1        
      GO TO 5500        
    2 WRITE (OUTTAP,1020) SFM,P1        
      GO TO 5500        
    3 WRITE (OUTTAP,1030) UFM,P2,P1        
      GO TO 5500        
    4 WRITE (OUTTAP,1040) UFM,P2,P1        
      GO TO 5500        
    5 WRITE (OUTTAP,1050) SFM        
      GO TO 5500        
    6 WRITE (OUTTAP,1060) UFM,P1,P2        
      GO TO 5500        
    7 WRITE (OUTTAP,1070) UFM,P1,P2        
      GO TO 5500        
    8 WRITE (OUTTAP,1080) UFM,P1,P2        
      GO TO 5500        
    9 WRITE (OUTTAP,1090) UFM,P1,P2        
      GO TO 5500        
   10 WRITE (OUTTAP,1100) UFM,P1,P2        
      GO TO 5500        
   11 WRITE (OUTTAP,1110) UFM,P1,P2        
      GO TO 5500        
   12 WRITE (OUTTAP,1120) UFM,P1        
      GO TO 5500        
   13 WRITE (OUTTAP,1130) UWM        
      GO TO 5600        
   14 WRITE (OUTTAP,1140) UFM        
      GO TO 5500        
   15 I2015 = I2015 + 1        
      IF (I2015 .EQ. 30) WRITE (OUTTAP,1152)        
      IF (I2015 .GE. 30) GO TO 5600        
      IF (I2015 .EQ.  4) WRITE (OUTTAP,1153)        
      EXIN = INTER        
      IF (P2 .NE. 0) EXIN = EXTER        
      IF (P2 .NE. 0) P1 = P2        
      IF (I2015 .LE. 3) WRITE (OUTTAP,1150) UWM,EXIN,P1        
      IF (I2015 .GT. 3) WRITE (OUTTAP,1151) UWM,EXIN,P1        
      GO TO 5600        
   16 WRITE (OUTTAP,1160) UFM        
      GO TO 5500        
   17 WRITE (OUTTAP,1170) UFM,P1        
      GO TO 5500        
   18 WRITE (OUTTAP,1180) UFM,P1        
      GO TO 5500        
   19 WRITE (OUTTAP,1190) UFM,P1        
      GO TO 5500        
   20 WRITE (OUTTAP,1200) UFM,P1        
      GO TO 5500        
   21 WRITE (OUTTAP,1210) UFM        
      GO TO 5500        
   22 WRITE (OUTTAP,1220) UFM        
      GO TO 5500        
   23 WRITE (OUTTAP,1230) UFM,P1        
      GO TO 5500        
   24 WRITE (OUTTAP,1240)        
      GO TO 5600        
   25 WRITE (OUTTAP,1250) UFM,P1        
      GO TO 5500        
   26 WRITE (OUTTAP,1260) UFM,P1        
      GO TO 5500        
   27 WRITE (OUTTAP,1270) UFM,P1,P2        
      GO TO 5500        
   28 WRITE (OUTTAP,1280) UFM,P1        
      GO TO 5500        
   29 WRITE (OUTTAP,1290) UFM,P1        
      GO TO 5500        
   30 WRITE (OUTTAP,1300) UFM        
      GO TO 5500        
   31 WRITE (OUTTAP,1310) UFM,P1        
      GO TO 5500        
   32 WRITE (OUTTAP,1320) UFM,P1        
      GO TO 5500        
   33 WRITE (OUTTAP,1330) UFM,P1        
      GO TO 5500        
   34 WRITE (OUTTAP,1340) SFM,P1        
      GO TO 5500        
   35 WRITE (OUTTAP,1350) UFM,P1        
      GO TO 5500        
   36 WRITE (OUTTAP,1360) UFM,P1        
      GO TO 5500        
   37 WRITE (OUTTAP,1370) UFM,P1        
      GO TO 5500        
   38 WRITE (OUTTAP,1380) SFM,P1        
      GO TO 5500        
   39 WRITE (OUTTAP,1390) UFM,P2,P1        
      GO TO 5500        
   40 WRITE (OUTTAP,1400) UFM,P1        
      GO TO 5500        
   41 WRITE (OUTTAP,1410) UFM,P1        
      GO TO 5500        
   42 WRITE (OUTTAP,1420) UFM,P2,P1        
      GO TO 5500        
   43 WRITE (OUTTAP,1430) UFM,P1        
      GO TO 5500        
   44 WRITE (OUTTAP,1440) UFM,P1        
      GO TO 5500        
   45 WRITE (OUTTAP,1450) UFM,P1        
      GO TO 5500        
   46 WRITE (OUTTAP,1460) UFM,P1        
      GO TO 5500        
   47 WRITE (OUTTAP,1470) UFM,P1        
      GO TO 5500        
   48 WRITE (OUTTAP,1480) UFM,P1,P2        
      GO TO 5500        
   49 WRITE (OUTTAP,1490) UFM,P1        
      GO TO 5500        
   50 WRITE (OUTTAP,1500) UFM,P1        
      GO TO 5500        
   51 WRITE (OUTTAP,1510) UFM,P1,P2        
      GO TO 5500        
   52 WRITE (OUTTAP,1520) UFM,P1,P2        
      GO TO 5500        
   53 WRITE (OUTTAP,1530) UFM,P1        
      GO TO 5500        
   54 WRITE (OUTTAP,1540) UFM,P1,P2        
      GO TO 5500        
   55 WRITE (OUTTAP,1550) SFM        
      GO TO 5500        
   56 WRITE (OUTTAP,1560) UFM,P1        
      GO TO 5500        
   57 WRITE (OUTTAP,1570) UFM,P1        
      GO TO 5500        
   58 WRITE (OUTTAP,1580) UWM,P1        
      GO TO 5600        
   59 WRITE (OUTTAP,1590) UFM,P2,P1        
      GO TO 5500        
   60 WRITE (OUTTAP,1600) UFM,P2,P1        
      GO TO 5500        
   61 WRITE (OUTTAP,1610) UFM,P2,P1        
      GO TO 5500        
   62 WRITE (OUTTAP,1620) UFM,P2,P1        
      GO TO 5500        
   63 WRITE (OUTTAP,1630) UFM        
      GO TO 5500        
   64 WRITE (OUTTAP,1640) UFM,P1        
      GO TO 5500        
   65 WRITE (OUTTAP,1650) UFM,P1        
      GO TO 5500        
   66 WRITE (OUTTAP,1660) UFM,P1        
      GO TO 5500        
C*****        
C     DETERMINE NONLINEAR LOAD TYPE AND NONLINEAR LOAD SET ID        
C*****        
   67 LDTYPE = P2 / 100000000        
      LDSET  = P2 - 100000000*LDTYPE        
      WRITE (OUTTAP,1670) UFM,P1,LDTYPE,LDSET        
      GO TO 5500        
   68 WRITE (OUTTAP,1680) UFM,P1,P2        
      GO TO 5500        
   69 WRITE (OUTTAP,1690) UFM,P1,P2        
      GO TO 5500        
   70 WRITE (OUTTAP,1700) UFM,P1,P2        
      GO TO 5500        
C*****        
C     DETERMINE TYPE OF UNDEFINED SET (DAREA, DELAY OR DPHASE)        
C*****        
   71 INDEX = P2 / 100000000        
      P2    = P2 - 100000000*INDEX        
      INDEX = 2*INDEX - 1        
      WRITE (OUTTAP,1710) UFM,P1,ITYPE(INDEX),ITYPE(INDEX+1),P2        
      GO TO 5500        
   72 WRITE (OUTTAP,1720) SWM,P1,P2        
      GO TO 5600        
   73 WRITE (OUTTAP,1730) UIM,P1,P2        
      GO TO 5500        
   74 WRITE (OUTTAP,1740) UFM,P1        
      GO TO 5500        
   75 WRITE (OUTTAP,1750) UFM,P1,P2        
      GO TO 5500        
   76 WRITE (OUTTAP,1760) UWM        
      GO TO 5600        
   77 WRITE (OUTTAP,1770) UWM        
      GO TO 5600        
   78 WRITE (OUTTAP,1780) UWM        
      GO TO 5600        
   79 WRITE (OUTTAP,1790) UWM        
      GO TO 5600        
   80 WRITE (OUTTAP,1800) UWM        
      GO TO 5600        
   81 WRITE (OUTTAP,1810) UFM        
      GO TO 5500        
   82 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
   83 WRITE (OUTTAP,1830) UFM        
      GO TO 5500        
   84 WRITE (OUTTAP,1840) UFM,P1        
      GO TO 5500        
   85 WRITE (OUTTAP,1850) UIM,P1,P2        
      GO TO 5600        
   86 WRITE (OUTTAP,1860) UIM,P1        
      GO TO 5600        
   87 WRITE (OUTTAP,1870) SFM        
      GO TO 5500        
   88 WRITE (OUTTAP,1880) UFM,P1        
      GO TO 5500        
   89 WRITE (OUTTAP,1890) UFM,P1        
      GO TO 5500        
   90 WRITE (OUTTAP,1900) SFM,P1        
      GO TO 5500        
   91 WRITE (OUTTAP,1910) SFM,P1        
      GO TO 5500        
   92 WRITE (OUTTAP,1920) SWM,P1,P2        
      GO TO 5600        
   93 WRITE (OUTTAP,1930) UFM,P1,P2        
      GO TO 5500        
   94 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
   95 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
   96 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
   97 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
   98 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
   99 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  100 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  101 J = P2/10        
      A = P2 - 10*J        
      K = BLANK        
      IF (A .NE. 0) K = A        
      JA = J/10        
      B  = J - 10*JA        
      UM = BLANK        
      IF (B .NE. 0) UM = BCD(1)        
      JB = JA/10        
      C  = JA - 10*JB        
      US = BLANK        
      IF (C .NE. 0) US = BCD(2)        
      JC = JB/10        
      D  = JB - 10*JC        
      UO = BLANK        
      IF (D .NE. 0) UO = BCD(3)        
      JD = JC/10        
      E  = JC - 10*JD        
      UR = BLANK        
      IF (E .NE. 0) UR = BCD(4)        
      JF = JD/10        
      F  = JD - 10*JF        
      UL = BLANK        
      IF (F .NE. 0) UL = BCD(5)        
      IF (A .EQ. 0) WRITE (OUTTAP,2011) UFM,P1,UM,US,UO,UR,UL        
      IF (A .NE. 0) WRITE (OUTTAP,2010) UFM,P1,K,UM,US,UO,UR,UL        
      GO TO 5500        
  102 WRITE (OUTTAP,2020) UWM,P2,P1        
      GO TO 5600        
  103 WRITE (OUTTAP,2030) SFM        
      GO TO 5500        
  104 WRITE (OUTTAP,2040) UFM,P1        
      GO TO 5500        
  105 WRITE (OUTTAP,2050) UFM,P1,P2        
      GO TO 5500        
  106 WRITE (OUTTAP,2060) UFM,P1        
      GO TO 5500        
  107 WRITE (OUTTAP,2070) UFM,P1,P2        
      GO TO 5500        
  108 WRITE (OUTTAP,2080) UFM,P1,P2        
      GO TO 5500        
  109 WRITE (OUTTAP,2090) UFM        
      GO TO 5500        
  110 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  111 WRITE (OUTTAP,2110) UWM,P1        
      GO TO 5600        
  112 WRITE (OUTTAP,2120) UFM,P1        
      GO TO 5500        
  113 WRITE (OUTTAP,2130) UFM,P1        
      GO TO 5500        
  114 WRITE (OUTTAP,2140) UFM,P1        
      GO TO 5500        
  115 WRITE (OUTTAP,2150) UFM,P1,P2        
      GO TO 5500        
  116 WRITE (OUTTAP,2160) SFM,P2,P1        
      GO TO 5500        
  117 WRITE (OUTTAP,2170) UFM,P1        
      GO TO 5500        
  118 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  119 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  120 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  121 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  122 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  123 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  124 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  125 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  126 WRITE (OUTTAP,2260) UFM,P1        
      GO TO 5500        
  127 WRITE (OUTTAP,2270) SFM,P1        
      GO TO 5500        
  128 WRITE (OUTTAP,2280) SFM,P1        
      GO TO 5500        
  129 WRITE (OUTTAP,2290) SFM,P1        
      GO TO 5500        
  130 WRITE (OUTTAP,2300) UFM        
      GO TO 5500        
  131 WRITE (OUTTAP,2131) UFM,P1        
      GO TO 5500        
  132 WRITE (OUTTAP,2132) UFM        
      GO TO 5500        
  133 WRITE (OUTTAP,2133) UFM,P1        
      GO TO 5500        
  134 WRITE (OUTTAP,2134) UFM,P1        
      GO TO 5500        
  135 WRITE (OUTTAP,2135) UFM,P1,P2        
      GO TO 5500        
  136 WRITE (OUTTAP,2136) UFM,P1        
      GO TO 5500        
  137 WRITE (OUTTAP,2137) UFM,P1,P2        
      GO TO 5500        
  138 WRITE (OUTTAP,2138) UFM,P1        
      GO TO 5500        
  139 WRITE (OUTTAP,2139) UFM,P1,P2        
      GO TO 5500        
  140 WRITE (OUTTAP,2400) UFM,P1        
      GO TO 5500        
  141 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  142 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  143 WRITE (OUTTAP,2143) UFM,P1        
      GO TO 5600        
  144 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  145 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  146 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  147 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  148 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  149 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  150 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  151 INDEX = P2 / 100000000        
      P2    = P2 - INDEX*100000000        
      WRITE (OUTTAP,2510) UFM,P1,ICRIGD(INDEX),P2        
      GO TO 5500        
  152 WRITE (OUTTAP,2520) UFM        
      GO TO 5500        
  153 WRITE (OUTTAP,2530) UFM        
      GO TO 5500        
  154 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  155 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  156 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  157 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  158 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  159 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  160 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  161 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  162 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  163 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  164 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  165 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  166 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  167 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  168 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  169 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  170 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  171 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  172 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  173 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  174 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  175 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  176 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  177 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  178 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  179 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  180 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  181 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  182 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  183 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  184 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  185 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  186 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  187 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  188 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  189 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  190 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  191 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  192 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  193 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  194 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  195 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  196 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  197 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  198 WRITE (OUTTAP,2980) UFM,P1        
      GO TO 5500        
  199 WRITE (OUTTAP,2990) SFM,P1,P2        
      GO TO 5500        
  200 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  201 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  202 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  203 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  204 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  205 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  206 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  207 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  208 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  209 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  210 WRITE (OUTTAP,5000) L,P1,P2        
      GO TO 5600        
  211 WRITE (OUTTAP,3211) UFM,P1        
      GO TO 5500        
  212 WRITE (OUTTAP,3212) UFM,P1        
      GO TO 5500        
  213 WRITE (OUTTAP,3213) UFM,P1        
      GO TO 5500        
  214 WRITE (OUTTAP,3214) UFM,P2,P2,P1        
      GO TO 5500        
  215 WRITE (OUTTAP,3215) UFM,P1,P2        
      GO TO 5500        
  216 WRITE (OUTTAP,3216) UFM,P2,P2,P1        
      GO TO 5500        
  217 WRITE (OUTTAP,3217) UFM,P1        
      GO TO 5500        
  218 WRITE (OUTTAP,3218) UFM,P2,AX,P1        
      GO TO 5500        
  219 WRITE (OUTTAP,3219) UFM        
      GO TO 5500        
  220 WRITE (OUTTAP,3220) UIM,P1,P2        
      GO TO 5600        
  221 WRITE (OUTTAP,3218) UFM,P2,RG,P1        
      GO TO 5500        
  222 WRITE (OUTTAP,3222) UWM,P1,P2        
      GO TO 5600        
  223 WRITE (OUTTAP,3223) SFM,TRIA3,P1        
      GO TO 5500        
  224 WRITE (OUTTAP,3224) UFM,TRIA3,P1        
      GO TO 5500        
  225 WRITE (OUTTAP,3225) UFM,P2,TRIA3,P1        
      GO TO 5500        
  226 WRITE (OUTTAP,3226) UFM,P2,TRIA3,P1        
      GO TO 5500        
  227 WRITE (OUTTAP,3227) UFM,P2,TRIA3,P1        
      GO TO 5500        
  228 WRITE (OUTTAP,3228) SFM,TRIA3        
      GO TO 5500        
  229 WRITE (OUTTAP,3223) SFM,QUAD4,P1        
      GO TO 5500        
  230 WRITE (OUTTAP,3224) UFM,QUAD4,P1        
      GO TO 5500        
  231 WRITE (OUTTAP,3225) UFM,P2,QUAD4,P1        
      GO TO 5500        
  232 WRITE (OUTTAP,3226) UFM,P2,QUAD4,P1        
      GO TO 5500        
  233 WRITE (OUTTAP,3227) UFM,P2,QUAD4,P1        
      GO TO 5500        
  234 WRITE (OUTTAP,3228) SFM,QUAD4        
      GO TO 5500        
C        
C        
 1010 FORMAT (A23,' 2001, SEQGP CARD REFERENCES UNDEFINED GRID POINT',  
     1       I9)        
 1020 FORMAT (A25,' 2002, GRID POINT',I9,' NOT IN EQEXIN')        
 1030 FORMAT (A23,' 2003, COORDINATE SYSTEM',I9,        
     1       ' REFERENCES UNDEFINED GRID POINT',I9)        
 1040 FORMAT (A23,' 2004, COORDINATE SYSTEM',I9,        
     1       ' REFERENCES UNDEFINED COORDINATE SYSTEM',I9)        
 1050 FORMAT (A25,' 2005, INCONSISTENT COORDINATE SYSTEM DEFINITION')   
 1060 FORMAT (A23,' 2006, INTERNAL GRID POINT',I9,        
     1       ' REFERENCES UNDEFINED COORDINATE SYSTEM',I9)        
 1070 FORMAT (A23,' 2007, ELEMENT',I12,' REFERENCES UNDEFINED GRID ',   
     1       'POINT',I12)        
 1080 FORMAT (A23,' 2008, LOAD SET',I9,        
     1       ' REFERENCES UNDEFINED GRID POINT',I9)        
 1090 FORMAT (A23,' 2009, TEMP SET',I9,' REFERENCES UNDEFINED GRID ',   
     1       'POINT',I9)        
 1100 FORMAT (A23,' 2010, ELEMENT',I9,' REFERENCES UNDEFINED PROPERTY', 
     1       I9)        
 1110 FORMAT (A23,' 2011, NO PROPERTY CARD FOR ELEMENT TYPE - C',2A4)   
 1120 FORMAT (A23,' 2012, GRID POINT',I9,' SAME AS SCALAR POINT')       
 1130 FORMAT (A25,' 2013, NO STRUCTURAL ELEMENTS EXIST')        
 1140 FORMAT (A23,' 2014, LOGIC ERROR IN ECPT CONSTRUCTION')        
 1150 FORMAT (A25,' 2015, EITHER NO ELEMENTS CONNECTED TO ',A8,' GRID', 
     1       ' POINT',I9, /5X,'OR IT IS CONNECTED TO A RIGID ELEMENT ', 
     2       'OR A GENERAL ELEMENT.')        
 1151 FORMAT (A25,' 2015, ',A8,' GRID PT.',I9,' NOT CONNECTED')        
 1152 FORMAT (11X,':', /11X,':', /7X,'AND MORE')        
 1153 FORMAT (1X)        
 1160 FORMAT (A23,' 2016, NO MATERIAL PROPERTIES EXIST')        
 1170 FORMAT (A23,' 2017, MATS1 CARD REFERENCES UNDEFINED MAT1',I9,     
     1       ' CARD')        
 1180 FORMAT (A23,' 2018, MATS2 CARD REFERENCES UNDEFINED MAT2',I9,     
     1       ' CARD')        
 1190 FORMAT (A23,' 2019, MATT1 CARD REFERENCES UNDEFINED MAT1',I9,     
     1       ' CARD')        
 1200 FORMAT (A23,' 2020, MATT2 CARD REFERENCES UNDEFINED MAT2',I9,     
     1       ' CARD')        
 1210 FORMAT (A23,' 2021, BAD GMMAT- CALLING SEQUENCE')        
 1220 FORMAT (A23,' 2022, SMA-B SCALAR POINT INSERTION LOGIC ERROR')    
 1230 FORMAT (A23,' 2023, DETCK UNABLE TO FIND PIVOT POINT',I9,        
     1       ' IN GPCT')        
 1240 FORMAT ('0*** UNDEFINED MESSAGE 2024')        
 1250 FORMAT (A23,' 2025, UNDEFINED COORDINATE SYSTEM',I9)        
 1260 FORMAT (A23,' 2026,ELEMENT',I9,' GEOMETRY YIELDS UNREASONABLE ',  
     1       'MATRIX')        
 1270 FORMAT (A23,' 2027,ELEMENT',I9,' HAS INTERIOR ANGLE GREATER THAN',
     1       ' 180 DEG. AT GRID POINT',I9)        
 1280 FORMAT (A23,' 2028, SMA3A ERROR NO.',I9)        
 1290 FORMAT (A23,' 2029, UNDEFINED TEMPERATURE SET',I9)        
 1300 FORMAT (A23,' 2030, BAD GPTT')        
 1310 FORMAT (A23,' 2031, ELEMENT',I9,' UNACCEPTABLE GEOMETRY')        
 1320 FORMAT (A23,' 2032, ELEMENT',I9,' UNACCEPTABLE GEOMETRY')        
 1330 FORMAT (A23,' 2033, SINGULAR H-MATRIX FOR ELEMENT',I9)        
 1340 FORMAT (A25,' 2034, ELEMENT',I9,' SIL-S DO NOT MATCH PIVOT')      
 1350 FORMAT (A23,' 2035, QUADRILATERAL',I9,        
     1       ' INTERIOR ANGLE GREATER THAN 180 DEG.')        
 1360 FORMAT (A23,' 2036, SINGULAR MATRIX FOR ELEMENT',I9)        
 1370 FORMAT (A23,' 2037, BAD ELEMENT',I9,' GEOMETRY')        
 1380 FORMAT (A25,' 2038, SINGULAR MATRIX FOR ELEMENT',I9)        
 1390 FORMAT (A23,' 2039, ZERO SLANT LENGTH FOR HARMONIC',I9,        
     1       ' OF CCONEAX',I9)        
 1400 FORMAT (A23,' 2040, SINGULAR MATRIX FOR ELEMENT',I9)        
 1410 FORMAT (A23,' 2041, A MATT1, MATT2, MATT3, OR MATS1 CARD REFER',  
     1       'ENCES TABLE NUMBER',I9,' WHICH IS NOT DEFINED ON', /5X,   
     2       'A TABLEM1, TABLEM2, TABLEM3, TABLEM4, OR TABLES1 CARD.')  
 1420 FORMAT (A23,' 2042, MISSING MATERIAL TABLE',I9,' FOR ELEMENT',I9) 
 1430 FORMAT (A23,' 2043, MISSING MATERIAL TABLE',I9)        
 1440 FORMAT (A23,' 2044, UNDEFINED TEMPERATURE SET',I9)        
 1450 FORMAT (A23,' 2045, TEMPERATURE UNDEFINED AT GRID POINT WITH ',   
     1       'INTERNAL INDEX',I9)        
 1460 FORMAT (A23,' 2046, UNDEFINED ELEMENT DEFORMATION SET',I9)        
 1470 FORMAT (A23,' 2047, UNDEFINED MULTI-POINT CONSTRAINT SET',I9)     
 1480 FORMAT (A23,' 2048, UNDEFINED GRID POINT',I9,        
     1       ' IN MULTI-POINT CONSTRAINT SET',I9)        
 1490 FORMAT (A23,' 2049, UNDEFINED GRID POINT',I9,        
     1       ' REFERENCED ON AN ASET, ASET1, OMIT OR OMIT1 CARD.')      
 1500 FORMAT (A23,' 2050, UNDEFINED GRID POINT',I9,        
     1       ' HAS A SUPPORT COORDINATE')        
 1510 FORMAT (A23,' 2051, UNDEFINED GRID POINT',I9,        
     1       ' IN SINGLE-POINT CONSTRAINT SET',I9)        
 1520 FORMAT (A23,' 2052, UNDEFINED GRID POINT',I9,        
     1       ' IN SINGLE-POINT CONSTRAINT SET',I9)        
 1530 FORMAT (A23,' 2053, UNDEFINED SINGLE-POINT CONSTRAINT SET',I9)    
 1540 FORMAT (A23,' 2054, SUPER ELEMENT',I9,        
     1       ' REFERENCES UNDEFINED SIMPLE ELEMENT',I9)        
 1550 FORMAT (A25,' 2055')        
 1560 FORMAT (A23,' 2056, UNDEFINED SUPER ELEMENT',I9,' PROPERTIES')    
 1570 FORMAT (A23,' 2057, IRRATIONAL SUPER ELEMENT',I9,' TOPOLOGY')     
 1580 FORMAT (A25,' 2058, ELEMENT',I9,' CONTRIBUTES TO THE DAMPING ',   
     1       'MATRIX WHICH IS PURGED.  IT WILL BE IGNORED.')        
 1590 FORMAT (A23,' 2059, UNDEFINED GRID POINT',I9,        
     1       ' ON SE--BFE CARD FOR SUPER ELEMENT',I9)        
 1600 FORMAT (A23,' 2060, UNDEFINED GRID POINT',I9,        
     1       ' ON QDSEP CARD FOR SUPER ELEMENT',I9)        
 1610 FORMAT (A23,' 2061, UNDEFINED GRID POINT',I9,' ON GENERAL ',      
     1       'ELEMENT',I9)        
 1620 FORMAT (A23,' 2062, UNDEFINED SUPER ELEMENT PROPERTY',I9,        
     1       ' FOR SUPER ELEMENT',I9)        
 1630 FORMAT (A23,' 2063, TA1C LOGIC ERROR')        
 1640 FORMAT (A23,' 2064, UNDEFINED EXTRA POINT',I9,        
     1       ' REFERENCED ON SEQEP CARD')        
 1650 FORMAT (A23,' 2065, UNDEFINED GRID POINT',I9,' ON DMIG CARD')     
 1660 FORMAT (A23,' 2066, UNDEFINED GRID POINT',I9,        
     1       ' ON RLOAD- OR TLOAD- CARD')        
 1670 FORMAT (A23,' 2067, UNDEFINED GRID POINT',I9,' IN NONLINEAR ',    
     1       '(NOLIN',I1,') LOAD SET',I9)        
 1680 FORMAT (A23,' 2068, UNDEFINED GRID POINT',I9,        
     1       ' IN TRANSFER FUNCTION SET',I9)        
 1690 FORMAT (A23,' 2069, UNDEFINED GRID POINT',I9,        
     1       ' IN TRANSIENT INITIAL CONDITION SET',I9)        
 1700 FORMAT (A23,' 2070, REQUESTED DMIG MATRIX ',2A4,' IS UNDEFINED.') 
 1710 FORMAT (A23,' 2071, DYNAMIC LOAD SET',I9,' REFERENCES UNDEFINED ',
     1       2A4,' SET',I9)        
 1720 FORMAT (A27,' 2072, CARD TYPE',I9,' NOT FOUND ON DATA BLOCK. ',   
     1       ' BIT POSITION =',I4)        
 1730 FORMAT (A29,' 2073, MPYAD METHOD',I9,' NO. PASSES =',I8)        
 1740 FORMAT (A23,' 2074, UNDEFINED TRANSFER FUNCTION SET',I9)        
 1750 FORMAT (A23,' 2075, IMPROPER KEYWORD ',2A4,        
     1       ' FOR APPROACH PARAMETER IN DMAP INSTRUCTION.')        
 1760 FORMAT (A25,' 2076, SDR2 OUTPUT DATA BLOCK NO. 1 IS PURGED')      
 1770 FORMAT (A25,' 2077, SDR2 OUTPUT DATA BLOCK NO. 2 IS PURGED')      
 1780 FORMAT (A25,' 2078, SDR2 OUTPUT DATA BLOCK NO. 3 IS PURGED')      
 1790 FORMAT (A25,' 2079, SDR2 FINDS THE -EDT-, -EST-, OR -GPTT- ',     
     1       'PURGED OR INADEQUATE AND IS THUS NOT PROCESSING', /5X,    
     2       'ANY REQUESTS FOR STRESSES OR FORCES.')        
 1800 FORMAT (A25,' 2080, SDR2 OUTPUT DATA BLOCK NO. 6 IS PURGED')      
 1810 FORMAT (A23,' 2081, DIFFERENTIAL STIFFNESS CAPABILITY NOT ',      
     1       'DEFINED FOR ANY OF THE ELEMENT TYPES IN THE PROBLEM.')    
 1830 FORMAT (A23,' 2083, NULL DISPLACEMENT VECTOR')        
 1840 FORMAT (A23,' 2084, DSMG2 LOGIC ERROR',I9)        
 1850 FORMAT (A29,' 2085, ',A4,' SPILL, NPVT',I9)        
 1860 FORMAT (A29,' 2086, SMA2 SPILL, NPVT',I9)        
 1870 FORMAT (A25,' 2087, ECPT CONTAINS BAD DATA')        
 1880 FORMAT (A23,' 2088, DUPLICATE TABLE ID',I9)        
 1890 FORMAT (A23,' 2089, TABLE',I9,' UNDEFINED')        
 1900 FORMAT (A25,' 2090, TABLE DICTIONARY ENTRY',I9,' MISSING')        
 1910 FORMAT (A25,' 2091, PLA3, BAD ESTNL ELEMENT ID',I9)        
 1920 FORMAT (A27,' 2092, SDR2 FINDS A SYMMETRY SEQUENCE LENGTH =',I20, 
     1       /5X,'AND AN INSUFFICIENT NUMBER OF VECTORS AVAILABLE=',I21,
     2       ' WHILE ATTEMPTING TO COMPUTE STRESSES AND FORCES.', /5X,  
     3       'ALL FURTHER STRESS AND FORCE COMPUTATION TERMINATED.')    
 1930 FORMAT (A23,' 2093, NOLIN CARD FROM NOLIN SET',I9,        
     1       ' REFERENCES GRID POINT',I9,' UD SET.')        
 2010 FORMAT (A23,' 2101A, GRID POINT',I9,' COMPONENT',I2,        
     1       ' ILLEGALLY DEFINED IN SETS',5(2X,A4))        
 2011 FORMAT (A23,' 2101B, SCALAR POINT',I9,' ILLEGALLY DEFINED IN ',   
     1       'SETS',5(2X,A4))        
 2020 FORMAT (A25,' 2102, LEFT HAND MATRIX ROW POSITION',I9,        
     1       ' OUT OF RANGE - IGNORED')        
 2030 FORMAT (A25,' 2103, SUBROUTINE MAT WAS CALLED WITH INFLAG=2, THE',
     1       ' SINE OF THE ANGLE X', /5X,' MATERIAL ORIENTATION ANGLE,',
     2       ' NON-ZERO, BUT SIN(X)**2+COS(X)**2 DIFFERED FROM 1 IN ',  
     3       'ABSOLUTE VALUE BY MORE THAN .0001')        
 2040 FORMAT (A23,' 2104, UNDEFINED COORDINATE SYSTEM',I9)        
 2050 FORMAT (A23,' 2105, PLOAD2 CARD FROM LOAD SET',I9,        
     1       ' REFERENCES MISSING OR NON-2-D ELEMENT',I9)        
 2060 FORMAT (A23,' 2106, LOAD CARD DEFINES NON-UNIQUE LOAD SET',I9)    
 2070 FORMAT (A23,' 2107, EIG- CARD FROM SET',I9,        
     1       ' REFERENCES DEPENDENT COORDINATE OF GRID POINT',I9)       
 2080 FORMAT (A23,' 2108, SPCD ON A POINT NOT IN S SET. GRID',I9,       
     1       ' COMP.',I9)        
 2090 FORMAT (A23,' 2109, NO GRID, SCALAR OR EXTRA POINTS DEFINED')     
 2110 FORMAT (A25,' 2111, BAR',I9,' COUPLED BENDING INERTIA SET TO 0.0',
     1       ' IN DIFFERENTIAL STIFFNESS')        
 2120 FORMAT (A23,' 2112, UNDEFINED TABLE',I9)        
 2130 FORMAT (A23,' 2113, MATERIAL',I9,', A NON-MAT1 TYPE, IS NOT ',    
     1       'ALLOWED TO BE STRESS-DEPENDENT')        
 2131 FORMAT (A23,' 2131, NON-SCALAR ELEMENT',I9,        
     1       ' REFERENCES A SCALAR POINT.')        
 2132 FORMAT (A23,' 2132, NON-ZERO SINGLE POINT CONSTRAINT VALUE ',     
     1       'SPECIFIED BUT DATA BLOCK YS IS PURGED.')        
 2133 FORMAT (A23,' 2133, INITIAL CONDITION IN SET',I9,        
     1       ' SPECIFIED FOR POINT NOT IN ANALYSIS SET.')        
 2134 FORMAT (A23,' 2134, LOAD SET',I9,' DEFINED FOR BOTH GRAVITY AND ',
     1       'NON-GRAVITY LOADS.')        
 2135 FORMAT (A23,' 2135, DLOAD CARD',I9,' HAS A DUPLICATE SET ID FOR ',
     1       'SET ID',I9)        
 2136 FORMAT (A23,' 2136, SET ID',I9,' HAS BEEN DUPLICATED ON A DLOAD,',
     1       ' RLOAD1,2 OR TLOAD1,2 CARD.')        
 2137 FORMAT (A23,' 2137, PROGRAM RESTRICTION FOR MODULE ',A4,        
     1       '.  ONLY 360 LOAD SET ID-S.', /5X,        
     2       'ALLOWED.  DATA CONTAINS',I9,' LOAD SET ID-S.')        
 2138 FORMAT (A23,' 2138, ELEMENT ID NO.',I9,' IS TOO LARGE')        
 2139 FORMAT (A23,' 2139, ELEMENT',I9,' IN DEFORM SET',I9,        
     1       ' IS UNDEFINED.')        
 2140 FORMAT (A23,' 2114, MATT3 CARD REFERENCES UNDEFINED MAT3',I9,     
     1       ' CARD')        
 2143 FORMAT (A23,' 2143, SINGULAR JACOBIAN MATRIX FOR ISOPARAMETRIC ', 
     1       'ELEMENT NO.',I9)        
 2150 FORMAT (A23,' 2115, TABLE',I9,' (TYPE',I9,') ILLEGAL WITH STRESS',
     1       '-DEPENDENT MATERIAL')        
 2160 FORMAT (A25,' 2116, MATID',I9,' TABLEID',I9)        
 2170 FORMAT (A23,' 2117, TEMPERATURE DEPENDENT MATERIAL PROPERTIES ',  
     1       'ARE NOT PERMISSIBLE', /5X,'IN A PIECEWISE LINEAR ',       
     2       'ANALYSIS PROBLEM.  TEMPERATURE SET =',I9)        
 2260 FORMAT (A23,' 2126, UNDEFINED MATERIAL FOR ELEMENT',I9)        
 2270 FORMAT (A25,' 2127, PLA2 INPUT DATA BLOCK NO.',I9,' IS PURGED.')  
 2280 FORMAT (A25,' 2128, PLA2 OUTPUT DATA BLOCK NO.',I9,' IS PURGED.') 
 2290 FORMAT (A25,' 2129, PLA2, ZERO VECTOR ON APPENDED DATA BLOCK NO.',
     1       I9)        
 2300 FORMAT (A23,' 2130, ZERO INCREMENTAL DISPLACEMENT VECTOR INPUT ', 
     1       'TO MODULE PLA2.')        
 2400 FORMAT (A23,' 2140, GRID OR SCALAR POINT ID',I9,', EXCEEDING MAX',
     1       ' OF 2140000, COULD BE FATAL')        
 2510 FORMAT (A23,' 2192, UNDEFINED GRID POINT',I9,' IN RIGD',A1,       
     1       ' ELEMENT',I9)        
 2520 FORMAT (A23,' 2193, A REDUNDANT SET OF RIGID BODY MODES WAS ',    
     1       'SPECIFIED FOR THE GENERAL ELEMENT')        
 2530 FORMAT (A23,' 2194, A MATRIX D IS SINGULAR IN SUBROUTINE TA1CA')  
 2980 FORMAT (A23,' 2198, INPUT DATA BLOCK',I9,' HAS BEEN PURGED.')     
 2990 FORMAT (A25,' 2199, SUMMARY', /5X,'ONE OR MORE OF THE ABOVE ',    
     1       'FATAL ERRORS WAS ENCOUNTERED IN SUBROUTINE ',2A4)        
 3211 FORMAT (A23,' 2355, GRID POINT COORDINATES OF ELEMENT',I9,        
     1       ' ARE IN ERROR.', /5X,        
     2       'ONE OR MORE OF THE R-COORDINATES ARE ZERO OR NEGATIVE.')  
 3212 FORMAT (A23,' 2364, GRID POINT COORDINATES OF ELEMENT',I9,        
     1       ' ARE IN ERROR.', /5X,        
     2       'ONE OR MORE OF THE THETA-COORDINATES ARE NONZERO.')       
 3213 FORMAT (A23,' 2213, MATERIAL ID',I9,' NOT UNIQUELY DEFINED.')     
 3214 FORMAT (A23,' 2214, MATT',I1,' CARD REFERENCES UNDEFINED MAT',I1, 
     1       I9,' CARD')        
 3215 FORMAT (A23,' 2215, UNDEFINED MATERIAL ID',I9,        
     1       ' WAS REFERENCED BY PROPERTY CARD ID',I9)        
 3216 FORMAT (A23,' 2216, MATPZT',I1,' CARD REFERENCES UNDEFINED MATPZ',
     1       I1,I9,' CARD')        
 3217 FORMAT (A23,' 2217, MATPZ1 ID',I9,' HAS SINGULAR SE MATRIX.')     
 3218 FORMAT (A23,' 2218, ',A4,A2,' ELEMENT',I9,        
     1       ' HAS A MAXIMUM TO MINIMUM RADIUS RATIO EXCEEDING 10.',/5X,
     2       'ACCURACY OF NUMERICAL INTEGRATION WOULD BE IN DOUBT.')    
 3219 FORMAT (A23,' 2219, MAT6 CARDS REQUIRE REPROCESSING. RE-SUBMIT ', 
     1       'JOB WITH THE FOLLOWING DMAP ALTER (AFTER GP1)', //10X,    
     2       'ANISOP  GEOM1,EPT,BGPDT,EQEXIN,MPT/MPTA/S,N,ISOP $', /10X,
     3       'EQUIV   MPTA,MPT/ISOP $',/)        
 3220 FORMAT (A29,' 2220, NO APPLICABLE ELEMENT OR SUBCASE DURING OUT', 
     1       'PUT SCAN', /5X,'EITHER NO VALUES OUTSIDE MAX-MIN RANGE ', 
     2       'OR NOT IN SET SPECIFIED FOR ',2A4)        
 3222 FORMAT (A25,' 2222, METHOD OF NORMALIZATION ON ',A4,' CARD NOT ', 
     1       'SPECIFIED. DEFAULT OF ''',A4,''' WILL BE USED')        
 3223 FORMAT (A25,' 3223 NO PCOMP, PCOMP1 OR PCOMP2 PROPERTY DATA ',    
     1       'FOUND FOR ',A6,' ELEMENT ID =',I9)        
 3224 FORMAT (A23,' 2224, ',A6,' ELEMENT ID =',I9,        
     1       ' HAS ILLEGAL GEOMETRY OR CONNECTIONS')        
 3225 FORMAT (A23,' 2225, THE X-AXIS OF THE MATERIAL COORDINATE SYSTEM',
     1       ' ID =',I9,' HAS NO PROJECTION ON TO THE PLANE OF THE',    
     2       /5X,A6,' ELEMENT ID =',I9)        
 3226 FORMAT (A23,' 2226, ILLEGAL DATA DETECTED ON MATERIAL ID =',I9,   
     1       ' REFERENCED BY ',A6,' ELEMENT ID =',I9, /5X,        
     2       'FOR MID3 APPLICATION')        
 3227 FORMAT (A23,' 2228, THE X-AXIS OF THE STRESS COORDINATE SYSTEM ', 
     1       'ID =',I9,' HAS NO PROJECTION ON TO THE PLANE OF THE', /5X,
     2       A6,' ELEMENT ID =',I9)        
 3228 FORMAT (A25,' 3008, INSUFFICIENT MEMORY IS AVAIL ABLE FOR ',A6,   
     1       ' ELEMENTS GENERATION.  RE-RUN JOB WITH AN ADDITIONAL',    
     2       /5X,'2000 WORDS OF MEMORY')        
C        
 5000 FORMAT ('0*** UNASSIGNED MESSAGE (L=',I3,'), P1=',I20,', P2=',I9) 
C        
C     MESSAGE IS FATAL.        
C     IF DIAG 1 IS ON, AND MACHINE IS VAX AND UNIX, CALL ERROR TRACEBACK
C        
 5500 IF (MACH .LE. 4) GO TO 5600        
      CALL SSWTCH (1,J)        
      IF (J .EQ. 1) CALL ERRTRC ('USRWRT  ',L)        
 5600 RETURN        
C        
C     ILLEGAL INPUT TO SUBROUTINE        
C        
 9000 WRITE  (OUTTAP,9001) L        
 9001 FORMAT ('0IMPROPER USRMSG NO.',I20)        
      CALL MESAGE (-7,0,NAME)        
      RETURN        
      END        
