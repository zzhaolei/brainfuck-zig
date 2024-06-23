const std = @import("std");
const fs = std.fs;
const bf = @import("brainfuck");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloctor = gpa.allocator();

    const args = try std.process.argsAlloc(alloctor);
    defer std.process.argsFree(alloctor, args);
    if (args.len < 2) {
        std.debug.print("need input file\n", .{});
        std.process.exit(1);
    }

    const path = args[1];
    const file = try fs.cwd().openFile(path, .{});
    defer file.close();

    var buf = try alloctor.alloc(u8, try file.getEndPos());
    defer alloctor.free(buf);

    const size = try file.reader().readAll(buf);

    bf.brainfuck(buf[0..size]) catch |err| {
        switch (err) {
            bf.err.NotSupportedOpCode => {
                std.debug.print("Not Supported Op Code", .{});
            },
            else => {
                std.debug.print("{any}", .{err});
            },
        }
    };
}
