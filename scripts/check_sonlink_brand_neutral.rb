#!/usr/bin/env ruby
# frozen_string_literal: true

require "pathname"

root = Pathname.new(__dir__).join("..").expand_path
landing = root.join("apps/sonlink/index.html").read
home = root.join("index.html").read
supermote = root.join("apps/supermote/index.html").read
guide_path = root.join("apps/sonlink/use-phone-as-tv-remote/index.html")
privacy_policy = root.join("legal/privacy-policy.html").read

errors = []

unless guide_path.exist?
  errors << "missing manufacturer-neutral TV remote guide"
end

allowed_identifiers = [
  "sony_remote_icon.png",
  "sony-tv-remote-bravia-tv/id6474549094",
  "com.firesharkhk.sony.bravia.tv.remote"
]

sanitize = lambda do |content|
  allowed_identifiers.reduce(content) { |text, identifier| text.gsub(identifier, "ALLOWED_INTERNAL_IDENTIFIER") }
end

sonlink_card = home[/<!-- App 1: SonLink TV Remote -->(.*?)<!-- App 2:/m, 1]
errors << "cannot locate SonLink home-page card" unless sonlink_card

public_pages = {
  "SonLink landing page" => landing,
  "Fireshark home page" => home,
  "SuperMote landing page" => supermote
}
public_pages["TV remote guide"] = guide_path.read if guide_path.exist?

public_pages.each do |label, content|
  checked = sanitize.call(content)
  errors << "#{label} still contains a manufacturer brand" if checked.match?(/\b(?:Sony|BRAVIA)\b/i)
  errors << "#{label} contains an inaccurate no-ads/no-tracking claim" if checked.match?(/\bno\s+(?:ads|tracking)\b/i)
end

required_landing_copy = [
  "SonLink: Wi-Fi TV Remote",
  "Advertising partners may process device and usage data",
  "not affiliated with, endorsed by, or sponsored by any television manufacturer"
]
required_landing_copy.each do |copy|
  errors << "landing page is missing required copy: #{copy}" unless landing.include?(copy)
end

required_privacy_copy = [
  "App Tracking Transparency",
  "Firebase Analytics",
  "Firebase Crashlytics",
  "Meta Audience Network",
  "Unity Ads",
  "consent choices"
]
required_privacy_copy.each do |copy|
  errors << "privacy policy is missing required disclosure: #{copy}" unless privacy_policy.include?(copy)
end

if errors.any?
  warn errors.map { |error| "- #{error}" }.join("\n")
  exit 1
end

puts "Public web copy is manufacturer-neutral and privacy-accurate for SonLink review."
