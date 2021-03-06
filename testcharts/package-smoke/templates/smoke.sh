#!/bin/bash

export TMPDIR=$PWD/tmp
export LUET_NOLOCK=true
export LUET_YES=true

{{$debug:=.Values.debug}}
{{$rootfs:=.Values.rootfs_dir}}
{{$luet_box:=.Values.features.luet_box}}
{{$uninstall:=.Values.features.uninstall}}

{{range $i, $e := .Values.packages }}

{{- if $luet_box }}
./bin/luet box exec --rootfs $PWD/{{$rootfs}} \
--stdin --stdout --env USER=root --env LUET_NOLOCK=true --stderr --entrypoint /usr/bin/luet install {{$e}} {{- if not $debug }}>/dev/null 2>&1 {{- end }}
{{- else }}
./bin/luet install --config config.yaml {{$e}} {{- if not $debug }}>/dev/null 2>&1 {{- end }}
{{- end }}

if ./bin/luet --config config.yaml search --hidden --installed {{$e}} | grep -q {{$e}}; then
    echo "{{$e}} OK. "
else
    echo "{{$e}} Not OK. Installed packages: "
    ./bin/luet --config config.yaml search --hidden --installed {{$e}} -o json
    exit 1
fi

{{ if $uninstall }}
set -e
{{- if $luet_box }}
./bin/luet box exec --rootfs $PWD/{{$rootfs}} \
--stdin --stdout --env USER=root --env LUET_NOLOCK=true --stderr --entrypoint /usr/bin/luet uninstall {{$e}} {{- if not $debug }}>/dev/null 2>&1 {{- end }}
{{- else }}
./bin/luet uninstall --config config.yaml {{$e}} {{- if not $debug }}>/dev/null 2>&1 {{- end }}
{{- end }}
{{- end }}

{{end}}
