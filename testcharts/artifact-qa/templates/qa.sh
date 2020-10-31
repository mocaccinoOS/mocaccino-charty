#!/bin/bash
set -ex
export TMPDIR=$PWD/tmp
export LUET_NOLOCK=true

{{$debug:=.Values.debug}}
{{$rootfs:=.Values.rootfs_dir}}
{{$packagesdir:=.Values.packages_dir}}


./bin/luet install --config config.yaml system/luet-extensions {{- if not $debug }}>/dev/null 2>&1 {{- end }}

export ROOT_DIR={{$packagesdir}}
{{- if .Values.features.verify_checksum }}
{{$rootfs}}/usr/bin/luet-qa-artefacts
{{- end }}
{{- if .Values.features.verify_fileconflicts }}
{{$rootfs}}/usr/bin/luet-qa-repo-fileconflicts $ROOT_DIR
{{- end }}