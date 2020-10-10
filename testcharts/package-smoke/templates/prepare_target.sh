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

{{- if .Values.features.luet_box }}
cat > config_root.yaml <<EOF
general:
  debug: {{.Values.debug}}
system:
  rootfs: /
  database_path: "/"
repositories: {{ nindent 1 .Values.repositories }}
EOF
mkdir -p {{.Values.rootfs_dir }}/etc/luet
mkdir -p {{.Values.rootfs_dir }}/etc/ssl

mkdir -p {{.Values.rootfs_dir }}/usr/bin
mkdir -p {{.Values.rootfs_dir }}/var/cache/luet

cp -rfv config_root.yaml {{.Values.rootfs_dir }}/etc/luet/luet.yaml
cp -rfv bin/luet {{.Values.rootfs_dir }}/usr/bin/luet
echo "nameserver {{.Values.box_dns}}" > {{.Values.rootfs_dir }}/etc/resolv.conf
cp -rfv /etc/ssl/certs {{.Values.rootfs_dir }}/etc/ssl
{{- end }}
