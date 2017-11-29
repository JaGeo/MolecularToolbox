classdef UstarWorker<Worker
    %Converts Ustar to Ucif, Bcif, Betas, Ueq, U1,U2,U3
    properties(GetAccess = 'private', SetAccess = 'private')
        
    end
    
    
    
    methods
        
        function obj=UstarWorker(Vector,g1length,g2length,g3length,Reader,TSTART,TEND,TSTEP,NumberOfAllAtoms)
            obj@Worker(Vector,g1length,g2length,g3length,Reader,TSTART,TEND,TSTEP,NumberOfAllAtoms);%uses Constructor from Superclass
        end
        
        %Transforms Ustar to Ucif
         function [UcifOutput]=Ucif(obj)
             N=obj.getN;

               for TemperatureCounter=1:obj.NumberOfTemperatures
                 for AtomCounter=1:obj.NumberOfAllAtoms
                      Ustar=obj.ReaderToMatrix(AtomCounter,TemperatureCounter);
                      Ucif=(inv(N))*Ustar*(inv(N))';
                      UcifOutputPerTemperature(:,:,AtomCounter)=Ucif;
                end
                UcifOutput(:,:,:,TemperatureCounter)=UcifOutputPerTemperature;

           end
             
             
         end
         
         %Transforms Ustar to Bcif
         function [BcifOutput]=Bcif(obj)
             N=obj.getN;
          for TemperatureCounter=1:obj.NumberOfTemperatures
                 for AtomCounter=1:obj.NumberOfAllAtoms
                     Ustar=obj.ReaderToMatrix(AtomCounter,TemperatureCounter);
                     Ucif=(inv(N))*Ustar*(inv(N))';
                     BcifOutputPerTemperature(:,:,AtomCounter)=Ucif*8*pi^2;
                     
                 end
                 BcifOutput(:,:,:,TemperatureCounter)=BcifOutputPerTemperature;
                 
             end
             
         end
         
         
         
         %gives Ustar back
         function [UstarOutput]=Ustar(obj)
             for TemperatureCounter=1:obj.NumberOfTemperatures
                for AtomCounter=1:obj.NumberOfAllAtoms
                    Ustar=obj.ReaderToMatrix(AtomCounter,TemperatureCounter);
                    UstarOutputPerTemperature(:,:,AtomCounter)=Ustar;

                end
                UstarOutput(:,:,:,TemperatureCounter)=UstarOutputPerTemperature;

            end
        end
         
         %Converts Ustar to Betas
         function [BetasOutput]=Betas(obj)

             for TemperatureCounter=1:obj.NumberOfTemperatures
                 for AtomCounter=1:obj.NumberOfAllAtoms
             
                   Ustar=obj.ReaderToMatrix(AtomCounter,TemperatureCounter);
                   BetasOutputPerTemperature(:,:,AtomCounter)=Ustar*2*pi^2;
                  
                 end
                 BetasOutput(:,:,:,TemperatureCounter)=BetasOutputPerTemperature;
             end
             
         end
         
         %Converts Ustar to a Cartesian Coordinate System
         function [UcartOutput]=Ucart(obj)
                  N=obj.getN;
             for TemperatureCounter=1:obj.NumberOfTemperatures
                 for AtomCounter=1:obj.NumberOfAllAtoms
                    
                  Ustar=obj.ReaderToMatrix(AtomCounter,TemperatureCounter);
                  Ucart=(obj.Vector)*Ustar*(obj.Vector)';
                                      
                   UcartOutputPerTemperature(:,:,AtomCounter)=Ucart;
                     
                 end
                UcartOutput(:,:,:,TemperatureCounter)=UcartOutputPerTemperature;
             end   
             
             
         end
         
         
         
         %Calculates the main-axis components for all T
         
         function  [eOutput]=U1U2U3(obj)

             for TemperatureCounter=1:obj.NumberOfTemperatures
                 for AtomCounter=1:obj.NumberOfAllAtoms
                  Ustar=obj.ReaderToMatrix(AtomCounter,TemperatureCounter);
                  Ucart=(obj.Vector)*Ustar*(obj.Vector)';
                              
                  eOutputPerTemperature(:,AtomCounter)=eig(Ucart);
                     
                 end
                eOutput(:,:,TemperatureCounter)=eOutputPerTemperature;
             end   
         end
 
%           %Calculates the main-axis components for one special T
         function e=U1U2U3ForASpecifiedT(obj,T)
             
             Tnumber=(T-obj.TSTART)/obj.TSTEP+1;
                                       
             for AtomCounter=1:obj.NumberOfAllAtoms
                Ustar=obj.ReaderToMatrix(AtomCounter,TemperatureCounter);
                Ucart=(obj.Vector)*Ustar*(obj.Vector)';
                 
                 e(:,AtomCounter)=eig(Ucart);
                                         
             end
                    
         end
%         
%         
%     Calculates the equivalent Uiso    from Ustar
          function [UeqOutput]=Ueq(obj)
             %Uxx, Uyy, Uzz, Uyz, Uxz, Uxy 
             for TemperatureCounter=1:obj.NumberOfTemperatures
                 for AtomCounter=1:obj.NumberOfAllAtoms
                   Ustar=obj.ReaderToMatrix(AtomCounter,TemperatureCounter);
                   Ucart=(obj.Vector)*Ustar*(obj.Vector)';
                   Ueq=(1/3)*trace(Ucart);
                   UeqOutputPerTemperature(:,AtomCounter)=Ueq;
                 end
                 UeqOutput(:,:,TemperatureCounter)=UeqOutputPerTemperature;
            end
          end
   
    end
end
