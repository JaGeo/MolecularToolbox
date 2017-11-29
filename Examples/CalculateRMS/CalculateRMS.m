%% RMS of the Cartesian Displacement
% You can also calculate the root mean square of the Cartesian displacement
% with the help of two POSCARs in which the atoms have to be sorted in the
% same way. This is done as described in:
% <https://dx.doi.org/10.1021/ic5023328 J.George, V. L. Deringer, R. Dronskowski, _Inorg. Chem._ , *2015* , _54_ , 956–962>. Please cite this
% article, if you use this script.

%%

import Molecular-Toolbox.*
%%
% The script does not work if the atoms of the two POSCARs are sorted differently!
%%
% Just define the relative pathways of the sorted POSCARs and the
% output file below. Then, run the script.

PathwayPOSCAR1='POSCAR.vdw';
PathwayPOSCAR2='POSCAR_exp100K';
filenameOUTPUT='RMS';

%%
% If you do not know what you are doing, do not change anything here,
% please.
%
% What is actually done here?
% A object called RMS1 of the type RMS is instantiated. Therefore, the pathways of two POSCARs are needed. Then, its method printFileRMSandRMSxyz is called with the pathway of the OUTPUT-file.

try
    RMS1=RMS(PathwayPOSCAR1,PathwayPOSCAR2);
    RMS1.printFileRMSandRMSxyz(filenameOUTPUT);
    disp('No error. All files are created :).')
    
    
    %That is why you get an error message.
catch exception
     disp(exception.message)
end
clear;
