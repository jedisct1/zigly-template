const std = @import("std");

pub fn build(b: *std.build.Builder) !void {
    const target = try std.zig.CrossTarget.parse(.{ .arch_os_abi = "wasm32-wasi" });

    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("app", "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
}
