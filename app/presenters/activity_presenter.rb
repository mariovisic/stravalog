class ActivityPresenter < Struct.new(:activity)
  delegate :title, to: :activity

  def self.to_partial_path
    'activity'
  end

  def to_model
    activity
  end

  def short_summary_paragraphs(paragraphs)
    array = activity.body.gsub("\r", "\n").split("\n").reject(&:blank?)
    paragraphs = array.take(paragraphs) + [yield]

    ActionController::Base.helpers.simple_format(paragraphs.join("\n\n"))
  end
end
