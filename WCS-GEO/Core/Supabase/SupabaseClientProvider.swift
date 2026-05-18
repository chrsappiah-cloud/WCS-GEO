import Foundation
import Supabase

enum SupabaseClientProvider {
    static let shared: SupabaseClient? = {
        guard let url = AppConfig.supabaseURL,
              let key = AppConfig.supabaseAnonKey
        else {
            return nil
        }
        return SupabaseClient(supabaseURL: url, supabaseKey: key)
    }()
}
