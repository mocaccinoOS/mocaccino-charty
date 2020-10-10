# How to use


```bash
charty start testcharts/package-smoke
```

or for a specific package, enabling debug:

```bash
charty start testcharts/package-smoke --set 'packages[0]=repository/luet' --set 'packages[1]=system/luet' --set 'packages[2]=utils/charty' --set 'debug=true'
```

or take the [values](https://github.com/mocaccinoOS/mocaccino-charty/blob/main/testcharts/package-smoke/values.yaml) file, edit as needed and use it with charty:

```bash
charty start testcharts/package-smoke -f values.yaml
```
