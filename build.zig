const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{ .cpu_arch = .wasm32, .os_tag = .wasi });

    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "app",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "zigly", .module = b.dependency("zigly", .{}).module("zigly") }},
        }),
    });
    const install = b.addInstallArtifact(exe, .{});
    b.getInstallStep().dependOn(&install.step);

    const viceroy = b.addSystemCommand(&.{
        "viceroy",
        "-C",
        "fastly.toml",
        "zig-out/bin/app.wasm",
    });
    viceroy.step.dependOn(&install.step);
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&viceroy.step);
}
