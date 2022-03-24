class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates :follower_id, presence: true
  validates :followed_id, presence: true

  def self.to_csv role
    column_names = %w(name created_at)
    CSV.generate do |csv|
      csv << column_names
      all.each do |relationship|
        csv << column_names.map do |attr|
          if attr == "created_at"
            relationship.send(attr)
          elsif role == "following"
            relationship.followed.send(attr)
          else
            relationship.follower.send(attr)
          end
        end
      end
    end
  end

end
