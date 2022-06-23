#!/bin/bash
#SBATCH --job-name={name}                                        #Set job name
#SBATCH --out=/hpc/group/soderlinglab/other/%j.out
#SBATCH --error=/hpc/group/soderlinglab/other/%j.err
#SBATCH -p scavenger-gpu --gres=gpu:1
#SBATCH -c 10
#SBATCH --mem=200G
#SBATCH --mail-type=END
#SBATCH --exclude=dcc-lefkowitz-gpu-[01-05],dcc-tdunn-gpu-[01-02],dcc-collinslab-gpu-[01-04],dcc-dsplus-gpu-[01-10]
#SBATCH --mail-user={netID}@duke.edu                               #Set email address

export SINGULARITY_TMPDIR=/hpc/home/{netID}                        #Change the NetID
export SINGULARITY_CACHEDIR=/hpc/home/{netID}                      #Change the NetID

#For multimers, put all sequences in one .fasta file
faFile=/hpc/group/soderlinglab/alphafold/sequence/{sequence.fasta}            #Set path to input fasta file
outputPath=/hpc/group/soderlinglab/alphafold/output
ALPHAFOLD_DATA_PATH=/opt/apps/community/alphafold2/databases/


singularity run --nv \
            --env TF_FORCE_UNIFIED_MEMORY=1,XLA_PYTHON_CLIENT_MEM_FRACTION=0.5,OPENMM_CPU_THREADS=8 \
            -B $ALPHAFOLD_DATA_PATH:/data \
            -B .:/etc \
            -B $outputPath \
            --pwd /app/alphafold \
            /opt/apps/community/alphafold2/alphafoldv2.2/alphafold_latest.sif \
            --num_multimer_predictions_per_model=5\
            --fasta_paths=$faFile \
            --data_dir=/data \
            --run_relax=True\
            --use_gpu_relax=True\
            --model_preset=multimer \
            --db_preset=full_dbs \
            --max_template_date=2022-06-01 \
            --uniref90_database_path=/data/uniref90/uniref90.fasta\
            --mgnify_database_path=/data/mgnify/mgy_clusters.fa\
            --uniclust30_database_path=/data/uniclust30/uniclust30_2018_08/uniclust30_2018_08\
            --bfd_database_path=/data/bfd/bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt\
            --template_mmcif_dir=/data/pdb_mmcif/mmcif_files\
            --obsolete_pdbs_path=/data/pdb_mmcif/obsolete.dat\
            --pdb_seqres_database_path=/data/pdb_seqres/pdb_seqres.txt\
            --uniprot_database_path=/data/uniprot/uniprot.fasta\
            --output_dir=$outputPath
