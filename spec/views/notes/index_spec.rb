require 'rails_helper'

RSpec.describe 'notes/index', type: :view do
  context 'when user is authorized' do
    let(:user) { create(:user) }
    let(:note1) { create(:note, user:) }
    let(:note2) { create(:note, user:) }

    before do
      assign(:notes, [note1, note2])
      assign(:pagy, Pagy.new(count: 2))
      sign_in user
      render
    end

    it 'displays the note count' do
      expect(rendered).to have_selector('h1', text: '2 notes')
    end

    it 'displays each note in the table' do
      expect(rendered).to have_selector('tr', count: 4) # 2 notes + table header + new note form
      expect(rendered).to have_selector('td', text: note1.content)
      expect(rendered).to have_selector('td', text: note2.content)
    end

    it 'displays the note creation form' do
      expect(rendered).to have_selector('form')
    end

    it 'displays the pagination' do
      expect(rendered).to have_selector('.pagination')
    end
  end

  context 'when user is not authorized' do
    let(:user) { create(:user) }
    let(:note1) { create(:note, user:) }
    let(:note2) { create(:note, user:) }

    before do
      assign(:notes, [note1, note2])
      assign(:pagy, Pagy.new(count: 2))
      render
    end

    it 'displays each note in the table' do
      expect(rendered).to have_selector('tr', count: 3) # 2 notes + table header
      expect(rendered).to have_selector('td', text: note1.content)
      expect(rendered).to have_selector('td', text: note2.content)
    end

    it 'doesnt displays the note creation form' do
      expect(rendered).to have_no_selector('form', visible: true)
    end
  end
end
