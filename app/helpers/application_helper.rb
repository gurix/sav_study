module ApplicationHelper
  def title(page_title)
    content_for :title, strip_tags(page_title.to_s)
    page_title
  end

  def bootstrap_class_for(flash_type)
    { success: 'alert-success', error: 'alert-danger', alert: 'alert-warning', notice: 'alert-info' }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(_opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in") do
               concat content_tag(:button, 'x', class: 'close', data: { dismiss: 'alert' })
               concat message
             end)
    end
    nil
  end

  def hilight_number(number)
    return 'text-success' if number < 0
    return 'text-danger' if number > 0
  end

  def distance_of_time_in_words_or_empty(value)
    distance_of_time_in_words(value) if value != 0
  end

  def costs_in_chf(value)
    t('shared.costs_in_chf', costs: value.round(2)) if value != 0
  end

  def distance_in_kilometer(value)
    t('shared.distance_in_kilometer', kilometers: value.round(2)) if value != 0
  end

  def emmissions_in_gramms(value)
    t('shared.emmissions_in_gramms', kg: (value / 1000).round(2)) if value != 0
  end
end
