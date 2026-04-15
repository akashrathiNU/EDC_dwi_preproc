# BD2_dwi_preproc

Instructions:
1. Ensure FSL, freesurfer, and MATLAB are all installed.
2. Download the following libaries and pipelines and place them in your home directory:
    BRC Pipeline (https://github.com/SPMIC-UoN/BRC_Pipeline)
    ANTs (https://github.com/ANTsX/ANTs)
    SPM (https://github.com/spm)
    DVARS (https://gitlab-public.fz-juelich.de/f.hoffstaedter/multistate12/-/tree/master/DVARS-master)
    eddy qc release (https://github.com/mabast85/eddy_qc_release)

3. Replace SetUpBRCPipeline.sh in the BRC_Pipeline with the version in this repo.
4. Run the following command:
    source BRC_Pipeline/SetUpBRCPipeline.sh
5. Place bidsified data in the bids folder.
6. Run the following command in terminal:
    ./master_preproc.sh sub-{subjectID}
