require 'rails_helper'

RSpec.describe 'notes/_note', type: :view do
  let(:user) { create(:user) }
  let(:note) { create(:note, user:) }

  before do
    render partial: 'notes/note', locals: { note:, line_number: 1 }
  end

  it 'displays the note content' do
    expect(rendered).to have_selector('td', text: note.content)
  end

  it 'displays the note author name' do
    expect(rendered).to have_selector('td', text: note.user.name)
  end

  it 'displays the note creation date' do
    expect(rendered).to have_selector('td', text: formatted_date(note.created_at))
  end

  context 'when the note is authored by the current user' do
    before do
      allow(view).to receive(:authored_by_current_user?).with(note).and_return(true)
      render partial: 'notes/note', locals: { note:, line_number: 1 }
    end

    it 'displays the delete note link' do
      expect(rendered).to have_selector('a.delete-note')
    end
  end

  context 'when the note is not authored by the current user' do
    before do
      allow(view).to receive(:authored_by_current_user?).with(note).and_return(false)
      render partial: 'notes/note', locals: { note:, line_number: 1 }
    end

    it 'does not display the delete note link' do
      expect(rendered).not_to have_selector('a.delete-note')
    end

    it 'displays the note delete restriction message' do
      expect(rendered).to have_selector('i[title="You can delete only your own note"]')
    end
  end
end
