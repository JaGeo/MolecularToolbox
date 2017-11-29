classdef ADPReaderFromFile
    % Reads Input-Values (Ustar, Ucif, Bcif, Betas) from a specific file.
    % Order of the matrix elements in the file: B11 B22 B33 B23 B13 B12
    properties(GetAccess = 'public', SetAccess = 'private')
        %3D array: First dimension: U xx, yy, zz, yz, xz, xy, Second Dimension: specfies the atom number, third dimension: specifies the number of the temperature
        Reader
        
        %Information about the temperature range
        NumberOfTemperatures
        TSTART
        TEND
        TSTEP
        
        %saves the number of all atoms
        NumberOfAllAtoms
        
        %Test
        
        %is a cell that gives Names of the Atoms for each temperature
        AtomnameWithNumber
    end
    methods
        %Constructor: It just reads the file!
        function obj=ADPReaderFromFile(filenamethermals,TSTART,TEND,TSTEP,NumberOfAllAtoms)
            
            %Initializes the attributes of the object
            obj.TSTART=TSTART;
            obj.TEND=TEND;
            obj.TSTEP=TSTEP;
            
            if (TSTEP<=0)
                error('TSTEP cannnot be 0 or smaller.')
            end
            
            if (TSTART >TEND)
                error('TSTART has to be smaller than TEND or equal to TEND.')
            end
            
            
            obj.NumberOfTemperatures=((obj.TEND-obj.TSTART)/obj.TSTEP)+1;
            obj.NumberOfAllAtoms=NumberOfAllAtoms;
            
            
            
            try
                %Opens the file to read the matrix elements
                
                fid2=fopen(filenamethermals);
                
                % First line is not read
                text=fgets(fid2);
            catch
                error([filenamethermals ' is missing.'  ]);
            end
            
            found = strfind(text,num2str(obj.TSTART));
            if (isempty(found)==true)
                error('The temperature ranges in both input files differ. Please make that consistent.');
            end
          
            
            %Opens the file to read the matrix elements
            
            fid2=fopen(filenamethermals);
            
            % First line is not read
            fgets(fid2);
            
            %Try and catch-statement since the file-format could be wrong!
            %If so an error-message is given
            try
                %Iterates over all Temperatures
                for TemperatureCounter=1:obj.NumberOfTemperatures
                    
                    [ReaderLittle]=fscanf(fid2,'%*s %f %f %f %f %f %f',[6 obj.NumberOfAllAtoms]);
                    
                    obj.Reader(:,:,TemperatureCounter)=ReaderLittle;
                    fgets(fid2);
                    text2=fgets(fid2);
                    t=(TemperatureCounter)*obj.TSTEP+obj.TSTART;
                    if t<=obj.TEND
                       
                        found = strfind(text2,num2str(t));
                        if (isempty(found)==true)
                            error('The temperature ranges in both input files differ. Please make that consistent.');
                        end
                    end
                end
            catch
                error(['There is something wrong with the '  filenamethermals ' File.' char(10) 'Please check the temperature range again. Is the number of atoms consistent at all temperatures? Is the format of the input files in general correct?'])
                
            end
            
            %Closes the file
            fclose(fid2);
            %Opens it again to read the name of the atoms.
            fid2=fopen(filenamethermals);
            % First line is not read
            fgets(fid2);
            %Try and catch-statement since the file-format could be wrong!
            %If so an error-message is given
            try
                for TemperatureCounter=1:obj.NumberOfTemperatures
                    
                    Atomreader{:,TemperatureCounter}=textscan(fid2,'%s %*f %*f %*f %*f %*f %*f',[obj.NumberOfAllAtoms 1]);
                    
                    fgets(fid2);
                    fgets(fid2);
                end
            catch
                error(['There is something wrong with the ' filenamethermals ' file.' char(10)  'Please check the temperature range again.' char(10) 'Is the number of atoms consistent at all temperatures?' char(10) 'Is the format correct?'])
                
            end
            
            % is this the end of the file?
            if ~(feof(fid2))
                error(['The given temperature range could be wrong. Please check your files again.' char(10) 'If it isn''t incorrect please remove the empty lines at the end of the ' filenamethermals ' file.'])
            end
            
            %Closes the file
            fclose(fid2);
            
            obj.AtomnameWithNumber=Atomreader;
        end
    end
end




