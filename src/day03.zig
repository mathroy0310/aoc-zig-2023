const std = @import("std");
const util = @import("utils.zig");
const fmt = std.fmt;
const mem = std.mem;

const data = @embedFile("data/input_day03.txt");

fn min(a: usize, b: usize) usize {
    return (if (a > b) b else a);
}

fn is_symbol(slice: []const u8) bool {
    if (slice.len == 0) return (false);
    for (slice) |c| {
        switch (c) {
            '0'...'9', '.' => {},
            else => return (true),
        }
    }
    return (false);
}

fn part1(input: []const u8) !u32 {
    var lines_it = std.mem.tokenizeScalar(u8, input, '\n');
    var prev_line: ?[]const u8 = null;

    var sum: u32 = 0;

    while (lines_it.next()) |current_line| : (prev_line = current_line) {
        const next_line = lines_it.peek();
        var parser = std.fmt.Parser{ .buf = current_line };

        while (std.mem.indexOfAnyPos(u8, parser.buf, parser.pos, "0123456789")) |pos| {
            parser.pos = pos;
            const num: u32 = @intCast(parser.number().?);

            // a gauche
            if (pos > 0 and is_symbol(current_line[pos - 1 .. pos])) {
                sum += num;
                continue;
            }
            // a droite
            if (parser.pos < current_line.len and is_symbol(current_line[parser.pos .. parser.pos + 1])) {
                sum += num;
                continue;
            }

            const start = if (pos > 0) pos - 1 else 0;
            const end = min(parser.buf.len, parser.pos + 1);

			// en haut (avec diagonal)
            if (prev_line) |l| {
                if (is_symbol(l[start..end])) {
                    sum += num;
                    continue;
                }
            }
			// en bas (avec diagonal)
            if (next_line) |l| {
                if (is_symbol(l[start..end])) {
                    sum += num;
                    continue;
                }
            }
        }
    }
    return (sum);
}

fn part2(input: []const u8) !u32 {
    _ = input;
    return 0;
}

fn solve(is_part2: bool, read_buff: []const u8) !u32 {
    return (if (is_part2 == true) try part2(read_buff) else part1(read_buff));
}

pub fn main() !void {
    util.printday(3);

    std.debug.print("[Part 1] result total : {d}\n", .{try solve(false, data)});
    std.debug.print("[Part 2] result total : {d}\n", .{try solve(true, data)});
}
