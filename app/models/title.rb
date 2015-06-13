class Title
  def initialize(page_title)
    @page_title = page_title
  end

  def to_s
    [blog_title, @page_title].compact.join(' - ')
  end

  def blog_title
    ENV['BLOG_TITLE']
  end
end
