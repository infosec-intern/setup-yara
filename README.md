# setup-yara docker action

Run multiple Yara versions as GitHub Actions!

This action will set up an environment with YARA, the pattern-matching swiss army knife.
Versions can be specified, and are matched against existing version tags found at https://github.com/VirusTotal/yara/tags

**Warning**: This is not production-ready

**Warning #2**: The latest versions of `automake` only build YARA v2.0.0+. Because of this, earlier YARA versions (v1.x) always fail.
                I haven't found a great way to install multiple package versions to mitigate this yet.

## Inputs

### `yara-version`

Version input can be provided in the following formats:
```
<major>.<minor>.<patch>
<major>.<minor>
<major>
```

Any missing values will result in the most up-to-date matching version being taken.

If no version is specified, the latest version is taken (currently `v3.10.0`)

## Example usage

#### Full Version Number

If a full version is provided, it will be taken as-is.
```
uses: actions/setup-yara@master
  with:
    yara-version: 3.10.0
```

#### Major/Minor Version

Major/minor versions will result in the most up-to-date version being taken. In this case, that is `v3.6.3`
```
uses: actions/setup-yara@master
  with:
    yara-version: 3.6
```

#### Major Version

If only a major version is provided, the same rule is applied as major/minor. In this case, that is `v2.1.0`
```
uses: actions/setup-yara@master
  with:
    yara-version: 2
```
