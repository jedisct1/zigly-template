const zigly = @import("zigly");

pub fn main() !void {
    try zigly.compatibilityCheck();
    var downstream = try zigly.downstream();
    try downstream.proxy("mybackend", "ziglang.org");
}
