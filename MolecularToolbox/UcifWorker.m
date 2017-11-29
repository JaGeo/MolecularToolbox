classdef UcifWorker<Worker
       
    properties(GetAccess = 'private', SetAccess = 'private')
        
    end
    
    
    
    methods
        
        function obj=UcifWorker(Vector,g1length,g2length,g3length,Reader,TSTART,TEND,TSTEP,NumberOfAllAtoms)
            obj@Worker(Vector,g1length,g2length,g3length,Reader,TSTART,TEND,TSTEP,NumberOfAllAtoms)%uses Constructor from Superclass
        
        
        end
        
        function [UcifOutput]=Ucif(obj)
              for TemperatureCounter=1:obj.NumberOfTemperatures
                for AtomCounter=1:obj.NumberOfAllAtoms
                    Ucif=obj.ReaderToMatrix(AtomCounter,TemperatureCounter);
                    UcifOutputPerTemperature(:,:,AtomCounter)=Ucif;
                    
                end
                UcifOutput(:,:,:,TemperatureCounter)=UcifOutputPerTemperature;
                
            end
            
            
        end
        
        
        function [BcifOutput]=Bcif(obj)
         for TemperatureCounter=1:obj.NumberOfTemperatures
                for AtomCounter=1:obj.NumberOfAllAtoms
                    Ucif=obj.ReaderToMatrix(AtomCounter,TemperatureCounter);
                    BcifOutputPerTemperature(:,:,AtomCounter)=Ucif*8*pi^2;
                    
                end
                BcifOutput(:,:,:,TemperatureCounter)=BcifOutputPerTemperature;
                
            end
            
        end
        
        
        
       
        function [UstarOutput]=Ustar(obj)
            N=obj.getN;
            for TemperatureCounter=1:obj.NumberOfTemperatures
                for AtomCounter=1:obj.NumberOfAllAtoms
                  Ucif=obj.ReaderToMatrix(AtomCounter,TemperatureCounter);
                  Ustar=(N)*Ucif*(N)';
                                     
                  UstarOutputPerTemperature(:,:,AtomCounter)=Ustar;
                    
                end
                UstarOutput(:,:,:,TemperatureCounter)=UstarOutputPerTemperature;
           end
        end
        
        
        function [BetasOutput]=Betas(obj)
            N=obj.getN;
            for TemperatureCounter=1:obj.NumberOfTemperatures
                for AtomCounter=1:obj.NumberOfAllAtoms
                  
                  Ucif=obj.ReaderToMatrix(AtomCounter,TemperatureCounter);
                  Ustar=(N)*Ucif*(N)';
                                     
                  BetasOutputPerTemperature(:,:,AtomCounter)=Ustar*2*pi^2;
                    
                end
                BetasOutput(:,:,:,TemperatureCounter)=BetasOutputPerTemperature;
            end
            
        end
        
        function [UcartOutput]=Ucart(obj)
                 N=obj.getN;
            for TemperatureCounter=1:obj.NumberOfTemperatures
                for AtomCounter=1:obj.NumberOfAllAtoms
                  
                  Ucif=obj.ReaderToMatrix(AtomCounter,TemperatureCounter);
                  Ustar=(N)*Ucif*(N)';
                  Ucart=(obj.Vector)*Ustar*(obj.Vector)'
                                     
                  UcartOutputPerTemperature(:,:,AtomCounter)=Ucart;
                    
                end
               UcartOutput(:,:,:,TemperatureCounter)=UcartOutputPerTemperature;
            end   
            
            
        end
        
        
        
        
        
        function  [eOutput]=U1U2U3(obj)
             N=obj.getN;
            for TemperatureCounter=1:obj.NumberOfTemperatures
                for AtomCounter=1:obj.NumberOfAllAtoms
                  
                  Ucif=obj.ReaderToMatrix(AtomCounter,TemperatureCounter);
                  Ustar=(N)*Ucif*(N)';
                  Ucart=(obj.Vector)*Ustar*(obj.Vector)';
                                     
                  eOutputPerTemperature(:,AtomCounter)=eig(Ucart);
                    
                end
               eOutput(:,:,TemperatureCounter)=eOutputPerTemperature;
            end   
        end
        
        
        function e=U1U2U3ForASpecifiedT(obj,T)
            
            Tnumber=(T-obj.TSTART)/obj.TSTEP+1;
                                   
            
            for AtomCounter=1:obj.NumberOfAllAtoms
                 N=obj.getN;
               Ucif=obj.ReaderToMatrix(AtomCounter,Tnumber);
               Ustar=(N)*Ucif*(N)';
               Ucart=(obj.Vector)*Ustar*(obj.Vector)';
                
                e(:,AtomCounter)=eig(Ucart);
              
                          
            end
                   
        end
        
        
        
         function [UeqOutput]=Ueq(obj)
              N=obj.getN;
            %Uxx, Uyy, Uzz, Uyz, Uxz, Uxy 
            for TemperatureCounter=1:obj.NumberOfTemperatures
                for AtomCounter=1:obj.NumberOfAllAtoms
                    Ucif=obj.ReaderToMatrix(AtomCounter,TemperatureCounter);
                   
             
                     Ustar=(N)*Ucif*(N)';
                  Ucart=(obj.Vector)*Ustar*(obj.Vector)';
                  Ueq=(1/3)*trace(Ucart);
                    UeqOutputPerTemperature(:,AtomCounter)=Ueq;
                    
                end
                UeqOutput(:,:,TemperatureCounter)=UeqOutputPerTemperature;
         end
         end
     
    end
    
    
end
