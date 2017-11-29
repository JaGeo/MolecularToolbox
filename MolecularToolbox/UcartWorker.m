classdef UcartWorker<Worker
    %Calculates Ucif and U1,U2,U3
    
    
       properties(GetAccess = 'private', SetAccess = 'private')
        %NumberOfTemperatures
        %TSTART
       % TEND
        %TSTEP
        %Reader %3D array: First dimension: U xx, yy, zz, yz, xz, xy, Second Dimension: specfies the atom number, third dimension: specifies the number of the temperature
      %  NumberOfAllAtoms 
       % Vector %lattice vector 
       % g1length
       % g2length
       % g3length
    end
    
    methods
       
        function obj=UcartWorker(Vector,g1length,g2length,g3length,Reader,TSTART,TEND,TSTEP,NumberOfAllAtoms)
        obj@Worker(Vector,g1length,g2length,g3length,Reader,TSTART,TEND,TSTEP,NumberOfAllAtoms) %uses Constructor from Superclass
        end
        
        function [UcartOutput]=Ucart(obj)
            for TemperatureCounter=1:obj.NumberOfTemperatures
                for AtomCounter=1:obj.NumberOfAllAtoms
                    Ucart=obj.ReaderToMatrix(AtomCounter,TemperatureCounter);
                    UcartOutputPerTemperature(:,:,AtomCounter)=Ucart;
                end
                UcartOutput(:,:,:,TemperatureCounter)=UcartOutputPerTemperature;
                
            end
            
        end
        
        function [UcifOutput]=Ucif(obj)
            N=obj.getN;
              
            
            %Uxx, Uyy, Uzz, Uyz, Uxz, Uxy 
            for TemperatureCounter=1:obj.NumberOfTemperatures
                for AtomCounter=1:obj.NumberOfAllAtoms
                    Ucart=obj.ReaderToMatrix(AtomCounter,TemperatureCounter);
                    Ustar=(inv(obj.Vector))*Ucart*((inv(obj.Vector))');
                    Ucif=(inv(N))*Ustar*(inv(N))';
                    UcifOutputPerTemperature(:,:,AtomCounter)=Ucif;
                    
                end
                UcifOutput(:,:,:,TemperatureCounter)=UcifOutputPerTemperature;
            end
            
        end
        
        
         function [BcifOutput]=Bcif(obj)
          N=obj.getN;
           %Uxx, Uyy, Uzz, Uyz, Uxz, Uxy 
            for TemperatureCounter=1:obj.NumberOfTemperatures
                for AtomCounter=1:obj.NumberOfAllAtoms
                  
                  Ucart=obj.ReaderToMatrix(AtomCounter,TemperatureCounter);
                  Ustar=(inv(obj.Vector))*Ucart*((inv(obj.Vector))');
                  Bcif=((inv(N))*Ustar*(inv(N))')*(8*pi^2);
                  BcifOutputPerTemperature(:,:,AtomCounter)=Bcif;
                    
                end
                BcifOutput(:,:,:,TemperatureCounter)=BcifOutputPerTemperature;
            end
            
        end
        
        
        function e=U1U2U3ForASpecifiedT(obj,T)
            
            Tnumber=(T-obj.TSTART)/obj.TSTEP+1;
                                   
            
            for AtomCounter=1:obj.NumberOfAllAtoms
                
               Ucart=obj.ReaderToMatrix(AtomCounter,Tnumber);
                
                e(:,AtomCounter)=eig(Ucart);
              
                          
            end
            
            
        end
        
        function eOutput=U1U2U3(obj)
             for TemperatureCounter=1:obj.NumberOfTemperatures
                for AtomCounter=1:obj.NumberOfAllAtoms
                    Ucart=obj.ReaderToMatrix(AtomCounter,TemperatureCounter);
                    
                    ePerTemperature(:,AtomCounter)=eig(Ucart);
                    
                end
                eOutput(:,:,TemperatureCounter)=ePerTemperature;
                
            end
            
            
        end
        
        
      
         function [UstarOutput]=Ustar(obj)
            
            %Uxx, Uyy, Uzz, Uyz, Uxz, Uxy 
            for TemperatureCounter=1:obj.NumberOfTemperatures
                for AtomCounter=1:obj.NumberOfAllAtoms
                    
                    Ucart=obj.ReaderToMatrix(AtomCounter,TemperatureCounter);
                    
                    Ustar=(inv(obj.Vector))*Ucart*((inv(obj.Vector))');
                   
                    UstarOutputPerTemperature(:,:,AtomCounter)=Ustar;
                    
                end
                UstarOutput(:,:,:,TemperatureCounter)=UstarOutputPerTemperature;
            end
            
        end
       
         function [BetasOutput]=Betas(obj)
            
            %Uxx, Uyy, Uzz, Uyz, Uxz, Uxy 
            for TemperatureCounter=1:obj.NumberOfTemperatures
                for AtomCounter=1:obj.NumberOfAllAtoms
                    
                    Ucart=obj.ReaderToMatrix(AtomCounter,TemperatureCounter);
                    
                    Ustar=(inv(obj.Vector))*Ucart*((inv(obj.Vector))');
                    
                    BetasOutputPerTemperature(:,:,AtomCounter)=Ustar*2*pi^2;
                    
                end
                BetasOutput(:,:,:,TemperatureCounter)=BetasOutputPerTemperature;
            end
            
         end
        
         function [UeqOutput]=Ueq(obj)
             N=obj.getN;
             %Uxx, Uyy, Uzz, Uyz, Uxz, Uxy 
             for TemperatureCounter=1:obj.NumberOfTemperatures
                 for AtomCounter=1:obj.NumberOfAllAtoms
                     Ucart=obj.ReaderToMatrix(AtomCounter,TemperatureCounter);
                     Ueq=(1/3)*trace(Ucart);
                     UeqOutputPerTemperature(:,AtomCounter)=Ueq;
                     
                 end
                 UeqOutput(:,:,TemperatureCounter)=UeqOutputPerTemperature;
            end
            
        end
    end
end