import Foundation

enum AppConfig {
    private static let supabaseURLKey = "SUPABASE_URL"
    private static let supabaseAnonKeyKey = "SUPABASE_ANON_KEY"

    static var supabaseURL: URL? {
        guard let raw = bundledOrEnvironment(supabaseURLKey), !raw.isEmpty else { return nil }
        return URL(string: raw)
    }

    static var supabaseAnonKey: String? {
        let value = bundledOrEnvironment(supabaseAnonKeyKey)
        return value?.isEmpty == false ? value : nil
    }

    static var isSupabaseConfigured: Bool {
        supabaseURL != nil && supabaseAnonKey != nil
    }

    private static func bundledOrEnvironment(_ key: String) -> String? {
        if let value = Bundle.main.object(forInfoDictionaryKey: key) as? String, !value.isEmpty {
            return value
        }
        if let value = ProcessInfo.processInfo.environment[key], !value.isEmpty {
            return value
        }
        return nil
    }
}
