if [ ! -d build ]; then
    mkdir build
fi
cd build

check_integrity() {
    local file=$1
    local sha256sum=$2
    echo "Validating $file with sha256sum..."
    realsum="$(sha256sum $file)"
    realsum="${realsum%% *}"
    if [[ ${sha256sum} != "$realsum" ]]; then
        echo "Downloaded file did not pass the validity check!"
        echo "Delete file and try again" && exit 1
    fi
}

download_file() {
    local file=$1
    local url=$3
    if [ ! -f $file ]; then
        curl -qgb "" -fLC - --retry 3 --retry-delay 3 -o $file "$url"
    fi

    if [ ! -f $file ]; then
        echo Download $file failed && exit 1
    fi

    local sha256sum=$2
    check_integrity $file $sha256sum
}
