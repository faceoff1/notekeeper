module NotesHelper
  def authored_by_current_user?(note)
    note.user == current_user
  end

  def formatted_date(date)
    date.strftime('%Y-%m-%d')
  end

  def formatted_time(date)
    date.strftime('%H:%M:%S')
  end

  def formatted_note_count(count)
    pluralize(count, 'note')
  end
end
