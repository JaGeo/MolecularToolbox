%% Calculate other ADP parametrizations starting from Phonopy-Output
%
% Please cite the following papers, if you use this script:
%
% # R. W. Grosse-Kunstleve, P. D. Adams, _J. Appl. Crystallogr._ , 2002, *35*, 477–480.
% # J. George, A. Wang, V. L. Deringer, R. Wang, R. Dronskowski, U. Englert, _CrystEngComm_ , 2015, *17*, 7414-7422.
%
% And of course, don't forget to cite Phonopy and the ADP-calculation properly!

import Molecular-Toolbox.*
%%
% Please give the pathway of the POSCAR file you used for the phonon
% calculation with Phonopy.
FilenameOfYourPOSCAR='POSCAR';
%%
% Did you rename the thermal_displacement_matrices.yaml? How is it called
% at the moment? Make sure you used the POSCAR specified above to create this file.
FilenameOfYourPhonopyADPFile='thermal_displacement_matrices.yaml';
%%
% Define TMIN,TMAX and TSTEP as in your calculation with Phonopy. This is needed to
% read the thermal_displacement_matrices.yaml correctly.
TMIN=0;
TMAX=300;
TSTEP=10;

%%
% Here, name the Output-Files:
CIFwithUsFilename='U.cif';
CIFwithBsFilename='B.cif';
MainAxisComponentsFilename='U1U2U3';
UstarFilename='Ustar';
BetasFilename='Betas';
UeqFilename='Ueq';

%%
% These are the commands to get the files written. Change these
% commands only if you know what you are doing!
try
    CIF=FromPhonopywriter(FilenameOfYourPOSCAR,FilenameOfYourPhonopyADPFile,TMIN,TMAX,TSTEP);
    CIF.cifwrite(CIFwithUsFilename);
    CIF.cifwriteWithBs(CIFwithBsFilename);
    CIF.writeU1U2U3inFile(MainAxisComponentsFilename);
    CIF.writeUstarinFile(UstarFilename);
    CIF.writeBetasinFile(BetasFilename);
    CIF.writeUeqinFile(UeqFilename);
    
    disp('No error. All files are created :).')
    
    
% That is why you get an error message.
catch exception
    
    disp(exception.message)
end


clear;

