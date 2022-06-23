### 1. Input the sequence
1. Go to sequence directory: `cd /hpc/group/soderlinglab/alphafold/sequence`
2. Create a txt or fasta file: `vim {Sequence.txt}` or `vim {Sequence.fasta}`

```commandline
# Example
vim test_monomer.fasta
```
3. Input the fasta: first line begins with >; second line is the protein sequence.
```
# Example for monomer

>T1084
MAAHKGAEHHHKAAEHHEQAAKHHHAAAEHHEKGEHEQAAHHADTAYAHHKHAEEHAAQAAKHDAEHHAPKPH
```

```
# Example for multimer

>T1084
MAAHKGAEHHHKAAEHHEQAAKHHHAAAEHHEKGEHEQAAHHADTAYAHHKHAEEHAAQAAKHDAEHHAPKPH
>T1083
MAAHKGAEHHHKAAEHHEQAAKHHHAAAEHHEKGEHEQAAH
```
4.	Save and quit: `:wq`

### 2. Change the Code for Alphafold 2
1. Go to directory for Alphafold: `cd /hpc/group/soderlinglab/alphafold`
2. Make edition on the `af2_monomer.sh` `af2_multimer.sh`  
   (1) Go into the file: `vim af2_monomer.sh`  
   (2) Begin edition: `i`  
   (3) Change the text before the #comments   
   (4) Stop editing: `esc` on keyboard  
   (5) Save and quit: `:wq`

### 3. Submit the job
Submit the job: `sbatch af2_monomer.sh` or `sbatch af2_multimer.sh`  
Check the status: `squeue -u {netID}` 

### 4. View the result
When finishing the prediction, the system will send an e-mail to the assigned e-mail address, the results can be downloaded to personal computer through Filezilla.
