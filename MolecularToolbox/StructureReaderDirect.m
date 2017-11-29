classdef StructureReaderDirect<StructureReader
    %
     properties(GetAccess = 'public', SetAccess = 'private')
       a
       b
       c
       alphaInDegrees
       betaInDegrees
       gammaInDegrees
    end
    
    methods
    
        function obj=StructureReaderDirect(a,b,c,alphaInDegrees,betaInDegrees,gammaInDegrees)
            obj.a=a;
            obj.b=b;
            obj.c=c;
            obj.alphaInDegrees=alphaInDegrees;
            obj.betaInDegrees=betaInDegrees;
            obj.gammaInDegrees=gammaInDegrees;
             alpha = alphaInDegrees*pi / 180.0;
            beta =betaInDegrees*pi / 180.0;
            gamma = gammaInDegrees*pi / 180.0;
            a1 = 1.0;
            a2 = 0.0;
            a3 = 0.0;
            b1 = cos(gamma);
            b2 = sin(gamma);
            b3 = 0.0;
            c1 = cos(beta);
            c2 = ( cos(alpha)  -   b1 * c1 ) / ( b2);
            c3 = sqrt(1 - c1^2 - c2^2);
            obj.POSCARVector=[a1*a b1*b c1*c;a2*a b2*b c2*c; a3*a b3*b c3*c];
      
            
        end
        
        
        function [a,b,c,alphaInDegrees,betaInDegrees,gammaInDegrees]=LatticeLengthsAndAngles(obj)
                a=obj.a;
                b=obj.b;
                c=obj.c;
                alphaInDegrees=obj.alphaInDegrees;
                betaInDegrees=obj.betaInDegrees;
                gammaInDegrees=obj.gammaInDegrees;
        end
        
    end
    
    
    
end