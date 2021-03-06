#!/bin/bash
#SBATCH --job-name={jobname}                                        #Change the job name
#SBATCH --output=/hpc/group/soderlinglab/other/%j.out
#SBATCH --error=/hpc/group/soderlinglab/other/%j.err
#SBATCH -p scavenger-gpu --gres=gpu:1
#SBATCH -c 10
#SBATCH --mem=100G
#SBATCH --mail-type=END
#SBATCH --exclude=dcc-lefkowitz-gpu-[01-05],dcc-tdunn-gpu-[01-02],dcc-collinslab-gpu-[01-04],dcc-dsplus-gpu-[01-10]
#SBATCH --mail-user={netID}@duke.edu                                       #Change the email address


#SBATCH -a 0-2                                                          #Change the total number of sequences
file_name={filename}                                               #Change the file_name (same as before)

export SINGULARITY_TMPDIR=/hpc/home/{netID}                                #Change the NetID
export SINGULARITY_CACHEDIR=/hpc/home/{netID}                              #Change the NetID

faFile=/hpc/group/soderlinglab/optimal_insertion/sequence/${file_name}/${SLURM_ARRAY_TASK_ID}.txt
outputPath=/hpc/group/soderlinglab/optimal_insertion/output/${file_name}
ALPHAFOLD_DATA_PATH=/opt/apps/community/alphafold2/databases/

singularity run --nv \
            --env TF_FORCE_UNIFIED_MEMORY=1,XLA_PYTHON_CLIENT_MEM_FRACTION=0.5 \
            -B $ALPHAFOLD_DATA_PATH:/data \
            -B .:/etc \
            -B $outputPath \
            --pwd /app/alphafold \
            /opt/apps/community/alphafold2/alphafoldv2.2/alphafold_latest.sif \
            --fasta_paths=$faFile \
            --data_dir=/data \
            --run_relax=True\
            --use_gpu_relax=True\
            --model_preset=monomer \
            --db_preset=full_dbs \
            --max_template_date=2022-06-01 \
            --uniref90_database_path=/data/uniref90/uniref90.fasta\
            --mgnify_database_path=/data/mgnify/mgy_clusters.fa\
            --uniclust30_database_path=/data/uniclust30/uniclust30_2018_08/uniclust30_2018_08\
            --bfd_database_path=/data/bfd/bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt\
            --template_mmcif_dir=/data/pdb_mmcif/mmcif_files\
            --obsolete_pdbs_path=/data/pdb_mmcif/obsolete.dat\
            --pdb70_database_path=/data/pdb70/pdb70\
            --output_dir=$outputPath
