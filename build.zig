const std = @import("std");

pub fn build(b: *std.build.Builder) !void {
    const target = try std.zig.CrossTarget.parse(.{ .arch_os_abi = "wasm32-wasi" });

    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("app", "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.install();

    const viceroy = b.addSystemCommand(&.{
        "viceroy",
        "-C",
        "fastly.toml",
        "zig-out/bin/app.wasm",
    });
    viceroy.step.dependOn(&exe.install_step.?.step);
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&viceroy.step);
}
