# rm

Move files to Trash instead of permanently deleting them.

Drop-in replacement for `/bin/rm` that delegates to `/usr/bin/trash`, so deleted files are recoverable from the macOS Trash.

## Install

```sh
swift build -c release
cp .build/release/rm ~/.local/bin/
```

Or with Make:

```sh
make build install
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
