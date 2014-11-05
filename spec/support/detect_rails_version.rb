def detect_rails_version
  gemfile = ENV["BUNDLE_GEMFILE"] || File.expand_path("../../../Gemfile", __FILE__)
  content = File.read("#{gemfile}.lock")
  match = content.match(/^[ ]{4}rails \((?<version>.*)\)$/)
  version = match[:version]
ensure
  puts "Detected Rails: #{version}" if ENV['DEBUG']
end

def detect_rails_version!
  detect_rails_version or raise "can't find a version of Rails to use!"
end
