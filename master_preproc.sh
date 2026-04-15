#!/usr/bin/env bash
# master_preproc.sh
# Description: Master launcher for BRC diffusion preprocessing pipeline
# Author: Akash Rathi

set -e

# --- Parse subject argument ---
subject="$1"

if [ -z "$subject" ]; then
  echo "Usage: $0 <subject_id>"
  exit 1
fi

echo "Running preprocessing for subject: $subject"

# --- Define key paths ---
# Current directory where this script is executed
CURRENT_DIR="$(pwd)"

# Assume BRC_Pipeline is in the same directory as this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="${SCRIPT_DIR}/BRC_Pipeline"

# --- Source setup script in the current shell ---
if [ -f "${REPO_ROOT}/SetUpBRCPipeline.sh" ]; then
  echo "Initializing environment from ${REPO_ROOT}/SetUpBRCPipeline.sh"
  source "${REPO_ROOT}/SetUpBRCPipeline.sh"
else
  echo "Setup script not found at ${REPO_ROOT}/SetUpBRCPipeline.sh"
  exit 1
fi

echo "Environment initialized. BRCDIR = $BRCDIR"

# --- Construct input/output paths relative to current directory ---
BIDS_DIR="${CURRENT_DIR}/bids"
OUTPUT_DIR="${CURRENT_DIR}/output_folder"

AP_INPUT="${BIDS_DIR}/${subject}/ses-1/dwi/${subject}_ses-1_run-1_dir-AP_dwi.nii.gz"
PA_INPUT="${BIDS_DIR}/${subject}/ses-1/dwi/${subject}_ses-1_run-1_dir-PA_dwi.nii.gz"

# --- Verify inputs exist ---
if [ ! -f "$AP_INPUT" ]; then
  echo "Missing AP input: $AP_INPUT"
  exit 1
fi

if [ ! -f "$PA_INPUT" ]; then
  echo "Missing PA input: $PA_INPUT"
  exit 1
fi

# --- Run diffusion preprocessing pipeline ---
echo "Running diffusion preprocessing..."
"${BRCDIR}/BRC_diffusion_pipeline/dMRI_preproc.sh" \
  --input "$AP_INPUT" \
  --input_2 "$PA_INPUT" \
  --subject "$subject" \
  --path "$OUTPUT_DIR" \
  --pe_dir 2 \
  --qc \
  --tbss \
  --dki \
  --echospacing 0.00055

echo "Preprocessing complete for subject: $subject"
