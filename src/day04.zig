//! https://adventofcode.com/2023/day/4
const std = @import("std");
const util = @import("utils.zig");
const fmt = std.fmt;
const mem = std.mem;

const data = @embedFile("data/input_day04.txt");

fn solve(is_part2: bool, read_buff: []const u8) !u32 {
    return (if (is_part2 == true) try part2(read_buff) else part1(read_buff));
}

pub fn main() !void {
    util.printday(4);

    std.debug.print("[Part 1] result total : {d}\n", .{try solve(false, data)});
    std.debug.print("[Part 2] result total : {d}\n", .{try solve(true, data)});
}

fn part1(input: []const u8) !u32 {
    _ = input;
	return 0;
}

fn part2(input: []const u8) !u32 {
    _ = input;
	return 0;
}