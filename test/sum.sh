if [[ $# -ne 2 ]]; then
  exit -1
fi
echo "input:$1 and $2"
let sum=$1+$2
echo $sum
