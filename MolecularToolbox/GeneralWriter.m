classdef GeneralWriter<WriterSuperclass
    %Superclass of FromBcifwriter, FromBetaswriter, FromUcifwriter, FromUstarwriter
    %To use this the object ADP has to be initialized. This object has to
    %have the functions defined in the abstract class Worker
    properties(GetAccess = 'public', SetAccess = 'protected')
        %Informations about the temperature range
        TSTART
        TEND
        TSTEP
        
        %Information about the structure
        a
        b
        c
        alphaInDegrees
        betaInDegrees
        gammaInDegrees
        NumberOfAllAtoms
        AtomnameWithNumber
        
        %Type of this Object is a Subtype to Worker:
        ADP
        
        %Type of this Object is StructureReaderDirect
        Structure1
        
        %Reciprocal Lattice Lengths
        g1length
        g2length
        g3length
        
        %saves the ADPs from files
        Reader1
          end
    
    
    
    methods
        
        function obj=GeneralWriter(a,b,c,alpha,beta,gamma,filenameADPs,TSTART,TEND,TSTEP,NumberOfAllAtoms)
            obj.TSTART=TSTART;
            obj.TEND=TEND;
            obj.TSTEP=TSTEP;
            obj.NumberOfAllAtoms=NumberOfAllAtoms;
            obj.Structure1=StructureReaderDirect(a,b,c,alpha,beta,gamma);
            [obj.g1length,obj.g2length,obj.g3length]=obj.Structure1.ReciprocalLatticeLengthsFromPOSCAR;
            obj.NumberOfAllAtoms=NumberOfAllAtoms;
            obj.Reader1=ADPReaderFromFile(filenameADPs,TSTART,TEND,TSTEP,NumberOfAllAtoms);
            obj.AtomnameWithNumber=obj.Reader1.AtomnameWithNumber;
            [obj.a, obj.b, obj.c, obj.alphaInDegrees,obj.betaInDegrees,obj.gammaInDegrees]=obj.Structure1.LatticeLengthsAndAngles;
            
            
        end
        
        
        
        
        function writeU1U2U3inFile(obj,Outputfilename)
            
            
            
            fidout2 = fopen(Outputfilename,'w');
            obj.writeHeader(fidout2)
            
            e=obj.ADP.U1U2U3;
            TAnzahl=1;
            
            for TRequired=obj.TSTART:obj.TSTEP:obj.TEND
                fprintf(fidout2,'%i K\n', TRequired);
                fprintf(fidout2,'U_1 U_2 U_3\n');
                
                for AtomCounter=1:obj.NumberOfAllAtoms
                    fprintf(fidout2,'%s %e %e %e\n', obj.AtomnameWithNumber{TAnzahl}{1}{AtomCounter},e(1,AtomCounter,TAnzahl),e(2,AtomCounter,TAnzahl),e(3,AtomCounter,TAnzahl));
                    
                end
                TAnzahl=TAnzahl+1;
                
            end
            
            fclose(fidout2);
            
            
        end
        
        function writeUstarinFile(obj,Outputfilename)
                      
            fidout = fopen(Outputfilename,'w');
            obj.writeHeader(fidout)
            UstarOutput=obj.ADP.Ustar;
            TAnzahl=1;
            for T=obj.TSTART:obj.TSTEP:obj.TEND
                fprintf(fidout,'%i K\n',T);
                
                
                fprintf(fidout,'U*_11 U*_22 U*_33 U*_23 U*_13 U*_12\n');
                
                
                
                for AtomCounter=1:obj.NumberOfAllAtoms
                    fprintf(fidout,'%s %e %e %e %e %e %e\n',  obj.AtomnameWithNumber{TAnzahl}{1}{AtomCounter},UstarOutput(1,1,AtomCounter,TAnzahl),UstarOutput(2,2,AtomCounter,TAnzahl),UstarOutput(3,3,AtomCounter,TAnzahl),UstarOutput(2,3,AtomCounter,TAnzahl),UstarOutput(1,3,AtomCounter,TAnzahl),UstarOutput(1,2,AtomCounter,TAnzahl));
                    
                end
                
                
                
                fprintf(fidout,'\n');
                TAnzahl=TAnzahl+1;
            end
            fclose(fidout);
            
        end
        
        
        
        
        function writeBetasinFile(obj,Outputfilename)
                       
            fidout = fopen(Outputfilename,'w');
            obj.writeHeader(fidout)
            
            
            BetasOutput=obj.ADP.Betas;
            TAnzahl=1;
            for T=obj.TSTART:obj.TSTEP:obj.TEND
                fprintf(fidout,'%i K\n',T);
                
                
                fprintf(fidout,'beta_11 beta_22 beta_33 beta_23 beta_13 beta_12\n');
                
                
                for AtomCounter=1:obj.NumberOfAllAtoms
                    
                    fprintf(fidout,'%s %e %e %e %e %e %e\n',  obj.AtomnameWithNumber{TAnzahl}{1}{AtomCounter},BetasOutput(1,1,AtomCounter,TAnzahl),BetasOutput(2,2,AtomCounter,TAnzahl),BetasOutput(3,3,AtomCounter,TAnzahl),BetasOutput(2,3,AtomCounter,TAnzahl),BetasOutput(1,3,AtomCounter,TAnzahl),BetasOutput(1,2,AtomCounter,TAnzahl));
                    
                    
                end
                
                
                fprintf(fidout,'\n');
                TAnzahl=TAnzahl+1;
            end
            fclose(fidout);
            
        end
        
        function writeBcifinFile(obj,Outputfilename)
            
            
            fidout = fopen(Outputfilename,'w');
            
            obj.writeHeader(fidout)
            
            BcifOutput=obj.ADP.Bcif;
            TAnzahl=1;
            for T=obj.TSTART:obj.TSTEP:obj.TEND
                fprintf(fidout,'%i K\n',T);
                
                
                fprintf(fidout,'B_11 B_22 B_33 B_23 B_13 B_12\n');
                
                
                for AtomCounter=1:obj.NumberOfAllAtoms
                    
                    fprintf(fidout,'%s %e %e %e %e %e %e\n',  obj.AtomnameWithNumber{TAnzahl}{1}{AtomCounter},BcifOutput(1,1,AtomCounter,TAnzahl),BcifOutput(2,2,AtomCounter,TAnzahl),BcifOutput(3,3,AtomCounter,TAnzahl),BcifOutput(2,3,AtomCounter,TAnzahl),BcifOutput(1,3,AtomCounter,TAnzahl),BcifOutput(1,2,AtomCounter,TAnzahl));
                    
                    
                end
                
                
                fprintf(fidout,'\n');
                TAnzahl=TAnzahl+1;
            end
            fclose(fidout);
            
        end
        
        function writeUcifinFile(obj,Outputfilename)
                       
            fidout = fopen(Outputfilename,'w');
           obj.writeHeader(fidout)
            
            UcifOutput=obj.ADP.Ucif;
            TAnzahl=1;
            for T=obj.TSTART:obj.TSTEP:obj.TEND
                fprintf(fidout,'%i K\n',T);
                
                
                fprintf(fidout,'U_11 U_22 U_33 U_23 U_13 U_12\n');
                
                
                for AtomCounter=1:obj.NumberOfAllAtoms
                    
                    fprintf(fidout,'%s %e %e %e %e %e %e\n',  obj.AtomnameWithNumber{TAnzahl}{1}{AtomCounter},UcifOutput(1,1,AtomCounter,TAnzahl),UcifOutput(2,2,AtomCounter,TAnzahl),UcifOutput(3,3,AtomCounter,TAnzahl),UcifOutput(2,3,AtomCounter,TAnzahl),UcifOutput(1,3,AtomCounter,TAnzahl),UcifOutput(1,2,AtomCounter,TAnzahl));
                    
                    
                end
                
                
                fprintf(fidout,'\n');
                TAnzahl=TAnzahl+1;
            end
            fclose(fidout);
            
        end
        
        
        
        function writeUeqinFile(obj,Outputfilename)
                   
            fidout = fopen(Outputfilename,'w');
            obj.writeHeader(fidout)
            UeqOutput=obj.ADP.Ueq;
            TAnzahl=1;
            for T=obj.TSTART:obj.TSTEP:obj.TEND
                fprintf(fidout,'%i K\n',T);
                
                
                fprintf(fidout,'U_eq\n');
                
                for AtomCounter=1:obj.NumberOfAllAtoms
                    
                    fprintf(fidout,'%s %e \n',   obj.AtomnameWithNumber{TAnzahl}{1}{AtomCounter},UeqOutput(1,AtomCounter,TAnzahl));
                    
                end
                
                
                fprintf(fidout,'\n');
                TAnzahl=TAnzahl+1;
            end
            fclose(fidout);
            
        end
        
        
        
        
        
        
        
        
        
        
        
        
        
    end
    
    
    
    
    
    
    
    
    
    
    
end
