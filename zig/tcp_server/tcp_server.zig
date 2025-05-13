const std = @import("std");
const builtint = @import("builtin");
const mystd = @import("mystd.zig");
const os = std.os; 
const net = std.net;
const posix = std.posix;

var gpa_o: std.heap.GeneralPurposeAllocator(.{}) = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = gpa_o.allocator();

pub fn formatSockAddrIPv4(sa: posix.sockaddr) ![]u8 {
    if (sa.family != 2) return error.UnsupportedFamily; 

    const port: u16 = (@as(u16, sa.data[0]) << 8) | sa.data[1];

    const ip = .{
        sa.data[2],
        sa.data[3],
        sa.data[4],
        sa.data[5],
    };

    return std.fmt.allocPrint(
        gpa,
        "{d}.{d}.{d}.{d}:{d}",
        .{ ip[0], ip[1], ip[2], ip[3], port },
    );
}

fn handleClient(socket: posix.socket_t, sockaddr: *posix.sockaddr) void {
    var sockaddrsize: u32 = 0;
    posix.getsockname(socket, sockaddr, &sockaddrsize) catch @panic("could not get socket name");
    const formattedIP = formatSockAddrIPv4(sockaddr.*) catch @panic("could not format ip");
    defer gpa.free(formattedIP);

    while (true) {
        const mem: [*]u8 = @ptrCast(mystd.malloc(1024)); 
        const buffer: []u8 = mem[0..1024];
        defer mystd.free(mem); 
        var bytes_read: u64 = 0;
        bytes_read = posix.read(socket, buffer) catch @panic("read error");
        if (bytes_read == 0) break; 
        std.debug.print("{s}: {s}", .{formattedIP, buffer[0..bytes_read]});
    }
}

pub fn main() u8 {
    const socket: posix.socket_t = posix.socket(posix.AF.INET, posix.SOCK.STREAM, 0) catch @panic("could not open socket."); 
    const address: net.Address = net.Address.parseIp4("0.0.0.0", 6969) catch @panic("something went wrong idk");
    
    std.posix.bind(socket, &address.any, address.getOsSockLen()) catch @panic("bind error");
    std.posix.listen(socket, 5) catch @panic("listen error"); 
    std.debug.print("Opened socket at address 0.0.0.0:6969", .{});
    while (true) {
        var csockaddr: posix.sockaddr = undefined;
        var csockaddr_size: posix.socklen_t = @sizeOf(std.posix.sockaddr);

        const client_fd = posix.accept(socket, @ptrCast(&csockaddr), &csockaddr_size, 0)
            catch |err| {
                std.debug.print("Accept error: {}", .{err});
                continue;
            };

        const pid = posix.fork() catch @panic("fork error");
        if (pid == 0) {
            handleClient(client_fd, &csockaddr);
            posix.exit(0); 
        } else {
            posix.close(client_fd);
        }
    }
    posix.close(socket);
    gpa_o.deinit();
    return 1;
} 

