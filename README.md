[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://github.com/JaGeo/AtomicContributions/blob/master/LICENSE)

# MolecularToolbox

Features of the Toolbox
----------
1. Conversion of Anisotropic Displacement Parameters to Different Parametrizations
<img src="https://github.com/JaGeo/MolecularToolbox/blob/master/Doc/Piktogramm-01.png" width="40%" height="40%">
2. Calculation of the Root-Mean-Square of the Cartesian Displacements
<img src="https://github.com/JaGeo/MolecularToolbox/blob/master/Doc/Piktogramm-02.png" width="40%" height="40%">

Have a look at [Doc/Documentation.pdf](https://github.com/JaGeo/MolecularToolbox/blob/master/Doc/Documentation.pdf) for an introduction to the use of the program.


How to install the MATLAB Toolbox
-------------
- Download the **Molecular-Toolbox.mltbx**-file
- Open your MATLAB. Please use version 2015a or newer.
- Browse with MATLAB's explorer to the folder with the Molecular-Toolbox files.
- Double click on the **Molecular-Toolbox.mltbx**-file.
- Click **Install**.
- Check whether the Molecular-Toolbox is correctly installed. 
- This is done by going to the **Home** tab, then switching to the **Environment** section, clicking on the **Add-Ons** icon and finally selecting **Manage Add-Ons**.
- Run the scripts within the Matlab GUI or in the shell by typing:
  `matlab -nodisplay < NameOfTheScript.m`

How to use the scripts
----------------------
- Download a script from the **Example** folder (choose according to task)
- Adapt the filenames and temperatures in the scripts (names for *POSCAR* files and *thermal_displacement_matrices.yaml*)
- Run the scripts within the Matlab GUI or in the shell by typing:
  `matlab -nodisplay < NameOfTheScript.m`


What to cite
----------
If you use the program to convert ADPs, please cite:
- R. W. Grosse-Kunstleve and P. D. Adams, *J. Appl. Crystallogr.*, **2002**, *35*, 477–480.
- J. George, A. Wang, V. L. Deringer, R. Wang, R. Dronskowski, U. Englert, *CrystEngComm*, **2015**, *17*, 7414–7422.

And please, don’t forget to cite Phonopy

- A. Togo, I. Tanaka, *Scr. Mater.* **2015**, *108*, 1–5.

and the ADP calculation with Phonopy, if you have performed it:

- V. L. Deringer, R. P. Stoffel, A. Togo, B. Eck, M. Meven, R. Dronskowski, *CrystEngComm*, **2014**, *16*, 10907–10915.
- J. George, A. Wang, V. L. Deringer, R. Wang, R. Dronskowski, U. Englert, *CrystEngComm*, **2015**, *17*, 7414–7422.

If you use the program to calculate the root-mean-square of the Cartesian Displacements, please cite:

- J. George, V. L. Deringer, R. Dronskowski, *Inorg. Chem.*, **2015**, *54*, 956–962.

If you use the program to calculate the root-mean-square of the Cartesian Displacements as defined by van de Streek and Neumann, please cite:

- J. van de Streek, M. A. Neumann, *Acta Cryst. B*, **2010**, *66*, 544–558.
- J. George, V. L. Deringer, R. Dronskowski, *Inorg. Chem.*, **2015**, *54*, 956–962.


Information about the Author
--------

- J. George (RWTH Aachen University)
- PI during the development of the code: [R. Dronskowski, RWTH Aachen University](http://www.ssc.rwth-aachen.de/)

Have a look at our project website for the calculation of thermal ellipsoids: [www.ellipsoids.de](http://www.ellipsoids.de)!

