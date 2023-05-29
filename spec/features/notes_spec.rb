require 'rails_helper'

RSpec.feature 'notes', type: :feature, js: true do
  let(:user) { create :user }
  let(:another_user) { create :user }
  let!(:saved_author_note) { create(:note, user:) }
  let!(:saved_another_note) { create(:note, user: another_user) }

  before do
    login_as user
  end

  scenario 'displaying essential elements on the homepage' do
    visit '/'

    user_fullname_info = find('.navbar-nav > li:nth-child(1).nav-item > span')
    expect(user_fullname_info).to have_text(user.fullname)

    notes_counter = find('div > h1')
    expect(notes_counter).to have_text('2 notes')

    notes_table = find('.table')
    expect(notes_table.find('tr > th:nth-child(1)')).to have_text('#')
    expect(notes_table.find('tr > th:nth-child(2)')).to have_text('Note text')
    expect(notes_table.find('tr > th:nth-child(3)')).to have_text('Author name')
    expect(notes_table.find('tr > th:nth-child(4)')).to have_text('Create date')
    expect(notes_table.find('tr > th:nth-child(5)')).to have_text('')

    expect(notes_table.find('tbody')).to have_css('tr', count: 3)

    first_row = notes_table.find('tbody tr:nth-child(1)')
    expect(first_row.find('td:nth-child(2)')).to have_content(saved_author_note.content)
    delete_icon = first_row.find('.delete-note')
    expect(delete_icon.tag_name).to eq('a')

    second_row = notes_table.find('tbody tr:nth-child(2)')
    expect(second_row.find('td:nth-child(2)')).to have_content(saved_another_note.content)
    delete_icon = second_row.find('.bi-x-circle')
    expect(delete_icon).to be_visible

    td_with_form = notes_table.find('tbody > tr:last-child > td:nth-child(2)')
    form = td_with_form.find('form[data-controller="note-form"]')
    input = form.find('input[name="note[content]"]')
    expect(input[:placeholder]).to eq('WRITE A NEW NOTE')

    nav = page.find('nav.pagy-bootstrap-nav')
    active_page = nav.find('li.page-item.active')
    expect(active_page).to have_text('1')
  end

  scenario 'Adding a Note' do
    visit '/'

    expect(page.find('div > h1')).to have_text('2 notes')

    within('form[data-controller="note-form"]') do
      fill_in 'note[content]', with: 'new note!!'
      page.execute_script("document.querySelector('form[data-controller=\"note-form\"]').submit()")
    end

    expect(page).to have_current_path '/?page=1'

    expect(page.find('div > h1')).to have_text('3 notes')

    new_note_tr = page.find('table tbody tr:nth-child(3)')
    new_note_td = new_note_tr.find('td:nth-child(2)')

    expect(new_note_td).to have_text('new note!!')
  end

  scenario 'Delliting a Note' do
    visit '/'

    expect(page.find('div > h1')).to have_text('2 notes')

    find('.delete-note').click
    page.driver.browser.switch_to.alert.accept

    expect(page).to have_current_path '/?page=1'

    expect(page.find('div > h1')).to have_text('1 note')

    expect(page.find('.table tbody')).to have_css('tr', count: 2)
  end
end
