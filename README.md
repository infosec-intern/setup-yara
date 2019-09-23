# Work In Progress: setup-yara

**Warning**: This is NOT ready to be used yet

Run multiple Yara versions as GitHub Actions!

Version input should line up to tags in https://github.com/VirusTotal/yara/tags

Example:
```
steps:
- uses: actions/setup-yara@master
  with:
    version: 3.10.0
```
