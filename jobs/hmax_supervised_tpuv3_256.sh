
mode=train  # _and_eval
resnet_depth=50

base_learning_rate=0.1
use_tpu=True
train_batch_size=4096
eval_batch_size=1024

# train_steps=3558
# iterations_per_loop=2558
# skip_host_call=True
num_cores=256
# enable_lars=False
# label_smoothing=0.1

experiment_name=$1  # finetune_BU_{bu_loss}_TD_{td_loss}_R50_lr0.1_T0.1
tpu_name=$2
model_script=$3
export TPU_NAME=$tpu_name  # 'prj-selfsup-tpu'
export STORAGE_BUCKET='gs://serrelab'
DATA_DIR=gs://imagenet_data/train/
# DATA_DIR=$STORAGE_BUCKET/imagenet_dataset/imagenet2012/5.0.0/
MODEL_DIR=$STORAGE_BUCKET/prj-hmax/results/$experiment_name
EXPORT_DIR=$STORAGE_BUCKET/prj-hmax/exported/$experiment_name
gsutil mkdir $MODEL_DIR
gsutil mkdir $EXPORT_DIR
python3 main.py \
  --tpu=$TPU_NAME\
  --mode=$mode\
  --data_dir=$DATA_DIR\
  --model_dir=$MODEL_DIR\
  --export_dir=$EXPORT_DIR\
  --train_batch_size=$train_batch_size\
  --eval_batch_size=$eval_batch_size\
  --resnet_depth=$resnet_depth\
  --model_script=$model_script\
  --num_cores=$num_cores
  # --skip_host_call

  # --train_steps=$train_steps\
  # --base_learning_rate=$base_learning_rate\
  # --eval_batch_size=$eval_batch_size\
  # --iterations_per_loop=$iterations_per_loop\
  # --enable_lars=$enable_lars\
  # --label_smoothing=$label_smoothing

  # --mode=$mode\

# Move params to the model bucket
gsutil cp params.npz $MODEL_DIR
gsutil cp "models/${model_script}.py" $MODEL_DIR
