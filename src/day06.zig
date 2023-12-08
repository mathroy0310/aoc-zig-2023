//! https://adventofcode.com/2023/day/6
const std = @import("std");
const util = @import("utils.zig");
const fmt = std.fmt;
const mem = std.mem;

const data = @embedFile("data/input_day06.txt");

const Race = struct {
    /// Duration of the race in MS
    duration: usize,
    /// Record distance traveled in MM
    record_distance: usize,
};

fn num_winning_times(duration: usize, record_distance: usize) usize {
    // Let `t` = the duration, and `d` = the record distance.
    // Solving for `x`, the minimum time to win, we get the equation
    // `x(t-x) > d`.
    // Rearranging this, we get `-x^2+tx > d`.
    // Again, we can arrange this as the quadratic equation (`ax^2+bx+c`) `-x^2+tx-d = 0`,
    // and use the quadratic formula `(-b±sqrt(b^2-4ac)/2a`.
    // Simplifying that a bit, the minimum winning number must be > `t/2 - sqrt(t^2/4 - d)`.

    const duration_f: f64 = @floatFromInt(duration);
    const record_distance_f: f64 = @floatFromInt(record_distance);
    const min_winning: usize = @intFromFloat(@floor(duration_f / 2.0 - std.math.sqrt(duration_f * duration_f / 4.0 - record_distance_f)) + 1);

    return duration + 1 - 2 * min_winning;
}

fn solve(is_part2: bool, read_buff: []const u8) !f64 {
    return (if (is_part2 == true) try part2(read_buff) else try part1(read_buff));
}

pub fn main() !void {
    util.printday(6);

    var timer = try std.time.Timer.start();
    std.debug.print("[Part 1] result total : {d} | Timer : {any}ms \n", .{ try solve(false, data), timer.read() });
    timer.reset();
    std.debug.print("[Part 2] result total : {d} | Timer : {any}ms\n", .{ try solve(true, data), timer.read() });
}

fn part1(input: []const u8) !usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer if (gpa.deinit() == .leak) @panic("Memory leak");
    const allocator = gpa.allocator();
    var races = std.ArrayList(Race).init(allocator);
    defer races.deinit();
    var races_product: usize = 1;

    var lines_it = std.mem.tokenizeScalar(u8, input, '\n');
    var times_it = std.mem.tokenizeScalar(u8, lines_it.next() orelse return error.NoTimes, ' ');
    _ = times_it.next(); // Ignore the "Times:" column.
    var i: usize = 0;
    while (times_it.next()) |time| : (i += 1) {
        const duration = try std.fmt.parseInt(usize, time, 10);
        try races.append(.{ .duration = duration, .record_distance = 0 });
    }

    var distances_it = std.mem.tokenizeScalar(u8, lines_it.next() orelse return error.NoDistances, ' ');
    _ = distances_it.next(); // Ignore the "Distances:" column
    i = 0;
    while (distances_it.next()) |distance| : (i += 1) {
        if (i >= races.items.len) return error.NonUniformTable;
        const record_distance = try std.fmt.parseInt(usize, distance, 10);
        races.items[i].record_distance = record_distance;

        races_product *= num_winning_times(races.items[i].duration, races.items[i].record_distance);
    }
    if (i < races.items.len) return error.NonUniformTable;

    return (races_product);
}

fn part2(input: []const u8) !usize {
    var race = Race{ .duration = 0, .record_distance = 0 };

    var lines_it = std.mem.tokenizeScalar(u8, input, '\n');
    const time = lines_it.next() orelse return error.NoTime;
    for (time) |d| {
        switch (d) {
            '0'...'9' => race.duration = 10 * race.duration + d - '0',
            else => {},
        }
    }
    const record_distance = lines_it.next() orelse return error.NoRecordDistance;
    for (record_distance) |d| {
        switch (d) {
            '0'...'9' => race.record_distance = 10 * race.record_distance + d - '0',
            else => {},
        }
    }

    return (num_winning_times(race.duration, race.record_distance));
}
