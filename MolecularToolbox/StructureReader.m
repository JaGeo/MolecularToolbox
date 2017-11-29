classdef StructureReader
    %Objects of this class read in structure information, Superclass of
    %POSCAR
    properties(GetAccess = 'public', SetAccess = 'protected')
        POSCARVector
    end
    
    methods(Abstract)
        LatticeLengthsAndAngles(obj)
        
    end
    
    methods
        %gives the reciprocal Lattice
        function [g1,g2,g3]=ReciprocalLatticeFromPOSCAR(obj);
            aVector=[];
            bVector=[];
            cVector=[];
            aVector=obj.POSCARVector(:,1);
            bVector=obj.POSCARVector(:,2);
            cVector=obj.POSCARVector(:,3);
            Vol=0;
            Vol=dot(aVector,cross(bVector,cVector));
            g1=[];
            g2=[];
            g3=[];
            g1=(1/Vol)*cross(bVector,cVector);
            g2=(1/Vol)*cross(cVector,aVector);
            g3=(1/Vol)*cross(aVector,bVector);
        end
        
        %Reciprocal Lattice vector lengths
        function [g1length,g2length,g3length]=ReciprocalLatticeLengthsFromPOSCAR(obj)
            [g1,g2,g3]=ReciprocalLatticeFromPOSCAR(obj);
            g1length=0;
            g2length=0;
            g3length=0;
            g1length=norm(g1);
            g2length=norm(g2);
            g3length=norm(g3);
        end
    end
end





