//! https://adventofcode.com/2023/day/1
const std = @import("std");
const util = @import("utils.zig");
const fmt = std.fmt;
const mem = std.mem;

const data = @embedFile("data/input_day01.txt");

const word_digit = [_][]const u8{ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };

pub fn main() !void {
    util.printday(1);

    var timer = try std.time.Timer.start();
    std.debug.print("[Part 1] result total : {d} | Timer : {any}ms\n", .{ solve(false, data), timer.read() });
    timer.reset();
    std.debug.print("[Part 2] result total : {d} | Timer : {any}ms \n", .{ solve(true, data), timer.read() });
}

fn search(is_part2: bool, input: []const u8) ?u8 {
    return fmt.charToDigit(input[0], 10) catch blk: {
        if (is_part2 == false) break :blk null;
        if (input.len < word_digit[0].len) break :blk null;

        for (word_digit, 1..) |term, i| {
            if (input.len < term.len) continue;

            if (mem.eql(u8, input[0..term.len], term))
                break :blk @intCast(i);
        }
        break :blk null;
    };
}

fn solve(is_part2: bool, read_buff: []const u8) u32 {
    var it = mem.split(u8, read_buff, "\n");

    var total_sum: u32 = 0;
    while (it.next()) |line| {
        const first_digit, const last_digit = blk: {
            var first_digit: ?u32 = null;
            var last_digit: ?u32 = null;

            for (0..line.len) |i| {
                const digit = search(is_part2, line[i..]) orelse continue;

                if (first_digit == null) first_digit = digit;
                last_digit = digit;
            }

            break :blk .{ first_digit.?, last_digit.? };
        };
        total_sum += (first_digit * 10) + last_digit;
    }
    return (total_sum);
}
