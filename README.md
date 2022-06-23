Log in: `ssh <netID>@dcc-login.oit.duke.edu`

### Basic Linux Commends
Go to parent directory: `cd ..`  
Go to certain directory: `cd /hpc/group/soderlinglab`  
List all files: `ls`  
View a file: `cat <FileName>`  
Delete a file: `rm <FileName>` (irrevocable)

### Create/Make Edition on a File
1. Go into the file: `vim <FileName>`
2. Begin edition: `i`
3. Change the text
4. Stop editing: `esc` on keyboard
5. Save and quit: `:wq` or quit directly: `:q!`
(semicolon is to tell the program what to do; w is to save; q is to quit) 

### Submit a Job
Submit `sbatch jobname.sh`  
Run the alphafold: `sbatch af2_monomer.sh` `sbatch af2_multimer.sh`  
Check the status: `squeue -u netID`  
Cancel the job: `scancel jobID`   
See running history: `
sacct -u {netID} -S{MMDD} --format=user,JobID%20,state%12,partition,start,elapsed,nodelist%25,MaxRss%10,ReqMem,NCPUS,ExitCode,Workdir%110
`
