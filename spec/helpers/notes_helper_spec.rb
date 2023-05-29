require 'rails_helper'

RSpec.describe NotesHelper, type: :helper do
  describe '#authored_by_current_user?' do
    let(:user) { create(:user) }
    let(:note) { create(:note, user:) }

    it 'returns true when note is authored by current user' do
      allow(helper).to receive(:current_user).and_return(user)
      result = helper.authored_by_current_user?(note)

      expect(result).to eq(true)
    end

    it 'returns false when note is not authored by current user' do
      other_user = create(:user)
      allow(helper).to receive(:current_user).and_return(other_user)
      result = helper.authored_by_current_user?(note)

      expect(result).to eq(false)
    end
  end

  describe '#formatted_date' do
    let(:date) { Time.new(2023, 5, 31, 14, 1) }
    it 'returns the formatted date' do
      result = helper.formatted_date(date)

      expect(result).to eq('2023-05-31')
    end
  end

  describe '#formatted_time' do
    let(:date) { Time.new(2023, 5, 31, 14, 1, 37) }
    it 'returns the formatted time' do
      result = helper.formatted_time(date)

      expect(result).to eq('14:01:37')
    end
  end

  describe '#formatted_note_count' do
    it 'returns the formatted note count' do
      count = 1
      result = helper.formatted_note_count(count)

      expect(result).to eq('1 note')
    end

    it 'returns the formatted note count with plural' do
      count = 2
      result = helper.formatted_note_count(count)

      expect(result).to eq('2 notes')
    end
  end
end
