require 'rails_helper'

    # create_table :mileage_records do |t|
    #   t.date :record_date
    #   t.integer :start_mileage
    #   t.integer :end_mileage
    #   t.string :route_description
    #   t.integer :distance
    #   t.text :notes
    #   t.references :user, index: true

    #   t.timestamps

describe MileageRecord do
	it "properly sets the date with a value" do
		mileage_entry = build(:mileage_record, record_date: Date.today - 5.days)

		expect(mileage_entry.record_date).to eq(Date.today - 5.days)
  end

	it "properly sets the date given no value" do
		mileage_entry = build(:mileage_record, record_date: nil)

		expect(mileage_entry.record_date).to eq(Date.today)
  end
  
  it "has a default record_date value" do
    expect(MileageRecord.new.record_date).to_not be_nil
  end


  describe "Validations" do
    it " has an invalid route" do
      expect(build(:mileage_record, route_description: nil)).to have(1).errors_on(:route_description)
    end

    it "has an invalid mileage value" do
      expect(build(:mileage_record, start_mileage: 1.34)).to have(1).errors_on(:start_mileage)
    end

    it "has a valid mileage value" do
      expect(build(:mileage_record, start_mileage: 1024)).to have(0).errors_on(:start_mileage)
    end

    it "has an invalid mileage value" do
      expect(build(:mileage_record, end_mileage: 1.024)).to have(1).errors_on(:end_mileage)
    end

    it "is allowed to have nil mileage" do
      expect(build(:mileage_record, end_mileage: nil, start_mileage: nil)).to be_valid
    end

    it "is allowed to have nil end mileage" do
      expect(build(:mileage_record, end_mileage: nil, start_mileage: 90)).to be_valid
    end

    it "is a valid record" do
      expect(create(:mileage_record)).to be_valid
    end

    it "saves the distance of the trip" do
      record = create(:mileage_record, start_mileage: 5, end_mileage: 10)
      expect(record.distance).to eq(5)
    end

    it "is invalid due to start_mileage > end_mileage" do
      expect(build(:mileage_record, start_mileage: 15, end_mileage: 10)).to be_invalid
    end
  end

  describe "last_end_mileage_for" do
    it 'should return 0 if first record for user' do
      user = build(:user)

      expect(MileageRecord.last_end_mileage_for(user)).to eq 0
    end
    
  end
end
