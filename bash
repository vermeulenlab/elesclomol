#Remove adaptor using cutadapt
$for i in *.gz; do ~/.local/bin/cutadapt --cores=32 -m 1 -u 3 -a AGATCGGAAGAGCACACGT $i -o trimmed/$i;done

#Mapp reads using STAR and generate the count matrix for every sample
$for i in ../done/*R1*.fastq.gz; do name=$(basename ${i} | cut -d "_" -f1,2,3,4); /STORAGE/leandrofm/SanneB/STAR-2.6.1d/source//STAR --genomeDir /storage/leandrofm/SanneB  --outSAMunmapped Within  --outFilterType BySJout  --outSAMattributes NH HI AS NM MD  --outFilterMultimapNmax 20  --outFilterMismatchNmax 999  --outFilterMismatchNoverLmax 0.04  --alignIntronMin 20  --alignIntronMax 1000000  --alignMatesGapMax 1000000  --alignSJoverhangMin 8  --alignSJDBoverhangMin 1  --sjdbScore 1 --outFilterScoreMinOverLread 0.3 --outFilterMatchNminOverLread 0.3  --runThreadN 12  --genomeLoad NoSharedMemory  --outSAMtype BAM SortedByCoordinate  --quantMode GeneCounts  --outSAMheaderHD \@HD VN:1.4 SO:unsorted  --outFileNamePrefix ${name}  --readFilesCommand zcat  --readFilesIn ../done/${name}_R1.fastq.gz ../done/${name}_R2.fastq.gz; done

#Integrate the STAR output
paste *ReadsPerGene.out.tab | grep -v N_ | awk '{printf "%s\t", $1}{for (i=4;i<=NF;i+=4) printf "%s\t", $i; printf "\n" }' > tmp
sed -e "1igene_name\t$(ls *ReadsPerGene.out.tab | tr '\n' '\t' | sed 's/ReadsPerGene.out.tab//g')" tmp  > matrix_s.txt
