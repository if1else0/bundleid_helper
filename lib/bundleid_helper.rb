require "bundleid_helper/version"

module BundleidHelper
  class Helper
    def get_bundleid
      ###check if gem CFPropertyList exist,if not,install it
      ###use use this gem to parse plist file
      begin
        require 'cfpropertylist'
      rescue LoadError
        `gem install CFPropertyList`
        require 'cfpropertylist'
      end

      ipa_name = ''
      if ARGV.empty?
        puts "Please specify the ipa name you want to get info from!"
        exit 1
      elsif (ARGV.length > 1)
        puts "You can only specify one parameter!"
        exit 1
      else
        ipa_name = ARGV[0]
      end

      ###unzip plist file from ipa
      command = "unzip -j #{ipa_name} \"Payload/*.app/Info.plist\" -d xxxxxtemp"
      `#{command}`
      plist = CFPropertyList::List.new(:file => "xxxxxtemp/Info.plist")
      data = CFPropertyList.native_types(plist.value)
      ###get bundle id
      bundle_id = data['CFBundleIdentifier']
      ###remove temp directory: xxxxxtemp
      `rm -rf xxxxxtemp`
      puts bundle_id
    end
  end
end
