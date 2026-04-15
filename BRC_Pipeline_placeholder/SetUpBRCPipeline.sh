#!/usr/bin/env bash
# Last update: 16/10/2025

# Script name: init_vars.sh
# Description: Initialize environment variables for the BRC pipeline.
# Authors: Adapted by Akash Rathi (based on Mohammadi-Nejad & Sotiropoulos)

set -e

############################################
#   AUTOMATIC SETUP — NO MANUAL EDITS NEEDED
############################################

# Detect repo root (directory containing this script)
REPO_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Optional: detect system OS for compatibility
OS=$(uname -s)

# Default: running locally, not on a cluster
export CLUSTER_MODE="${CLUSTER_MODE:-NO}"

############################################
#   LIBRARY LOCATIONS
############################################

# Automatically resolve subfolders in the repo
export BRCDIR="${REPO_ROOT}"
export BRC_SCTRUC_DIR="${BRCDIR}/BRC_structural_pipeline"
export BRC_DMRI_DIR="${BRCDIR}/BRC_diffusion_pipeline"
export BRC_FMRI_DIR="${BRCDIR}/BRC_functional_pipeline"
export BRC_PMRI_DIR="${BRCDIR}/BRC_perfusion_pipeline"
export BRC_FMRI_GP_DIR="${BRCDIR}/BRC_func_group_analysis"
export BRC_IDPEXTRACT_DIR="${BRCDIR}/BRC_IDP_extraction"
export BRC_GLOBAL_DIR="${BRCDIR}/global"

# Script directories
export BRC_SCTRUC_SCR="${BRC_SCTRUC_DIR}/scripts"
export BRC_DMRI_SCR="${BRC_DMRI_DIR}/scripts"
export BRC_FMRI_SCR="${BRC_FMRI_DIR}/scripts"
export BRC_PMRI_SCR="${BRC_PMRI_DIR}/scripts"
export BRC_FMRI_GP_SCR="${BRC_FMRI_GP_DIR}/scripts"
export BRC_IDPEXTRACT_SCR="${BRC_IDPEXTRACT_DIR}/scripts"
export BRC_GLOBAL_SCR="${BRC_GLOBAL_DIR}/scripts"

# cuDIMOT path
export CUDIMOT="${BRC_GLOBAL_DIR}/libs/cuDIMOT"

############################################
#   FSL, FreeSurfer, MATLAB SETUP
############################################

if [ "$CLUSTER_MODE" = "YES" ]; then
    export JOBSUBpath="/gpfs01/software/imaging/jobsub"
else
    # Try to detect FSL and FreeSurfer automatically if installed in common locations
    if [ -z "$FSLDIR" ]; then
        if [ -d "/usr/local/fsl" ]; then
            export FSLDIR="/usr/local/fsl"
        elif [ -d "/Applications/fsl" ]; then
            export FSLDIR="/Applications/fsl"
        else
            echo "Warning: FSL not found. Please install or set FSLDIR manually."
        fi
    fi
    [ -f "${FSLDIR}/etc/fslconf/fsl.sh" ] && source "${FSLDIR}/etc/fslconf/fsl.sh"
    export FSLOUTPUTTYPE="NIFTI_GZ"

    if [ -z "$FREESURFER_HOME" ]; then
        if [ -d "/usr/local/freesurfer" ]; then
            export FREESURFER_HOME="/usr/local/freesurfer"
        elif [ -d "/Applications/freesurfer" ]; then
            export FREESURFER_HOME="/Applications/freesurfer"
        fi
    fi
    [ -f "${FREESURFER_HOME}/SetUpFreeSurfer.sh" ] && source "${FREESURFER_HOME}/SetUpFreeSurfer.sh"

    # MATLAB
    if [ -z "$MATLABpath" ]; then
        export MATLABpath="$(which matlab 2>/dev/null || echo '/usr/local/MATLAB/bin')"
    fi

    # CUDA (optional)
    if [ -d "/usr/local/cuda/lib64" ]; then
        export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64"
    fi
fi

############################################
#   OTHER LIBRARIES (if bundled with repo)
############################################

export SPMpath="${BRCDIR}/libs/spm"
export DVARSpath="${BRCDIR}/libs/DVARS"
export ANTSPATH="${BRCDIR}/libs/ANTs"
export C3DPATH="${BRCDIR}/libs/c3d"

############################################
#   ADD TO PATH
############################################

export PATH=$PATH:$BRC_SCTRUC_DIR:$BRC_DMRI_DIR:$BRC_FMRI_DIR:$BRC_PMRI_DIR:$BRC_FMRI_GP_DIR:$BRC_IDPEXTRACT_DIR
export PATH=$PATH:$SPMpath:$DVARSpath:$ANTSPATH:$C3DPATH

echo "Environment initialized successfully from: $REPO_ROOT"

