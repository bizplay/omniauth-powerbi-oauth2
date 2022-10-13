# Omniauth::PowerbiOauth2

Microsoft Power BI Strategy for OmniAuth.
Can be used to get a token for the Microsoft Power BI API.

This gem is based on the [Microsoft V2 Auth gem forked and maintained by Bizplay](https://github.com/bizplay/omniauth-microsoft_v2_auth)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth'
gem 'omniauth-oauth2'
gem 'omniauth-powerbi-oauth2', git: 'https://github.com/bizplay/omniauth-powerbi-oauth2.git'
```

And then execute:

    $ bundle

Or install it yourself as:

```shell
$ git clone https://github.com/bizplay/omniauth-powerbi-oauth2.git
$ cd omniauth-powerbi-oauth2
$ gem build omniauth-powerbi-oauth2.gemspec
$ gem install omniauth-powerbi-oauth2-version.gem
```

## Usage
The base usage looks like this:
```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :powerbi_oauth2, ENV['POWERBI_KEY'], ENV['POWERBI_SECRET']
end
```

Here's an example where we request permissions to read a user's Dashboard (or other Power BI asset),
get a refresh_token (by setting it to offline_access) and be able to ready the
user's profile:
```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :powerbi_oauth2, ENV['POWERBI_KEY'], ENV['POWERBI_SECRET'], :scope => 'offline_access https://analysis.windows.net/powerbi/api/.default'
end
```

Remember to handle the callback, for example: https://example.com/auth/powerbi_oauth2/callback


## Please note
The Microsoft Power BI API does not have an endpoint/method of retrieving identifying information
equivalent to the /me call that is available on the Microsoft V2 Auth API. This means that for the
moment the **skip_info** omniauth option is set to true (this usually is false by default since
most API's offer an endpoint that returns identifying information that should be used to populate
the OAuth record with information that is recognizable for users).

This means that the email and name fields of the OAuth record are left empty by this gem and
should be given sensible values before they are used.
