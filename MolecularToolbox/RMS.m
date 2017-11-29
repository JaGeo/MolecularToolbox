classdef RMS<WriterSuperclass
    %This class calculates the RMS and RMSxyz as defined in :
    %J.George, V. L. Deringer, R. Dronskowski, Inorg. Chem., 2015, 54 (3), pp 956–962
    properties(GetAccess = 'public', SetAccess = 'private')
        %Objects of the type POSCAR
        POSCAR1
        POSCAR2
        
        %Coordinates of both POSCARs
        Coord1
        Coord2
        
        %lattice vectors for both POSCARs
        Vector1
        Vector2
        
        %Saves the overall RMS values
        RMSxyz
        RMSabs
        %Definition by van de Streek und Neumann
        DisplacementvdStreek
        RMSvdStreek
        %How many atoms types?
        NumberofAtomTypes
        
        %Names of the POSCARs
        filename1
        filename2
        
        %Gives a data structure which saves the coordinates for each atom
        %type
        MatrixPerAtomType1
        MatrixPerAtomType2
        
        %saves the RMS values as an array.
        %2D array, first dimension is the atomtype
        RMSxyzPerAtomType
        
        %1Darray.
        RMSabsPerAtomType
        
        %An array for the number of atoms per type in the POSCARs
        NumberofAtomsperType
        
        %How are the atoms called. It is a cell.
        Atomnames
        
        %To make sure all periodic boundary conditions are okay!
        
    end
    
    
    
    methods
        
        
        function  obj=RMS(filename1,filename2)
            %constructor: some initializations
            
            
            obj.filename1=filename1;
            obj.filename2=filename2;
            
            %Read in POSCAR1 and calculate three new lattice vectors
            %(consistent definition of the Cartesian coordinate system!!)
            obj.POSCAR1=POSCAR(filename1);
            obj.Coord1=obj.POSCAR1.Coord;
            obj.Vector1=obj.POSCAR1.NewCartesianCoordinateSystem;
            obj.NumberofAtomTypes=obj.POSCAR1.NumberofAtomTypes;
            obj.MatrixPerAtomType1=obj.POSCAR1.MatrixperAtomType;
            obj.Atomnames=obj.POSCAR1.Atomnames;
            
            %Test=obj.Vector1-obj.POSCAR1.POSCARVector
            obj.NumberofAtomsperType=obj.POSCAR1.NumberofAtomsperType;
            %Read in POSCAR2 and calculate three new lattice vectors
            %(consistent definition of the Cartesian coordinate system!!)
            obj.POSCAR2=POSCAR(filename2);
            obj.Coord2=obj.POSCAR2.Coord;
            obj.Vector2=obj.POSCAR2.NewCartesianCoordinateSystem;
            obj.MatrixPerAtomType2=obj.POSCAR2.MatrixperAtomType;
            
            %Checks POSCARs for consistency
            if obj.POSCAR2.NumberofAtomTypes~=obj.POSCAR1.NumberofAtomTypes
                error('Check the POSCARs again. They do not have the same number of atom types.')
            end
            
            if obj.POSCAR2.NumberOfAllAtoms~=obj.POSCAR1.NumberOfAllAtoms
                error('Check the POSCARs again. They do not have the same number of atoms.')
            end
            
            for i=1:obj.POSCAR1.NumberofAtomTypes
                if obj.POSCAR1.NumberofAtomsperType(i)~=obj.POSCAR2.NumberofAtomsperType(i)
                    error('Check the POSCARs again. They do not have the same number of atoms per atom type.')
                end
                if ~strcmpi(obj.POSCAR1.Atomnames{i},obj.POSCAR2.Atomnames{i})
                    error ('Check the POSCARs again. The names of the atoms are inconsistent.')
                end
                
            end
            
            
            %This is not really a sufficient treatment of the periodic
            %boundary conditions but is should be okay for most of the cases
            
            
            DiffoftheFractionalCoords= abs(obj.Coord1-obj.Coord2);
            [m,n] = size(DiffoftheFractionalCoords);
            for k=1:m %
                for j=1:n
                    if DiffoftheFractionalCoords(k,j)>0.2 %
                        if obj.Coord1(k,j)>0.9
                            obj.Coord1(k,j)=obj.Coord1(k,j)-1.00;
                        elseif obj.Coord1(k,j)<0.1
                            obj.Coord1(k,j)=obj.Coord1(k,j)+1.00;
                        end
                    end
                end
            end
            Maximum=max(max(abs(obj.Coord1-obj.Coord2)),[],2);
            if Maximum > 0.2
                error('The RMS cannot be calculated. Please sort the atoms in both POSCARs in the same way. There is a huge deviation between the fractional coordinates! The program stops here.')
            end
            
            %for test purposes
            DiffoftheFractionalCoords2=abs(obj.Coord1-obj.Coord2);
            
            %test centers of gravity
            centerofgravity1=sum((obj.Vector1+obj.Vector2)*(obj.Coord1')/(2*m),2);
            centerofgravity2=sum((obj.Vector1+obj.Vector2)*(obj.Coord2')/(2*m),2);
            differencecentersofgravity=centerofgravity1-centerofgravity2;
            differencecoord=sum((obj.Coord1)/m)-sum((obj.Coord2/m));
            
            %try to adapt centers of gravity
            
            for i=1:m
               testCoord1(i,:)=obj.Coord1(i,:)-differencecoord;
            end
            
            obj.Coord1=testCoord1;

             centerofgravity11=sum((obj.Vector1+obj.Vector2)*(testCoord1')/(2*m),2);
             centerofgravity21=sum((obj.Vector1+obj.Vector2)*(obj.Coord2')/(2*m),2);
             differencecentersofgravity2=centerofgravity11-centerofgravity21;
            % if centers of gravity are still too far away: break
            if abs(max(differencecentersofgravity2)) > 10^(-3)
                error('The RMS cannot be calculated. Both cells differ strongly and their centers of gravity cannot be adapted to each other. The program stops here.')
            end
%             if abs(max(differencecentersofgravity2)) > 10^(-5)
%                warning('Be careful the cells differ in their centers of gravity. The RMS will be calculated. However, I hope you know what you are doing.')
%             end
%           
            
            
            %RMSxyz and RMS are calculated
            obj.RMSxyz=sqrt(mean(((obj.Vector1+obj.Vector2)*(obj.Coord1'-obj.Coord2')/2).^2,2));
            obj.RMSabs=sqrt(dot(obj.RMSxyz,obj.RMSxyz));

            %RMS as defined by van de Streek and Neumann
            obj.DisplacementvdStreek=(sqrt(dot(obj.Vector1*obj.Coord1'-obj.Vector1*obj.Coord2',obj.Vector1*obj.Coord1'-obj.Vector1*obj.Coord2'))+sqrt(dot(obj.Vector2*obj.Coord1'-obj.Vector2*obj.Coord2',obj.Vector2*obj.Coord1'-obj.Vector2*obj.Coord2')))/2;
            obj.RMSvdStreek=sqrt(mean(obj.DisplacementvdStreek.^2));
         
            
            
            
            %Now, per atom type!
            
            for i=1:obj.NumberofAtomTypes
                CoordNeu1=[];
                CoordNeu2=[];
                for j=1:obj.NumberofAtomsperType(i)
                    for k=1:3
                        CoordNeu1(k,j)=obj.MatrixPerAtomType1(i,j,k);
                        CoordNeu2(k,j)=obj.MatrixPerAtomType2(i,j,k);
                    end
                end
                
                DiffoftheFractionalCoordsneu= abs(CoordNeu1-CoordNeu2);
                
                              
                % Treat the periodic boundary conditions again
                
                for k=1:3
                    for j=1:obj.NumberofAtomsperType(i)
                        if DiffoftheFractionalCoordsneu(k,j)>0.2
                            if CoordNeu1(k,j)>0.9
                                CoordNeu1(k,j)=CoordNeu1(k,j)-1.00;
                            elseif CoordNeu1(k,j)<0.1
                                CoordNeu1(k,j)=CoordNeu1(k,j)+1.00;
                            end
                        end
                    end
                end
                
            %adapt centers of gravity    
            testCoordNeu1=[];
            for o=1:obj.NumberofAtomsperType(i)
               testCoordNeu1(:,o)=CoordNeu1(:,o)-differencecoord';
            end
            
            CoordNeu1=testCoordNeu1;


                
                
                %Calculation of the RMS-value per atom type
                obj.RMSxyzPerAtomType(i,:)=sqrt(mean(((obj.Vector1+obj.Vector2)*(CoordNeu1-CoordNeu2)/2).^2,2));
                obj.RMSabsPerAtomType(i)=sqrt(dot(obj.RMSxyzPerAtomType(i,:),obj.RMSxyzPerAtomType(i,:)));
            end
            
            
            
            
        end
        
        function printFileRMSandRMSxyz(obj,OutputFilename)
            %prints a File with the calculated RMS values
            fidout2 = fopen(OutputFilename,'w');
            obj.writeHeader(fidout2);
            fprintf(fidout2,'----------------------------------------\n');
            fprintf(fidout2,'RMS between the following files:\n %s %s\n', obj.filename1, obj.filename2);
            fprintf(fidout2,'----------------------------------------\n');
            fprintf(fidout2,'RMS (George et al.): %f \n', obj.RMSabs);
            fprintf(fidout2,'RMS (van de Streek and Neumann): %f \n', obj.RMSvdStreek);
            fprintf(fidout2,'RMSxyz (George et al.) : %f %f %f\n',obj.RMSxyz(1),obj.RMSxyz(2),obj.RMSxyz(3));
            fprintf(fidout2,'----------------------------------------\n');
            fprintf(fidout2,'----------------------------------------\n');
            fprintf(fidout2,'RMS per atom type:\n');
            fprintf(fidout2,'----------------------------------------\n');
            for i=1:obj.NumberofAtomTypes
                fprintf(fidout2,'Atom name %s\n', obj.Atomnames{i});
                fprintf(fidout2,'RMS (George et al.): %f \n',obj.RMSabsPerAtomType(i));
                fprintf(fidout2,'RMSxyz (George et al.): %f %f %f\n',obj.RMSxyzPerAtomType(i,1),obj.RMSxyzPerAtomType(i,2),obj.RMSxyzPerAtomType(i,3));
                fprintf(fidout2,'----------------------------------------\n');
                
            end
            fclose(fidout2);
            
            
        end
        
        
    end
    
    
    
    
end
