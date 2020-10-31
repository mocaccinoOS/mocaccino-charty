#!/bin/bash
export TMPDIR=$PWD/tmp
mkdir bin
mkdir tmp
wget "https://github.com/mudler/luet/releases/download/{{.Values.luet_version}}/luet-{{.Values.luet_version}}-linux-amd64" -O bin/luet --quiet
chmod +x bin/luet

if [ -e "bin/luet" ]; then
  echo "Luet {{.Values.luet_version}} downloaded correctly"
fi

cat > config.yaml <<EOF
general:
  debug: {{.Values.debug}}
system:
  rootfs: $PWD/{{.Values.rootfs_dir}}
  database_path: "/"
repositories: {{ nindent 1 .Values.repositories }}
EOF

mkdir -p $PWD/{{.Values.rootfs_dir}}