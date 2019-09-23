# Work In Progress: setup-yara

Run multiple Yara versions as GitHub Actions!

Versions are matched against existing version tags found at https://github.com/VirusTotal/yara/tags

**Warning**: This is not production-ready

**Warning #2**: The latest versions of `automake` only build YARA v2.0.0+.
                Earlier versions do not work, and I haven't found a great way to install multiple package versions to mitigate this

## yara-version
Version input can be provided in the following formats:
```
<major>.<minor>.<patch>
<major>.<minor>
<major>
```

Any missing values will result in the most up-to-date matching version being taken.

If no version is specified, the latest version is taken (currently `v3.10.0`)

## Examples

#### Full Version Number
If a full version is provided, it will be taken as-is.
```
steps:
- uses: actions/setup-yara@master
  with:
    version: 3.10.0
```

#### Major/Minor Version
Major/minor versions will result in the most up-to-date version being taken. In this case, that is `v3.6.3`
```
steps:
- uses: actions/setup-yara@master
  with:
    version: 3.6
```

#### Major Version
If only a major version is provided, the same rule is applied as major/minor. In this case, that is `v2.1.0`
```
steps:
- uses: actions/setup-yara@master
  with:
    version: 2
```
