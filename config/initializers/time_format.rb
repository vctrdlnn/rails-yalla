Time::DATE_FORMATS[:humanized_ago]  = ->(time) do
  st = Time.now.beginning_of_day
  nd = Time.now.end_of_day

  case
  when time.between?(st + 1.day, nd + 1.day)
    "Tomorrow #{time.strftime('%H:%M')}"
  when time.between?(st, nd)
    # time_ago_in_words(time) + "ago"
    "Today at #{time.strftime('%H:%M')}"
  when time.between?(st - 1.day, nd - 1.day)
    "Yesterday at #{time.strftime('%H:%M')}"
  when time.between?(st - 6.day, nd - 2.day)
    time.strftime('%a %H:%M')
  else
    time.strftime('%y-%b-%d %H:%M')
  end
end
