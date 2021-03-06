
# gpu id
ID=3

codedir=/afs/inf.ed.ac.uk/group/project/img2txt/dep_parser/dense_release
curdir=`pwd`
lr=0.001
label=.dp0.35.r0.1.bs20
model=$curdir/model_$lr$label.t7
log=$curdir/log_$lr$label.txt


train=/disk/scratch/s1270921/dep_parse/data_conll/czech/czech_gold_train.conll
valid=/disk/scratch/s1270921/dep_parse/data_conll/czech/czech_gold_dev.conll
test=/disk/scratch/s1270921/dep_parse/data_conll/czech/czech_gold_test.conll


cd $codedir

CUDA_VISIBLE_DEVICES=$ID th train.lua --useGPU \
    --model SelectNetPos \
    --seqLen 112 \
    --maxTrainLen 110 \
    --freqCut 1 \
    --nhid 300 \
    --nin 300 \
    --nlayers 2 \
    --dropout 0.35 \
    --recDropout 0.1 \
    --lr $lr \
    --train $train \
    --valid $valid \
    --test $test \
    --optimMethod Adam \
    --save $model \
    --batchSize 20 \
    --validBatchSize 20 \
    --maxEpoch 15 \
    --npin 40 \
    --evalType conllx \
    | tee $log

cd $curdir

# ./gpu_lock.py --free $ID
# ./gpu_lock.py


