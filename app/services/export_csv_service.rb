require "csv"
class ExportCsvService
  attr_reader :attributes, :objects, :filename, :role

  def initialize objects, attributes, filename, role = nil
    @attributes = attributes
    @objects = objects
    @filename = filename
    @role = role
  end

  def perform
    CSV.generate do |csv|
      csv << @attributes
      @objects.each do |object|
        csv << @attributes.map do |attr|
          if attr == "name" && @role
            object.send(@role).send(attr)
          else
            object.send(attr)
          end
        end
      end
    end
  end
end
