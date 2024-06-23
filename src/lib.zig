const std = @import("std");
pub const err = error{
    NotSupportedOpCode,
};

pub fn brainfuck(code: []u8) !void {
    const input = std.io.getStdIn().reader();
    const output = std.io.getStdOut().writer();

    var tape = std.mem.zeroes([30_000]u8);
    var ptr: u32 = 0;
    var index: usize = 0;

    while (index < code.len) : (index += 1) {
        const item = code[index];
        switch (item) {
            '>' => ptr += 1,
            '<' => ptr -= 1,
            '+' => tape[ptr] += 1,
            '-' => tape[ptr] -= 1,
            '.' => try output.print("{c}", .{tape[ptr]}),
            ',' => {
                try output.print("[ascii]> ", .{});
                tape[ptr] = try input.readByte();
            },
            '[' => {
                if (tape[ptr] != 0) {
                    continue;
                }
                index += 1;
                var loop: usize = 1;
                while (loop > 0) : (index += 1) {
                    switch (code[index]) {
                        '[' => loop += 1,
                        ']' => loop -= 1,
                        else => continue,
                    }
                }
            },
            ']' => {
                if (tape[ptr] == 0) {
                    continue;
                }
                index -= 1;
                var loop: usize = 1;
                while (loop > 0) : (index -= 1) {
                    switch (code[index]) {
                        '[' => loop -= 1,
                        ']' => loop += 1,
                        else => continue,
                    }
                }
                index += 1;
            },
            '\n', ' ' => continue,
            else => return err.NotSupportedOpCode,
        }
    }
}
