//! https://adventofcode.com/2023/day/5
const std = @import("std");
const util = @import("utils.zig");
const fmt = std.fmt;
const mem = std.mem;

const data = @embedFile("data/input_day05.txt");

fn solve(is_part2: bool, read_buff: []const u8) !usize {
    return (if (is_part2 == true) try part2(read_buff) else try part1(read_buff));
}

pub fn main() !void {
    util.printday(5);

    var timer = try std.time.Timer.start();
    std.debug.print("[Part 1] result total : {d} | Timer {any}ms \n", .{ try solve(false, data), timer.read() });
    timer = try std.time.Timer.start();
    std.debug.print("[Part 2] result total : {d} | Timer {any}ms \n", .{ try solve(true, data), timer.read() });
}

fn part1(input: []const u8) !u32 {
    _ = input;

    const sum: u32 = 0;
    return (sum);
}

fn part2(input: []const u8) !usize {
    _ = input;

    const sum: usize = 0;
    return (sum);
}
