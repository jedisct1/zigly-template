const std = @import("std");
const zigly = @import("zigly.zig");

fn start() !void {
    try zigly.compatibilityCheck();
    var downstream = try zigly.downstream();
    try downstream.proxy("mybackend", null);
}

pub export fn _start() callconv(.C) void {
    start() catch unreachable;
}
