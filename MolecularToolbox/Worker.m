classdef Worker
    %Superclass of Bcifworker, BetasWorker, UcartWorker, UcifWorker,
    %UstarWorker
    properties(GetAccess = 'public', SetAccess = 'protected')
        %Informations about the temperature range
        NumberOfTemperatures
        TSTART
        TEND
        TSTEP
        
        %3D array: First dimension: U xx, yy, zz, yz, xz, xy, Second Dimension: specfies the atom number, third dimension: specifies the number of the temperature
        Reader
        
        NumberOfAllAtoms 
        
        %lattice vector 
        Vector 
        
        %reciprocal lattice lengths
        g1length
        g2length
        g3length
        
    end
    
    methods(Abstract)
        Bcif(obj)
        U1U2U3ForASpecifiedT(obj,T)
        Ustar(obj)
        Betas(obj)
        Ucart(obj)
        Ucif(obj)
        
    end
    
    
    methods
        %Constructor initializes the attributes
         function obj=Worker(Vector,g1length,g2length,g3length,Reader,TSTART,TEND,TSTEP,NumberOfAllAtoms)
            obj.Vector=Vector;
            obj.g1length=g1length;
            obj.g2length=g2length;
            obj.g3length=g3length;
            obj.Reader=Reader;
            obj.TSTART=TSTART;
            obj.TEND=TEND;
            obj.TSTEP=TSTEP;
            obj.NumberOfAllAtoms=NumberOfAllAtoms;
            obj.NumberOfTemperatures=((obj.TEND-obj.TSTART)/obj.TSTEP)+1;
         end
         
         %This is needed for the conversion of the ADPs
         function N=getN(obj)
             N=[obj.g1length 0 0;
                0 obj.g2length 0;
                0 0 obj.g3length;];
         
         end
         
         %Converts data from the attribute Reader for a special atom and a special temperature
         %to a matrix
         function Matrix=ReaderToMatrix(obj,AtomCounter,TemperatureCounter)
             Matrix(1,1)=obj.Reader(1,AtomCounter,TemperatureCounter);
             Matrix(2,2)=obj.Reader(2,AtomCounter,TemperatureCounter);
             Matrix(3,3)=obj.Reader(3,AtomCounter,TemperatureCounter);
             Matrix(2,3)=obj.Reader(4,AtomCounter,TemperatureCounter);
             Matrix(3,2)=obj.Reader(4,AtomCounter,TemperatureCounter);
             Matrix(3,1)=obj.Reader(5,AtomCounter,TemperatureCounter);
             Matrix(1,3)=obj.Reader(5,AtomCounter,TemperatureCounter);
             Matrix(1,2)=obj.Reader(6,AtomCounter,TemperatureCounter);
             Matrix(2,1)=obj.Reader(6,AtomCounter,TemperatureCounter);
             
         end
         %Convert the Reader for a special atom and a special temperature
         %to a matrix. Does the same as the function above but for any
         %delivered reader.
         function Matrix=OtherReaderToMatrix(obj,Reader,AtomCounter,TemperatureCounter)
             Matrix(1,1)=Reader(1,AtomCounter,TemperatureCounter);
             Matrix(2,2)=Reader(2,AtomCounter,TemperatureCounter);
             Matrix(3,3)=Reader(3,AtomCounter,TemperatureCounter);
             Matrix(2,3)=Reader(4,AtomCounter,TemperatureCounter);
             Matrix(3,2)=Reader(4,AtomCounter,TemperatureCounter);
             Matrix(3,1)=Reader(5,AtomCounter,TemperatureCounter);
             Matrix(1,3)=Reader(5,AtomCounter,TemperatureCounter);
             Matrix(1,2)=Reader(6,AtomCounter,TemperatureCounter);
             Matrix(2,1)=Reader(6,AtomCounter,TemperatureCounter);
             
             
             positivedefinite = all(eig(Matrix) > 0); 
             
             if (positivedefinite==false)
                 error(['The ADP matrix at ' num2str(TemperatureCounter) '. temperature for ' num2str(AtomCounter) '. atom is not positive definite. The program stops here. Check your ADP input-file again. '])
               
             end
             
             
         end
             
        
    end
    
    
    
    
end
