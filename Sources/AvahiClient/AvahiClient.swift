import Clibavahiclient

// This error is for AvahiClient (swift) runtime failures.
public enum RuntimeError: Error {
    case generic(String)
}

// This is a wrapper of the libavahi-client AvahiClient type.
public class AvahiClient: Error {
    let cPointer: OpaquePointer
    let avahiSimplePoll: AvahiSimplePoll

    init() throws {
        avahiSimplePoll = try AvahiSimplePoll()
        var error = Int32(0)
        let p = avahi_client_new(avahi_simple_poll_get(avahiSimplePoll.cPointer), AvahiClientFlags(rawValue: 0), nil, nil, &error);

        if p == nil {
            throw RuntimeError.generic("avahi_client_new() failed")
        } else {
            cPointer = p!
        }
    }
}
