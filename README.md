# 3D_ChronoCoulometry
Data processing script for 3D chronocoulometry (Charge x Time x Potential). This algorithm was developed and published at \[[1](https://doi.org/10.11606/T.46.2016.tde-07042016-090549)\] (some code formatting was performed to increase readability).

## What is 3D Chronocoulometry?
The 3D Chronocoulometry is a superposition of double step chronocoulometry \[[2](https://chem.libretexts.org/Bookshelves/Analytical_Chemistry/Supplemental_Modules_(Analytical_Chemistry)/Analytical_Sciences_Digital_Library/Courseware/Analytical_Electrochemistry%3A_The_Basic_Concepts/04_Voltammetric_Methods/A._Basics_of_Voltammetry/01_Potential_Step_Methods/b\)_Chronocoulometry)\] curves measured at different potential steps, and plotted after linearization using the Anston equation.

This experiment, initially proposed by Gutz I.G.R. \[[3](http://dx.doi.org/10.0.45.86/T.46.2008.tde-29022008-142848)\], enabled direct inspection of complex data and chemical processes, highlighting adsorption, catalysis and kinectic chemical processes. In the original work, all the instrumentation and data processing steps were made in-house.

This algorithm runs on Octave (developed in version 3.8.0) and can process data from commercial potentiostat software (NOVA 1.10, Metrohm-Autolab).

1. Batista, G. L. (2015). inglêsBreath acetone analysis: development of electroanalytical method and signal processing algorithm. Ph.D. Thesis, Instituto de Química, Universidade de São Paulo, São Paulo. doi:10.11606/T.46.2016.tde-07042016-090549. Accessed on 2023-05-15 from www.teses.usp.br
2. Analytical Electrochemistry: The Basic Concepts, Avaliable at http://chem.libretexts.org
3. Gutz, I. G. R. (1985). Chemometrics and automation in analytical chemistry: some contributions. Full Professor thesis, Instituto de Química, Universidade de São Paulo, São Paulo. doi:10.11606/T.46.2008.tde-29022008-142848. Accessed on 2023-05-15 from www.teses.usp.br
