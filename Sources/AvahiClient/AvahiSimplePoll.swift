import Clibavahiclient

// This is a wrapper of the libavahi-client AvahiSimplePoll type.
public class AvahiSimplePoll: Error {
    let cPointer: OpaquePointer // AvahiSimplePoll

    init() throws {
        let p = avahi_simple_poll_new();

        if p == nil {
            throw RuntimeError.generic("avahi_simple_poll_new() failed")
        } else {
            cPointer = p!
        }
    }
}
