require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class PowerbiOauth2 < OmniAuth::Strategies::OAuth2
      option :name, :powerbi_oauth2

      DEFAULT_SCOPE         = 'offline_access https://analysis.windows.net/powerbi/api/.default'
      DEFAULT_SITE          = 'https://login.microsoftonline.com'
      DEFAULT_AUTHORIZE_URL = '/common/oauth2/v2.0/authorize'
      DEFAULT_TOKEN_URL     = '/common/oauth2/v2.0/token'
      DEFAULT_SKIP_INFO     = true
      # PLEASE NOTE: no identity endpoint is available on the Power BI API; that
      #              is why the skip_info option is set to true
      IDENTITY_URL          = ''

      option :client_options, {
        site:          DEFAULT_SITE,
        authorize_url: DEFAULT_AUTHORIZE_URL,
        token_url:     DEFAULT_TOKEN_URL,
        skip_info:     DEFAULT_SKIP_INFO
      }

     option :authorize_options, [:scope]

      uid { raw_info["id"] }

      extra do
        skip_info? ? { } : { 'raw_info' => raw_info }
      end

      def raw_info
        @raw_info ||= access_token.get(IDENTITY_URL).parsed
      end

      def authorize_params
        super.tap do |params|
          %w[display score auth_type].each do |v|
            if request.params[v]
              params[v.to_sym] = request.params[v]
            end
          end

          params[:scope] ||= DEFAULT_SCOPE
        end
      end

      def callback_url
        options[:redirect_uri] || (full_host + script_name + callback_path)
      end

    end
  end
end
