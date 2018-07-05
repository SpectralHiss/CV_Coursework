DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TOP_DIR=$DIR/..

spark-submit $TOP_DIR/kmeans.py
