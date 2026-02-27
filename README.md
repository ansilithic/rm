# rm

![Swift 6.0](https://img.shields.io/badge/Swift-6.0-F05138?logo=swift&logoColor=white)
![macOS 14+](https://img.shields.io/badge/macOS-14%2B-000000?logo=apple&logoColor=white)
![License: MIT](https://img.shields.io/badge/License-MIT-blue)

Drop-in `rm` replacement for macOS that moves files to Trash instead of permanently deleting them.

## How it works

`rm` delegates to `/usr/bin/trash` so every deletion is recoverable from the macOS Trash. It accepts the same arguments as `/bin/rm` — files go to Trash silently on success, with errors printed to stderr on failure.

Supports `-f` (suppress errors for missing files) and `--` (end of options for filenames starting with `-`). All other flags are accepted and ignored — files always go to Trash regardless.

## Install

```sh
brew install ansilithic/tap/rm
```

Or build from source (requires Xcode and macOS 14+):

```sh
make build && make install
```

Ensure `/usr/local/bin` appears before `/bin` in `$PATH` to shadow the system `rm`.

## Usage

```
rm [-f] [--] file ...
```

### Examples

```sh
# Move files to Trash
rm file.txt
rm *.log

# Silently skip missing files
rm -f maybe-exists.txt

# Handle filenames starting with -
rm -- -weird-name.txt
```

## License

MIT
