# Toolchain

This is a docker image containing toolchain for robotalks projects.

## How To Use

With [hmake](https://github.com/evo-cloud/hmake),
use image `robotalks/toolchain:latest` for targets.
The following setting is required to correctly map source folder

```yaml
settings:
  docker:
    src-volume: /go/src/YOUR-GO-REPOSITORY
```

The recommended settings:

```yaml
settings:
  docker:
    image: robotalks/toolchain:latest
    src-volume: /go/src/github.com/robotalks/toolchain
```

The tbus codegen tools are pre-installed, and all standard tbus proto files
sit in `/usr/local/include`, so no additional `-I` option is required when
invoking `tbus-proto-gen`.
