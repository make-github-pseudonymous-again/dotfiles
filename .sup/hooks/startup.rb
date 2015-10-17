class Redwood::ThreadIndexMode
  def actually_toggle_archived_and_deleted t
    multi_toggle_archived [t]
    multi_toggle_deleted [t]
  end
  def toggle_archived_and_deleted
    t = cursor_thread or return
    actually_toggle_archived_and_deleted t
  end
  def multi_toggle_archived_and_deleted threads
    threads.each { |t| actually_toggle_archived_and_deleted t }
  end
end

class Redwood::InboxMode
  def actually_archive_and_delete t
    multi_archive [t]
    multi_toggle_deleted [t]
  end
  def archive_and_delete
    t = cursor_thread or return
    actually_archive_and_delete t
  end
  def multi_archive_and_delete threads
    threads.each { |t| actually_archive_and_delete t }
  end
end

class Redwood::ThreadViewMode
  def archive_and_delete_and_next
    archive_and_then delete_and_next
  end
end

