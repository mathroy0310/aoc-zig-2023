//! https://adventofcode.com/2023/day/6
const std = @import("std");
const util = @import("utils.zig");
const fmt = std.fmt;
const mem = std.mem;

const data = @embedFile("data/input_day06.txt");

fn solve(is_part2: bool, read_buff: []const u8) !usize {
    return (if (is_part2 == true) try part2(read_buff) else try part1(read_buff));
}

pub fn main() !void {
    util.printday(6);

    var timer = try std.time.Timer.start();
    std.debug.print("[Part 1] result total : {d} | Timer : {any}ms \n", .{ try solve(false, data), timer.read() });
    timer = try std.time.Timer.start();
    //std.debug.print("[Part 2] result total : {d} | Timer : {any}ms\n", .{try solve(true, data), timer.read()});
}

fn part1(input: []const u8) !usize {
    var races = std.ArrayList(struct { duration: usize, record_distance: usize = 0, current_ways: u32 = 0 }).init(std.heap.page_allocator);
    var race_data = std.mem.tokenizeScalar(u8, input, '\n');
    var race_index: usize = 0;
    var tokens = std.mem.tokenizeScalar(u8, race_data.next().?, ' ');
    _ = tokens.next();
    while (tokens.next()) |token| try races.append(.{ .duration = try std.fmt.parseInt(usize, token, 10) });
    tokens = std.mem.tokenizeScalar(u8, race_data.next().?, ' ');
    _ = tokens.next();
    race_index = 0;
    while (tokens.next()) |token| {
        races.items[race_index].record_distance = try std.fmt.parseInt(usize, token, 10);
        race_index += 1;
    }
    race_index = 1;
    for (races.items) |*race| {
        for (0..race.duration) |time| {
            if (((race.duration - time) * time) > race.record_distance) race.current_ways += 1;
        }
        race_index *= race.current_ways;
    }
    return (race_index);
}

fn part2(input: []const u8) !u32 {
    _ = input;

    return (32);
}
