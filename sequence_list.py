import requests, sys
import string
import re
import os
import shutil

### Required Input

# Protien ID in CCDS
sequence_id = 'ENSMUST00000231415.2324'
# Three types of donor
donor_0 = 'gaa...aaaacc'
donor_1 = 'gaa...aaaac'
donor_2 = 'gaa...aaaacg'

# Length requirement for introns
length_criteria = 100
# Directory name for output sequences
file_name = "filename"

if sequence_id.startswith("ENS") and ('.' in sequence_id):
    sequence_id = re.search(r'^[^.]*', sequence_id).group(0)

### Establised API
# API import sequence
server = "https://rest.ensembl.org"
ext1 = f"/sequence/id/{sequence_id}?mask_feature=1" # whole sequence: intron + extron
ext2 = f"/sequence/id/{sequence_id}?mask_feature=1;type=cds" # only the exon that will transcripted

r1 = requests.get(server+ext1, headers={ "Content-Type" : "text/plain"})
r2 = requests.get(server+ext2, headers={ "Content-Type" : "text/plain"})

if not r1.ok:
  r1.raise_for_status()
  sys.exit()

if not r2.ok:
  r2.raise_for_status()
  sys.exit()

# Delete introns (lower case), keep all exons
table = str.maketrans('','', string.ascii_lowercase)
all_exon = r1.text.translate(table)

# Locate the non-transcripted exon
start_len = all_exon.find(r2.text)
end_len = len(all_exon[start_len + len(r2.text):])

# Start position of transcripted exon
count1 = 0
for num, char in enumerate(r1.text):
    if count1 == start_len:
        start = num
        break
    if char.isupper():
        count1 += 1

# End position of transcripted exon
count2 = 0
for num, char in enumerate(r1.text[::-1]):
    if count2 == end_len:
        end = num
        break
    if char.isupper():
        count2 += 1

# Delete the non-transcripted exon
if all_exon == r2.text:
    seq = r1.text
else:
    seq = r1.text[start:-end]

# Extract extron and intron
exon = re.findall(r'[A-Z]+', seq)
intron = re.findall(r'[a-z]+', seq)

# Filter introns that length is greater than or equal to length_criteria
qualified = [i for i in range(len(intron)) if len(intron[i]) >= length_criteria]

mutants = []
donor = []
donor.append(donor_0.upper())
donor.append(donor_1.upper())
donor.append(donor_2.upper())
for i in qualified:
    s1 = ''.join(exon[:i+1])
    s2 = ''.join(exon[i+1:])
    s = s1 + donor[len(s1)%3] + s2
    mutants.append(s)

def translate(seq):

    table = {
        'ATA':'I', 'ATC':'I', 'ATT':'I', 'ATG':'M',
        'ACA':'T', 'ACC':'T', 'ACG':'T', 'ACT':'T',
        'AAC':'N', 'AAT':'N', 'AAA':'K', 'AAG':'K',
        'AGC':'S', 'AGT':'S', 'AGA':'R', 'AGG':'R',
        'CTA':'L', 'CTC':'L', 'CTG':'L', 'CTT':'L',
        'CCA':'P', 'CCC':'P', 'CCG':'P', 'CCT':'P',
        'CAC':'H', 'CAT':'H', 'CAA':'Q', 'CAG':'Q',
        'CGA':'R', 'CGC':'R', 'CGG':'R', 'CGT':'R',
        'GTA':'V', 'GTC':'V', 'GTG':'V', 'GTT':'V',
        'GCA':'A', 'GCC':'A', 'GCG':'A', 'GCT':'A',
        'GAC':'D', 'GAT':'D', 'GAA':'E', 'GAG':'E',
        'GGA':'G', 'GGC':'G', 'GGG':'G', 'GGT':'G',
        'TCA':'S', 'TCC':'S', 'TCG':'S', 'TCT':'S',
        'TTC':'F', 'TTT':'F', 'TTA':'L', 'TTG':'L',
        'TAC':'Y', 'TAT':'Y', 'TAA':'', 'TAG':'',
        'TGC':'C', 'TGT':'C', 'TGA':'', 'TGG':'W',
    }
    protein =""
    if len(seq)%3 == 0:
        for i in range(0, len(seq), 3):
            codon = seq[i:i + 3]
            protein+= table[codon]
    return protein

protein = []
for mutant in mutants:
    protein.append(translate(mutant))

def mkdir(path):
    folder = os.path.exists(path)
    if not folder:
        os.makedirs(path)
    else:
        shutil.rmtree(path)
        os.makedirs(path)

sequence_path = f"/hpc/group/soderlinglab/optimal_insertion/sequence/{file_name}"
mkdir(sequence_path)
output_path = f"/hpc/group/soderlinglab/optimal_insertion/output/{file_name}"
mkdir(output_path)

with open(f"{sequence_path}/0.txt", "a") as o:
    o.write(f">{sequence_id}\n")
    o.write(translate("".join(exon)))

file = [f'{sequence_path}/{i:d}.txt' for i in range(1,len(protein)+1)]
for num, pr in enumerate(protein):
    with open(file[num], "a") as o:
        o.write(f">Mutant {num+1} inserted at intron {qualified[num]+1}\n")
        o.write(pr)
