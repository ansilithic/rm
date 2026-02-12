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
        var files: [String] = []
        var force = false
        var pastDoubleDash = false

        for arg in args {
            if pastDoubleDash {
                files.append(arg)
            } else if arg == "--" {
                pastDoubleDash = true
            } else if arg.hasPrefix("-") {
                if arg.contains("f") { force = true }
                continue
            } else {
                files.append(arg)
            }
        }

        guard !files.isEmpty else {
            fputs("usage: rm file ...\n", stderr)
            throw ExitCode.failure
        }

        let fm = FileManager.default

        for file in files {
            let path = file.hasPrefix("-") ? "./\(file)" : file

            if !fm.fileExists(atPath: path) {
                if force { continue }
                fputs("rm: \(file): No such file or directory\n", stderr)
                throw ExitCode.failure
            }

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
