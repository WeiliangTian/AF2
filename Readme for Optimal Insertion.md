### 1. Input Host and Donor sequence
1. Go to the directory: `cd /hpc/group/soderlinglab/optimal_insertion`
2. Change the input: `vim sequence_list.py`  
   (1) Change the host sequence ID:   
Sequence ID could be found in Ensembl website. For example, the ID for SCN2A in mouse is `CCDS38130` (CCDS ID) or `ENSMUST00000028377.14` (Transcript ID)  
   (2) Change the donor sequence for +0 +1 +2  
   (3) Change the length requirement for intron  
   (4) Name the folder

### 2. Run API to List the Mutants
1. Run the code for API: `python3 sequence_list.py`
2. Check the sequence information in sequence directory
3. Calculate the number of sequence files

### 3. Predicting the Structure in Alphafold
1. Edit the code for predicting: `vim structure_predict.sh`
2. Submit the code for predicting: `sbatch structure_predict.sh`

### 4. Download the structure files through Filezilla

### 5. Compare the Structures
There are two main online servers to compare the structures:
1. Dali server (All-against-all): http://ekhidna2.biocenter.helsinki.fi/dali/
2. PDBeFold: https://www.ebi.ac.uk/msd-srv/ssm/cgi-bin/ssmserver
