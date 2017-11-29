classdef PhonopyADPs
    %Reads files from Phonopy
    properties(GetAccess = 'public', SetAccess = 'private')
        %Information about temperature range
        NumberOfTemperatures
        %start of the temperature range
        TSTART
        %end of the temperature range
        TEND
        %temperature step
        TSTEP
        
        %3D array: First dimension: U xx, yy, zz, yz, xz, xy, Second Dimension: specfies the atom number, third dimension: specifies the number of the temperature
        UcartReader
        
        %saves number of all atoms
        NumberOfAllAtoms
    end
    
    
    
    methods
        %Constructor that reads in the files!
        function obj=PhonopyADPs(filenamethermals,TSTART,TEND,TSTEP,NumberOfAllAtoms)
            %initializes all values
            obj.NumberOfTemperatures=0;
            obj.TSTART=TSTART;
            obj.TEND=TEND;
            obj.TSTEP=TSTEP;
            obj.NumberOfTemperatures=((obj.TEND-obj.TSTART)/obj.TSTEP)+1;
            obj.NumberOfAllAtoms=NumberOfAllAtoms;
            
            %Checks TSTART,TSTEP and TEND
            if (TSTEP<=0)
                error('TSTEP cannnot be 0 or smaller.')
            end
            
            if (TSTART >TEND)
               error('TSTART has to be smaller than TEND or equal to TEND.') 
            end
            
            
            %opens file
            try
                fid2=fopen(filenamethermals);
                
                
                %ignore some lines
                for i = 1:6
                    
                    if i==5
                        text=fgets(fid2);
                    else
                        fgets(fid2);
                    end
                    
                end
            catch
                error([filenamethermals ' is missing.'  ]);
                
            end
            
            found = strfind(text,num2str(obj.TSTART));
            if (isempty(found)==true)
                error('The temperature ranges in both input files differ. Please make that consistent.');
            end
            
            
            UcartReaderLittle=[];
            obj.UcartReader=[];
            
            
            %try and catch statement if something with the format is not
            %okay. Gives an error if it is not okay.
            try
                
            %read the data for all temperatures
            for TemperatureCounter=1:obj.NumberOfTemperatures
                UcartReaderLittle=fscanf(fid2,'%*s %*s %f %*s %f %*s %f %*s %f %*s %f %*s %f %*c %*c %*s %*i ',[6 obj.NumberOfAllAtoms]);
                obj.UcartReader(:,:,TemperatureCounter)=UcartReaderLittle;
                
                for i = 1:3
                                      
                    if i==2
                        text=fgets(fid2);
                    else
                        fgets(fid2);
                    end
                end
                t=(TemperatureCounter)*obj.TSTEP+obj.TSTART;
                    if t<=obj.TEND
                       
                        found = strfind(text,num2str(t));
                        if (isempty(found)==true)
                            error('The temperature ranges in both input files differ. Please make that consistent.');
                        end
                    end
            end
            catch
            error(['There is something wrong with "thermal_displacement_matrices.yaml".' char(10) 'It does not fit to the given POSCAR. The given temperature range could be incorrect' char(10) 'or you have used an old Phonopy version.' char(10) 'Please use at least Phonopy 1.9.7.'])    
                
            end
            
            % is this the end of the file?
            if ~(feof(fid2))
            
                error(['The given temperature range could be wrong. Please have a look at the input files.' char(10) 'If it isn''t wrong, please remove the empty lines at the end of the ADP input file.'])
            end
            
            
            fclose(fid2);
            
        end
        
        
        
        
        
        
    end
end
