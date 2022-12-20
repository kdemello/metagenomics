#script to create a bam file by reference name
r1="panBacterial_16s_Reference.fasta"
r2="gg_13_5_with_taxonomy8fasta_with_truefalsefalse.fasta"

mkdir new

#make a list of the reference names
grep ">" $r1 | sed 's/>//' > new/r1.list
grep ">" $r2 | sed 's/>//' > new/r2.list

#convert all bam files to sam files and make a list with newlines
for a in *.bam; do
  samtools view -h $a -o ${a}.sam
done
touch new/sam.list

for a in '*.sam'; do
  echo $a >> new/sam.list
  mv $a new
done
cd new
echo  'task 1\r'

#make a list of the reference names that are in the bam file
for i in `cat sam.list`; do
    for j in `cat r1.list`; do
      touch ${i}r1.sam
        if grep $j $i; then
            echo $j >> ${i}r1.sam
        fi
    done
done

echo  'task 2\r'
for i in `cat sam.list`; do
    for j in `cat r2.list`; do
      touch ${i}r2.sam
        if grep $j $i; then
            echo $j >> ${i}r2.sam
        fi
    done
done

echo 'task 3\r'
#make a list of the bam file rnames that are in the reference and print to file
for i in `cat sam.list`; do
    for j in `cat r1.sam.list`; do
        if grep -q $j $i; then
            echo $i >> ${i}r1.sam
        fi
    done
done

echo 'task 4\r'
for i in `cat sam.list`; do
    for j in `cat r2.sam.list`; do
        if grep -q $j $i; then
            echo $i >> ${i}r2.sam
        fi
    done
done
echo 'task finished\r'
