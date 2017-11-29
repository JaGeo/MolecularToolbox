classdef FromBcifwriter<GeneralWriter
    %Writes Files starting from bcif input
    properties(GetAccess = 'public', SetAccess = 'private')
    end
    
    
    methods
        function obj=FromBcifwriter(a,b,c,alpha,beta,gamma,filenameADPs,TSTART,TEND,TSTEP,NumberOfAllAtoms)
            %Uses constructor from GeneralWriter
            obj@GeneralWriter(a,b,c,alpha,beta,gamma,filenameADPs,TSTART,TEND,TSTEP,NumberOfAllAtoms);
            %Initializes ADP from Generalwriter with an Object of the Class
            %Bcifworker
            obj.ADP=Bcifworker(obj.Structure1.POSCARVector,obj.g1length,obj.g2length,obj.g3length,obj.Reader1.Reader,obj.TSTART,obj.TEND,obj.TSTEP,obj.NumberOfAllAtoms);
        end
        
    end
    
    
end
