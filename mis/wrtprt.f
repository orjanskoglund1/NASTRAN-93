      SUBROUTINE WRTPRT (FILE,LIST,FORMAT,N)        
C        
      INTEGER FILE,LIST(1),FORMAT(N)        
C        
      CALL WRITE (FILE,LIST,LIST(1)+1,0)        
      CALL WRITE (FILE,N,1,0)        
      CALL WRITE (FILE,FORMAT,N,0)        
      RETURN        
      END        