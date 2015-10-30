#!/bin/bash
RELEASE_ID=$(date +build-%Y-%m-%d-%Hh%M);

initFile() {
    echo '#!/bin/bash' > $1;
    echo "#" >> $1;
    cat src/00-header.pl >> $1;
    echo "#" >> $1;
    echo "# $RELEASE_ID | $2" >> $1;
    printf "#\n##\n\n" >> $1;
}

compileBin() {
    initFile bin/$1.sh "source: src/$1/";
    cat src/$1/* >> bin/$1.sh;
}
