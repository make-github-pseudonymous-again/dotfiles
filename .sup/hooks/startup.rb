class Redwood::ThreadIndexMode
  def toggle_archived_and_deleted
    t = cursor_thread or return
    multi_toggle_archived [t]
    multi_toggle_deleted [t]
  end
end

class Redwood::InboxMode
  def archive_and_delete
    t = cursor_thread or return
    multi_archive [t]
    multi_toggle_deleted [t]
  end
end

class Redwood::ThreadViewMode
  def archive_and_delete_and_next
    archive_and_then delete_and_next
  end
end
