#!/bin/sh
DIR=$1
LESS_FILENAME=$1"/"$2".less"
CSS_FILENAME=$1"/"$2".css"
MAP_FILENAME=$2".map"

cd $DIR

while FILENAME=$(inotifywait --format %w%f -qre close_write $DIR)
do
    EXTENSION="${FILENAME##*.}"
    if [ 'less' != $EXTENSION ]; then
        continue
    fi

    BASENAME=$(basename $FILENAME)
    if [ '_include.less' = $BASENAME ]; then
        continue
    fi

    DIRNAME=$(dirname ${FILENAME})
    if [ -f "$DIRNAME/_include.less" ]; then
        ls -1 --file-type $DIRNAME | grep '.less$' | grep -v '_include.less' | grep -v '/' | grep -v '~' | sed 's/^\(.*\)$/@import "\1";/' > "$DIRNAME/_include.less"
    fi

    echo "File $BASENAME has been changed"
    /usr/bin/lessc --compress --no-color --source-map=$MAP_FILENAME $LESS_FILENAME > $CSS_FILENAME
done
