classdef WriterSuperclass
    %This Class is Superclass from GeneralWriter and FromPhonopywriter
    properties(Constant)

    %Header-Text
    NameOfProgram='Molecular-Toolbox 1.0.0';
    header='Code written and copyrighted by Janine George (2015-2016)';
  
    end
    
    methods
        %writes the header for any OUTPUT-File
        function writeHeader(obj,fidout2)
           fprintf(fidout2,'%s',[ obj.NameOfProgram char(10) obj.header char(10)]);
           
        end 
        
    end
    
    
    
end
