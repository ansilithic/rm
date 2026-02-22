# rm — safe file deletion for macOS

A drop-in replacement for `/bin/rm` that moves files to the macOS Trash instead of permanently deleting them. Built in Swift, delegates to `/usr/bin/trash` so every deletion is recoverable.

## Install

```sh
brew install ansilithic/tap/rm
```

Or build from source:

```sh
swift build -c release
cp .build/release/rm ~/.local/bin/
```

Ensure `~/.local/bin` is earlier in your `$PATH` than `/bin` to shadow the system `rm`.

## Usage

```sh
rm file.txt
rm -f missing.txt    # silently skip missing files
rm -- -weird-name    # handle filenames starting with -
```

Supports `-f` (force/silent) and `--` (end of options). All other flags are ignored — files always go to Trash.

## Requirements

- macOS 14+ (Sonoma)
- Swift 6.0

## License

MIT
