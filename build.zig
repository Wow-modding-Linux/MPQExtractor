const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const dirent = b.dependency("dirent", .{});
    const storm = b.dependency("storm", .{
        .target = target,
        .optimize = optimize,
    });

    const mpq_extractor = b.addExecutable(.{
        .name = "MPQExtractor",
        .target = target,
        .optimize = optimize,
    });
    mpq_extractor.addCSourceFile(.{
        .file = .{ .path = "main.cpp" },
        .flags = &.{},
    });
    mpq_extractor.linkLibrary(storm.artifact("storm"));
    mpq_extractor.addLibraryPath(dirent.path("include"));
    mpq_extractor.addIncludePath(storm.path(""));
    mpq_extractor.addIncludePath(.{ .path = "include" });
    mpq_extractor.linkLibCpp();

    b.installArtifact(mpq_extractor);
}
