classdef Bcifworker<UcifWorker
    % Converts Bcif to all other OUTPUT-Values, several functions from
    % UcifWorker are reused.
    properties(GetAccess = 'private', SetAccess = 'private')
        ReaderBcif
    end
    
    methods
        
        function obj=Bcifworker(Vector,g1length,g2length,g3length,Reader,TSTART,TEND,TSTEP,NumberOfAllAtoms)
            %Constructor from UcifWorker is reused
            obj@UcifWorker(Vector,g1length,g2length,g3length,Reader,TSTART,TEND,TSTEP,NumberOfAllAtoms);
            obj.ReaderBcif=obj.Reader;
            %Converts the data from Bcif to Ucif to reuse UcifWorker
            for TemperatureCounter=1:obj.NumberOfTemperatures
                for AtomCounter=1:obj.NumberOfAllAtoms
                    
                    obj.Reader(:,AtomCounter,TemperatureCounter)= ((obj.Reader(:,AtomCounter,TemperatureCounter))/(8*pi^2));
                    
                    
                end
            end
            
        end
        
        %Bcif from UcifWorker is overwritten since Bcif does not need to be
        %converted
        function [BcifOutput]=Bcif(obj)
            for TemperatureCounter=1:obj.NumberOfTemperatures
                for AtomCounter=1:obj.NumberOfAllAtoms
                    Bcif=obj.OtherReaderToMatrix(obj.ReaderBcif,AtomCounter,TemperatureCounter);
                    BcifOutputPerTemperature(:,:,AtomCounter)=Bcif;
                    
                end
                BcifOutput(:,:,:,TemperatureCounter)=BcifOutputPerTemperature;
                
            end
            
            
        end
        
        
        
        
    end
    
    
    
    
    
end
