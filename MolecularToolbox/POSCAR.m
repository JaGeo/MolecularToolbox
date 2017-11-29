classdef POSCAR <StructureReader
    %A object of the type POSCAR reads a POSCAR and can evaluate several
    %properties. This class is subclass of StructureReader
    
    
    properties(GetAccess = 'public', SetAccess = 'private')
        
        KindOfCoordinates %Direct coordinates?
        Coord %Array of the Coordinates
        Atomnames %Array with the names of the Atoms
        % POSCARVector %lattice vectors from POSCAR with the scaling factor
        NumberOfAllAtoms %number of atoms in your POSCAR
        NumberofAtomsperType %number of atoms per atom type
        filename %name of the POSCAR
        NumberofAtomTypes %number of atom types
    end
    
    methods
        %Constructor that reads the file
        function obj=POSCAR(filename)
            obj.filename=filename;
            obj.NumberOfAllAtoms=0;
            obj.NumberofAtomsperType=[];
            try
            
            fid = fopen(filename);
            
            reader=[];
            %tests whether there are atom names in the file, stops if not
            reader = textscan(fid, '%s','delimiter', '\n');
            catch
              
                error([filename ' is missing.'  ]);    
                
            end   
            
            VASP5Info=strtrim(char(reader{1}{6}));
            if isstrprop(VASP5Info(1),'alpha')~=true
                error('This is not the VASP 5 format of the POSCAR. Please insert the names of the atom types in line 6 of the POSCAR. One cannot print a cif without it.')
            end
            
            AreThereSelectiveD=strtrim(char(reader{1}{9}));
            
            if isstrprop(AreThereSelectiveD(1),'alpha')==true
                error('The coordinates have to start in line 9. Please remove "Selective Dynamics" or similar from line 7.')
            end
            
            %Tests whether the scaling factor is bigger than 0.0. Stops if
            %not
            Scaling=str2num(reader{1}{2});
            if Scaling <=0
                error('Only a scaling factor for each lattice vector can be included, not one for the overall volume. The program stops here. Please change the POSCAR.')
               
            end
            
            
            
            obj.KindOfCoordinates=strtrim(reader{1}{8});
            KindOfCoordinatescharArray=char(obj.KindOfCoordinates);
            
            if (KindOfCoordinatescharArray(1)~='d') & (KindOfCoordinatescharArray(1)~='D')
                %disp('');
                error('Please use Direct coordinates in the POSCAR. The program stops here. Please adapt the POSCAR.');
                %return
            end
            
            
            
            
            
            %saves the lattice vector and multiplies it by the scaling
            %factor
            POSCARVectortest(1,:)=str2num(reader{1}{3} );
            POSCARVectortest(2,:)=str2num(reader{1}{4} );
            POSCARVectortest(3,:)=str2num(reader{1}{5} );
            obj.POSCARVector=POSCARVectortest'*Scaling;
            
            
            %saves the atom names           
            obj.Atomnames=strsplit(strtrim(reader{1}{6}));
            NumberofAtomsperType=str2num(reader{1}{7});
            obj.NumberofAtomsperType=NumberofAtomsperType;
            
            
            obj.NumberofAtomTypes=size(NumberofAtomsperType,2);
            for i=1:obj.NumberofAtomTypes
                obj.NumberOfAllAtoms=obj.NumberofAtomsperType(i)+obj.NumberOfAllAtoms;
            end
            
         
                     
            %tries to read in the coordinates
            try
            for i=1:obj.NumberOfAllAtoms
             
                obj.Coord(i,:)=str2num(reader{1}{8+i} );
             
                
            end
            catch
                error('There are less coordinates in the POSCAR than indicated by the number of atoms for each element.') 
                
            end
                  
            
            

            
            
            
            % if (KindOfCoordinatescharArray(1)=='d') | (KindOfCoordinatescharArray(1)=='D')
            %   disp('Allet jut');
            % end
            
            fclose(fid);
            
            
        end
        
        %gives lattice lengths and angles
        function [a,b,c,alphaInDegrees,betaInDegrees,gammaInDegrees]=LatticeLengthsAndAngles(obj)
            a=0;
            b=0;
            c=0;
            a=norm(obj.POSCARVector(:,1));
            b=norm(obj.POSCARVector(:,2));
            c=norm(obj.POSCARVector(:,3));
            alphaInDegrees = acos(dot(obj.POSCARVector(:,2),obj.POSCARVector(:,3)) / b / c) / pi * 180.0;
            betaInDegrees  = acos(dot(obj.POSCARVector(:,3),obj.POSCARVector(:,1)) / c / a) / pi * 180.0;
            gammaInDegrees = acos(dot(obj.POSCARVector(:,1),obj.POSCARVector(:,2) ) / a / b) / pi * 180.0;
        end
        
        %one definition of the Cartesian Coordinate system. Just to make
        %the Cartesian Coordinates comparable!
        
        function [Vector]=NewCartesianCoordinateSystem(obj)
            [a,b,c,alphaInDegrees,betaInDegrees,gammaInDegrees]=obj.LatticeLengthsAndAngles;
            alpha=0;
            beta=0;
            gamma=0;
            a1=0;
            a2=0;
            a3=0;
            b1=0;
            b2=0;
            b3=0;
            c1=0;
            c2=0;
            c3=0;
            Vector=[];
            alpha = alphaInDegrees*pi / 180.0;
            beta =betaInDegrees*pi / 180.0;
            gamma = gammaInDegrees*pi / 180.0;
            a1 = 1.0;
            a2 = 0.0;
            a3 = 0.0;
            b1 = cos(gamma);
            b2 = sin(gamma);
            b3 = 0.0;
            c1 = cos(beta);
            c2 = ( cos(alpha)  -   b1 * c1 ) / ( b2);
            c3 = sqrt(1 - c1^2 - c2^2);
            Vector=[a1*a b1*b c1*c;a2*a b2*b c2*c; a3*a b3*b c3*c];
        end
       
        
        function [CartesianCoordinates]=KindOfCoordinatesfuerRMS(obj)
            [LatticeVector]=NewCartesianCoordinateSystem(obj);
            CartesianCoordinates=(LatticeVector*obj.Coord')';
            
        end
        
        function [MatrixperAtomType]=MatrixperAtomType(obj)
            
            
            Counter=1;
            
            for Type=1:obj.NumberofAtomTypes
                for NumberperType=1:obj.NumberofAtomsperType(Type)
                    MatrixperAtomType(Type,NumberperType,:)=obj.Coord(Counter,:);
                    Counter=Counter+1;
                end
                
            end
            
            
            
        end
        
        
        
        
    end
    
    
    
end

