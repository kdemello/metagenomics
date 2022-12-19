#script to create a bam file by reference name
r1="panBacterial_16s_Reference.fasta"
r2="gg_13_5_with_taxonomy8fasta_with_truefalsefalse.fasta"

#make a list of the reference names
grep ">" $r1 | sed 's/>//' > new/r1.list
grep ">" $r2 | sed 's/>//' > new/r2.list

#convert all bam files to sam files and make a list
for a in *.bam; do
  samtools view -h $a -o a.sam
  done
done

ls *.sam > sam.list

#make a list of the reference names that are in the bam file
for i in `cat sam.list`; do
    for j in `cat r1.list`; do
        if grep -q $j $i; then
            echo $j >> r1.sam.list
        fi
    done
done

for i in `cat sam.list`; do
    for j in `cat r2.list`; do
        if grep -q $j $i; then
            echo $j >> r2.sam.list
        fi
    done
done

#make a list of the bam file names that are in the reference
for i in `cat sam.list`; do
    for j in `cat r1.sam.list`; do
        if grep -q $j $i; then
            echo $i >> r1.bam
        fi
    done
done

for i in `cat sam.list`; do
    for j in `cat r2.sam.list`; do
        if grep -q $j $i; then
            echo $i >> r2.bam
        fi
    done
done


