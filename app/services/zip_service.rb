require "csv"

class ZipService
  def self.zip *files
    compressed_filestream = Zip::OutputStream.write_buffer do |zos|
      files.each do |file|
        zos.put_next_entry file.filename
        zos.print file.perform
      end
    end
    compressed_filestream.rewind
    compressed_filestream.read
  end
end
