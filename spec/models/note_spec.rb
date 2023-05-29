require 'rails_helper'

RSpec.describe Note, type: :model do
  let(:user) { create(:user) }

  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:content) }
  end
end
