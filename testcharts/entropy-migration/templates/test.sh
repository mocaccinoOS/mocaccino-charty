#!/bin/bash

export TMPDIR=$PWD/tmp
export LUET_NOLOCK=true
export PATH=:$PWD/bin:$PATH

{{$debug:=.Values.debug}}
{{$rootfs:=.Values.rootfs_dir}}
{{$luet_box:=.Values.features.luet_box}}

echo "#!/bin/bash" > wrapper
echo "luet --config config.yaml \"\$@\"" >> wrapper
chmod +x wrapper 

./bin/luet install --config config.yaml system/luet-extensions

LUET=$PWD/wrapper {{.Values.rootfs_dir }}/usr/bin/luet-migrate-entropy

{{range $i, $e := .Values.packages }}

if ./bin/luet --config config.yaml search --installed {{$e}} | grep -q {{$e}}; then
    echo "{{$e}} OK. "
else
    echo "{{$e}} Not OK. Installed packages: "
    ./bin/luet --config config.yaml search --installed {{$e}} -o json 
    exit 1
fi

time ./bin/luet --config config.yaml upgrade

{{end}}