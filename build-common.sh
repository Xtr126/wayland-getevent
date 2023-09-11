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
