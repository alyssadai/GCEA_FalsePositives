#!/bin/csh
#PBS -N CFPR_mouseSBPspatial
#PBS -o CFPR_mouseSBPspatial.txt
#PBS -q physics
#PBS -l nodes=1:ppn=12
#PBS -l mem=96GB
# Minimum acceptable walltime: day-hours:minutes:seconds
#PBS -l walltime=140:00:00
# Email user if job ends or aborts
#PBS -m ea
#PBS -M ben.fulcher@sydney.edu.au
#PBS -j oe
#PBS -V

# Show the host on which the job ran and return to home repository directory
hostname
cd $PBS_O_WORKDIR
cd ../../

# Set environment variables to run Matlab
module load Matlab2018a

# Launch the Matlab job
set jobText = "startup;parpool('local',12);params = GiveMeDefaultParams('mouse','all');params.g.whatSurrogate = 'spatialLag';params.nulls.customShuffle = 'none';SurrogateEnrichment(params); exit"
matlab -nodesktop -r "$jobText"
