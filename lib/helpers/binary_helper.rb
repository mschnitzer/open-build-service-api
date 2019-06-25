module OpenBuildServiceAPI
  module BinaryHelper
    def self.binary_file?(file_name)
      file_name.end_with?('.rpm') || file_name.end_with?('.deb') || file_name.end_with?('.qcow2')
    end
  end
end
