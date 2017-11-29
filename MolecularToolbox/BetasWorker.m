classdef BetasWorker<UstarWorker
    %Converts betas to all other OUTPUT-Values, several functions from
    %UstarWorker are reused
    properties(GetAccess = 'private', SetAccess = 'private')
        ReaderBetas
    end
    methods
        function obj=BetasWorker(Vector,g1length,g2length,g3length,Reader,TSTART,TEND,TSTEP,NumberOfAllAtoms)
            %Reuses the Constructor from UstarWorker
            obj@UstarWorker(Vector,g1length,g2length,g3length,Reader,TSTART,TEND,TSTEP,NumberOfAllAtoms);
            obj.ReaderBetas=obj.Reader;
            %Converts all Betas to Ustar to reusse UstarWorker
            for TemperatureCounter=1:obj.NumberOfTemperatures
                for AtomCounter=1:obj.NumberOfAllAtoms
                    obj.Reader(:,AtomCounter,TemperatureCounter)= ((obj.Reader(:,AtomCounter,TemperatureCounter))/(2*pi^2));
                end
            end
        end
        %Overwrites the function Betas in UstarWorker
        function [BetasOutput]=Betas(obj)
            for TemperatureCounter=1:obj.NumberOfTemperatures
                for AtomCounter=1:obj.NumberOfAllAtoms
                    Betas=obj.OtherReaderToMatrix(obj.ReaderBetas,AtomCounter,TemperatureCounter);
                    BetasOutputPerTemperature(:,:,AtomCounter)=Betas;
                end
                BetasOutput(:,:,:,TemperatureCounter)=BetasOutputPerTemperature;
            end
        end
    end
    
end


    
    

