import ArgumentParser
import Foundation

@main
struct Rm: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "rm",
        abstract: "Move files to Trash instead of permanent deletion.",
        discussion: "Shadows /bin/rm, delegating to /usr/bin/trash.",
        version: "1.0.0"
    )

    @Argument(parsing: .captureForPassthrough)
    var args: [String]

    func run() throws {
        // Filter out flags, keep file paths
        var files: [String] = []
        var pastDoubleDash = false

        for arg in args {
            if pastDoubleDash {
                files.append(arg)
            } else if arg == "--" {
                pastDoubleDash = true
            } else if arg.hasPrefix("-") {
                continue
            } else {
                files.append(arg)
            }
        }

        guard !files.isEmpty else {
            fputs("usage: rm file ...\n", stderr)
            throw ExitCode.failure
        }

        for file in files {
            // Prefix with ./ if it starts with - to avoid trash misinterpreting it
            let path = file.hasPrefix("-") ? "./\(file)" : file

            let task = Process()
            task.executableURL = URL(fileURLWithPath: "/usr/bin/trash")
            task.arguments = [path]

            do {
                try task.run()
                task.waitUntilExit()
            } catch {
                fputs("rm: \(file): failed to trash\n", stderr)
                throw ExitCode.failure
            }

            if task.terminationStatus != 0 {
                throw ExitCode(task.terminationStatus)
            }
        }
    }
}
