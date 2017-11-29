%% Calculate other ADP parametrizations starting from B
%
% Please cite the following papers, if you use this script:
%
% # R. W. Grosse-Kunstleve, P. D. Adams, _J. Appl. Crystallogr._ , 2002, *35*, 477–480.
% # J. George, A. Wang, V. L. Deringer, R. Wang, R. Dronskowski, U. Englert, _CrystEngComm_ , 2015, *17*, 7414-7422.
%
%


%%

import Molecular-Toolbox.*

%%
% Then, specify the type of input data you wish to convert. 
% You can choose between the following keywords: Betas, Bcif, Ucif, or Ustar.
% It will only work if the spelling is correct.
INPUTType='Bcif';
%%
% Then, give the name of your input file. The tensor elements have to be sorted in the following way:
% E11 E22 E33 E23 E13 E12
NameOfFile='BcifInput';

%%
% Specify the lattice parameters of the structure: a, b, c, alpha, beta, gamma.

a=5.350524;
b=5.192441;
c=15.058446;
alpha=89.999991;
beta=99.578013;
gamma=89.999998;

%%
% Specify the temperature range by giving the starting temperature TSTART, the end temperature TEND and the step TSTEP:

TSTART=0;
TEND=10;
TSTEP=10;

%%
% Specify the number of atoms in the structure
NumberofAtomsPerTemperature=22;



%%
% Last, name the output files here:
OUTPUTU1U2U3='U1U2U3';
OUTPUTUcif='Ucif';
OUTPUTBcif='BcifOutput';
OUTPUTUstar='Ustar';
OUTPUTBetas='Betas';
OUTPUTUeq='Ueq';




%%
% If you do not know what you are doing, do not change anything here,
% please.
try
    if strcmp(INPUTType,'Bcif')
        NewWriter=FromBcifwriter(a,b,c,alpha,beta,gamma,NameOfFile,TSTART,TEND,TSTEP,NumberofAtomsPerTemperature);
    elseif  strcmp(INPUTType,'Betas')
        NewWriter=FromBetaswriter(a,b,c,alpha,beta,gamma,NameOfFile,TSTART,TEND,TSTEP,NumberofAtomsPerTemperature);
    elseif strcmp(INPUTType,'Ucif')
        NewWriter=FromUcifwriter(a,b,c,alpha,beta,gamma,NameOfFile,TSTART,TEND,TSTEP,NumberofAtomsPerTemperature);
    elseif strcmp(INPUTType,'Ustar')
        NewWriter=FromUstarwriter(a,b,c,alpha,beta,gamma,NameOfFile,TSTART,TEND,TSTEP,NumberofAtomsPerTemperature);
    end
    
    
    NewWriter.writeU1U2U3inFile(OUTPUTU1U2U3);
    NewWriter.writeUcifinFile(OUTPUTUcif);
    NewWriter.writeBcifinFile(OUTPUTBcif);
    NewWriter.writeUstarinFile(OUTPUTUstar);
    NewWriter.writeBetasinFile(OUTPUTBetas);
    NewWriter.writeUeqinFile(OUTPUTUeq);
    
    disp('No error. All files are created :).');
    
    
    % That is why you get an error message.
catch exception
    
    disp(exception.message)
    
end
clear;
