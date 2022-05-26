Log in: `ssh <netID>@dcc-login.oit.duke.edu`

### Linux Basic
Go back: `cd ..`  
Go to certain directory: `cd /hpc/group/soderlinglab`  
List all files: `ls`  
View a file: `cat <FileName>`  
Delete a file: `rm <FileName>` (irrevocable)

### Make edition on a file
1.	Go into the file: `vim <FileName>`
2.	Begin edition: `i`
3.	Change the text
4.	Stop changing: `esc` on keyboard
5.	Save and quit: `:wq` (semicolon is to tell the program what to do; w is to save; q is to quit) / Quit directly: `q!`

### Input the sequence
1.	Go to the directory of sequence: `cd  /hpc/group/soderlinglab/alphafold/sequence`
2.	Create a txt or fasta file: `vim <Sequence.txt>` or `vim <Sequence.fasta>`
3.	Input the fasta: first line begins with >; second line is the protein sequence.

For monomer:
```
>T1084
MAAHKGAEHHHKAAEHHEQAAKHHHAAAEHHEKGEHEQAAHHADTAYAHHKHAEEHAAQAAKHDAEHHAPKPH
```
For multimer: 
```
>T1084
MAAHKGAEHHHKAAEHHEQAAKHHHAAAEHHEKGEHEQAAHHADTAYAHHKHAEEHAAQAAKHDAEHHAPKPH
>T1083
MAAHKGAEHHHKAAEHHEQAAKHHHAAAEHHEKGEHEQAAH
```

4.	Save and quit: `:wq`

### Change the Code for Alphafold 2

```
#!/bin/bash
#SBATCH --job-name=full_turboid                                           #Set job name
#SBATCH --error=/hpc/group/soderlinglab/other/%j.err                 #Read error file to track progress
#SBATCH -p scavenger-gpu --gres=gpu:1
#SBATCH -c 8
#SBATCH --mem=40G
#SBATCH --mail-type=END
#SBATCH --mail-user=wt69@duke.edu                                    #Set Duke email address
#SBATCH --exclude=dcc-lefkowitz-gpu-[01-05],dcc-mastatlab-gpu-01,dcc-tdunn-gpu-[01-02],dcc-dsplus-gpu-[01-08]

export SINGULARITY_TMPDIR=/hpc/group/soderlinglab/singularity/tmp
export SINGULARITY_CACHEDIR=/hpc/group/soderlinglab/singularity/cache

faFile=/hpc/group/soderlinglab/alphafold/sequence/full_turboid.fasta      #Set path to fasta file
outputPath=/hpc/group/soderlinglab/alphafold/output/test
ALPHAFOLD_DATA_PATH=/opt/apps/community/alphafold2/databases/        #This should not change


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
            --max_template_date=2022-05-01 \
            --uniref90_database_path=/data/uniref90/uniref90.fasta\
            --mgnify_database_path=/data/mgnify/mgy_clusters.fa\
            --uniclust30_database_path=/data/uniclust30/uniclust30_2018_08/uniclust30_2018_08\
            --bfd_database_path=/data/bfd/bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt\
            --template_mmcif_dir=/data/pdb_mmcif/mmcif_files\
            --obsolete_pdbs_path=/data/pdb_mmcif/obsolete.dat\
```

Run the alphafold: `sbatch run_monomer.sh` `sbatch run_multimer.sh`  
See the status: `squeue -u netID`  
Cancel the job: `scancel jobID`  
View the result: Filezilla  
