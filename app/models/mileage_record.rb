class MileageRecord < ActiveRecord::Base

    # create_table :mileage_records do |t|
    #   t.date :record_date
    #   t.integer :start_mileage
    #   t.integer :end_mileage
    #   t.string :route_description
    #   t.integer :distance
    #   t.text :notes
    #   t.references :user, index: true

    #   t.timestamps
	
	attr_accessor :new_route_description

  validates :user_id, :record_date, :route_description, presence: true
	validates :start_mileage, numericality: { only_integer: true }, if: :start_mileage_present?
	validates :end_mileage, numericality: { only_integer: true }, if: :end_mileage_present?
  validate :start_less_than_end_mileage
  belongs_to :user

  before_save :set_distance

  public
    def self.last_end_mileage_for(user)
      if MileageRecord.where(user_id: user).count < 1
        return 0
      else
        MileageRecord.where(user_id: user).last.end_mileage
      end
    end

    def self.to_csv(user)
      CSV.generate do |csv|
        csv << column_names
        where(user_id: user).each do |record|
          csv << record.attributes.values_at(*column_names)
        end
      end
    end

  private
    def set_distance
      self.distance = self.end_mileage - self.start_mileage if self.end_mileage
    end

    def start_less_than_end_mileage
      unless self.end_mileage.nil?
        if self.end_mileage < self.start_mileage ||= 0
          errors[:base] << "End Mileage must be greater than Start Mileage"
        end
      end
    end
		
		def start_mileage_present?
			self.start_mileage 
		end

		def end_mileage_present?
			 self.end_mileage
		end
end
